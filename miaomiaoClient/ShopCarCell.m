//
//  ShopCarCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-18.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "ShopCarCell.h"

@implementation ShopCarCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    [self startLayout];
    
    return self;

}

-(void)startLayout
{
    [self.contentView  removeConstraints:self.contentView.constraints];
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-14-[_productImageView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_productImageView)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[_productImageView]-2-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_productImageView)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_productImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_productImageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    
    
    
//    _titleL.numberOfLines = 1;
    [_titleL setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_productImageView]-5-[_titleL(110)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_productImageView,_titleL)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleL attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];

    
  
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_addBt]-11-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_addBt)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_addBt]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_addBt)]];
    
     [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_addBt attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    _addBt.layer.cornerRadius = 12.5;
    
    
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_countLabel(25)]-5-[_addBt]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_countLabel,_addBt)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_countLabel(25)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_countLabel)]];
    
     [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_countLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_subtractBt]-5-[_countLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_subtractBt,_countLabel)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_subtractBt]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_subtractBt)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_subtractBt attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];

    
    
    _priceL.textColor = DEFAULTNAVCOLOR;
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_priceL]-12-[_subtractBt]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_subtractBt,_priceL)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_priceL attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
}

@end
