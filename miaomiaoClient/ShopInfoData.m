//
//  ShopInfoData.m
//  miaomiaoShop
//
//  Created by 陶海龙 on 15-5-2.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "ShopInfoData.h"
#import "DateFormateManager.h"
@implementation ShopInfoData
@synthesize countCategory,countOrder,closeTime,countProducts,shopAddress,serveArea,shopName,shopStatue,minPrice;
@synthesize latitude,longitude,shopID,district;
@synthesize combinPay,deliverCharge;
@synthesize shopArea;

-(NSString*)getOpenTime
{
    if (self.openTime==0) {
        return @"00:00";
    }
    
    DateFormateManager* formate = [DateFormateManager shareDateFormateManager];
    
    [formate setDateStyleString:@"HH:mm"];
    return [formate formateFloatTimeValueToString:self.openTime];

}

-(NSString*)getCloseTime
{
    if (self.closeTime==0) {
        return @"24:00";
    }
    DateFormateManager* formate = [DateFormateManager shareDateFormateManager];
    
    [formate setDateStyleString:@"HH:mm"];
    return [formate formateFloatTimeValueToString:self.closeTime];
}

-(NSString*)getOpenTimeAddThirtyMins
{
    if (self.openTime == 0) {
        return @"8:30";
    }
    
    DateFormateManager* formate = [DateFormateManager shareDateFormateManager];
    [formate setDateStyleString:@"HH:mm"];
    return [formate formateFloatTimeValueToString:self.openTime+1800];
}


-(void)parseCombinPay:(int)pay
{
    switch (pay) {
        case 1:
            self.combinPay = CashPayCommit;
            break;
        case 2:
            self.combinPay = AliPayCommit;
            break;
        case 3:
            self.combinPay = Ali_CashPayCommit;
            break;
        case 4:
            self.combinPay = WxPayCommit;
            break;
        case 5:
            self.combinPay = Wx_CashPayCommit;
            break;
        case 6:
            self.combinPay = Ali_WxPayCommit;
            break;
            
        default:
            self.combinPay = All_payCommit;
            break;
    }
    
}

@end
