//
//  SiPointView.m
//  Si+智能家居
//
//  Created by 蒋一博 on 16/5/11.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import "SiPointView.h"

@implementation SiPointView

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        self.frame = [UIScreen mainScreen].bounds;
        
        self.backgroundColor = [UIColor clearColor];
        
        [self initData];
        
        [self initUI];
        
    }
    
    return self;
    
}

- (void)initData{
    
    _currentData = [[SimData alloc]init];
    
    _bestData = [[SimBestData alloc]init];
    
    [self initCurrentData];
    
    [self initBestData];

    
}

- (void)initUI{
    
    //背后模糊板
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    _visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    
    _visualEffectView.alpha = 1;
    
    [_visualEffectView setFrame:self.frame];
    
    [self addSubview:_visualEffectView];
    
    UIImageView *imgBG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sipointBG"]];
    

    //数据图BG
    imgBG.frame = CGRectMake(BASE_PX * 10, BASE_PX * (467 / 2 - 150), BASE_PX * 355, BASE_PX * 355 / 619 * 370);
    
    imgBG.backgroundColor = [UIColor clearColor];
    
    imgBG.alpha = 1;
    
    [self addSubview:imgBG];
    
    //按钮背景
    UIImageView *tipBG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TipBG"]];

    tipBG.frame = CGRectMake( BASE_PX * 10, BASE_PX *  510, BASE_PX *  355, BASE_PX *  100);
    
    [self addSubview:tipBG];
    
    //按钮
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    setButton.frame = CGRectMake( BASE_PX * 10, BASE_PX *  510, BASE_PX *  355,BASE_PX *  100);
    
    [setButton setTitle:@"一键设置" forState:UIControlStateNormal];
    
    [setButton setTintColor:[UIColor whiteColor]];
    
    setButton.titleLabel.font = [UIFont fontWithName:@"RTWSYueGoTrial-Regular" size:BASE_PX * 30];
    
    [setButton addTarget:self action:@selector(setUp) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:setButton];
    
    
    //数据图
    
    valueImg = [[JYRadarChart alloc] initWithFrame:CGRectMake(BASE_PX * 75 / 2,BASE_PX * (467 / 2 - 140), BASE_PX * 300,BASE_PX * 200)];
    
    valueImg.dataSeries = @[_currentDataArr, _bestDataArr];
    
    valueImg.steps = 3;
    
    valueImg.showStepText = NO;
    
    valueImg.backgroundColor = [UIColor clearColor];
    
    valueImg.backgroundLineColor = [UIColor blueColor];
    
    valueImg.r = 80;
    
    valueImg.minValue = 0;
    
    valueImg.maxValue = 100;
    
    valueImg.showStepText = NO;
    
    valueImg.fillArea = NO;
    
    valueImg.colorOpacity = 1;
    
    valueImg.attributes = @[@"温度", @"净化开关", @"AQI指数", @"空气舒适", @"灯1", @"灯2"];
    
    valueImg.showLegend = YES;
    
    [valueImg setTitles:@[@"当前环境", @"最佳环境"]];
    
    [valueImg setColors:@[OUTHOME_COLOR, INHOME_COLOR]];
    
    [self addSubview:valueImg];
    
    //文字数据背景
    _messageBG = [[UILabel alloc]initWithFrame:CGRectMake(BASE_PX * 0, BASE_PX * 305 , BASE_PX * 375, BASE_PX * 200)];
    
    _messageBG.backgroundColor = [UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:0.1];
    
    [self addSubview:_messageBG];
    
    [self initMessage];
    
    self.alpha = 0;
    
    //出现动画
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.alpha = 1;
        
    } completion:nil];
    
    
}

#pragma mark -- 回跳转
- (void)setUp{

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];

}

