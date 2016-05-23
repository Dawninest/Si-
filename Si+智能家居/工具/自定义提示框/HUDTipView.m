//
//  HUDTipView.m
//  Si+智能家居
//
//  Created by 蒋一博 on 16/5/5.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import "HUDTipView.h"

@implementation HUDTipView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame = [UIScreen mainScreen].bounds;
        
        self.backgroundColor = [UIColor clearColor];
        
        [self initUI];
        
    }
    return self;
}

- (void)initUI{
    
    //背后模糊板
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    _visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    
    _visualEffectView.alpha = 0;//0.8
    
    [_visualEffectView setFrame:self.frame];
    
    [self addSubview:_visualEffectView];
    
    UIImageView *tipBG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TipBG"]];
    
    //300 * 135
    tipBG.bounds = CGRectMake(0, 0, 375, 375/300*135);
    
    tipBG.center = self.center;
    
    tipBG.alpha = 0;
    
    [self addSubview:tipBG];
    
    _tipMessage = [[UILabel alloc]init];
    
    _tipMessage.bounds = CGRectMake(0, 0, 375, 375/300*135);
    
    _tipMessage.center = self.center;
    
    _tipMessage.textColor = [UIColor whiteColor];
    
    _tipMessage.textAlignment = NSTextAlignmentCenter;
    
    _tipMessage.font =  [UIFont fontWithName:@"RTWSYueGoTrial-Regular" size:BASE_PX * 20];
    
    _tipMessage.alpha = 0;
    
    [self addSubview:_tipMessage];
    
    //动画
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        _visualEffectView.alpha = 0.8;
        
        tipBG.alpha = 1;
        
        _tipMessage.alpha = 1;
        
    } completion:nil];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}


@end
