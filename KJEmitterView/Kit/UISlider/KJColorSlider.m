//
//  KJColorSlider.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/8/24.
//  Copyright © 2020 杨科军. All rights reserved.
//

#import "KJColorSlider.h"

@interface KJColorSlider()
@property(nonatomic,strong) UIImageView *imgView;
@property(nonatomic,assign) NSTimeInterval lastTime;
@end

@implementation KJColorSlider
#pragma mark - public method
- (void)kj_setUI{ [self drawNewImage];}

#pragma mark - system method
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    if (CGRectEqualToRect(self.imgView.frame, CGRectZero)) {
        CGRect imgViewFrame = self.imgView.frame;
        imgViewFrame.size.width = self.frame.size.width;
        imgViewFrame.size.height = _colorHeight;
        imgViewFrame.origin.y = (self.frame.size.height - _colorHeight) * 0.5;
        self.imgView.frame = imgViewFrame;
        [self drawNewImage];
    }
}

#pragma mark - private method
- (void)drawNewImage{
    self.imgView.image = [UIColor kj_colorImageWithColors:_colors locations:_locations size:CGSizeMake(self.frame.size.width, _colorHeight) borderWidth:_borderWidth borderColor:_borderColor];
}
- (void)setup{
    self.colorHeight = 2.;
    self.borderWidth = 0.0;
    self.borderColor = UIColor.blackColor;
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self insertSubview:self.imgView atIndex:4];
    self.tintColor = [UIColor clearColor];
    self.maximumTrackTintColor = self.minimumTrackTintColor = [UIColor clearColor];
    [self addTarget:self action:@selector(valueChange) forControlEvents:UIControlEventValueChanged];
    [self addTarget:self action:@selector(endMove) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(endMove) forControlEvents:UIControlEventTouchUpOutside];
    [self addTarget:self action:@selector(touchCancel) forControlEvents:UIControlEventTouchCancel];
}
- (void)valueChange{
    if (self.kValueChangeBlock) {
        if (_timeSpan == 0) {
            self.kValueChangeBlock(self.value);
        }else if (CFAbsoluteTimeGetCurrent() - self.lastTime > _timeSpan) {
            _lastTime = CFAbsoluteTimeGetCurrent();
            self.kValueChangeBlock(self.value);
        }
    }
}
- (void)endMove{
    if (self.kMoveEndBlock) {
        self.kMoveEndBlock(self.value);
        return;
    }
    if (self.kValueChangeBlock) self.kValueChangeBlock(self.value);
}
- (void)touchCancel{
    if (self.kMoveEndBlock) self.kMoveEndBlock(self.value);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
