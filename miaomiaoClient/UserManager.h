//
//  UserManager.h
//  miaomiaoShop
//
//  Created by 陶海龙 on 15-4-22.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserManager : NSObject
typedef void (^logCallBack)(BOOL success) ;

typedef void (^LocationBk)(BOOL success,float longitude,float latitude);

+(UserManager*)shareUserManager;
@property(nonatomic,strong)NSString* shopName;
@property(nonatomic,strong)NSString* phoneNumber;
@property(nonatomic,strong)NSString* token;
@property(nonatomic,strong)NSString* shopID;
@property(nonatomic,strong)NSString* shopAddress;
@property(nonatomic,assign)float shopMinPrice;

-(NSString*)getUserAccount;

-(void)startLocationWithBk:(LocationBk)bk;
-(void)checkGID;
-(void)setShopID:(NSString *)shopID WithLongitude:(float)longitude WithLatitude:(float)latitude;
-(float)figureoutDistanceFromLongitude:(float)longitude Latitude:(float)latitude;


-(void)savePushToken:(NSString*)push;
-(void)registePushKey;
-(void)removeUserAccountWithBk:(logCallBack)complete;

-(BOOL)isLogin;
-(void)logInWithPhone:(NSString *)phone Pass:(NSString *)ps logBack:(logCallBack) blockBack;
-(BOOL)verifyTokenOnNet:(void(^)(BOOL success, NSError *error))completeBlock;
@end
