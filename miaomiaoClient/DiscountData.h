//
//  DiscountData.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/6/8.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum _discountTicketStatus
{
    DiscountStatusValid,
    DiscountStatusExpire,
    DiscountStatusUsed
}DiscountTicketStatus;
@interface DiscountData : NSObject
@property(nonatomic,assign)float discountMoney;
@property(nonatomic,strong)NSString* discountTitle;
@property(nonatomic,strong)NSString* deadTime;
@property(nonatomic,strong)NSString* discountID;
@property(nonatomic,strong)NSString* discountCode;
@property(nonatomic,assign)float minMoney;
@property(nonatomic,assign)DiscountTicketStatus valid;
-(void)setDateStamp:(double)time;
-(void)setDiscountStatus:(int)status;
@end
