//
//  RulerScrollView.h
//  Si+智能家居
//
//  Created by 蒋一博 on 16/5/7.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DISTANCELEFTANDRIGHT 8.f // 标尺左右距离

#define DISTANCEVALUE 8.f // 每隔刻度实际长度8个点

#define DISTANCETOPANDBOTTOM 20.f // 标尺上下距离

@interface RulerScrollView : UIScrollView

@property (nonatomic) NSUInteger rulerCount;

@property (nonatomic) NSNumber * rulerAverage;

@property (nonatomic) NSUInteger rulerHeight;

@property (nonatomic) NSUInteger rulerWidth;

@property (nonatomic) CGFloat rulerValue;

@property (nonatomic) BOOL mode;

- (void)drawRuler;

@end
