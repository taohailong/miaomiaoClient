//
//  CommitPDetailCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/7/3.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "CommitPDetailCell.h"

@implementation CommitPDetailCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.textLabel.textColor = DEFAULTGRAYCOLO;
    self.textLabel.font = DEFAULTFONT(14);
    return self;
}

@end
