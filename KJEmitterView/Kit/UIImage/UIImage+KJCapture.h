//
//  UIImage+KJCapture.h
//  KJEmitterView
//
//  Created by 杨科军 on 2020/7/25.
//  Copyright © 2020 杨科军. All rights reserved.
//  截图和裁剪处理

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (KJCapture)
#pragma mark - 截图处理
/// 指定位置屏幕截图
+ (UIImage*)kj_captureScreen:(UIView *)view Rect:(CGRect)rect;
/// 根据特定的区域对图片进行裁剪
+ (UIImage*)kj_cutImageWithImage:(UIImage*)image Frame:(CGRect)frame;
/// 屏幕截图 返回一张截图
+ (UIImage*)kj_captureScreen:(UIView*)view;
/// 多边形切图
+ (UIImage*)kj_polygonCaptureImageWithImageView:(UIImageView*)imageView PointArray:(NSArray*)points;
/// 不规则图形切图
+ (UIImage*)kj_anomalyCaptureImageWithView:(UIView*)view BezierPath:(UIBezierPath*)path;
/// 截取当前屏幕
+ (UIImage*)kj_captureScreenWindow;
/// 图片路径裁剪，裁剪路径 "以外" 部分
+ (UIImage*)kj_captureOuterImage:(UIImage*)image BezierPath:(UIBezierPath*)path Rect:(CGRect)rect;
/// 图片路径裁剪，裁剪路径 "以内" 部分
+ (UIImage*)kj_captureInnerImage:(UIImage*)image BezierPath:(UIBezierPath*)path Rect:(CGRect)rect;
@end

NS_ASSUME_NONNULL_END
