//
//  OrderFootSpecialCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-21.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "OrderFootSpecialCell.h"

@implementation OrderFootSpecialCell


-(void)setSubLayout
{
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_firstBt]-10|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_firstBt)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_firstBt attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [_secondBt removeFromSuperview];
    [_thirdBt removeFromSuperview];
    [_fourthBt removeFromSuperview];

}



@end
