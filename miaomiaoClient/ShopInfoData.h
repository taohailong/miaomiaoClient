//
//  ShopInfoData.h
//  miaomiaoShop
//
//  Created by 陶海龙 on 15-5-2.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum _ShopStatusType {
   ShopClose,
   ShopOpen
}ShopStatusType;

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


@interface ShopInfoData : NSObject
@property(nonatomic,strong)NSString* shopArea;
@property(nonatomic,strong)NSString* shopName;
@property(nonatomic,strong)NSString* shopAddress;
@property(nonatomic,strong)NSString* countProducts;
@property(nonatomic,strong)NSString* countCategory;
@property(nonatomic,strong)NSString* countOrder;
@property(nonatomic,strong)NSString* totalMoney;
@property(nonatomic,strong)NSString* serveArea;
@property(nonatomic,strong)NSString* telPhoneNu;
@property(nonatomic,strong)NSString* mobilePhoneNu;
@property(nonatomic,assign)ShopStatusType shopStatue;
@property(nonatomic,assign)double openTime;
@property(nonatomic,assign)double closeTime;
@property(nonatomic,assign)float minPrice;

@property(nonatomic,assign)float deliverCharge;
@property(nonatomic,assign)CommitPayMethod combinPay;
@property(nonatomic,strong)NSString* shopID;
@property(nonatomic,assign)float latitude;
@property(nonatomic,assign)float longitude;
@property(nonatomic,strong)NSString* district;
@property(nonatomic,assign)float distance;

-(void)parseCombinPay:(int)pay;
-(NSString*)getBusinessHours;

-(NSString*)getOpenTime;
-(NSString*)getCloseTime;
-(NSString*)getOpenTimeAddThirtyMins;
@end
