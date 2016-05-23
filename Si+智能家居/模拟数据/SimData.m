//
//  SimData.m
//  Si+智能家居
//
//  Created by 蒋一博 on 16/5/10.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//


#import "SimData.h"

@implementation SimData

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _getTemp = @"22℃";
        
        _AQIon = @"OFF";
        
        _AQIValue = 150;
        
        _lampsOne = @"OFF";
        
        _lampsTwo = @"OFF";
        
    }
    return self;
}



@end
