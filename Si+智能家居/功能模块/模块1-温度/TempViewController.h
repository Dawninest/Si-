//
//  TempViewController.h
//  Si+智能家居
//
//  Created by 蒋一博 on 16/5/3.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^tempBlock)(NSString *setTemp);

@interface TempViewController : UIViewController

@property (nonatomic ,strong) NSString *getTemp;

@property (nonatomic ,strong) UILabel *showLabel;

@property (nonatomic ,strong) tempBlock tempHandle;

- (instancetype)initWithTemp:(NSString *)temp;

- (void)backWithTemp:(tempBlock) backTemp;

@end
