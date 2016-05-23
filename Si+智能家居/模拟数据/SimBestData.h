//
//  SimBestData.h
//  Si+智能家居
//
//  Created by 蒋一博 on 16/5/11.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//
/*
 该类用来模拟最佳数据的传入，作为功能一键设置的数据设置
 数据来自于 最佳环境设置算法
 此类作为最佳环境设置算法的接口
 
 */

#import <Foundation/Foundation.h>

@interface SimBestData : NSObject

/** 最佳室内温度 */
@property (strong ,nonatomic) NSString *getTemp;

/** 最佳空气净化器开启状态 */
@property (strong ,nonatomic) NSString *AQIon;

/** 最佳空气质量AQI */
@property (assign ,nonatomic) int AQIValue;

/** 最佳灯组1情况 */
@property (strong ,nonatomic) NSString *lampsOne;

/** 最佳灯组2情况 */
@property (strong ,nonatomic) NSString *lampsTwo;

@end
