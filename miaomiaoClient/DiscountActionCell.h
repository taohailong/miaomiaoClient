//
//  DiscountActionCell.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/6/10.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "FourLabelCell.h"
#import "DiscountData.h"
@interface DiscountActionCell : FourLabelCell
-(void)setTitleLabelAttribute:(NSString*)str;
-(void)setTicketStatus:(DiscountTicketStatus)status;
@end
