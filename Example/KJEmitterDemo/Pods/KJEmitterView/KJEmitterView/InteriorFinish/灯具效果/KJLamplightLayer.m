//
//  KJLamplightLayer.m
//  KJEmitterView
//
//  Created by 杨科军 on 2020/6/3.
//  Copyright © 2020 杨科军. All rights reserved.
//

#import "KJLamplightLayer.h"
@interface KJLamplightLayer ()
@property(nonatomic,strong) UIImage *perspectiveImage; /// 透视好的素材图
@property(nonatomic,assign) CGFloat canvasWidth;
@property(nonatomic,assign) KJKnownPoints knownPoints;/// 外界区域四点
@property(nonatomic,assign) CGFloat lastLamplightAngle; /// 上一次的灯光角度
@property(nonatomic,strong) UIImage *lastLamplightImage;/// 上一次旋转处理之后灯光图片
@end
@implementation KJLamplightLayer
- (void)layoutSublayers {
    [super layoutSublayers];
    [self setNeedsDisplay];
}
/// 初始化
- (instancetype)kj_initWithKnownPoints:(KJKnownPoints)points{
    if (self == [super init]) {
        self.lastLamplightAngle = 0.0;
        self.knownPoints = points;
        self.drawsAsynchronously = YES;// 进行异步绘制
        self.contentsScale = [UIScreen mainScreen].scale;
        self.maxRect = [_KJIFinishTools kj_rectWithPoints:points];
        self.canvasWidth = self.maxRect.size.width;
    }
    return self;
}
/// 重置
- (void)kj_clearLayers{
    self.lastLamplightAngle = 0.0;
    self.lastLamplightImage = nil;
}
/// 处理灯光效果
- (UIImage*)kj_addLayerWithLamplightModel:(KJLamplightModel*)lamplightModel PerspectiveBlock:(UIImage *(^)(KJKnownPoints points,UIImage *jointImage))block{
    UIImage *img = [self kj_jointImageWithLamplightModel:lamplightModel];
    if (block) {
        self.perspectiveImage = block(self.knownPoints,img);
        [self setNeedsDisplay];
    }
    return img;
}
/// 存储
- (void)kj_lamplightSaveWithLamplightModel:(KJLamplightModel*)lamplightModel{
    if (self.saveblock) {
        KJInteriorSaveDatasInfo *info = [KJInteriorSaveDatasInfo new];
        info.lamplightModel.imageName = lamplightModel.image.kj_imageName;
        info.lamplightModel.imageGetModeType = lamplightModel.image.kj_imageGetModeType;
        info.lamplightModel.lamplightNumber = lamplightModel.lamplightNumber;
        info.lamplightModel.lamplightSize = lamplightModel.lamplightSize;
        info.lamplightModel.lamplightMoveX = lamplightModel.lamplightMoveX;
        info.lamplightModel.lamplightMoveY = lamplightModel.lamplightMoveY;
        info.lamplightModel.lamplightAngle = lamplightModel.lamplightAngle;
        self.saveblock(info);
    }
}
#pragma mark - 内部方法
/// 拼接素材图
- (UIImage*)kj_jointImageWithLamplightModel:(KJLamplightModel*)model{
    CGFloat sw = self.maxRect.size.width * .5;
    CGFloat w = model.lamplightSize + 0;
    CGFloat h = model.image.size.height * w / model.image.size.width;
//    model.lamplightMoveX -= ksw*.5 - sw - (model.lamplightSpace*.5 + (model.lamplightSpace+w)*model.lamplightNumber)*.5;
    /// 切换了图片素材
    if (model.image != self.lastLamplightImage) self.lastLamplightImage = nil;
    UIImage *image = nil;
    if (self.lastLamplightAngle == model.lamplightAngle && self.lastLamplightImage != nil) {
        image = self.lastLamplightImage;
    }else{
        CGPoint point = CGPointMake(model.image.size.width*.5, 0);
        image = [_KJIFinishTools kj_rotateImage:model.image Rotation:model.lamplightAngle Point:point];;
        self.lastLamplightImage = image;
        self.lastLamplightAngle = model.lamplightAngle;
        !self.kAngleChangeSizeBlock?:self.kAngleChangeSizeBlock(w);
    }
    /// 设置画布尺寸
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    CGFloat x = 0.0;
    CGFloat y = 0.0;
    NSInteger number = model.lamplightNumber;
    /// 奇数个处理
    if (number % 2) {
        for (NSInteger i=(-number/2); i<=number/2; i++) {
            x = model.lamplightMoveX + sw - w*.5 + (model.lamplightSpace+w)*i;
            y = model.lamplightMoveY;
            [image drawInRect:CGRectMake(x,y,w,h)];
        }
    }else{
        for (NSInteger i=(-number/2); i<number/2; i++) {
            x = model.lamplightMoveX + sw + model.lamplightSpace*.5 + (model.lamplightSpace+w)*i;
            y = model.lamplightMoveY;
            [image drawInRect:CGRectMake(x,y,w,h)];
        }
    }
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}
/// 绕某点旋转图片
- (UIImage*)kj_rotateImage:(UIImage*)image Rotation:(CGFloat)rotation Point:(CGPoint)point{
    double radius = rotation * M_PI / 180;
    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    CGFloat xw = h*sin(radius) + w*cos(radius);
    CGFloat xh = h*cos(radius) + w*sin(radius);
    CGFloat scale = 1;//w/xw;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(xw, xh), NO, 0.0);
    CGFloat x = -point.x;//w-2*w*cos(radius)-point.x;
    CGFloat y = -h+point.y;//2*w*sin(radius)-h+point.y;
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(bitmap, scale, -scale);
    CGContextTranslateCTM(bitmap, point.x, -point.y);
    CGContextRotateCTM(bitmap, radius);
    CGContextDrawImage(bitmap, CGRectMake(x, y, w, h), image.CGImage);
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}
#pragma mark - 绘制
- (void)drawInContext:(CGContextRef)context {
    CGContextSetShouldAntialias(context,YES);
    UIGraphicsPushContext(context);
    [self.perspectiveImage drawInRect:self.bounds];
    UIGraphicsPopContext();
}
@end
