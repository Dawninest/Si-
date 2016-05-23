//
//  MTTCircularSlider.m
//  圆形控制器模拟
//
//  Created by 蒋一博 on 16/4/1.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import "CircularSlider.h"


@interface CircularSlider () {
    
    CGFloat _minRotation;
    CGFloat _rotation;
    CGAffineTransform _currentTransform;
    
}
@end

@implementation CircularSlider

@synthesize maxAngle = _maxAngle;
@synthesize minAngle = _minAngle;
@synthesize circulate = _circulate;

#pragma mark -init
- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    _currentTransform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);

    _maxAngle = 360;
    _maxValue = 1;

    _circulate = NO;
}
#pragma mark -Draw UI
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
        CGFloat center = rect.size.width / 2;
        CGRect imageRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
        CGContextRef context = UIGraphicsGetCurrentContext();
    
//        CGContextTranslateCTM(context, 0, self.frame.size.width);
//        CGContextScaleCTM(context, 1.0, -1.0);

    
        CGContextDrawImage(context, imageRect, self.unselectImage.CGImage);
        CGContextSaveGState(context);
        CGContextMoveToPoint(context, center, center);
        CGContextAddArc(context, center, center, center, _minRotation, _rotation, 0);
        CGContextClosePath(context);
        CGContextClip(context);
    
        CGContextDrawImage(context, imageRect, self.selectImage.CGImage);
        CGContextRestoreGState(context);
    
    
        CGContextTranslateCTM(context, center, center);
        CGContextConcatCTM(context, _currentTransform);
        CGContextTranslateCTM(context, -(center), -(center));
        CGContextDrawImage(context, CGRectMake(self.frame.size.width * 0.1, self.frame.size.width * 0.1, self.frame.size.width * 0.8, self.frame.size.width * 0.8), self.indicatorImage.CGImage);
    
    
}

#pragma mark -Event
- (BOOL)continueTrackingWithTouch:(UITouch*)touch withEvent:(nullable UIEvent*)event
{
    [super continueTrackingWithTouch:touch withEvent:event];
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGPoint starTouchPoint = [touch locationInView:self];
    CGPoint endTouchPoint = [touch previousLocationInView:self];
    CGFloat rotation = atan2f(starTouchPoint.y - center.y, starTouchPoint.x - center.x) - atan2f(endTouchPoint.y - center.y, endTouchPoint.x - center.x);
  
    
    CGAffineTransform transform = CGAffineTransformRotate(_currentTransform, rotation);
    [self changAngleWithTransform:transform];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}
- (void)endTrackingWithTouch:(nullable UITouch*)touch withEvent:(nullable UIEvent*)event
{
    [super endTrackingWithTouch:touch withEvent:event];
    [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
}

#pragma mark -Angle
- (void)setMaxAngle:(NSInteger)maxAngle
{
    _maxAngle = (self.minAngle > maxAngle || maxAngle > 360) ? 360 : maxAngle;
    self.angle = (self.angle > _maxAngle) ? _maxAngle : self.angle;
    [self setNeedsDisplay];
}
- (void)setMinAngle:(NSInteger)minAngle
{
    _minAngle = (self.maxAngle < minAngle || minAngle < 0) ? 0 : minAngle;
    CGAffineTransform transform = CGAffineTransformMakeRotation((M_PI * _minAngle) / 180.0);
    CGFloat r = acosf(transform.a);
    _minRotation = (transform.b < 0) ? (2 * M_PI - r) : r;
    self.angle = (self.angle < _minAngle) ? _minAngle : self.angle;
    [self setNeedsDisplay];
}
- (void)setAngle:(NSInteger)angle
{
    if (angle > self.maxAngle)
        _angle = self.maxAngle;
    else if (angle < self.minAngle)
        _angle = self.minAngle;
    else
        _angle = angle;
    
    CGAffineTransform transform = CGAffineTransformMakeRotation((M_PI * _angle) / 180.0);
    _currentTransform = transform;
    CGFloat r = acosf(transform.a);
    _rotation = (transform.b < 0) ? (2 * M_PI - r) : r;
    
    if (self.maxAngle == self.minAngle) {
        _value = self.maxValue;
    }
    else {
        _value = ((float)_angle - (float)self.minAngle) / ((float)self.maxAngle - (float)self.minAngle) * self.maxValue;
    }
    
    [self setNeedsDisplay];
}
- (void)changAngleWithTransform:(CGAffineTransform)transform
{
    if (!self.isCirculate) {
        if (_currentTransform.b < 0 && _currentTransform.a > 0 && transform.b > 0 && transform.a > 0) {
            if (self.angle == 360) {
                return;
            }
            self.angle = 360;
            return;
        }
        else if (_currentTransform.b >= 0 && _currentTransform.a >= 0 && transform.b < 0 && transform.a > 0) {
            if (self.angle == 0) {
                return;
            }
            self.angle = 0;
            return;
        }
    }
    CGFloat r = acosf(transform.a);
    _currentTransform = transform;
    _rotation = (transform.b < 0) ? (2 * M_PI - r) : r;
    self.angle = _rotation / M_PI * 180;
}

#pragma mark -Value
- (void)setMaxValue:(CGFloat)maxValue
{
    _maxValue = maxValue;
    self.value = self.minValue + ((_maxValue - self.minValue) * ((float)self.angle / (float)self.maxAngle));
}
- (void)setMinValue:(CGFloat)minValue
{
    _minValue = minValue;
    self.value = _minValue + ((self.maxValue - _minValue) * ((float)self.angle / (float)self.maxAngle));
}
- (void)setValue:(CGFloat)value
{
    if (value < self.minValue) {
        _value = self.minValue;
    }
    else if (value > self.maxValue) {
        _value = self.maxValue;
    }
    else {
        _value = value;
    }
    self.angle = _value / self.maxValue * (float)self.maxAngle;
}

#pragma mark -UI Attribute


- (void)setSelectImage:(UIImage*)selectImage
{
    _selectImage = selectImage;
    [self setNeedsDisplay];
}
- (void)setUnselectImage:(UIImage*)unselectImage
{
    _unselectImage = unselectImage;
    [self setNeedsDisplay];
}
- (void)setIndicatorImage:(UIImage*)indicatorImage
{
    _indicatorImage = indicatorImage;
    [self setNeedsDisplay];
}



@end
