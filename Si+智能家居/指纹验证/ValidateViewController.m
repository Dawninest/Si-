//
//  ViewController.m
//  Si+智能家居
//
//  Created by 蒋一博 on 16/5/3.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import "ValidateViewController.h"

#import "DawnPresentTransition.h"

#import "MapKitViewController.h"

#import <LocalAuthentication/LocalAuthentication.h>

@interface ValidateViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic ,strong) UIImageView *validateImage0;

@property (nonatomic ,strong) UIImageView *validateImage1;

@property (nonatomic ,strong) UIImageView *validateImage2;

@property (nonatomic ,strong) UIImageView *validateImage3;

@property (nonatomic ,strong) UIImageView *tipBG;

@property (nonatomic ,strong) UILabel *tipLabel;

@property (nonatomic ,strong) UIButton *iconButton;

@property (strong, nonatomic) DawnPresentTransition *presentTransition;

@end

@implementation ValidateViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self initializeDataSource];
    
    [self initializeInterface];
    
}

- (void)initializeDataSource{
    
    
    
}

- (void)initializeInterface{
    
    UIImageView *BGImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BG"]];
    
    BGImage.frame = self.view.frame;
    
    [self.view addSubview:BGImage];
    
    _presentTransition = [[DawnPresentTransition alloc] init];
    
    _presentTransition.duration = 1.0f;
    
    UIView *bgView = [[UIView alloc]initWithFrame:self.view.frame];
    
    bgView.backgroundColor = [UIColor colorWithRed:0.86 green:0.87 blue:0.86 alpha:1.00];
    
    _presentTransition.containerBackgroundView = bgView;
    
    //从3-0依次对应圆环从外到内
    [self.view addSubview:self.validateImage3];
    
    [self.view addSubview:self.validateImage2];
    
    [self.view addSubview:self.validateImage1];
    
    [self.view addSubview:self.validateImage0];
    
    [self.view addSubview:self.tipBG];
    
    [self.view addSubview:self.tipLabel];
    
    [self.view addSubview:self.iconButton];
    
    [self initAnimation];
    
}

- (void)initAnimation{
    
    [_validateImage3.layer setTransform:CATransform3DMakeRotation( - M_PI * 0.25, 0, 0, 1)];
    
    [_validateImage1.layer setTransform:CATransform3DMakeRotation(0, 0, 0, 1)];

    
    [UIView animateWithDuration:4 delay:0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
        
        [_validateImage3.layer setTransform:CATransform3DMakeRotation(M_PI * 0.75, 0, 0, 1)];
        
    } completion:^(BOOL finished) {
        
        [self initAnimation];//循环
        
    }];
    
    [UIView animateWithDuration:3 delay:0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
        
        [_validateImage1.layer setTransform:CATransform3DMakeRotation(M_PI, 0, 0, 1)];
        
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark -- 指纹验证
- (void)validateStart{
    
    [self TouchIDTestSuccess:^{
        
         NSLog(@"Touch ID");
        
         UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示"  message:@"通过了Touch ID身份验证" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancel= [UIAlertAction actionWithTitle:@"下一步" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [self validateSuccess];
            
        }];
        
         [alert addAction:cancel];
        
         [self presentViewController:alert animated:YES completion:nil];
        
     } Failure:^(NSError *error){
         
         NSLog(@"Touch ID\n\(error)");
         
         UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示"  message:@"未能通过Touch ID身份验证"  preferredStyle:UIAlertControllerStyleAlert];
         
         UIAlertAction * cancel= [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:nil];
         
         [alert addAction:cancel];
         
         [self presentViewController:alert animated:YES completion:nil];
         
     } Unvilabe:^(NSError *error){
         
         NSLog(@"Touch ID\n\(error)");
         
         UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示"  message:@"Touch ID不可用"  preferredStyle:UIAlertControllerStyleAlert];
         
         UIAlertAction * cancel= [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

             /**
              *   虚拟机测试用跳转
              */
              [self validateSuccess];
             
             
         }];
         
         [alert addAction:cancel];
         
         [self presentViewController:alert animated:YES completion:nil];
         
     }];
}

