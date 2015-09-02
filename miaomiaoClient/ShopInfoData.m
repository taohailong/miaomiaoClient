//
//  ShopInfoData.m
//  miaomiaoShop
//
//  Created by 陶海龙 on 15-5-2.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "ShopInfoData.h"
#import "DateFormateManager.h"
#import <UIKit/UIKit.h>
#import "NSStringDrawView.h"
@interface ShopInfoData()
{
    BOOL _onlyOne;
    NSArray* _serverAreas;
    NSMutableDictionary* _serverDic;
}
@end

@implementation ShopInfoData
@synthesize countCategory,countOrder,closeTime,countProducts,shopAddress,shopName,shopStatue,minPrice;
@synthesize latitude,longitude,shopID,district;
@synthesize combinPay,deliverCharge;
@synthesize shopArea;
@synthesize distance;
@synthesize score;
@synthesize favorite;
#pragma mark- serverAreaParse

-(NSArray*)getServerArr
{
    return _serverAreas;
}

-(void)setServeArea:(NSString *)serveArea
{
   _serverAreas = [serveArea componentsSeparatedByString:@","];
   _serverDic = [[NSMutableDictionary alloc]init];
    
   float width = 0;
   for (NSString* temp in _serverAreas)
    {
        CGSize size = [temp sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];
    
        [_serverDic setObject:NSStringFromCGSize(size)  forKey:temp];
        
         width += size.width +HORIZONTALSPACE*2+ SPACEWIDTH;
    }
    if (width>SCREENWIDTH-90) {
        _onlyOne = NO;
    }
    else
    {
        _onlyOne = YES;
    }
}
-(BOOL)onlyOneLine
{
    return _onlyOne;
}

-(NSMutableDictionary*)getServerSizeDic
{
    return _serverDic;
}



-(NSString*)getOpenTime
{
    if (self.openTime==0) {
        return @"00:00";
    }
    
    DateFormateManager* formate = [DateFormateManager shareDateFormateManager];
    
    [formate setDateStyleString:@"HH:mm"];
    return [formate formateFloatTimeValueToString:self.openTime];

}



-(NSString*)getBusinessHours
{
    if (self.closeTime==0) {
        return @"24小时";
    }
    DateFormateManager* formate = [DateFormateManager shareDateFormateManager];
    
    [formate setDateStyleString:@"HH:mm"];
    NSString* close = [formate formateFloatTimeValueToString:self.closeTime];
    
    NSString* open = [formate formateFloatTimeValueToString:self.openTime];
    
   return [NSString stringWithFormat:@"%@-%@",open,close];

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
