//
//  MainViewController.m
//  Si+智能家居
//
//  Created by 蒋一博 on 16/5/3.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import "MainViewController.h"

#import "SimData.h"

#import "HUDTipView.h"

#import "DawnSimpleTransition.h"

#import "SiPointView.h"

#import "ModuleInMainView.h"

#import "TempViewController.h"

#import "AQIViewController.h"

#import "GPSViewController.h"

#import "LampsOneViewController.h"

#import "LampsTwoViewController.h"

@interface MainViewController ()<UIViewControllerTransitioningDelegate>

/** 读取数据 */
@property (strong ,nonatomic) SimData *data;

@property (assign ,nonatomic) BOOL homeEvent;

@property (strong ,nonatomic) UIColor     *homeEventColor;

@property (strong ,nonatomic) UILabel     *homeEventBG;

@property (strong ,nonatomic) UIButton    *SiButton;

@property (strong ,nonatomic) UIImageView *mainVC_BG;

@property (strong ,nonatomic) UIImageView *moduleOneTemp;

@property (strong ,nonatomic) ModuleInMainView *tempInMain;

@property (strong ,nonatomic) UIImageView *moduleTwoAQI;

@property (strong ,nonatomic) ModuleInMainView *AQIInMain;

@property (strong ,nonatomic) UIButton    *homeEventButton;

@property (strong ,nonatomic) UIImageView *moduleThreeGPS;

@property (strong ,nonatomic) UIButton    *lockEventButton;

@property (strong ,nonatomic) UIImageView *moduleFourLock;

@property (strong ,nonatomic) ModuleInMainView *lampsOneInMain;

@property (strong ,nonatomic) UIImageView *moduleFiveLampsOne;

@property (strong ,nonatomic) ModuleInMainView  *lampsTwoInMain;

@property (strong ,nonatomic) UIImageView *moduleSixLampsTwo;

@property (strong ,nonatomic) DawnSimpleTransition *SimpleTransition;

@end

@implementation MainViewController

- (instancetype)initWithHomeEvent:(BOOL)homeEvent{
    
    self = [super init];
    if (self) {
        _homeEvent = homeEvent;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self initializeDataSource];
    
    [self initializeInterface];
    
}

- (void)initializeDataSource{
    
    _data = [[SimData alloc]init];
    
    if (_homeEvent == 0) {
        
        self.homeEventColor = OUTHOME_COLOR;
        
    }else{
        
        self.homeEventColor = INHOME_COLOR;
        
    }

}

- (void)initializeInterface{
    
    UIImageView *topTipBG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TipBG"]];
    
    topTipBG.frame = CGRectMake(BASE_PX * 75 / 2, BASE_PX * 20, BASE_PX * 300, BASE_PX * 135 * 0.7);
    
    [self.view addSubview:topTipBG];
    
    UILabel *topTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(BASE_PX * 75 / 2, BASE_PX * 20, BASE_PX * 300, BASE_PX * 135 * 0.7)];
    
    topTipLabel.text = @"Si +";
    
    topTipLabel.textAlignment = NSTextAlignmentCenter;
    
    topTipLabel.textColor = [UIColor whiteColor];
    
    topTipLabel.font =  [UIFont fontWithName:@"orbitron-bold" size:BASE_PX * 40];

    [self.view addSubview:topTipLabel];
    
    [self.view addSubview:self.homeEventBG];
    
    [self.view addSubview:self.mainVC_BG];
    
    [self.view addSubview:self.SiButton];
    
    [self.view addSubview:self.tempInMain];
    
    [self.view addSubview:self.moduleOneTemp];
    
    [self.view addSubview:self.AQIInMain];
    
    [self.view addSubview:self.moduleTwoAQI];
    
    [self.view addSubview:self.homeEventButton];
    
    [self.view addSubview:self.moduleThreeGPS];
    
    [self.view addSubview:self.lockEventButton];
    
    [self.view addSubview:self.moduleFourLock];
    
    [self.view addSubview:self.lampsOneInMain];
    
    [self.view addSubview:self.moduleFiveLampsOne];
    
    [self.view addSubview:self.lampsTwoInMain];
    
    [self.view addSubview:self.moduleSixLampsTwo];
    
    [self createTransitionForTaped];
    
    [self initTapGesture];
    
    
}

