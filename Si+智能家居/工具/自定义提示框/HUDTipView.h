//
//  HUDTipView.h
//  Si+智能家居
//
//  Created by 蒋一博 on 16/5/5.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HUDTipView : UIView

@property (strong ,nonatomic) UILabel *tipMessage;

@property (strong ,nonatomic) UIVisualEffectView *visualEffectView;

- (instancetype)init;

@end
