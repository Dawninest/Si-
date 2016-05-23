//
//  GPSViewController.m
//  Si+智能家居
//
//  Created by 蒋一博 on 16/5/3.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import "GPSViewController.h"

#import "locationGPS.h"

#import "Myanotation.h"

#import "LocationManager.h"

#import <MapKit/MapKit.h>

#import "HUDTipView.h"

@interface GPSViewController ()<MKMapViewDelegate>

@property (strong, nonatomic) MKMapView *mapView;

@property (assign, nonatomic) CLLocationCoordinate2D homeCoordinate;

@property (strong, nonatomic) UIView  *messageView;

@property (strong, nonatomic) UIImageView *mapBG;

@property (strong, nonatomic) UILabel *longitudeLabel;//经度

@property (strong, nonatomic) UILabel *latitudeLabel;//纬度

@property (strong, nonatomic) UILabel *distanceLabel;

@property (strong, nonatomic) UILabel *homeEventLabel;

@property (strong, nonatomic) UIButton *setHomeButton;

@property (strong, nonatomic) UILabel *pointTipLabelOne;

@property (strong, nonatomic) UILabel *pointTipLabelTwo;

@property (strong, nonatomic) UIButton *backButton;

@property (assign, nonatomic) BOOL inHome;



@end

@implementation GPSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self initializeDataSource];
    
    [self initializeInterface];
    
}

- (void)initializeDataSource{
    
}

