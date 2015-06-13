//
//  OrderProductCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-18.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "OrderProductCell.h"
#import "UIImageView+WebCache.h"

@interface OrderProductCell()
{
    UIImageView* _productImageV;
    UILabel* _titleLabel;
    UILabel* _totalMoneyL;
    UILabel* _countLabel;
}
@end
@implementation OrderProductCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    
    _productImageV = [[UIImageView alloc]init];
    _productImageV.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_productImageV];
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[_productImageV]-3-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_productImageV)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-14-[_productImageV]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_productImageV)]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_productImageV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_productImageV   attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    
    
    
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = DEFAULTFONT(15);
    _titleLabel.textColor = FUNCTCOLOR(102 , 102, 102);
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_titleLabel];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_productImageV]-5-[_titleLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_productImageV,_titleLabel)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_titleLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
    
    
    
    
    _totalMoneyL = [[UILabel alloc]init];
    _totalMoneyL.font = DEFAULTFONT(13.5);
    _totalMoneyL.textColor = DEFAULTGRAYCOLO;
    _totalMoneyL.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_totalMoneyL];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_productImageV]-5-[_totalMoneyL]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_productImageV,_totalMoneyL)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_totalMoneyL]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_totalMoneyL)]];
    
    
    
    _countLabel = [[UILabel alloc]init];
    _countLabel.font = _totalMoneyL.font;
    _countLabel.textColor = DEFAULTGRAYCOLO;
    _countLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_countLabel];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_productImageV]-5-[_countLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_productImageV,_countLabel)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_countLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_totalMoneyL]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_totalMoneyL)]];
    
    
    return self;

}


-(void)setTotalMoney:(NSString*)str
{
    _totalMoneyL.text = str;
}


-(void)setTitleText:(NSString*)str
{
    _titleLabel.text =str;
}

-(void)setCountText:(NSString*)str
{
    _countLabel.text = str;
}



-(void)setProductUrl:(NSString*)url
{
    [_productImageV setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"Default_Image"]];
}

@end
