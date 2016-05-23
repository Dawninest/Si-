//
//  AQIViewController.m
//  Si+智能家居
//
//  Created by 蒋一博 on 16/5/3.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import "AQIViewController.h"

#import "SimData.h"

#import "Switch.h"

#define Scale [UIScreen mainScreen].scale

@interface AQIViewController ()

/** 读取数据 */
@property (strong ,nonatomic) SimData *data;

@property (strong, nonatomic) UIButton *backButton;

/** switch */
@property (strong ,nonatomic) Switch *mySwitch;

/** SwitchEvent */
@property (strong ,nonatomic) NSString *switchValue;

@property (strong, nonatomic) UIImageView *tipBG;

@property (strong, nonatomic) UILabel *tipLabel;

@property (strong, nonatomic) UILabel *valueLabel;

@end

@implementation AQIViewController

- (instancetype)initWithSwitch:(NSString *)value{
    
    self = [super init];
    if (self) {
        
        self.switchValue = value;
        
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
    
}

- (void)initializeInterface{
    
    [self.view addSubview:self.backButton];
    
    [self.view addSubview:self.mySwitch];
    
    [self.view addSubview:self.tipBG];
    
    [self.view addSubview:self.tipLabel];
    
    [self.view addSubview:self.valueLabel];
    
}

#pragma mark -- 开关点击
-(void)switchToggled:(Switch*)mySwitch{
    
    
    
}

#pragma mark -- 界面回跳
- (void)didCloseButtonTouch{
    
    NSString *setValue = @"";
    
    if (_mySwitch.on) {
        
       setValue = @"ON";
        
    }else{
   
        setValue = @"OFF";
    }
    
    
    self.AQIHandle(setValue);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)backWithValue:(AQIBlock) backValue{

    self.AQIHandle = [backValue copy];
    
}

#pragma mark -- Getter
- (UIButton *)backButton{
    
    if (_backButton == nil) {
        
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _backButton.frame = CGRectMake(BASE_PX * 330, BASE_PX * 5 , BASE_PX * 50, BASE_PX * 50);
        
        _backButton.backgroundColor = [UIColor clearColor];
        
        [_backButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        
        [_backButton addTarget:self action:@selector(didCloseButtonTouch) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _backButton;
}

- (UIImageView *)tipBG{
    
    if (_tipBG == nil) {
        
        _tipBG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TipBG"]];
        
        _tipBG.frame = CGRectMake(BASE_PX * 75 / 2, BASE_PX * 60, BASE_PX * 300, BASE_PX * 135 * 0.7);
        
    }
    
    return _tipBG;
    
}

- (UILabel *)tipLabel{
    
    if (_tipLabel == nil) {
        
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(BASE_PX * 20,BASE_PX * 70, [UIScreen mainScreen].bounds.size.width - BASE_PX * 40, BASE_PX * 40)];
        
        _tipLabel.font = [UIFont fontWithName:@"RTWSYueGoTrial-Regular" size:BASE_PX * 20];
        
        _tipLabel.text = @"空气净化";
        
        _tipLabel.textColor = [UIColor whiteColor];
        
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    
    return _tipLabel;
    
}

- (Switch *)mySwitch{

    if (_mySwitch == nil) {
        
        UIImage *swithcImage = [UIImage imageNamed:@"switch3"];
        
        _mySwitch = [Switch switchWithImage:swithcImage
                               visibleWidth:(swithcImage.size.width / Scale) * 0.62f];
        
        _mySwitch.layer.cornerRadius = (swithcImage.size.height / Scale) / 2;
        
        _mySwitch.center = self.view.center;
        
        [_mySwitch addTarget:self action:@selector(switchToggled:)
            forControlEvents:UIControlEventValueChanged];
        
        if ([self.switchValue isEqualToString:@"OFF"]) {
            
            _mySwitch.on = NO;
            
        }else{
        
            _mySwitch.on = YES;
            
        }
        
        _mySwitch.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(M_PI_2), CGAffineTransformMakeScale(1.5, 1.5));
        
    }
    
    return _mySwitch;
}

- (UILabel *)valueLabel{
    
    if (_valueLabel == nil) {
        
        _valueLabel = [[UILabel alloc]initWithFrame:CGRectMake( BASE_PX * 20,BASE_PX * 110, [UIScreen mainScreen].bounds.size.width - BASE_PX * 40, BASE_PX * 40)];
        
        _valueLabel.textAlignment = NSTextAlignmentCenter;
        
        _valueLabel.font = [UIFont fontWithName:@"RTWSYueGoTrial-Regular" size:20];
        
        _valueLabel.textColor = INHOME_COLOR;
        
        int nowAQI = self.data.AQIValue;
        
        if (nowAQI <= 100) {
            
            _valueLabel.text = @"当前空气质量优";
            
        }else if (nowAQI <= 200){
        
            _valueLabel.text = @"当前空气质量中";
            
        }else{
        
            _valueLabel.text = @"当前空气质量差";
            
            _valueLabel.textColor = OUTHOME_COLOR;
            
        }
        
        

        
        
    }
    
    return _valueLabel;
}

@end
