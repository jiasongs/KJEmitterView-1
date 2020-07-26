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

/// UIColor转#ffffff格式的16进制字符串
+ (NSString*)kj_hexStringFromColor:(UIColor*)color;
/// 16进制字符串转UIColor
+ (UIColor*)kj_colorWithHexString:(NSString*)hexString;

@end

NS_ASSUME_NONNULL_END
