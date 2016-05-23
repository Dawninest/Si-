//
//  AQIViewController.h
//  Si+智能家居
//
//  Created by 蒋一博 on 16/5/3.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AQIBlock)(NSString *setValue);

@interface AQIViewController : UIViewController

- (instancetype)initWithSwitch:(NSString *)value;

@property (nonatomic ,strong) AQIBlock AQIHandle;

- (void)backWithValue:(AQIBlock) backValue;

@end
