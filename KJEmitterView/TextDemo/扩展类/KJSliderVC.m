//
//  KJSliderVC.m
//  KJEmitterView
//
//  Created by 杨科军 on 2020/8/24.
//  Copyright © 2020 杨科军. All rights reserved.
//

#import "KJSliderVC.h"

@interface KJSliderVC ()
@property(nonatomic,strong) KJColorSlider *colorSlider;
@end

@implementation KJSliderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.colorSlider = [[KJColorSlider alloc]initWithFrame:CGRectMake(20, 84, kScreenW-40, 30)];
    [self.view addSubview:self.colorSlider];
    _colorSlider.colorHeight = 2.5;
    _colorSlider.colors = @[UIColorFromHEXA(0xF44336,1), UIColorFromHEXA(0xFFFFFF,1)];
    _colorSlider.locations = @[@0.2,@0.8];
    [_colorSlider kj_setUI];
    _colorSlider.kValueChangeBlock = ^(CGFloat progress) {
        NSLog(@"progress:%f",progress);
    };
    _colorSlider.kMoveEndBlock = ^(CGFloat progress) {
        NSLog(@"end:%f",progress);
    };
}

@end
