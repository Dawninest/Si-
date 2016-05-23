//
//  MapKitViewController.m
//  Si+智能家居
//
//  Created by 蒋一博 on 16/5/3.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import "MapKitViewController.h"

#import "HUDTipView.h"

#import "locationGPS.h"

#import "Myanotation.h"

#import "LocationManager.h"

#import <MapKit/MapKit.h>

#import "DawnPresentTransition.h"

#import "MainViewController.h"

@interface MapKitViewController ()<MKMapViewDelegate,UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) MKMapView *mapView;

@property (assign, nonatomic) CLLocationCoordinate2D homeCoordinate;

@property (strong, nonatomic) UIView  *messageView;

@property (strong, nonatomic) UIImageView *mapBG;

@property (strong, nonatomic) UILabel *longitudeLabel;//经度

@property (strong, nonatomic) UILabel *latitudeLabel;//纬度

@property (strong, nonatomic) UILabel *distanceLabel;

@property (strong, nonatomic) UILabel *homeEventLabel;

@property (strong, nonatomic) UIButton *homeButton;

@property (strong, nonatomic) DawnPresentTransition *presentTransition;

@property (assign, nonatomic) BOOL inHome;

@end

@implementation MapKitViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self initializeDataSource];
    
    [self initializeInterface];
    
}

- (void)initializeDataSource{
    
    _inHome = 0;
    
}

- (void)initializeInterface{
    
    UIImageView *BGImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BG"]];
    
    BGImage.frame = self.view.frame;
    
    [self.view addSubview:BGImage];
    
    _presentTransition = [[DawnPresentTransition alloc] init];
    
    _presentTransition.duration = 1.0f;
    
    UIView *bgView = [[UIView alloc]initWithFrame:self.view.frame];
    
    bgView.backgroundColor = [UIColor colorWithRed:0.51 green:0.51 blue:0.51 alpha:1.00];
    
    _presentTransition.containerBackgroundView = bgView;
    
    [self.view addSubview:self.mapView];
    
    [self.view addSubview:self.messageView];
    
    [self.messageView addSubview:self.distanceLabel];
    
    [self.messageView addSubview:self.homeEventLabel];
    
    [self.view addSubview:self.mapBG];
    
    [self.view addSubview:self.homeButton];
    
    locationGPS *loc = [locationGPS sharedlocationGPS];
    
    [loc getAuthorization];//授权
    
    [loc startLocation];//开始定位
    
    //跟踪用户位置
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    self.mapView.delegate = self;
    
    //初始位置
    [self initHome];
    
}

#pragma mark -- MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D center = userLocation.location.coordinate;
    
    userLocation.title = [NSString stringWithFormat:@"%f",center.longitude];
    
    userLocation.subtitle = [NSString stringWithFormat:@"%f",center.latitude];
    
    //反地理编码
    LocationManager *locManager = [[LocationManager alloc] init];
    
    //距离
    double distance = [locManager countLineDistanceDest:_homeCoordinate.longitude dest_Lat:_homeCoordinate.latitude self_Lon:center.longitude self_Lat:center.latitude];
    
    if (_homeCoordinate.longitude == 0) {
        
        self.distanceLabel.text = @"0M";
        
    }else{
        
        self.distanceLabel.text = [NSString stringWithFormat:@"%dM",(int)distance];
        
        if ((int)distance <= 100) {
            
            _inHome = 1;
            
        }else{
            
            _inHome = 0;
            
        }
        
    }
    
    [self homeEvent];
    
    //设置地图的中心点，（以home所在的位置为中心点）
    [mapView setCenterCoordinate:_homeCoordinate animated:YES];
    
    //设置地图的显示范围
    MKCoordinateSpan span = MKCoordinateSpanMake(0.023666, 0.016093);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    
    [mapView setRegion:region animated:YES];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    //自定义大头针
    if (![annotation isKindOfClass:[Myanotation class]]) {
        
        return nil;
        
    }
    static NSString *ID = @"anno";
    
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    
    if (annoView == nil) {
        
        annoView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
        
    }
    
    Myanotation *anno = annotation;
    
    annoView.image = [UIImage imageNamed:@"map_locate_blue"];
    
    annoView.annotation = anno;
    
    annoView.userInteractionEnabled = NO;
    
    return annoView;
    
}

