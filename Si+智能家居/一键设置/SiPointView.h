//
//  SiPointView.h
//  Si+智能家居
//
//  Created by 蒋一博 on 16/5/11.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SimData.h"

#import "SimBestData.h"

#import "JYRadarChart.h"

@interface SiPointView : UIView
{
    
    JYRadarChart *valueImg;
    
}

@property (strong ,nonatomic) UIVisualEffectView *visualEffectView;

/** 当前环境数据 */
@property (strong ,nonatomic) SimData *currentData;

/** 推荐环境设置 */
@property (strong ,nonatomic) SimBestData *bestData;


@property (strong ,nonatomic) NSArray *currentDataArr;

@property (strong ,nonatomic) NSArray *bestDataArr;

/** 文字数据展示板 */
@property (strong ,nonatomic) UILabel *messageBG;

@end
