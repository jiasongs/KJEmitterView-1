//
//  UIColor+KJExtension.h
//  KJEmitterView
//
//  Created by 杨科军 on 2019/12/31.
//  Copyright © 2019 杨科军. All rights reserved.
//  颜色相关扩展

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIColor (KJExtension)
/// 竖直渐变颜色
- (UIColor*)kj_gradientVerticalToColor:(UIColor*)color Height:(NSInteger)height;
/// 横向渐变颜色
- (UIColor*)kj_gradientAcrossToColor:(UIColor*)color Width:(NSInteger)width;
/// 生成附带边框的渐变色图片
+ (UIImage*)kj_colorImageWithColors:(NSArray<UIColor*>*)colors locations:(NSArray<NSNumber*>*)locations size:(CGSize)size borderWidth:(CGFloat)borderWidth borderColor:(UIColor*)borderColor;

/// UIColor转16进制字符串
+ (NSString*)kj_hexStringFromColor:(UIColor*)color;
/// 16进制字符串转UIColor
+ (UIColor*)kj_colorWithHexString:(NSString*)hexString;

/// 获取图片上指定点的颜色
+ (UIColor*)kj_colorAtImage:(UIImage*)image Point:(CGPoint)point;
/// 获取ImageView上指定点的图片颜色
+ (UIColor*)kj_colorAtImageView:(UIImageView*)imageView Point:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
