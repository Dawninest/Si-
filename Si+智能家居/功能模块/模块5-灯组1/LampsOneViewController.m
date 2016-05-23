//
//  LampsOneViewController.m
//  Si+智能家居
//
//  Created by 蒋一博 on 16/5/3.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import "LampsOneViewController.h"

#import "CircularSlider.h"

@interface LampsOneViewController ()

@property (strong, nonatomic) NSString *getValue;

@property (strong, nonatomic) UIButton *backButton;

@property (strong, nonatomic) UIImageView *tipBG;

@property (strong, nonatomic) UILabel *tipLabel;

@property (strong, nonatomic) UILabel *valueLabel;

@property (strong, nonatomic) CircularSlider *imageSlider;

@end

@implementation LampsOneViewController

- (instancetype)initWithValue:(NSString *)value{
    
    self = [super init];
    if (self) {
        
        self.getValue = value;
        
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
    
    [self.view addSubview:self.backButton];
    
    [self.view addSubview:self.tipBG];
    
    [self.view addSubview:self.tipLabel];
    
    [self.view addSubview:self.imageSlider];
    
    [self.view addSubview:self.valueLabel];
    
}

#pragma mark -- 界面回跳
- (void)didCloseButtonTouch{
    
    self.lampHandle(_valueLabel.text);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)backWithValue:(lampsOneBlock) backValue{
    
    self.lampHandle = [backValue copy];

}

#pragma mark -- 旋钮
- (void)sliderValueChanged:(CircularSlider*)slider
{
    
    _valueLabel.text = [NSString stringWithFormat:@"%.f%%", slider.value * 100];
    if ([_valueLabel.text isEqualToString:@"0%"]) {
        _valueLabel.text = @"OFF";
    }
}
- (void)sliderEditingDidEnd:(CircularSlider*)slider
{
    self.valueLabel.text = [NSString stringWithFormat:@"%.f%%", slider.value * 100];
    if ([_valueLabel.text isEqualToString:@"0%"]) {
        _valueLabel.text = @"OFF";        
    }
    
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
        
        _tipLabel.text = @"客厅灯组";
        
        _tipLabel.textColor = [UIColor whiteColor];
        
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    
    return _tipLabel;
    
}

- (CircularSlider *)imageSlider{

    if (_imageSlider == nil) {
        
        _imageSlider = [[CircularSlider alloc] init];

        _imageSlider.bounds = CGRectMake(0, 0, BASE_PX * 346/1.2, BASE_PX * 353/1.2);
        
        _imageSlider.center = self.view.center;
        
        _imageSlider.maxAngle = 360 * 0.9;
        
        _imageSlider.minAngle = 360 * 0.1;
        
        _imageSlider.angle = 360 * 0.1;
        
        _imageSlider.value = [_getValue doubleValue] / 100.00;
        
        _imageSlider.selectImage = [UIImage imageNamed:@"unselect.png"];
        
        _imageSlider.unselectImage = [UIImage imageNamed:@"select.png"];
        
        _imageSlider.indicatorImage = [UIImage imageNamed:@"indicator-black.png"];
        
        _imageSlider.circulate = YES;
        
        [_imageSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        [_imageSlider addTarget:self action:@selector(sliderEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
        
    }
    
    return _imageSlider;
}

- (UILabel *)valueLabel{

    if (_valueLabel == nil) {
        
        _valueLabel = [[UILabel alloc]initWithFrame:CGRectMake( BASE_PX * 20,BASE_PX * 110, [UIScreen mainScreen].bounds.size.width - BASE_PX * 40, BASE_PX * 40)];
        
        _valueLabel.textAlignment = NSTextAlignmentCenter;
        
        _valueLabel.font = [UIFont fontWithName:@"orbitron-bold" size:30];
        
        _valueLabel.textColor = [UIColor colorWithRed:0.00 green:1.00 blue:0.94 alpha:1.00];
        
        _valueLabel.text = _getValue;
        
        
    }
    
    return _valueLabel;
}


@end
