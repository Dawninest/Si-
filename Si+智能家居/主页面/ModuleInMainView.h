//
//  ModuleInMainView.h
//  Si+智能家居
//
//  Created by 蒋一博 on 16/5/9.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModuleInMainView : UIView

@property (strong ,nonatomic) UILabel *moduleTitleLabel;

@property (strong ,nonatomic) UILabel *moduleValueLabel;

@property (strong ,nonatomic) UIColor *homeEventColor;


- (instancetype)initWithColor:(UIColor *)mainColor;

@end
