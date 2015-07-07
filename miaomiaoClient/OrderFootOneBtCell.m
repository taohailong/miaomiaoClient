//
//  OrderFootOneBtCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/7/7.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "OrderFootOneBtCell.h"

@implementation OrderFootOneBtCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _firstBt.hidden = YES;
    _secondBt.hidden = YES;
    _thirdBt.hidden = YES;
    [_fourthBt setTitle:@"重新支付" forState:UIControlStateNormal];
    return self;
}


@end
