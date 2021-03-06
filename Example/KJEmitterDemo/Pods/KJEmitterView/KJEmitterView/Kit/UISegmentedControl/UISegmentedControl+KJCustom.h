//
//  UISegmentedControl+KJCustom.h
//  Winpower
//
//  Created by 杨科军 on 2019/10/12.
//  Copyright © 2019 cq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UISegmentedControl (KJCustom)

/// 解决修改不了 backgroundColor 和 tintColor
- (void)kj_ensureBackgroundAndTintColor;

@end

NS_ASSUME_NONNULL_END
