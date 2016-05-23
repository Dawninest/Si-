//
//  TempViewController.m
//  Si+智能家居
//
//  Created by 蒋一博 on 16/5/3.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import "TempViewController.h"

#import "RulerView.h"

@interface TempViewController ()<RulerViewDelegate>

@property (strong, nonatomic) UIButton *backButton;

@property (strong, nonatomic) UIImageView *tipBG;

@property (strong, nonatomic) UILabel *tipLabel;

@end

@implementation TempViewController

- (instancetype)initWithTemp:(NSString *)temp{
    
    self = [super init];
    
    if (self) {
        
        _getTemp = temp;
        
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
    
    
    
}

- (void)initializeInterface{
    
    UIImageView *tempBG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TempBG"]];
    
    tempBG.frame = CGRectMake(0, BASE_PX * 170, BASE_PX * 375, BASE_PX * 224);
    
    [self.view addSubview:self.tipBG];
    
    [self.view addSubview:self.backButton];
    
    [self.view addSubview:self.showLabel];
    
    [self.view addSubview:self.tipLabel];
    
    RulerView *ruler = [[RulerView alloc] initWithFrame:CGRectMake(BASE_PX * 20,BASE_PX * 180, [UIScreen mainScreen].bounds.size.width - BASE_PX * 40, BASE_PX * 140)];
    
    ruler.rulerDeletate = self;
    
    int tempInt = [_getTemp intValue];
    
    [ruler showRulerScrollViewWithCount:280 average:[NSNumber numberWithFloat:0.1] currentValue:tempInt smallMode:YES];
    
    [self.view addSubview:ruler];

    [self.view addSubview:tempBG];
    
}

#pragma mark -- RulerViewDelegate
- (void)ruler:(RulerScrollView *)rulerScrollView{
    
    _showLabel.text = [NSString stringWithFormat:@"%.1f ℃",rulerScrollView.rulerValue];
    
}

#pragma mark -- 界面回跳
- (void)didCloseButtonTouch{
    
    self.tempHandle(_showLabel.text);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark -- block
- (void)backWithTemp:(tempBlock) backTemp{

    self.tempHandle = [backTemp copy];
    
}


#pragma mark -- Getter
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
        
        _tipLabel.text = @"温度设置";
        
        _tipLabel.textColor = [UIColor whiteColor];
        
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    
    return _tipLabel;
    
}

- (UILabel *)showLabel{

    if (_showLabel == nil) {
        
        _showLabel = [[UILabel alloc] init];
        
        _showLabel.font = [UIFont fontWithName:@"orbitron-bold" size:BASE_PX * 30];;
        
        _showLabel.textColor = [UIColor whiteColor];
        
        _showLabel.frame = CGRectMake( BASE_PX * 20,BASE_PX * 110, [UIScreen mainScreen].bounds.size.width - BASE_PX * 40, BASE_PX * 40);
        
        _showLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    
    return _showLabel;
    
}


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

@end
