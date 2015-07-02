//
//  ShopDetailCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/7/2.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "ShopDetailCell.h"
@interface ShopDetailCell()
{
    UILabel* _fifthLabel;
}
@end
@implementation ShopDetailCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _firstLabel.font = DEFAULTFONT(14);
    _firstLabel.textColor = DEFAULTGRAYCOLO;
    
    _secondLabel.font = DEFAULTFONT(14);
    _secondLabel.textColor = DEFAULTGRAYCOLO;

    _thirdLabel.font = DEFAULTFONT(14);
    _thirdLabel.textColor = DEFAULTGRAYCOLO;

    _fourthLabel.font = DEFAULTFONT(14);
    _fourthLabel.textColor = DEFAULTGRAYCOLO;

    
    _fifthLabel = [[UILabel alloc]init];
    _fifthLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _fifthLabel.font = DEFAULTFONT(14);
    _fifthLabel.textColor = DEFAULTGRAYCOLO;
    
    [self.contentView addSubview:_fifthLabel];

    [self setLayout];
    
    return self;
}

-(void)setLayout
{
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_firstLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_firstLabel)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_firstLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_firstLabel)]];

    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_firstLabel]-10-[_secondLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_firstLabel,_secondLabel)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_secondLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_firstLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_secondLabel]-10-[_thirdLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_secondLabel,_thirdLabel)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_thirdLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_firstLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];

    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_thirdLabel]-10-[_fourthLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_thirdLabel,_fourthLabel)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_fourthLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_firstLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];

    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_fourthLabel]-10-[_fifthLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_fourthLabel,_fifthLabel)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_fourthLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_firstLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];

}

-(UILabel*)getFifthLabel
{
    return _fifthLabel;
}

-(void)setFirstLStr:(NSString *)str
{
    _firstLabel.text = [NSString stringWithFormat:@"店铺地址:%@",str];
}

-(void)setSecondLStr:(NSString *)str
{
   _secondLabel.text = [NSString stringWithFormat:@"配送时间:%@",str];
}

-(void)setThirdLStr:(NSString *)str
{
    _thirdLabel.text = [NSString stringWithFormat:@"起送价格:%@元",str];
}

-(void)setFourthLStr:(NSString *)str
{
    _fourthLabel.text = [NSString stringWithFormat:@"配送费:%@元",str];
}


-(void)setFifthLStr:(NSString *)str
{
   _fifthLabel.text = [NSString stringWithFormat:@"联系电话:%@",_fifthLabel];
}

@end
