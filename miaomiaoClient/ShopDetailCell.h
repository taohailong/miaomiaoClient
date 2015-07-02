//
//  ShopDetailCell.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/7/2.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "FourLabelCell.h"

@interface ShopDetailCell : FourLabelCell
-(UILabel*)getFifthLabel;

-(void)setFirstLStr:(NSString*)str;
-(void)setSecondLStr:(NSString*)str;
-(void)setThirdLStr:(NSString*)str;
-(void)setFourthLStr:(NSString*)str;
-(void)setFifthLStr:(NSString*)str;
@end
