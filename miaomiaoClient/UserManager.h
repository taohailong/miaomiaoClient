//
//  UserManager.h
//  miaomiaoShop
//
//  Created by 陶海龙 on 15-4-22.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum _CommitPayMethod
{
    AliPayCommit,
    Ali_WxPayCommit,
    Ali_CashPayCommit,
    Wx_CashPayCommit,
    WxPayCommit,
    CashPayCommit,
    All_payCommit
}CommitPayMethod;

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
@property(nonatomic,assign)CommitPayMethod combinPay;



-(NSString*)getUserAccount;

-(void)parseCombinPay:(int)pay;
-(void)startLocationWithBk:(LocationBk)bk;
-(float)figureoutDistanceFromLongitude:(float)longitude Latitude:(float)latitude;

-(void)checkGID;
-(void)setShopID:(NSString *)shopID WithLongitude:(float)longitude WithLatitude:(float)latitude;


-(void)savePushToken:(NSString*)push;
-(void)registePushKey;
-(void)removeUserAccountWithBk:(logCallBack)complete;

-(BOOL)isLogin;
-(void)logInWithPhone:(NSString *)phone Pass:(NSString *)ps logBack:(logCallBack) blockBack;
-(BOOL)verifyTokenOnNet:(void(^)(BOOL success, NSError *error))completeBlock;
@end
