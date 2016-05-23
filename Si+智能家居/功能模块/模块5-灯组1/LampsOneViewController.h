//
//  LampsOneViewController.h
//  Si+智能家居
//
//  Created by 蒋一博 on 16/5/3.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^lampsOneBlock)(NSString *setValue);

@interface LampsOneViewController : UIViewController

@property (nonatomic ,strong) lampsOneBlock lampHandle;

- (instancetype)initWithValue:(NSString *)value;

- (void)backWithValue:(lampsOneBlock) backValue;

@end