#pragma mark -- 相关手势
- (void)initTapGesture{

    UITapGestureRecognizer *tempTapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setTemp)];
    
    [self.tempInMain addGestureRecognizer:tempTapGes];
    
    UITapGestureRecognizer *AQITapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setAQI)];
    
    [self.AQIInMain addGestureRecognizer:AQITapGes];
    
    UITapGestureRecognizer *lampsOneTapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setLampsOne)];
    
    [self.lampsOneInMain addGestureRecognizer:lampsOneTapGes];
    
    UITapGestureRecognizer *lampsTwoTapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setLampsTwo)];
    
    [self.lampsTwoInMain addGestureRecognizer:lampsTwoTapGes];
    
}

#pragma mark -- 模块一 Temp设置
- (void)setTemp{
    
    if (_homeEvent == 0) {
        
        HUDTipView *lockTip = [[HUDTipView alloc]init];
        
        lockTip.tipMessage.text = @"离家状态无法使用此功能";
        
        [self.view addSubview:lockTip];
        
    }else{
    
        TempViewController *temVC = [[TempViewController alloc]initWithTemp:_tempInMain.moduleValueLabel.text];
        
        temVC.modalPresentationStyle = UIModalPresentationCustom;
        
        temVC.transitioningDelegate = self;
        
        [temVC backWithTemp:^(NSString *setTemp) {
            
            NSString *showTemp = [setTemp substringToIndex:2];
            
            _tempInMain.moduleValueLabel.text = [NSString stringWithFormat:@"%@℃",showTemp];
            
        }];
        
        [self presentViewController:temVC animated:YES completion:nil];
        
    }
    
}

#pragma mark -- 模块二 AQI设置
- (void)setAQI{
    
    if (_homeEvent == 0) {
        
        HUDTipView *lockTip = [[HUDTipView alloc]init];
        
        lockTip.tipMessage.text = @"离家状态无法使用此功能";
        
        [self.view addSubview:lockTip];
        
    }else{
    
        AQIViewController *AQIVC = [[AQIViewController alloc]initWithSwitch:_AQIInMain.moduleValueLabel.text];
        
        AQIVC.modalPresentationStyle = UIModalPresentationCustom;
        
        AQIVC.transitioningDelegate = self;
        
        [AQIVC setAQIHandle:^(NSString *setValue){
        
            _AQIInMain.moduleValueLabel.text = setValue;
        
        }];
        
        [self presentViewController:AQIVC animated:YES completion:nil];
        
    }
    
}

#pragma mark -- 模块三 GPS设置
- (void)setGPS{
    
    GPSViewController *GPSVC = [[GPSViewController alloc]init];
    
    GPSVC.modalPresentationStyle = UIModalPresentationCustom;
    
    GPSVC.transitioningDelegate = self;
    
    [GPSVC backWithHomeEvent:^(BOOL homeEvent) {
        
        _homeEvent = homeEvent;
        
        if (_homeEvent == 0) {
            
            [_homeEventButton setTitle:@"Out Home" forState:UIControlStateNormal];
            
            self.homeEventColor = OUTHOME_COLOR;
            
        }else{
            
            [_homeEventButton setTitle:@"In Home" forState:UIControlStateNormal];
            
            self.homeEventColor = INHOME_COLOR;
            
        }
        
        _homeEventBG.backgroundColor = self.homeEventColor;
        
        _homeEventButton.backgroundColor = self.homeEventColor;
        
        _lockEventButton.backgroundColor = self.homeEventColor;
        
        _tempInMain.moduleValueLabel.textColor = self.homeEventColor;
        
        _AQIInMain.moduleValueLabel.textColor = self.homeEventColor;
        
        _lampsOneInMain.moduleValueLabel.textColor = self.homeEventColor;
        
        _lampsTwoInMain.moduleValueLabel.textColor = self.homeEventColor;
        
    }];
    
    [self presentViewController:GPSVC animated:YES completion:nil];
    
}

