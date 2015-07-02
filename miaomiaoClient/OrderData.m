//
//  OrderData.m
//  miaomiaoShop
//
//  Created by 陶海龙 on 15-5-1.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "OrderData.h"
#import "ShopProductData.h"
@implementation OrderData
@synthesize orderAddress,orderID,orderStatue,orderTime,telPhone,messageStr,mobilePhone,payWay,productArr,shopName,discountMoney,totalMoney,countOfProduct,orderNu,orderTakeOver;
@synthesize orderStatusType;
@synthesize shopID;

-(NSString*)getPayMethod
{

    if ([self.payWay isEqualToString:@"wx_native"])
    {
        if (self.discountMoney) {
            return [NSString stringWithFormat:@"微信支付(代金券%.2f)",self.discountMoney];
        }
        else
        {
           return @"微信支付";
        }
    }
    
    else if ([self.payWay isEqualToString:@"ali_native"])
    {
        if (self.discountMoney) {
            return [NSString stringWithFormat:@"支付宝支付(代金券%.2f)",self.discountMoney];
        }
        else
        {
            return @"支付宝支付";
        }

    }
    else
    {
      return @"货到付款";
    }
}

-(void)setOrderInfoString:(NSString *)string
{
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSArray* arr = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSMutableArray* pArr = [NSMutableArray array];
    for (NSDictionary* dic in arr)
    {
        ShopProductData* product = [[ShopProductData alloc]init];
        product.count = [dic[@"count"] intValue];
        self.countOfProduct += product.count;
        product.pName = dic[@"name"];
        product.pUrl = dic[@"pic_url"];
        product.price = [dic[@"price"] floatValue]/100;
        [pArr addObject:product];
    }
    
    self.productArr = pArr;
}


-(void)setOrderStatueWithString:(NSString *)statue
{
    switch ([statue intValue]) {
        case 0:
            self.orderStatue = @"下单成功";
            self.orderStatusType = OrderStatusWaitConfirm;
            break;
        case 1:
            self.orderStatue = @"配送中";
            self.orderStatusType = OrderStatusDeliver;
            break;
        case 2:
            self.orderStatue = @"用户取消";
            self.orderStatusType = OrderStatusCancel;
            break;
        case 3:
            self.orderStatue = @"商家取消";
            self.orderStatusType = OrderStatusCancel;
            break;
        case 4:
            self.orderStatue = @"订单完成";
            self.orderStatusType = OrderStatusConfirm;
            break;
        case 5:
            self.orderStatue = @"订单取消";
            self.orderStatusType = OrderStatusCancel;
            break;

        default:
            self.orderStatusType = OrderStatusCancel;
            break;
    }
}

-(void)setOrderPayStatus:(NSString *)statue WithType:(NSString*)type
{
    switch ([statue intValue]) {
        case 0:
            self.orderStatue = @"支付失败";
//            self.orderStatue = @"待支付";

            self.orderStatusType = [type isEqualToString:@"ali_native"]? OrderStatus_Zfb_WaitPay:OrderStatus_Wx_WaitPay;
            break;
        case 1:
            self.orderStatue = @"下单成功";
            self.orderStatusType = OrderStatusWaitConfirm;
            break;
            
        default:
            self.orderStatusType = OrderStatusCancel;
            break;
    }


}

@end
