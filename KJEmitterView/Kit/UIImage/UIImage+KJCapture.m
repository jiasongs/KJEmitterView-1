//
//  UIImage+KJCapture.m
//  KJEmitterView
//
//  Created by 杨科军 on 2020/7/25.
//  Copyright © 2020 杨科军. All rights reserved.
//

#import "UIImage+KJCapture.h"

@implementation UIImage (KJCapture)
/** 指定位置屏幕截图 */
+ (UIImage*)kj_captureScreen:(UIView *)view Rect:(CGRect)rect{
    return ({
        UIGraphicsBeginImageContext(view.frame.size);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImage *newImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([viewImage CGImage], rect)];
        newImage;
    });
}
/// 根据特定的区域对图片进行裁剪
+ (UIImage*)kj_cutImageWithImage:(UIImage*)image Frame:(CGRect)frame{
    return ({
        /// 方法说明：核心裁剪方法CGImageCreateWithImageInRect(CGImageRef image,CGRect rect)
        CGImageRef tmp = CGImageCreateWithImageInRect([image CGImage], frame);
        UIImage *newImage = [UIImage imageWithCGImage:tmp scale:image.scale orientation:image.imageOrientation];
        CGImageRelease(tmp);
        newImage;
    });
}
/** 屏幕截图 */
+ (UIImage*)kj_captureScreen:(UIView *)view{
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
/// 多边形切图
+ (UIImage*)kj_polygonCaptureImageWithImageView:(UIImageView*)imageView PointArray:(NSArray*)points{
    CGRect rect = CGRectZero;
    rect.size = imageView.image.size;
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0);
    [[UIColor blackColor] setFill];
    UIRectFill(rect);
    [[UIColor whiteColor] setFill];
    
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    //起点
    CGPoint p1 = [self convertCGPoint:[points[0] CGPointValue] fromRect1:imageView.frame.size toRect2:imageView.frame.size];
    [aPath moveToPoint:p1];
    //其他点
    for (int i = 1; i< points.count; i++) {
        CGPoint point = [self convertCGPoint:[points[i] CGPointValue] fromRect1:imageView.frame.size toRect2:imageView.frame.size];
        [aPath addLineToPoint:point];
    }
    [aPath closePath];
    [aPath fill];
    
    //遮罩层
    UIImage *mask = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    CGContextClipToMask(UIGraphicsGetCurrentContext(), rect, mask.CGImage);
    [imageView.image drawAtPoint:CGPointZero];
    UIImage *maskedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return maskedImage;
}
+ (CGPoint)convertCGPoint:(CGPoint)point1 fromRect1:(CGSize)rect1 toRect2:(CGSize)rect2 {
    point1.y = rect1.height - point1.y;
    CGPoint result = CGPointMake((point1.x*rect2.width)/rect1.width, (point1.y*rect2.height)/rect1.height);
    return result;
}
/** 不规则图形切图 */
+ (UIImage*)kj_anomalyCaptureImageWithView:(UIView*)view BezierPath:(UIBezierPath*)path{
    CAShapeLayer *maskLayer= [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    maskLayer.fillColor = [UIColor blackColor].CGColor;//填充色
    maskLayer.strokeColor = [UIColor darkGrayColor].CGColor;
    maskLayer.frame = view.bounds;
    maskLayer.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1);
    maskLayer.contentsScale = [UIScreen mainScreen].scale;
    
    CALayer * contentLayer = [CALayer layer];
    contentLayer.mask = maskLayer;
    contentLayer.frame = view.bounds;
    view.layer.mask = maskLayer;
    UIImage *image = [self kj_captureScreen:view];
    return image;
}

/** 截取当前屏幕 */
+ (UIImage*)kj_captureScreenWindow{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)){
        imageSize = [UIScreen mainScreen].bounds.size;
    }else{        
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]){
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft){
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }else if (orientation == UIInterfaceOrientationLandscapeRight){
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }else{
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/// 图片路径裁剪，裁剪路径 "以外" 部分
+ (UIImage*)kj_captureOuterImage:(UIImage*)image BezierPath:(UIBezierPath*)path Rect:(CGRect)rect{
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef outer = CGPathCreateMutable();
    CGPathAddRect(outer, NULL, rect);
    CGPathAddPath(outer, NULL, path.CGPath);
    CGContextAddPath(context, outer);
    CGPathRelease(outer);
    CGContextSetBlendMode(context, kCGBlendModeClear);
    [image drawInRect:rect];
    CGContextDrawPath(context, kCGPathEOFill);
    UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimage;
}
/// 图片路径裁剪，裁剪路径 "以内" 部分
+ (UIImage*)kj_captureInnerImage:(UIImage*)image BezierPath:(UIBezierPath*)path Rect:(CGRect)rect{
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(context, kCGBlendModeClear);/// kCGBlendModeClear 裁剪部分透明
    [image drawInRect:rect];
    CGContextAddPath(context, path.CGPath);
    CGContextDrawPath(context, kCGPathEOFill);
    UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimage;
}


@end