#pragma mark -- 模块四 Lock设置
- (void)setLock{
    
    if (_homeEvent == 0) {
        
        HUDTipView *lockTip = [[HUDTipView alloc]init];
        
        lockTip.tipMessage.text = @"离家状态无法使用此功能";
        
        [self.view addSubview:lockTip];
        
    }else{
        
        HUDTipView *lockTip = [[HUDTipView alloc]init];
        
        lockTip.tipMessage.text = @"开锁请求中";
        
        [self.view addSubview:lockTip];
    
    }
    
}

#pragma mark -- 模块五 LampsOne设置
- (void)setLampsOne{
    
    if (_homeEvent == 0) {
        
        HUDTipView *lockTip = [[HUDTipView alloc]init];
        
        lockTip.tipMessage.text = @"离家状态无法使用此功能";
        
        [self.view addSubview:lockTip];
        
    }else{
        
        LampsOneViewController *LampsOneVC = [[LampsOneViewController alloc]initWithValue:self.lampsOneInMain.moduleValueLabel.text];
        
        LampsOneVC.modalPresentationStyle = UIModalPresentationCustom;
        
        LampsOneVC.transitioningDelegate = self;
        
        [LampsOneVC backWithValue:^(NSString *setValue) {
            
            self.lampsOneInMain.moduleValueLabel.text = setValue;
            
        }];
        
        [self presentViewController:LampsOneVC animated:YES completion:nil];
        
    }
    
}

#pragma mark -- 模块六 LampsTwo设置
- (void)setLampsTwo{
    
    if (_homeEvent == 0) {
        
        HUDTipView *lockTip = [[HUDTipView alloc]init];
        
        lockTip.tipMessage.text = @"离家状态无法使用此功能";
        
        [self.view addSubview:lockTip];
        
    }else{
        
        LampsTwoViewController *LampsTwoVC = [[LampsTwoViewController alloc]initWithValue:self.lampsTwoInMain.moduleValueLabel.text];
        
        LampsTwoVC.modalPresentationStyle = UIModalPresentationCustom;
        
        LampsTwoVC.transitioningDelegate = self;
        
        [LampsTwoVC backWithValue:^(NSString *setValue) {
            
            self.lampsTwoInMain.moduleValueLabel.text = setValue;
            
        }];
        
        [self presentViewController:LampsTwoVC animated:YES completion:nil];
        
    }
    
}

#pragma mark -- SiButton 按钮响应
- (void)siButtonTaped{

    if (_homeEvent == 0) {
        
        HUDTipView *lockTip = [[HUDTipView alloc]init];
        
        lockTip.tipMessage.text = @"离家状态无法使用此功能";
        
        [self.view addSubview:lockTip];
        
    }else{
    
        SiPointView *siPont = [[SiPointView alloc]init];
        
        [self.view addSubview:siPont];
    
    }
    
 
}

#pragma mark -- GPS Transition
- (void)createTransitionForTaped{
    
    self.SimpleTransition = [[DawnSimpleTransition alloc] initWithAnimatedView:self.homeEventBG];
    
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    self.SimpleTransition.reverse = NO;
    
    return self.SimpleTransition;
    
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    self.SimpleTransition.reverse = YES;
    
    return self.SimpleTransition;
    
}




#pragma mark -- Getter
- (UILabel *)homeEventBG{

    if (_homeEventBG == nil) {
        
        _homeEventBG = [[UILabel alloc]init];
        
        _homeEventBG.bounds = CGRectMake(0, 0, BASE_PX * 200, BASE_PX * 200);
        
        _homeEventBG.center = self.view.center;
        
        _homeEventBG.layer.cornerRadius = 65 / 2.;
        
        _homeEventBG.layer.masksToBounds = YES;
        
        _homeEventBG.backgroundColor = self.homeEventColor;
        
    }

    return _homeEventBG;
}


