//
//  UserManager.m
//  miaomiaoShop
//
//  Created by 陶海龙 on 15-4-22.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "UserManager.h"
#import "NetWorkRequest.h"
#import <CoreLocation/CoreLocation.h>
#import "DiscountCoverView.h"
#define USHOPID @"shop_id"
#define UACCOUNT @"user_account"
#define PUSHTOKEN @"push_token"
#define LONGITUDE @"longitude"
#define LATITUDE @"latitude"

//#define PUSHOK @"isPush"
@interface UserManager()<CLLocationManagerDelegate,UIAlertViewDelegate>
{
    NSString* _token;
    LocationBk _locationBk;
    BOOL _isLog;
    CLLocationManager*  _mylocationManager ;
}
@end

@implementation UserManager
@synthesize shopName,phoneNumber,token,shopID,shopAddress;
@synthesize shopMinPrice;

+(UserManager*)shareUserManager
{
    static UserManager* shareUser = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
    
        shareUser = [[self alloc]init];
    });
    return shareUser;
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




-(void)setShopID:(NSString *)shopIDs WithLongitude:(float)longitude WithLatitude:(float)latitude
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    [def setObject:[NSNumber numberWithFloat:longitude] forKey:LONGITUDE];
    
    [def setObject:[NSNumber numberWithFloat:latitude] forKey:LATITUDE];
    [def setObject:shopIDs forKey:USHOPID];
    [def synchronize];
    self.shopID = shopIDs;
}

-(float)figureoutDistanceFromLongitude:(float)longitude Latitude:(float)latitude
{

     NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    float originalLat = [[def objectForKey:LATITUDE] floatValue];
    float originalLong = [[def objectForKey:LONGITUDE] floatValue];
    
    if (originalLat==0) {
        return 0;
    }
    
    CLLocation *orig=[[CLLocation alloc] initWithLatitude:originalLat  longitude:originalLong] ;
    
    CLLocation* dist= [[CLLocation alloc] initWithLatitude:latitude longitude:longitude] ;
    
    CLLocationDistance kilometers=[orig distanceFromLocation:dist]/1000;
    return kilometers;
}


-(void)startLocationWithBk:(LocationBk)bk
{
    _locationBk = bk;
    
    _mylocationManager = [[CLLocationManager alloc] init];
    
//    BOOL ye = [CLLocationManager locationServicesEnabled];
    
    
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
    CLLocationDegrees latitude=currentLocation.coordinate.latitude;
    CLLocationDegrees longitude=currentLocation.coordinate.longitude;
    NSLog(@"didUpdateLocations当前位置的纬度:%f--经度%f",latitude,longitude);

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
    return self.shopName!=nil;
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
