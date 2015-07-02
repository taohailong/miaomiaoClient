//
//  LocationManager.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/6/16.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "LocationManager.h"

/*

#define BAIDUMAP 0
#if BAIDUMAP
#import <BaiduMapAPI/BMKLocationService.h>
#import <BaiduMapAPI/BMKMapManager.h>
#else

#endif

#import<BaiduMapAPI/BMKGeometry.h>

#if BAIDUMAP
@interface LocationManager()<BMKLocationServiceDelegate,UIAlertViewDelegate,BMKGeneralDelegate>
#else
@interface LocationManager()<UIAlertViewDelegate,CLLocationManagerDelegate>
#endif
{
#if BAIDUMAP
    BMKMapManager* _mapManager;
    BMKLocationService* _mylocationManager ;
#else
    CLLocationManager*  _mylocationManager;
#endif
     LocationBk _locationBk;
}
@end
@implementation LocationManager
#pragma mark--------------------Location-----------------

#if BAIDUMAP

-(void)startLocationWithBk:(LocationBk)bk
{
    _locationBk = bk;
    
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"please enter your key" generalDelegate:self];
    
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:10.f];
    //    _mylocationManager = [[CLLocationManager alloc] init];
    
    _mylocationManager = [[BMKLocationService alloc]init];
    _mylocationManager.delegate = self;
    [_mylocationManager startUserLocationService];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    CLLocationDegrees latitude = userLocation.location.coordinate.latitude;
    CLLocationDegrees longitude = userLocation.location.coordinate.longitude;
    if (_locationBk) {
        _locationBk(YES,longitude,latitude);
    }
    
    [_mylocationManager stopUserLocationService];
    _mylocationManager = nil;
    
}

-(void)didFailToLocateUserWithError:(NSError *)error
{
    if(IOS_VERSION(8.0))
    {
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse)
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查是否开启系统定位权限" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alert show];
            
        }
    }
    
    [_mylocationManager stopUserLocationService];
    _mylocationManager = nil;
    
    if (_locationBk) {
        _locationBk(NO,0,0);
    }
}



- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    _mapManager = nil;
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
    _mapManager = nil;
}

#else

-(void)startLocationWithBk:(LocationBk)bk
{
    _locationBk = bk;
    
    _mylocationManager = [[CLLocationManager alloc] init];
    
    _mylocationManager.delegate = self;
    //设置定位的精度
    _mylocationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    //设置定位服务更新频率
    _mylocationManager.distanceFilter = 100;
    
    if ([_mylocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [_mylocationManager requestWhenInUseAuthorization];// 前台定位
        
        //[mylocationManager requestAlwaysAuthorization];// 前后台同时定位
    }
    [_mylocationManager startUpdatingLocation];
    
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation * currentLocation = [locations lastObject];
    
    NSDictionary* testdic = BMKConvertBaiduCoorFrom(currentLocation.coordinate,BMK_COORDTYPE_GPS);
    
    CLLocationCoordinate2D lo = BMKCoorDictionaryDecode(testdic);
    NSLog(@"didUpdateLocations当前位置的纬度:%f--经度%f",lo.latitude,lo.longitude);
    if (_locationBk) {
        _locationBk(YES,lo);
    }
    
    [manager stopUpdatingLocation];
    _mylocationManager = nil;
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    if(IOS_VERSION(8.0))
    {
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse)
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查是否开启系统定位权限" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alert show];
            
        }
    }
    
    [manager stopUpdatingLocation];
    _mylocationManager = nil;
    
    if (_locationBk) {
        _locationBk(NO,CLLocationCoordinate2DMake(0, 0));
    }
}
#endif

-(float)figureoutDistanceFromSource:(CLLocationCoordinate2D)source toDestination:(CLLocationCoordinate2D)destination
{
    if (source.latitude == 0) {
        return 0;
    }
    
    BMKMapPoint point1 = BMKMapPointForCoordinate(source);
    BMKMapPoint point2 = BMKMapPointForCoordinate(destination);
    CLLocationDistance kilometers = BMKMetersBetweenMapPoints(point1,point2)/1000;
    
    return kilometers;
}


@end

*/