//
//  UserManager.h
//  miaomiaoShop
//
//  Created by 陶海龙 on 15-4-22.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopInfoData.h"
#import<BaiduMapAPI/BMKGeometry.h>
@interface UserManager : NSObject
{
    ShopInfoData* _shop;
}
typedef void (^UserApiCallBack)(BOOL success,id respond);

typedef void (^LocationBk)(BOOL success,float longitude,float latitude);

-(void)setCurrentShop:(ShopInfoData*)shops;
+(UserManager*)shareUserManager;
@property(nonatomic,strong,readonly)ShopInfoData* shop;
@property(nonatomic,strong)NSString* token;
@property(nonatomic,strong)NSString* shopID;
@property(nonatomic,strong)NSString* specifyCategory;

//@property(nonatomic,strong)NSString* shopName;
//@property(nonatomic,strong)NSString* phoneNumber;


//@property(nonatomic,strong)NSString* shopAddress;
//@property(nonatomic,assign)float shopMinPrice;
//@property(nonatomic,assign)float deliverCharge;
//@property(nonatomic,assign)CommitPayMethod combinPay;


-(NSString*)getCurrentShopArea;
-(NSString*)getCurrentShopName;
-(NSString*)getUserAccount;

-(void)startLocationWithBk:(LocationBk)bk;
-(float)figureoutDistanceFromLongitude:(float)longitude Latitude:(float)latitude;
-(int)figureDistanceFrom:(BMKMapPoint)start toPoint:(BMKMapPoint)end;


-(void)checkGID;
-(void)setShopID:(NSString *)shopID WithLongitude:(float)longitude WithLatitude:(float)latitude;


-(void)savePushToken:(NSString*)push;
-(void)registePushKey;
-(void)removeUserAccountWithBk:(UserApiCallBack)complete;

-(BOOL)isLogin;
-(void)logInWithPhone:(NSString *)phone Pass:(NSString *)ps logBack:(UserApiCallBack) blockBack;
-(BOOL)verifyTokenOnNet:(void(^)(BOOL success, NSError *error))completeBlock;
@end
