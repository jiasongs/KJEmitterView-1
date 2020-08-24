//
//  UIColor+KJExtension.h
//  KJEmitterView
//
//  Created by 杨科军 on 2019/12/31.
//  Copyright © 2019 杨科军. All rights reserved.
//  颜色相关扩展

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// RGBA
typedef struct KJColorRGBA {
    float red;
    float green;
    float blue;
    float alpha;
}KJColorRGBA;
/// 色相饱和度和亮度
typedef struct KJColorHSL {
    float hue;/// 色相 -π ~ π
    float saturation; /// 饱和度 0 ~ 1
    float light; /// 亮度 0 ~ 1
}KJColorHSL;
@interface UIColor (KJExtension)
/// 竖直渐变颜色
- (UIColor*)kj_gradientVerticalToColor:(UIColor*)color Height:(NSInteger)height;
/// 横向渐变颜色
- (UIColor*)kj_gradientAcrossToColor:(UIColor*)color Width:(NSInteger)width;
/// 生成附带边框的渐变色图片
+ (UIImage*)kj_colorImageWithColors:(NSArray<UIColor*>*)colors locations:(NSArray<NSNumber*>*)locations size:(CGSize)size borderWidth:(CGFloat)borderWidth borderColor:(UIColor*)borderColor;

/// UIColor转#ffffff格式的16进制字符串
+ (NSString*)kj_hexStringFromColor:(UIColor*)color;
/// 16进制字符串转UIColor
+ (UIColor*)kj_colorWithHexString:(NSString*)hexString;

/// 获取颜色对应的RGBA
- (KJColorRGBA)kj_colorGetRGBA;
/// 获取颜色对应的色相饱和度和透明度
- (KJColorHSL)kj_colorGetHSL;

@end

NS_ASSUME_NONNULL_END
