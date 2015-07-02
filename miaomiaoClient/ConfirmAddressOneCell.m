//
//  ConfirmAddressOneCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-28.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "ConfirmAddressOneCell.h"

@implementation ConfirmAddressOneCell

-(void)setLayout
{
    
    _contentImageView.image = [UIImage imageNamed:@"commit_address"];
    [_contentImageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[_contentImageView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentImageView)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_contentImageView]-10-[_textLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentImageView,_textLabel)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0]];
    
}


@end
