//
//  KJImageView.h
//  KJEmitterView
//
//  Created by 杨科军 on 2020/7/25.
//  Copyright © 2020 杨科军. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KJImageView : UIImageView
/// 透明区域是否手势穿透
@property(nonatomic,assign)bool transparencyPenetrate;
@end

NS_ASSUME_NONNULL_END
