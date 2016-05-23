//
//  RrettyRuler.h
//  Si+智能家居
//
//  Created by 蒋一博 on 16/5/7.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RulerScrollView.h"

@protocol RulerViewDelegate <NSObject>

- (void)ruler:(RulerScrollView *)rulerScrollView;

@end

@interface RulerView : UIView <UIScrollViewDelegate>

@property (nonatomic, assign) id <RulerViewDelegate> rulerDeletate;

/*
 *  count * average = 刻度最大值
 *  @param count        10个小刻度为一个大刻度，大刻度的数量
 *  @param average      每个小刻度的值，最小精度 0.1
 *  @param currentValue 直尺初始化的刻度值
 *  @param mode         是否最小模式
 */

- (void)showRulerScrollViewWithCount:(NSUInteger)count
                             average:(NSNumber *)average
                        currentValue:(CGFloat)currentValue
                           smallMode:(BOOL)mode;

@end