#pragma mark -- 文字数据展示
- (void)initMessage{
    
    //标题
    NSArray *tipName = @[@"",@"室内温度", @"净化开关", @"AQI指数", @"空气舒适", @"客厅灯组", @"卧室灯组"];
    
    for (NSInteger index = 0; index < 7; index ++) {
        
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(BASE_PX * 20,  BASE_PX * (12.5 + index * 25), BASE_PX * 100, BASE_PX * 25)];
        
        tipLabel.text = tipName[index];
        
        tipLabel.textAlignment = NSTextAlignmentLeft;
        
        tipLabel.textColor = [UIColor whiteColor];
        
        tipLabel.font =  [UIFont fontWithName:@"RTWSYueGoTrial-Regular" size:BASE_PX * 15];
        
        [_messageBG addSubview:tipLabel];
        
    }
    
    //当前环境数据
    
    NSString *currentAQILV = @"";
    
    if (_currentData.AQIValue < 100 ) {
        
        currentAQILV = @"优";
        
    }else if (_currentData.AQIValue < 200 ){
        
        currentAQILV = @"中";
        
    }else{
        
        currentAQILV = @"差";
        
    }

    NSString *currentAQIValue = [NSString stringWithFormat:@"%d",_currentData.AQIValue];
    
    NSArray *currentArr = @[@"当前环境",_currentData.getTemp,_currentData.AQIon,currentAQIValue,currentAQILV,_currentData.lampsOne,_currentData.lampsTwo];
    
    for (NSInteger index = 0; index < 7; index ++) {
        
        UILabel *currentLabel = [[UILabel alloc]initWithFrame:CGRectMake(BASE_PX * 137.5,  BASE_PX * (12.5 + index * 25), BASE_PX * 100, BASE_PX * 25)];
        
        currentLabel.text = currentArr[index];
        
        currentLabel.textAlignment = NSTextAlignmentLeft;
        
        currentLabel.textColor = OUTHOME_COLOR;
        
        currentLabel.font =  [UIFont fontWithName:@"orbitron-bold" size:BASE_PX * 15];
        
        if (index == 0 || index == 4) {
            currentLabel.font =  [UIFont fontWithName:@"RTWSYueGoTrial-Regular" size:BASE_PX * 15];
        }
        

        
        [_messageBG addSubview:currentLabel];
        
    }
    
    //最佳环境设置
    
    NSString *bestAQILV = @"";
    
    if (_bestData.AQIValue < 100 ) {
        
        bestAQILV = @"优";
        
    }else if (_bestData.AQIValue < 200 ){
        
        bestAQILV = @"中";
        
    }else{
        
        bestAQILV = @"差";
        
    }
    
    NSString *bestAQIValue = [NSString stringWithFormat:@"%d",_bestData.AQIValue];
    
    NSArray *bestArr = @[@"推荐设置",_bestData.getTemp,_bestData.AQIon,bestAQIValue,bestAQILV,_bestData.lampsOne,_bestData.lampsTwo];
    
    for (NSInteger index = 0; index < 7; index ++) {
        
        UILabel *currentLabel = [[UILabel alloc]initWithFrame:CGRectMake(BASE_PX * 255,  BASE_PX * (12.5 + index * 25), BASE_PX * 100, BASE_PX * 25)];
        
        currentLabel.text = bestArr[index];
        
        currentLabel.textAlignment = NSTextAlignmentLeft;
        
        currentLabel.textColor = INHOME_COLOR;
        
        currentLabel.font =  [UIFont fontWithName:@"orbitron-bold" size:BASE_PX * 15];
        
        if (index == 0 || index == 4) {
            currentLabel.font =  [UIFont fontWithName:@"RTWSYueGoTrial-Regular" size:BASE_PX * 15];
        }
        
        
        
        [_messageBG addSubview:currentLabel];
        
    }

}

#pragma mark -- 数据加载
- (void)initCurrentData{
    
    
    int currentTemp = [_currentData.getTemp intValue] * 100 / 28;
    
    int currentAQIOn = 100 / 3;
    
    if ([_currentData.AQIon isEqualToString:@"ON"]) {
        
        currentAQIOn = 200 / 3;
        
    }
    
    int currentAQIValue = _currentData.AQIValue / 3;
    
    int currentAQILV = 100;
    
    if (_currentData.AQIValue < 100 ) {
        
        currentAQILV = 100;
        
    }else if (_currentData.AQIValue < 200 ){
        
        currentAQILV = 200 / 3;
        
    }else{
        
        currentAQILV = 100 / 3;
        
    }
    
    int currentLampsOne = 100 / 3;
    
    if (![_currentData.lampsOne isEqualToString:@"OFF"]) {
        
        currentLampsOne = [_currentData.lampsOne intValue] / 100;
        
    }
    
    int currentLampsTwo = 100 / 3;
    
    if (![_currentData.lampsTwo isEqualToString:@"OFF"]) {
        
        currentLampsTwo = [_currentData.lampsTwo intValue] / 100;
        
    }
    
    self.currentDataArr = @[@(currentTemp),@(currentAQIOn),@(currentAQIValue),@(currentAQILV),@(currentLampsOne),@(currentLampsTwo)];

}

- (void)initBestData{
 
    int bestTemp = [_bestData.getTemp intValue] * 100 / 28;
    
    int bestAQIOn = 100 / 3;
    
    if ([_bestData.AQIon isEqualToString:@"ON"]) {
        
        bestAQIOn = 200 / 3;
        
    }
    
    int bestAQIValue = _bestData.AQIValue / 3;
    
    int bestAQILV = 100;
    
    if (_bestData.AQIValue < 100 ) {
        
        bestAQILV = 100;
        
    }else if (_bestData.AQIValue < 200 ){
        
        bestAQILV = 200 / 3;
        
    }else{
        
        bestAQILV = 100 / 3;
        
    }
    
    int bestLampsOne = 100 / 3;
    
    if (![_bestData.lampsOne isEqualToString:@"OFF"]) {
        
        bestLampsOne = 200 / 3;
        
    }
    
    int bestLampsTwo = 100 / 3;
    
    if (![_bestData.lampsTwo isEqualToString:@"OFF"]) {
        
        bestLampsTwo = 200 / 3;
        
    }
    
    self.bestDataArr = @[@(bestTemp),@(bestAQIOn),@(bestAQIValue),@(bestAQILV),@(bestLampsOne),@(bestLampsTwo)];
    
}

@end
