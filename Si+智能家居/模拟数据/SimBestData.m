//
//  SimBestData.m
//  Si+智能家居
//
//  Created by 蒋一博 on 16/5/11.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import "SimBestData.h"

@implementation SimBestData

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _getTemp = @"23℃";
        
        _AQIon = @"ON";
        
        _AQIValue = 70;
        
        _lampsOne = @"100%";
        
        _lampsTwo = @"100%";
        
    }
    return self;
}


@end
