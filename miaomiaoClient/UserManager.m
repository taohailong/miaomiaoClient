//
//  UserManager.m
//  miaomiaoShop
//
//  Created by 陶海龙 on 15-4-22.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "UserManager.h"
#import "NetWorkRequest.h"
#define BAIDUMAP 0

#if BAIDUMAP
#import <BaiduMapAPI/BMKLocationService.h>
#import <BaiduMapAPI/BMKMapManager.h>
#else
#import <CoreLocation/CoreLocation.h>
#endif

#import<BaiduMapAPI/BMKGeometry.h>

#import "DiscountCoverView.h"
#define USHOPID @"shop_id"
#define UACCOUNT @"user_account"
#define PUSHTOKEN @"push_token"
#define LONGITUDE @"longitude"
#define LATITUDE @"latitude"
#define USHOPNAME @"shop_name"
#define USHOPAREA @"shop_area"
//#define PUSHOK @"isPush"

#if BAIDUMAP
@interface UserManager()<BMKLocationServiceDelegate,UIAlertViewDelegate,BMKGeneralDelegate>
#else
@interface UserManager()<UIAlertViewDelegate,CLLocationManagerDelegate>
#endif
{
    NSString* _token;
    LocationBk _locationBk;
    BOOL _isLog;
   
#if BAIDUMAP
    BMKMapManager* _mapManager;
    BMKLocationService* _mylocationManager ;
#else
    CLLocationManager*  _mylocationManager;
#endif
}
@end

@implementation UserManager
@synthesize token,shopID;
@synthesize shop;
@synthesize specifyCategory;
//@synthesize shopName,phoneNumber,shopAddress;
//@synthesize shopMinPrice;
//@synthesize deliverCharge;
//@synthesize combinPay;

+(UserManager*)shareUserManager
{
    static UserManager* shareUser = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
    
        shareUser = [[self alloc]init];
    });
    return shareUser;
}


-(ShopInfoData*)shop
{
    return _shop;
}

-(void)setCurrentShop:(ShopInfoData*)shops
{
    _shop = shops;
    self.shopID = _shop.shopID;
    
    if (shops.shopArea) {
        NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
        [def setObject:shops.shopArea forKey:USHOPAREA];
        [def setObject:shops.shopName forKey:USHOPNAME];
        [def synchronize];
    }
   
    [self setShopID:shops.shopID WithLongitude:shops.longitude WithLatitude:shops.latitude];
}


-(NSString*)getCurrentShopArea
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    NSString* area = [def objectForKey:USHOPAREA];
    return area;
}

-(NSString*)getCurrentShopName
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:USHOPNAME];
}

-(NSString*)getUserAccount
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:UACCOUNT];
}


-(void)checkGID
{
    [self checkTokenExsit];
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    NSString* gid = [def objectForKey:UGID];
    if (gid == nil) {
        
        NetWorkRequest* req = [[NetWorkRequest alloc]init];
        [req getGidWithBk:^(NSDictionary* respond, NetWorkStatus error) {
            
            if (NetWorkSuccess==error) {
               [def setObject:respond[@"data"][@"gid"] forKey:UGID];
            }
            
        }];
        [req startAsynchronous];
    }
}




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
//    lat 40.036264,long 116.320227
//    didUpdateLocations当前位置的纬度:40.037400--经度116.320080
    CLLocationDegrees latitude = lo.latitude;
    CLLocationDegrees longitude = lo.longitude;
    
    if (_locationBk) {
        _locationBk(YES,longitude,latitude);
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
        _locationBk(NO,0,0);
    }
}
#endif

-(float)figureoutDistanceFromLongitude:(float)longitude Latitude:(float)latitude
{
    
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    float originalLat = [[def objectForKey:LATITUDE] floatValue];
    float originalLong = [[def objectForKey:LONGITUDE] floatValue];
    
    if (originalLat==0) {
        return 0;
    }
    
    BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(originalLat,originalLong));
    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(latitude,longitude));
    CLLocationDistance kilometers = BMKMetersBetweenMapPoints(point1,point2)/1000;

    
//    CLLocation *orig=[[CLLocation alloc] initWithLatitude:originalLat  longitude:originalLong] ;
//    
//    CLLocation* dist= [[CLLocation alloc] initWithLatitude:latitude longitude:longitude] ;
//    
//    CLLocationDistance kilometers=[orig distanceFromLocation:dist]/1000;
    return kilometers;
}


