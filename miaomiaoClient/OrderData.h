//
//  OrderData.h
//  miaomiaoShop
//
//  Created by 陶海龙 on 15-5-1.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum _OrderStatus {
    OrderStatusWaitComment,
   OrderStatusWaitConfirm,
    OrderStatusCancel,
    OrderStatusConfirm,
    OrderStatusDeliver,
//    OrderStatusWaitPay,
    OrderStatus_Wx_WaitPay,
    OrderStatus_Zfb_WaitPay,
}OrderStatus;
@interface OrderData : NSObject
@property(nonatomic,strong)NSString* orderAddress;
@property(nonatomic,strong)NSString* orderTime;
@property(nonatomic,strong)NSString* orderID;
@property(nonatomic,strong)NSString* shopID;
@property(nonatomic,strong)NSString* telPhone;
@property(nonatomic,strong)NSString* mobilePhone;
@property(nonatomic,strong)NSString* shopName;
@property(nonatomic,strong)NSString* payWay;
@property(nonatomic,strong)NSString* orderStatue;
@property(nonatomic,strong)NSArray* productArr;
@property(nonatomic,strong)NSString* totalMoney;
@property(nonatomic,strong)NSString* messageStr;
@property(nonatomic,strong)NSString* orderNu;
@property(nonatomic,strong)NSString* orderTakeOver;
@property(nonatomic,assign)OrderStatus orderStatusType;
@property(nonatomic,assign)int countOfProduct;
@property(nonatomic,assign)float discountMoney;
-(void)setOrderInfoString:(NSString*)string;
-(void)setOrderStatueWithString:(NSString *)statue comment:(int)comment;
-(void)setOrderPayStatus:(NSString *)statue WithType:(NSString*)type;
-(NSString*)getPayMethod;
@end
