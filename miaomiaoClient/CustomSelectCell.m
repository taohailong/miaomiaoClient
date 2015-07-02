//
//  CustomSelectCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-28.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "CustomSelectCell.h"

@implementation CustomSelectCell
-(void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType
{
    if (accessoryType==UITableViewCellAccessoryCheckmark) {
        self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"commit_selectCell"]];
    }
    else
    {
        self.accessoryView = nil;
       [super setAccessoryType:accessoryType];
    }
}
@end
