//
//  OrderInfoServerCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/6/4.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "OrderInfoServerCell.h"

@implementation OrderInfoServerCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    UILabel* titleLabel = [[UILabel alloc]init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:titleLabel];
    titleLabel.textColor = DEFAULTGRAYCOLO;
    titleLabel.font = DEFAULTFONT(13);
    titleLabel.text = @"本订单由喵喵生活提供售后服务";
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-13-[titleLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[titleLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];

    
    
    UILabel* detailLabel = [[UILabel alloc]init];
    detailLabel.font = DEFAULTFONT(13);
    detailLabel.textColor = DEFAULTGRAYCOLO;
    detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:detailLabel];
    detailLabel.text = @"喵喵生活客服电话：400-881-6807";
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-13-[detailLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(detailLabel)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel]-10-[detailLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel,detailLabel)]];
    return self;
}
@end
