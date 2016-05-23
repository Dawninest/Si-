//
//  ModuleInMainView.m
//  Si+智能家居
//
//  Created by 蒋一博 on 16/5/9.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import "ModuleInMainView.h"

@implementation ModuleInMainView

- (instancetype)initWithColor:(UIColor *)mainColor{
    
    self = [super init];
    if (self) {
        
        _homeEventColor = mainColor;
        
        self.backgroundColor = [UIColor blackColor];
        
        self.bounds = CGRectMake(0, 0, BASE_PX * 100, BASE_PX * 113);
        
        [self initUI];
        
    }
    
    return self;
    
}

- (void)initUI{
    
    _moduleTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(BASE_PX * 15, BASE_PX * 30, BASE_PX * 70, BASE_PX * 20)];
    
    _moduleTitleLabel.text = @"";
    
    _moduleTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    _moduleTitleLabel.textColor = [UIColor whiteColor];
    
    _moduleTitleLabel.font =  [UIFont fontWithName:@"RTWSYueGoTrial-Regular" size:BASE_PX * 15];
    
    [self addSubview:_moduleTitleLabel];
    
    _moduleValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(BASE_PX * 15, BASE_PX * 50, BASE_PX * 70, BASE_PX * 30)];
    
    _moduleValueLabel.text = @"";
    
    _moduleValueLabel.textAlignment = NSTextAlignmentCenter;
    
    _moduleValueLabel.textColor = _homeEventColor;
    
    _moduleValueLabel.font =  [UIFont fontWithName:@"orbitron-bold" size:BASE_PX * 20];
    
    [self addSubview:_moduleValueLabel];
    
    
}




@end
