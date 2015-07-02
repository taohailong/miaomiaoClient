//
//  OrderInfoStatistics.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/6/4.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "OrderInfoStatistics.h"
@interface OrderInfoStatistics()
{
    UILabel* _firstLabel;
    UILabel* _secondLabel;
    UILabel* _thirdLabel;
    UILabel* _fourthLabel;

}
@end
@implementation OrderInfoStatistics
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _firstLabel = [[UILabel alloc]init];
    _firstLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_firstLabel];
    
    _secondLabel = [[UILabel alloc]init];
    _secondLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_secondLabel];

    _thirdLabel = [[UILabel alloc]init];
    _thirdLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_thirdLabel];
    
    _fourthLabel = [[UILabel alloc]init];
    _fourthLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_fourthLabel];
    
    [self setLayout];
    return self;
}

-(UILabel*)getFLabel
{
    return _firstLabel;
}

-(UILabel*)getSLabel
{
    return _secondLabel;
}

-(UILabel*)getThirdLabel
{
    return _thirdLabel;
}


-(UILabel*)getFourthLabel
{
    return _fourthLabel;
}

-(void)setFirstLabelText:(NSAttributedString*)attribute
{
     _firstLabel.attributedText = attribute;
}

-(void)setSecondLabelText:(NSAttributedString*)attribute
{
    _secondLabel.attributedText = attribute;
}


-(void)setThirdLabelText:(NSAttributedString*)attribute
{
    _thirdLabel.attributedText = attribute;
}


-(void)setLayout
{
  
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-13-[_secondLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_secondLabel)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_secondLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_firstLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_secondLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_firstLabel]-5-[_secondLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_firstLabel,_secondLabel)]];
    
    
    
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_firstLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_thirdLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_secondLabel]-5-[_thirdLabel]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_thirdLabel,_secondLabel)]];

    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_fourthLabel]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_fourthLabel)]];

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_fourthLabel]-13-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_fourthLabel)]];
    
}
@end
