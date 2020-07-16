//
//  KJButtonVC2.m
//  KJEmitterView
//
//  Created by 杨科军 on 2018/12/1.
//  Copyright © 2018 杨科军. All rights reserved.
//

#import "KJButtonVC.h"
#import "UIButton+KJEmitter.h" // 按钮粒子效果
#import "UIButton+KJCountDown.h" // 倒计时

@interface KJButtonVC ()
@property(nonatomic,strong)UIButton *button;
@property(nonatomic,strong)NSArray *segmentedTitleArray;
@property(nonatomic,strong)NSArray *NameArray;
@property(nonatomic,strong)NSMutableArray <UILabel *>*labelArray;
@property(nonatomic,strong)UIButton *emitterButton;
@property(nonatomic,strong)UIButton *countDownButton;
@property(nonatomic,strong)UIButton *submitButton;
@end

@implementation KJButtonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.NameArray = @[@"",@"",@"图文间距",@"图文边界间距"];
    self.segmentedTitleArray = @[@[@"居中-图左文右",@"居中-图右文左",@"居中-图上文下",@"居中-图下文上"],
    @[@"居左-图左文右",@"居左-图右文左",@"居右-图左文右",@"居右-图右文左"]];
    self.labelArray = [NSMutableArray array];
    
    [self.view addSubview:self.button];
    [self.view addSubview:self.emitterButton];
    [self.view addSubview:self.countDownButton];
    [self.view addSubview:self.submitButton];
    [self createSegmented];
}
// 重写SET传值，需要在图文元素确定后才能设置布局，之后参数即可动态调整
- (void)clicksegmented:(UISegmentedControl *)sender{    // 两排控制布局的选择器
    NSInteger tag = sender.tag - 100;
    NSArray *arr = self.segmentedTitleArray[tag];
    switch (tag) {
        case 0:
            self.button.kj_ButtonContentLayoutType = sender.selectedSegmentIndex;
            [self.button setTitle:arr[sender.selectedSegmentIndex] forState:UIControlStateNormal];
        break;
        case 1:
            self.button.kj_ButtonContentLayoutType = sender.selectedSegmentIndex + 4;
            [self.button setTitle:arr[sender.selectedSegmentIndex] forState:UIControlStateNormal];
        break;
        default: break;
    }
}
- (void)slidingSlider:(UISlider *)sender{
    NSInteger tag = sender.tag - 100;
    switch (tag) {
            case 2:
            self.button.kj_Padding = sender.value;
            [self.labelArray objectAtIndex:0].text = [NSString stringWithFormat: @"%@：\t%.0f",self.NameArray[tag], sender.value];
            break;
            case 3:
            self.button.kj_PaddingInset = sender.value;
            [self.labelArray objectAtIndex:1].text = [NSString stringWithFormat: @"%@：\t%.0f",self.NameArray[tag], sender.value];
            break;
        default: break;
    }
}
- (void)createSegmented{
    NSArray *defaultParameters = @[@"",@"",@"0",@"5"];
    for (int i = 0; i < 4; i ++) {
        CGFloat width = 150;
        CGFloat Y = i * 40 + self.button.frame.origin.y + CGRectGetHeight(self.button.frame) + 50;
        if (i < self.segmentedTitleArray.count) {
            UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:self.segmentedTitleArray[i]];
            segmented.frame = CGRectMake(10, Y + i*10, kScreenW - 20, 40);
            segmented.tag = 100 + i;
            segmented.momentary = YES;
            UIFont *font = [UIFont boldSystemFontOfSize:12];
            NSDictionary *attributes = @{NSFontAttributeName:font};
            [segmented setTitleTextAttributes:attributes forState:UIControlStateNormal];
            [segmented addTarget:self action:@selector(clicksegmented:) forControlEvents:UIControlEventValueChanged];
            [self.view addSubview:segmented];
        }
        
        if (i >= 2) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, Y+30, width, 30)];
            label.text = self.NameArray[i];
            label.textColor = UIColor.blueColor;
            label.font = [UIFont systemFontOfSize:14];
            [self.view addSubview:label];
            [self.labelArray addObject:label];
            
            UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(width + 30,Y+30, kScreenW - (width + 40), 30)];
            [slider addTarget:self action:@selector(slidingSlider:)
             forControlEvents:UIControlEventValueChanged];
            slider.minimumValue = 0;
            slider.maximumValue = 30;
            slider.value = [defaultParameters[i] floatValue];
            slider.tag = i + 100;
            [self.view addSubview:slider];
            label.text =  [NSString stringWithFormat:@"%@:\t%@",self.NameArray[i],defaultParameters[i]];
        }
    }
}

