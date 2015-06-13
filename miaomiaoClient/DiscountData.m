//
//  DiscountData.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/6/8.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "DiscountData.h"
#import "DateFormateManager.h"
@implementation DiscountData
@synthesize deadTime,minMoney,discountID,discountTitle,discountCode,valid;
@synthesize discountMoney;
-(void)setDateStamp:(double)time
{
    time = time/1000;
    DateFormateManager* manager = [DateFormateManager shareDateFormateManager];
    [manager setDateStyleString:@"YY-MM-dd  HH:mm"];
    self.deadTime = [manager formateFloatTimeValueToString:time];
}

-(void)setDiscountStatus:(int)status
{
    switch (status) {
        case 0:
            self.valid = DiscountStatusValid;
            break;
        case 2:
            self.valid = DiscountStatusExpire;
            break;
            
        case 4:
            self.valid = DiscountStatusUsed;
            break;
    
        default:
            self.valid = DiscountStatusValid;
            break;
    }


}

@end
