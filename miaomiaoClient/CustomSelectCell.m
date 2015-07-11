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
        self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"unSelectCellAccessType"]];
    }
}

-(void)setNeedSeparate:(BOOL)flag
{
    _isNeedSeparate = flag;
}

- (void)drawRect:(CGRect)rect
{
//    if (_isNeedSeparate==NO) {
//        return;
//    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor); CGContextFillRect(context, rect); //上分割线，
    CGContextSetStrokeColorWithColor(context, FUNCTCOLOR(229, 229, 229).CGColor);
    CGContextStrokeRect(context, CGRectMake(1, -1, rect.size.width - 2, 1));
 //下分割线 CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"e2e2e2"].CGColor); CGContextStrokeRect(context, CGRectMake(5, rect.size.height, rect.size.width - 10, 1));
}

@end