- (UIButton *)SiButton{
    
    if (_SiButton == nil) {
        
        _SiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _SiButton.frame = CGRectMake(BASE_PX * 147, BASE_PX * 285, BASE_PX * 82, BASE_PX * 82 / 130 * 150);
        //CGRectMake(BASE_PX * 147, BASE_PX * 285, BASE_PX * 82, BASE_PX * 82 / 130 * 150)
        //CGRectMake(BASE_PX * 121, BASE_PX * 253, BASE_PX * 133, BASE_PX * 160)

        [_SiButton setImage:[UIImage imageNamed:@"Logo"] forState:UIControlStateNormal];
        
        [_SiButton addTarget:self action:@selector(siButtonTaped) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _SiButton;
}

- (UIImageView *)mainVC_BG{
    
    if (_mainVC_BG == nil) {
        
        _mainVC_BG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"主页蜂窝"]];
        
        _mainVC_BG.bounds = CGRectMake(0, 0, BASE_PX * 375, BASE_PX * 344);
        
        _mainVC_BG.center = self.view.center;
        
    }
    
    return _mainVC_BG;
}

- (UIImageView *)moduleOneTemp{
    
    if (_moduleOneTemp == nil) {
        
        _moduleOneTemp = [[UIImageView alloc]initWithFrame:CGRectMake(BASE_PX * 65, BASE_PX * 135, BASE_PX * 100, BASE_PX * 113)];
        
        [_moduleOneTemp setImage:[UIImage imageNamed:@"homeEvent"]];
        
    }

    return _moduleOneTemp;
}

- (ModuleInMainView *)tempInMain{
    
    if (_tempInMain == nil) {
        
        _tempInMain = [[ModuleInMainView alloc]initWithColor:self.homeEventColor];
        
        _tempInMain.frame = CGRectMake(BASE_PX * 65, BASE_PX * 135, BASE_PX * 100, BASE_PX * 113);
        
        _tempInMain.moduleTitleLabel.text = @"室内温度";
        
        _tempInMain.moduleValueLabel.text = self.data.getTemp;

    }
    
    return _tempInMain;
}

- (UIImageView *)moduleTwoAQI{
    
    if (_moduleTwoAQI == nil) {
        
        _moduleTwoAQI = [[UIImageView alloc]initWithFrame:CGRectMake(BASE_PX * 211, BASE_PX * 135, BASE_PX * 100, BASE_PX * 113)];
        
        [_moduleTwoAQI setImage:[UIImage imageNamed:@"homeEvent"]];
        
    }
    
    return _moduleTwoAQI;
}

- (ModuleInMainView *)AQIInMain{

    if (_AQIInMain == nil) {
        
        _AQIInMain = [[ModuleInMainView alloc]initWithColor:self.homeEventColor];
        
        _AQIInMain.frame = CGRectMake(BASE_PX * 211, BASE_PX * 135, BASE_PX * 100, BASE_PX * 113);
        
        _AQIInMain.moduleTitleLabel.text = @"空气净化";
        
        _AQIInMain.moduleValueLabel.text = self.data.AQIon;
        
    }
    
    return _AQIInMain;
}

