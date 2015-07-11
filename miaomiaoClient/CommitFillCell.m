//
//  CommitFillCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-28.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "CommitFillCell.h"

@implementation CommitFillCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithFieldBk:(TextFieldBk)bk
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier WithFieldBk:bk];
    
    _contentField.layer.borderWidth = 1;
    _contentField.layer.cornerRadius = 5;
    _contentField.layer.masksToBounds = YES;
    _contentField.layer.borderColor = FUNCTCOLOR(243, 243, 243).CGColor;

    return self;
}

-(void)setLayout
{
    
    
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-14-[_textLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textLabel)]];
//    
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    //    Hugging priority 确定view有多大的优先级阻止自己变大。
    //    Compression Resistance priority确定有多大的优先级阻止自己变小。
   
    
    
    UIImageView* contentImage = [[UIImageView alloc]init];
    contentImage.image = [UIImage imageNamed:@"commit_mess"];
    contentImage.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:contentImage];
    
    [contentImage setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[contentImage]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentImage)]];

    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:contentImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[contentImage]-8-[_contentField]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentImage,_contentField)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_contentField(30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentField)]];
    
    
    
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];

}
@end