#pragma mark - 懒加载区
- (UIButton *)button{
    if (!_button) {
        _button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenW-150, 80)];
        _button.center = CGPointMake(kScreenW/2, 150);
        _button.backgroundColor = UIColor.whiteColor;
        _button.layer.borderWidth = 1;
        _button.layer.borderColor = UIColor.blueColor.CGColor;
        _button.layer.masksToBounds = YES;
        _button.layer.cornerRadius = 5;
        _button.titleLabel.font = [UIFont systemFontOfSize:14];
        [_button setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:@"wode_nor"] forState:UIControlStateNormal];
        // 设置初始参数
        _button.kj_ButtonContentLayoutType = KJButtonContentLayoutStyleNormal;
        [_button setTitle:@"居中-图左文右" forState:UIControlStateNormal];
    }
    return _button;
}
- (UIButton*)emitterButton{
    if (!_emitterButton) {
        CGFloat Y = 5 * 40 + self.button.frame.origin.y + CGRectGetHeight(self.button.frame) + 45;
        UILabel *label = [UILabel new];
        label.text = @"按钮点赞粒子效果展示";
        label.textColor = UIColor.blueColor;
        label.font = [UIFont systemFontOfSize:14];
        label.frame = CGRectMake(10, Y, 150, 20);
        [self.view addSubview:label];
        _emitterButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _emitterButton.frame = CGRectMake(180, Y, 30, 30);
        _emitterButton.centerY = label.centerY;
        [_emitterButton setImage:kGetImage(@"button_like_norm") forState:(UIControlStateNormal)];
        [_emitterButton setImage:kGetImage(@"button_like_sele") forState:(UIControlStateSelected)];
//        _emitterButton.kj_buttonEmitterImage = [UIImage imageNamed:@"button_like_norm"];
        /// 开启点赞粒子效果
        _emitterButton.kj_openButtonEmitter = YES;
        [_emitterButton kj_addAction:^(UIButton * _Nonnull kButton) {
            kButton.selected = !kButton.selected;
        }];
    }
    return _emitterButton;
}
- (UIButton*)countDownButton{
    if (!_countDownButton) {
        CGFloat Y = CGRectGetMaxY(self.emitterButton.frame) + 15;
        UILabel *label = [UILabel new];
        label.text = @"倒计时按钮展示";
        label.textColor = UIColor.blueColor;
        label.font = [UIFont systemFontOfSize:14];
        label.frame = CGRectMake(10, Y, 150, 20);
        [self.view addSubview:label];
        _countDownButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _countDownButton.frame = CGRectMake(180, Y, 80, 25);
        _countDownButton.centerY = label.centerY;
        _countDownButton.backgroundColor = [UIColor kj_gradientFromColor:UIColor.redColor toColor:UIColor.yellowColor Width:80];//[UIColor.blueColor colorWithAlphaComponent:0.3];
        _countDownButton.layer.cornerRadius = 5;
        _countDownButton.layer.borderWidth = 1;
        _countDownButton.layer.borderColor = UIColor.blueColor.CGColor;
        _countDownButton.layer.masksToBounds = YES;
        _countDownButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_countDownButton setTitleColor:UIColor.blueColor forState:(UIControlStateNormal)];
        [_countDownButton setTitle:@"倒计时" forState:(UIControlStateNormal)];
        [_countDownButton kj_addAction:^(UIButton * _Nonnull kButton) {
            [kButton kj_startTime:10 CountDownFormat:@"计时%zd秒"];
        }];
        _countDownButton.kButtonCountDownStop = ^{
            NSLog(@"计时结束!!!");
        };
//        [_button kj_addAction:^(UIButton * _Nonnull kButton) {
//            [_countDownButton kj_cancelTimer];
//        }];
    }
    return _countDownButton;
}
- (UIButton*)submitButton{
    if (!_submitButton) {
        CGFloat Y = CGRectGetMaxY(self.countDownButton.frame) + 15;
        UILabel *label = [UILabel new];
        label.text = @"提交指示器按钮展示";
        label.textColor = UIColor.blueColor;
        label.font = [UIFont systemFontOfSize:14];
        label.frame = CGRectMake(10, Y, 150, 20);
        [self.view addSubview:label];
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(180, Y, 100, 25);
        button.centerY = label.centerY;
        button.backgroundColor = [UIColor.blueColor colorWithAlphaComponent:0.3];
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 1;
        button.layer.borderColor = UIColor.blueColor.CGColor;
        button.layer.masksToBounds = YES;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:UIColor.blueColor forState:(UIControlStateNormal)];
        [button setTitle:@"提交" forState:(UIControlStateNormal)];
        [button kj_addAction:^(UIButton * _Nonnull kButton) {
            [kButton kj_beginSubmitting:@"提交ing"];
        }];
        _submitButton = button;
    }
    return _submitButton;
}

@end