- (void)initializeInterface{
    
    [self.view addSubview:self.mapView];
    
    [self.view addSubview:self.messageView];
    
    [self.messageView addSubview:self.distanceLabel];
    
    [self.messageView addSubview:self.homeEventLabel];
    
    [self.view addSubview:self.mapBG];
    
    [self.view addSubview:self.setHomeButton];
    
    [self.view addSubview:self.pointTipLabelOne];
    
    [self.view addSubview:self.pointTipLabelTwo];
    
    [self.view addSubview:self.backButton];
    
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
        
        self.distanceLabel.text = @"    0M";
        
    }else{
    
        self.distanceLabel.text = [NSString stringWithFormat:@"    %dM",(int)distance];
        
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
        
        HUDTipView *setHomeTip = [[HUDTipView alloc]init];
        
        setHomeTip.tipMessage.text = @"No Home , Set home now home";
        
        [self.view addSubview:setHomeTip];
        
        
        
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

#pragma mark -- setHome
- (void)setHomeButtonTaped{

    _homeCoordinate = self.mapView.userLocation.coordinate;
    //经度
    NSString *nowHomeLongitude = [NSString stringWithFormat:@"%f",_homeCoordinate.longitude];
    //纬度
    NSString *nowHomeLatitude = [NSString stringWithFormat:@"%f",_homeCoordinate.latitude];
    
    NSLog(@"%@-%@",nowHomeLongitude,nowHomeLatitude);
    
    NSArray *nowHomeSit = @[nowHomeLongitude,nowHomeLatitude];
    
    //数据存储
    NSString *plistPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    plistPath = [plistPath stringByAppendingString:@"/homeSit.plist"];
    
    BOOL success = [nowHomeSit writeToFile:plistPath atomically:YES];
    NSLog(@"是否保存成功:%d",success);
    
    
    NSMutableArray *array = [NSMutableArray array];
    NSUInteger count = self.mapView.annotations.count;
    if (count > 1) {
        for (id obj in self.mapView.annotations) {
            if (![obj isKindOfClass:[MKUserLocation class]]) {
                [array addObject:obj];
            }
        }
        [self.mapView removeAnnotations:array];
    }
    
    Myanotation *anno = [[Myanotation alloc] init];
    anno.coordinate = _homeCoordinate;
    
    [self.mapView addAnnotation:anno];


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

#pragma mark -- 界面回跳
- (void)didCloseButtonTouch{
    
    self.homeEventHandle(_inHome);
  

    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark -- block回传
- (void)backWithHomeEvent:(homeEventBlock)backEvent{
    
    self.homeEventHandle = [backEvent copy];

}

#pragma mark -- Getter
- (MKMapView *)mapView{
    
    if (_mapView == nil) {
        
        _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(BASE_PX * 20, BASE_PX * 60, BASE_PX * 335, BASE_PX * 425)];
        
        _mapView.mapType = MKMapTypeStandard;
        
        _mapView.scrollEnabled = NO;
        
        _mapView.zoomEnabled = NO;
        
    }
    
    return _mapView;
}

- (UIView *)messageView{
    
    if (_messageView == nil) {
        
        _messageView = [[UIView alloc]initWithFrame:CGRectMake(BASE_PX * 28, BASE_PX * 400, BASE_PX * 317, BASE_PX * 85)];
        
        _messageView.backgroundColor = [UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:0.6];
        
    }
    
    return _messageView;
}

- (UIImageView *)mapBG{
    
    if (_mapBG == nil) {
        
        _mapBG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mapBG"]];
        
        _mapBG.frame = CGRectMake(BASE_PX * 10, BASE_PX * 50, BASE_PX * 355, BASE_PX * 445);
        
    }
    
    return _mapBG;
}

- (UILabel *)distanceLabel{
    
    if (_distanceLabel == nil) {
        
        _distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(BASE_PX * 108, 0, BASE_PX * 371 - 108, BASE_PX * 85)];
        
        _distanceLabel.textColor = [UIColor whiteColor];
        
        _distanceLabel.backgroundColor = [UIColor blackColor];
        
        _distanceLabel.textAlignment = NSTextAlignmentLeft;
        
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

- (UIButton *)setHomeButton{

    if (_setHomeButton == nil) {
        
        _setHomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //731 567
        _setHomeButton.frame = CGRectMake(BASE_PX * 0, BASE_PX * 405 , BASE_PX * 375, BASE_PX * 375 / 731 * 567);
        
        _setHomeButton.backgroundColor = [UIColor clearColor];
        
        [_setHomeButton setImage:[UIImage imageNamed:@"pointTip"] forState:UIControlStateNormal];
        
        [_setHomeButton addTarget:self action:@selector(setHomeButtonTaped) forControlEvents:UIControlEventTouchUpInside];
        
    }

    return _setHomeButton;
}

- (UILabel *)pointTipLabelOne{

    if (_pointTipLabelOne == nil) {
        
        _pointTipLabelOne = [[UILabel alloc]initWithFrame:CGRectMake(BASE_PX * 57, BASE_PX * 545 , BASE_PX * 270, BASE_PX * 25)];
        
        _pointTipLabelOne.text = @"点击将当前位置设置为家";
        
        _pointTipLabelOne.textAlignment = NSTextAlignmentCenter;
        
        _pointTipLabelOne.textColor = [UIColor whiteColor];
        
        _pointTipLabelOne.font =  [UIFont fontWithName:@"RTWSYueGoTrial-Regular" size:BASE_PX * 15];
        
    }
    
    return _pointTipLabelOne;
}

- (UILabel *)pointTipLabelTwo{

    if (_pointTipLabelTwo == nil) {
        
        _pointTipLabelTwo = [[UILabel alloc]initWithFrame:CGRectMake(BASE_PX * 50, BASE_PX * 570 , BASE_PX * 275, BASE_PX * 65)];
        
        _pointTipLabelTwo.text = @"设置正确的家庭地址以进行智能家居系统的更多操作";
        
        _pointTipLabelTwo.textAlignment = NSTextAlignmentCenter;
        
        _pointTipLabelTwo.numberOfLines = 0;
        
        _pointTipLabelTwo.textColor = [UIColor whiteColor];
        
        _pointTipLabelTwo.font =  [UIFont fontWithName:@"RTWSYueGoTrial-Regular" size:BASE_PX * 20];
        
    }
    
    return _pointTipLabelTwo;
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
