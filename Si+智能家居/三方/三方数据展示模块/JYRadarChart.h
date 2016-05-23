//
//  JYRadarChart.h
//  JYRadarChart
//
//  Created by jy on 13-10-31.
//  Copyright (c) 2013年 wcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYRadarChart : UIView

@property (nonatomic, assign) CGFloat r;//半径

@property (nonatomic, assign) CGFloat maxValue;

@property (nonatomic, assign) CGFloat minValue;

@property (nonatomic, assign) BOOL drawPoints;//是否有顶点点

@property (nonatomic, assign) BOOL fillArea;//是否被颜色填充

@property (nonatomic, assign) BOOL showLegend;//是否显示legend

@property (nonatomic, assign) BOOL showStepText;//是否显示数字

@property (nonatomic, assign) CGFloat colorOpacity;//颜色透明度

@property (nonatomic, copy) UIColor *backgroundLineColor;

@property (nonatomic, strong) NSArray *dataSeries;

@property (nonatomic, strong) NSArray *attributes;

@property (nonatomic, assign) NSUInteger steps;//每个小三角形被分割的层数

@property (nonatomic, assign) CGPoint centerPoint;

- (void)setTitles:(NSArray *)titles;
- (void)setColors:(NSArray *)colors;

@end