-(BOOL)verifyTokenOnNet:(void(^)(BOOL success, NSError *error))completeBlock
{
    NSString* t = [self checkTokenExsit];
    if (t==nil) {
        return NO;
    }
    
//    __weak UserManager* bSelf = self;

//    NetWorkRequest* req = [[NetWorkRequest alloc]init];
//    [req verifyTokenToServer:t WithCallBack:^(NSDictionary *backDic, NSError *error) {
//       
//        if ([backDic[@"code"] intValue] ==0&&backDic) {
//            bSelf.token = backDic[@"token"];
//            bSelf.shopName = backDic[@"data"][@"shop"][0][@"name"];
//            bSelf.shopID = backDic[@"data"][@"shop"][0][@"id"];
//            bSelf.shopAddress = backDic[@"data"][@"shop"][0][@"shop_address"];
//            bSelf.phoneNumber = backDic[@"data"][@"shop"][0][@"tel"];
//            
//            completeBlock(YES,nil);
//        }
//        else if(error)
//        {
//            completeBlock(NO,error);
//        }
//        else
//        {
//           completeBlock(NO,nil);//token失效
//        }
//
//    }];
//    [req startAsynchronous];
    return t !=nil;
}

-(void)setShopID:(NSString *)shopIDs WithLongitude:(float)longitude WithLatitude:(float)latitude
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    [def setObject:[NSNumber numberWithFloat:longitude] forKey:LONGITUDE];
    
    [def setObject:[NSNumber numberWithFloat:latitude] forKey:LATITUDE];
    [def setObject:shopIDs forKey:USHOPID];
    [def synchronize];
    self.shopID = shopIDs;
}






-(NSString*)checkTokenExsit
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    NSLog(@"USHOPID %@",[def objectForKey:USHOPID]);
    self.token= [def objectForKey:UTOKEN];
    self.shopID = [def objectForKey:USHOPID];
    
    return self.token ;
}

-(void)setTokenToDish:(NSString*)t WithAccount:(NSString*)account
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    [def setObject:t  forKey:UTOKEN];
//    [def setObject:shopId forKey:USHOPID];
    [def setObject:account forKey:UACCOUNT];
     NSLog(@"self.token %@",self.token);
    [def synchronize];
//    [[NSNotificationCenter defaultCenter] postNotificationName:SHOPIDCHANGED object:nil];
}

-(void)removeUserAccountWithBk:(logCallBack)complete
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    NSString* account = [def objectForKey:UACCOUNT];
//    NSString* pushKey = [def objectForKey:PUSHTOKEN];
    __weak UserManager* wSelf = self;
    NetWorkRequest* request = [[NetWorkRequest alloc]init];
    [request userLogOutWithAccount:account withBk:^(NSDictionary* respond, NetWorkStatus error) {
        
        if (error == NetWorkSuccess) {
            complete(YES);
            [wSelf removeUserData];
        }
        else
        {
            complete(NO);
        }
        
    }];
    [request startAsynchronous];
}


-(void)savePushToken:(NSString*)push
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    [def  setObject:push forKey:PUSHTOKEN];
    [def synchronize];
    [self registePushKey];
}


-(void)removeUserData
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    [def removeObjectForKey:UTOKEN];
//    [def removeObjectForKey:USHOPID];
//    [def removeObjectForKey:PUSHOK];
    [def removeObjectForKey:UACCOUNT];
    [def synchronize];
    self.token = nil;
//    self.shopID = nil;
}

-(void)registePushKey
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
//    if ([def objectForKey:PUSHOK]) {
//        return;
//    }
    
    NSString* account = [def objectForKey:UACCOUNT];
    NSString * pushKey = [def objectForKey:PUSHTOKEN];

    if (account==nil||pushKey==nil) {
        return;
    }

//    NetWorkRequest* request = [[NetWorkRequest alloc]init];
//    [request registePushToken:pushKey WithAccount:account WithBk:^(id backDic, NSError *error) {
//        
//        if (backDic) {
//            
////            [def setObject:@"YES" forKey:PUSHOK];
//        }
//        else
//        {
//          
//        }
//    }];
//    [request startAsynchronous];
}



-(BOOL)isLogin
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UTOKEN]==nil)
    {
        return NO;
    }
    return YES;
}
-(void)logInWithPhone:(NSString *)phone Pass:(NSString *)ps logBack:(logCallBack) blockBack
{
    __weak UserManager* bSelf = self;
    NetWorkRequest* req = [[NetWorkRequest alloc]init];
     [req userLoginWithAccount:phone WithPw:ps WithBk:^(NSDictionary* respond, NetWorkStatus error) {
         if (error == NetWorkSuccess) {
             
             if ([respond[@"data"][@"canGetCoupon"] intValue]==1)
             {
                 int money  = [respond[@"data"][@"couponTotalPrice"] intValue];
                 DiscountCoverView* conver  = [[DiscountCoverView alloc]initDiscountCoverViewWithTitle:[NSString stringWithFormat:@"%d",money/100]];
                 [conver show];
             }
            
             
             bSelf.token = respond[@"data"][@"user_token"];
             [bSelf  setTokenToDish:bSelf.token  WithAccount:phone];
             blockBack(YES);
         }
         else
         {
           blockBack(NO);
         }
        
     }];
    [req startAsynchronous];

}


#pragma mark-------------alertViewDelegate------------

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex == buttonIndex) {
        return;
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL
                                                    URLWithString:UIApplicationOpenSettingsURLString]];

}

@end
