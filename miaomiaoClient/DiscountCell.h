//
//  DiscountCell.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/6/8.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscountData.h"
@interface DiscountCell : UITableViewCell
-(UILabel*)getFirstLabel;
-(UILabel*)getSecondLabel;
-(UILabel*)getThirdLabel;
-(void)setTicketMinMoney:(float)money;
-(void)setTicketName:(NSString*)str;
-(void)setTicketStatus:(DiscountTicketStatus)status;
-(void)setTitleLabelAttribute:(NSString*)str;
@end
