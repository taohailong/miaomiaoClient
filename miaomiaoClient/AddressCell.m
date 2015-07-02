//
//  AddressCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-22.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "AddressCell.h"
@interface AddressCell()
{
//    UILabel* _textLabel;
//    UILabel* _detailLabel;
//    UIImageView* _contentImageView;
}
@end
@implementation AddressCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    
    _contentImageView = [[UIImageView alloc]init];
    _contentImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_contentImageView];
    
    
//    self.textLabel.textColor = FUNCTCOLOR(102, 102, 102);
    _textLabel = [[UILabel alloc]init];
    _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_textLabel];
    _textLabel.font = DEFAULTFONT(15);
    _textLabel.textColor = FUNCTCOLOR(102, 102, 102);
    
 

    _detailLabel = [[UILabel alloc]init];
    _detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_detailLabel];
    _detailLabel.textColor = DEFAULTGRAYCOLO;
    _detailLabel.font = DEFAULTFONT(15);
   
    [self setLayout];
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_textLabel]-5-[_detailLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textLabel,_detailLabel)]];
    return self;
}


-(void)setLayout
{
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_contentImageView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentImageView)]];
//    
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_textLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textLabel)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f/2 constant:3]];
    
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_detailLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_detailLabel)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_detailLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:3.0f/2 constant:-3]];
}


-(UILabel*)getTitleLabel
{
    return _textLabel;
}


-(UILabel*)getDetailLabel
{
    return _detailLabel;
}


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
