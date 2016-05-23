//
//  SimData.h
//  Si+智能家居
//
//  Created by 蒋一博 on 16/5/10.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//
/*
 该类用来模拟数据的传入，该App开发阶段的所有数据均来自此模拟数据接口
 此类作为开发后期的真实数据接口
 
 */

#import <Foundation/Foundation.h>

@interface SimData : NSObject

/** 当前室内温度 */
@property (strong ,nonatomic) NSString *getTemp;

/** 当前空气净化器开启状态 */
@property (strong ,nonatomic) NSString *AQIon;

/** 当前空气质量AQI */
@property (assign ,nonatomic) int AQIValue;

/** 当前灯组1情况 */
@property (strong ,nonatomic) NSString *lampsOne;

/** 当前灯组2情况 */
@property (strong ,nonatomic) NSString *lampsTwo;

@end
