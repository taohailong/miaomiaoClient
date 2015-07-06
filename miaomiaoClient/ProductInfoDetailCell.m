//
//  ProductInfoDetailCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/7/2.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "ProductInfoDetailCell.h"

@implementation ProductInfoDetailCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setLayout];
    return self;
}

-(void)setLayout
{
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_firstLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_firstLabel)]];
    
   [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_firstLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_firstLabel)]];
    
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_secondLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_firstLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    
     [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_firstLabel]-10-[_secondLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_firstLabel,_secondLabel)]];

}



-(void)setProductName:(NSString*)name
{
    NSMutableAttributedString* att = [[NSMutableAttributedString alloc]initWithString:@"商品名称：" attributes:@{NSFontAttributeName:DEFAULTFONT(16),NSForegroundColorAttributeName:DEFAULTBLACK}];
    
    NSAttributedString* nameAtt = [[NSAttributedString alloc]initWithString:name attributes:@{NSFontAttributeName:DEFAULTFONT(15),NSForegroundColorAttributeName:DEFAULTGRAYCOLO}];
    [att appendAttributedString:nameAtt];
    _firstLabel.attributedText = att;

}

-(void)setProductPrice:(NSString*)price
{
    NSMutableAttributedString* att = [[NSMutableAttributedString alloc]initWithString:@"商品价格：" attributes:@{NSFontAttributeName:DEFAULTFONT(16),NSForegroundColorAttributeName:DEFAULTBLACK}];
    
    NSAttributedString* nameAtt = [[NSAttributedString alloc]initWithString:price attributes:@{NSFontAttributeName:DEFAULTFONT(15),NSForegroundColorAttributeName:DEFAULTGRAYCOLO}];
    [att appendAttributedString:nameAtt];
    _secondLabel.attributedText = att;
}



@end