-(void)TouchIDTestSuccess:(void(^)())successed Failure:(void(^)(NSError * error))failured  Unvilabe:(void(^)(NSError * error))Unvilabe
{
    LAContext * lauth = [[LAContext alloc]init];
    
    NSError * error  = nil;
    
    BOOL isTouchAvalible = [lauth canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics  error:&error];
    
    if (isTouchAvalible){
        
        [lauth evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"需要验证您的指纹来确认您的身份信息" reply:^(BOOL success, NSError * _Nullable error){
            
            if (success){
                
                if (successed)  { successed();    }
             
             }else{
                
                if (failured)   { failured(error);}
                
             }
            
         }];
        
    }else{
        
        if (Unvilabe){
           
            Unvilabe(error);
            
        }
        
    }
    
}

#pragma mark -- 界面跳转
- (void)validateSuccess{
    
    self.iconButton.alpha = 0;
    
    MapKitViewController *mapKitVC = [[MapKitViewController alloc]init];
    
    mapKitVC.transitioningDelegate = self;
    
    CGRect startFrame = _iconButton.frame;
    CGRect finalFrame = _iconButton.frame;
    
    [self.presentTransition registerStartFrame:startFrame
                                    finalFrame:finalFrame transitionView:self.iconButton];

    
    [self presentViewController:mapKitVC animated:YES completion:nil];

}

#pragma mark -- Transition

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    return self.presentTransition;
    
}



#pragma mark -- Getter
- (UIImageView *)validateImage0{
    
    if (_validateImage0 == nil) {
       
        _validateImage0 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"validate0"]];
       
        _validateImage0.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width);
       
        _validateImage0.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds) - 60);
        
    }
    
    return _validateImage0;
    
}

- (UIImageView *)validateImage1{
    
    if (_validateImage1 == nil) {
        
        _validateImage1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"validate1"]];
        
        _validateImage1.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width);
        
        _validateImage1.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds) - BASE_PX * 60);
        
    }
    
    return _validateImage1;
    
}

- (UIImageView *)validateImage2{
    
    if (_validateImage2 == nil) {
       
        _validateImage2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"validate2"]];
       
        _validateImage2.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width);
      
        _validateImage2.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds) - BASE_PX * 60);
        
    }
    
    return _validateImage2;
    
}

- (UIImageView *)validateImage3{
    
    if (_validateImage3 == nil) {
       
        _validateImage3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"validate3"]];
       
        _validateImage3.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width);
       
        _validateImage3.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds) - BASE_PX * 60);
   
    }
   
    return _validateImage3;
    
}

- (UIImageView *)tipBG{

    if (_tipBG == nil) {
        
        _tipBG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TipBG"]];
        
        _tipBG.bounds = CGRectMake(0, 0, BASE_PX * 300, BASE_PX * 135 * 0.7);
        
        _tipBG.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds) + BASE_PX * 170);
        
    }
    
    return _tipBG;
}

- (UILabel *)tipLabel{
    
    if (_tipLabel == nil) {
        
        _tipLabel = [[UILabel alloc]init];
        
        _tipLabel.bounds = CGRectMake(0, 0, BASE_PX * 300, BASE_PX * 135 * 0.7);
        
        _tipLabel.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds) + BASE_PX * 170);
        
        _tipLabel.text = @"指 纹 验 证";
        
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        
        _tipLabel.textColor = [UIColor whiteColor];
        
        _tipLabel.font =  [UIFont fontWithName:@"RTWSYueGoTrial-Regular" size:BASE_PX * 35];
        
    }

    return _tipLabel;
}

- (UIButton *)iconButton{
    
    if (_iconButton == nil) {
        
        
        CGFloat width = self.view.bounds.size.width / 6;
        
        CGFloat height = width;
        
        CGFloat x = (CGRectGetWidth(self.view.frame) - width) / 2.;
        
        CGFloat y = CGRectGetMidY(self.view.bounds) - width / 2 - BASE_PX * 60;
        
        _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
       
        _iconButton.frame = CGRectMake(x, y, width, height);
        
        _iconButton.layer.cornerRadius = width / 2.;
        
        _iconButton.layer.masksToBounds = YES;
        
        _iconButton.backgroundColor = [UIColor colorWithRed:0.79 green:0.85 blue:0.82 alpha:1.00];
       
        [_iconButton setImage:[UIImage imageNamed:@"Icon"] forState:UIControlStateNormal];
       
        [_iconButton addTarget:self action:@selector(validateStart) forControlEvents:UIControlEventTouchUpInside];
    
    }

    return _iconButton;
    
}

@end
