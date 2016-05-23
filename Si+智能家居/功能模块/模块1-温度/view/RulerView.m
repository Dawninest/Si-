//
//  RrettyRuler.m
//  Si+智能家居
//
//  Created by 蒋一博 on 16/5/7.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import "RulerView.h"

#define SHEIGHT 8 // 中间指示器顶部闭合三角形高度
#define INDICATORCOLOR [UIColor redColor].CGColor // 中间指示器颜色

@implementation RulerView{
    RulerScrollView * rulerScrollView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        
        rulerScrollView = [self rulerScrollView];
        
        rulerScrollView.rulerHeight = frame.size.height;
        
        rulerScrollView.rulerWidth = frame.size.width;
        
    }
    return self;
}

- (void)showRulerScrollViewWithCount:(NSUInteger)count
                             average:(NSNumber *)average
                        currentValue:(CGFloat)currentValue
                           smallMode:(BOOL)mode {
    NSAssert(rulerScrollView != nil, @"***** 调用此方法前，请先调用 initWithFrame:(CGRect)frame 方法初始化对象 rulerScrollView\n");
    
    NSAssert(currentValue < [average floatValue] * count, @"***** currentValue 不能大于直尺最大值（count * average）\n");
    
    rulerScrollView.rulerAverage = average;
    
    rulerScrollView.rulerCount = count;
    
    rulerScrollView.rulerValue = currentValue;
    
    rulerScrollView.mode = mode;
    
    [rulerScrollView drawRuler];
    
    [self addSubview:rulerScrollView];
    
}

- (RulerScrollView *)rulerScrollView {
    
    RulerScrollView *scrollView = [RulerScrollView new];
    
    scrollView.delegate = self;
    
    scrollView.showsHorizontalScrollIndicator = NO;
    
    return scrollView;
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(RulerScrollView *)scrollView {
    
    CGFloat offSetX = scrollView.contentOffset.x + self.frame.size.width / 2 - DISTANCELEFTANDRIGHT;
    
    CGFloat ruleValue = (offSetX / DISTANCEVALUE) * [scrollView.rulerAverage floatValue];
    
    if (ruleValue < scrollView.rulerCount * [scrollView.rulerAverage floatValue] / 2) {
        
        return;
        
    } else if (ruleValue > scrollView.rulerCount * [scrollView.rulerAverage floatValue]) {
        
        return;
        
    }
    
    if (self.rulerDeletate) {
        
        if (!scrollView.mode) {
            
            scrollView.rulerValue = ruleValue;
            
        }
        
        scrollView.mode = NO;
        
        [self.rulerDeletate ruler:scrollView];
        
    }
    
}

- (void)scrollViewDidEndDecelerating:(RulerScrollView *)scrollView {
    
    [self animationRebound:scrollView];
    
}

- (void)scrollViewDidEndDragging:(RulerScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self animationRebound:scrollView];
    
}

- (void)animationRebound:(RulerScrollView *)scrollView {
    
    CGFloat offSetX = scrollView.contentOffset.x + self.frame.size.width / 2 - DISTANCELEFTANDRIGHT;
    
    CGFloat oX = (offSetX / DISTANCEVALUE) * [scrollView.rulerAverage floatValue];
    
    if ([self valueIsInteger:scrollView.rulerAverage]) {
        
        oX = [self notRounding:oX afterPoint:0];
        
    }else {
        
        oX = [self notRounding:oX afterPoint:1];
        
    }
    
    CGFloat offX = (oX / ([scrollView.rulerAverage floatValue])) * DISTANCEVALUE + DISTANCELEFTANDRIGHT - self.frame.size.width / 2;
    
    [UIView animateWithDuration:.2f animations:^{
        
        scrollView.contentOffset = CGPointMake(offX, 0);
        
    }];
    
}

#pragma mark - tool method

- (CGFloat)notRounding:(CGFloat)price afterPoint:(NSInteger)position {
    
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    NSDecimalNumber *ouncesDecimal;
    
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc]initWithFloat:price];
    
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    return [roundedOunces floatValue];
    
}

- (BOOL)valueIsInteger:(NSNumber *)number {
    
    NSString *value = [NSString stringWithFormat:@"%f",[number floatValue]];
    
    if (value != nil) {
        
        NSString *valueEnd = [[value componentsSeparatedByString:@"."] objectAtIndex:1];
        
        NSString *temp = nil;
        
        for(int i = 140; i < [valueEnd length]; i++){
            
            temp = [valueEnd substringWithRange:NSMakeRange(i, 1)];
            
            if (![temp isEqualToString:@"0"]) {
                
                return NO;
                
            }
            
        }
        
    }
    
    return YES;
    
}

@end