#pragma mark -- home定位
- (void)initHome{
    
    //从沙盒中取得用户存过的地理位置
    NSString *plistPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    plistPath = [plistPath stringByAppendingString:@"/homeSit.plist"];
    
    NSArray *getHomeSit = [NSArray arrayWithContentsOfFile:plistPath];
    
    if (getHomeSit.count == 0) {
        
        HUDTipView *lockTip = [[HUDTipView alloc]init];
        
        lockTip.tipMessage.text = @"请在定位设置中标记家的位置";
        
        [self.view addSubview:lockTip];

        
    }else{
        
        NSString *getLongitudeStr = getHomeSit[0];
        
        NSString *getLatitudeStr = getHomeSit[1];
        
        NSLog(@"%f-%f",[getLatitudeStr doubleValue],[getLongitudeStr doubleValue]);
        
        _homeCoordinate =  (CLLocationCoordinate2D){[getLatitudeStr doubleValue],[getLongitudeStr doubleValue]};
        
        Myanotation *anno = [[Myanotation alloc] init];
        
        anno.coordinate = _homeCoordinate;
        
        [self.mapView addAnnotation:anno];
        
        [self.mapView setCenterCoordinate:_homeCoordinate animated:YES];
        
    }

}

#pragma mark -- 用户情景
- (void)homeEvent{
    
    if (_inHome == 0) {
        
        _homeEventLabel.backgroundColor = OUTHOME_COLOR;
        
        _homeEventLabel.text = @"Out Home";
        
    }else{
        
        _homeEventLabel.backgroundColor = INHOME_COLOR;
    
        _homeEventLabel.text = @"In Home";
        
    }

}

#pragma mark -- 界面跳转
- (void)homeButtonTaped{
    
    MainViewController *mainVC = [[MainViewController alloc]initWithHomeEvent:_inHome];
    
    mainVC.transitioningDelegate = self;
    
    CGRect startFrame = CGRectMake(BASE_PX * 135, BASE_PX * 400, BASE_PX * 133, BASE_PX * 160);
    CGRect finalFrame = CGRectMake(BASE_PX * 121, BASE_PX * 253, BASE_PX * 133, BASE_PX * 160);
    
    [self.presentTransition registerStartFrame:startFrame
                                    finalFrame:finalFrame transitionView:self.homeButton];
    
    self.homeButton.hidden = YES;
    
    [self presentViewController:mainVC animated:YES completion:^{
        
        self.homeButton.hidden = NO;
        
    }];

}

#pragma mark - transition
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    return self.presentTransition;
    
}



#pragma mark -- Getter
- (MKMapView *)mapView{

    if (_mapView == nil) {
        
        _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(BASE_PX * 20, BASE_PX * 100, BASE_PX * 335, BASE_PX * 425)];
        
        _mapView.mapType = MKMapTypeStandard;
        
        _mapView.scrollEnabled = NO;
        
        _mapView.zoomEnabled = NO;
        
    }
    
    return _mapView;
}

- (UIView *)messageView{

    if (_messageView == nil) {
        
        _messageView = [[UIView alloc]initWithFrame:CGRectMake(BASE_PX * 28, BASE_PX * 440, BASE_PX * 317, BASE_PX * 85)];
        
        _messageView.backgroundColor = [UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:0.6];
        
    }
    
    return _messageView;
}

- (UIImageView *)mapBG{
    
    if (_mapBG == nil) {
        
        _mapBG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mapBG"]];
        
        _mapBG.frame = CGRectMake(BASE_PX * 10, BASE_PX * 90, BASE_PX * 355, BASE_PX * 445);
        
    }
    
    return _mapBG;
}

- (UILabel *)distanceLabel{

    if (_distanceLabel == nil) {
        
        _distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(BASE_PX * 227, 0, BASE_PX * 100, BASE_PX * 85)];
        
        _distanceLabel.textColor = [UIColor whiteColor];
        
        _distanceLabel.textAlignment = NSTextAlignmentCenter;
        
        _distanceLabel.font = [UIFont fontWithName:@"orbitron-bold" size:BASE_PX * 15];
        
    }
    
    return _distanceLabel;
}

- (UILabel *)homeEventLabel{
    
    if (_homeEventLabel == nil) {
        
        _homeEventLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, BASE_PX * 108, BASE_PX * 85)];
        
        _homeEventLabel.backgroundColor = [UIColor clearColor];
        
        _homeEventLabel.textColor = [UIColor whiteColor];
        
        _homeEventLabel.textAlignment = NSTextAlignmentCenter;
        
        _homeEventLabel.font = [UIFont fontWithName:@"orbitron-bold" size:BASE_PX * 15];
        
    }

    return _homeEventLabel;
}

- (UIButton *)homeButton{

    if (_homeButton == nil) {
        
        _homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _homeButton.frame = CGRectMake(BASE_PX * 135, BASE_PX * 400, BASE_PX * 133, BASE_PX * 160);
        
        [_homeButton setImage:[UIImage imageNamed:@"Logo"] forState:UIControlStateNormal];
        
        [_homeButton addTarget:self action:@selector(homeButtonTaped) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _homeButton;
}



@end
