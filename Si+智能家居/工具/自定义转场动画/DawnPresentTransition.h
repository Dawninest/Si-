//
//  DawnTransition.h
//  Si+智能家居
//
//  Created by 蒋一博 on 16/5/4.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface DawnPresentTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (assign ,nonatomic)CGFloat duration;
@property (strong ,nonatomic)UIView *containerBackgroundView;

- (void)registerStartFrame:(CGRect)startFrame
                finalFrame:(CGRect)finalFrame
            transitionView:(UIView *)transitionView;

@end
