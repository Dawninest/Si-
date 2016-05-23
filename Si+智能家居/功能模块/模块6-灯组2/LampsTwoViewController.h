//
//  LampsTwoViewController.h
//  Si+智能家居
//
//  Created by 蒋一博 on 16/5/3.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^lampsTwoBlock)(NSString *setValue);

@interface LampsTwoViewController : UIViewController

@property (nonatomic ,strong) lampsTwoBlock lampHandle;

- (instancetype)initWithValue:(NSString *)value;

- (void)backWithValue:(lampsTwoBlock) backValue;

@end