- (UIButton *)homeEventButton{

    if (_homeEventButton == nil) {
        
        _homeEventButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _homeEventButton.frame = CGRectMake(BASE_PX * 0, BASE_PX * 275, BASE_PX * 100, BASE_PX * 113);
        
        if (_homeEvent == 0) {
            
            [_homeEventButton setTitle:@"Out Home" forState:UIControlStateNormal];
            
            _homeEventButton.backgroundColor = OUTHOME_COLOR;
            
        }else{
            
            [_homeEventButton setTitle:@"In Home" forState:UIControlStateNormal];
            
            _homeEventButton.backgroundColor = INHOME_COLOR;
        }
        
        _homeEventButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [_homeEventButton setTintColor:[UIColor whiteColor]];
        
        _homeEventButton.titleLabel.font =  [UIFont fontWithName:@"orbitron-bold" size:BASE_PX * 13];
        
        [_homeEventButton addTarget:self action:@selector(setGPS) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _homeEventButton;
}

- (UIImageView *)moduleThreeGPS{
    
    if (_moduleThreeGPS == nil) {
        
        _moduleThreeGPS = [[UIImageView alloc]initWithFrame:CGRectMake(BASE_PX * 0, BASE_PX * 275, BASE_PX * 100, BASE_PX * 113)];
        
        [_moduleThreeGPS setImage:[UIImage imageNamed:@"homeEvent"]];
        
    }
    
    return _moduleThreeGPS;
}

- (UIButton *)lockEventButton{

    if (_lockEventButton == nil) {
        
        _lockEventButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _lockEventButton.frame = CGRectMake(BASE_PX * 273, BASE_PX * 275, BASE_PX * 100, BASE_PX * 113);
            
        _lockEventButton.backgroundColor = self.homeEventColor;
       
        [_lockEventButton addTarget:self action:@selector(setLock) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _lockEventButton;
}

- (UIImageView *)moduleFourLock{
    
    if (_moduleFourLock == nil) {
        
        _moduleFourLock = [[UIImageView alloc]initWithFrame:CGRectMake(BASE_PX * 273, BASE_PX * 275, BASE_PX * 100, BASE_PX * 113)];
        
        [_moduleFourLock setImage:[UIImage imageNamed:@"lockEvent"]];
        
    }
    
    return _moduleFourLock;
}

- (ModuleInMainView *)lampsOneInMain{

    if (_lampsOneInMain == nil) {
        
        _lampsOneInMain = [[ModuleInMainView alloc]initWithColor:self.homeEventColor];
        
        _lampsOneInMain.frame = CGRectMake(BASE_PX * 65, BASE_PX * 412, BASE_PX * 100, BASE_PX * 113);
        
        _lampsOneInMain.moduleTitleLabel.text = @"客厅灯组";
        
        _lampsOneInMain.moduleValueLabel.text = self.data.lampsOne;
        
    }
    
    return _lampsOneInMain;
}

- (UIImageView *)moduleFiveLampsOne{
    
    if (_moduleFiveLampsOne == nil) {
        
        _moduleFiveLampsOne = [[UIImageView alloc]initWithFrame:CGRectMake(BASE_PX * 65, BASE_PX * 412, BASE_PX * 100, BASE_PX * 113)];
        
        [_moduleFiveLampsOne setImage:[UIImage imageNamed:@"homeEvent"]];
        
    }
    
    return _moduleFiveLampsOne;
}

- (ModuleInMainView *)lampsTwoInMain{

    if (_lampsTwoInMain == nil) {
        
        _lampsTwoInMain = [[ModuleInMainView alloc]initWithColor:self.homeEventColor];
        
        _lampsTwoInMain.frame = CGRectMake(BASE_PX * 211, BASE_PX * 412, BASE_PX * 100, BASE_PX * 113);
        
        _lampsTwoInMain.moduleTitleLabel.text = @"卧室灯组";
        
        _lampsTwoInMain.moduleValueLabel.text = self.data.lampsTwo;
        
    }

    return _lampsTwoInMain;
}

- (UIImageView *)moduleSixLampsTwo{
    
    if (_moduleSixLampsTwo == nil) {
        
        _moduleSixLampsTwo = [[UIImageView alloc]initWithFrame:CGRectMake(BASE_PX * 211, BASE_PX * 412, BASE_PX * 100, BASE_PX * 113)];
        
        [_moduleSixLampsTwo setImage:[UIImage imageNamed:@"homeEvent"]];
        
    }
    
    return _moduleSixLampsTwo;
}

@end
