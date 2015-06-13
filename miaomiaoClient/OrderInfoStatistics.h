//
//  OrderInfoStatistics.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/6/4.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderInfoStatistics : UITableViewCell
-(void)setFirstLabelText:(NSAttributedString*)attribute;
-(void)setThirdLabelText:(NSAttributedString*)attribute;
-(void)setSecondLabelText:(NSAttributedString*)attribute
;


-(UILabel*)getFLabel;
-(UILabel*)getSLabel;
-(UILabel*)getThirdLabel;
-(UILabel*)getFourthLabel;
@end
