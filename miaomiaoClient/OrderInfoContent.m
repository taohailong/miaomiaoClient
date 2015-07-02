//
//  OrderInfoContent.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/6/4.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "OrderInfoContent.h"
@interface OrderInfoContent()
{
    UILabel* _orderNu;
    UILabel* _orderTime;
    UILabel* _orderWay;
    UILabel* _orderPhone;
    UILabel* _orderAddress;
}
@end
@implementation OrderInfoContent

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    _orderNu = [[UILabel alloc]init];
    _orderNu.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_orderNu];
    
    _orderTime = [[UILabel alloc]init];
    _orderTime.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_orderTime];
    
    _orderWay = [[UILabel alloc]init];
    _orderWay.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_orderWay];
    
    _orderPhone = [[UILabel alloc]init];
    _orderPhone.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_orderPhone];

    
    _orderAddress = [[UILabel alloc]init];
    _orderAddress.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_orderAddress];
    [self setLayout];
    
    return self;
}

-(void)setLayout
{
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-13-[_orderNu]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_orderNu)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-17-[_orderNu]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_orderNu)]];
    
    
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_orderTime attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_orderNu attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_orderNu]-15-[_orderTime]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_orderNu,_orderTime)]];
    
    
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_orderWay attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_orderNu attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_orderTime]-15-[_orderWay]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_orderTime,_orderWay)]];
    
    
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_orderPhone attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_orderNu attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_orderWay]-15-[_orderPhone]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_orderWay,_orderPhone)]];

    

    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_orderAddress attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_orderNu attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_orderPhone]-15-[_orderAddress]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_orderPhone,_orderAddress)]];
}

-(UILabel*)getNuLabel
{
    return _orderNu;
}

-(UILabel*)getOrderTimeLabel
{
    return _orderTime;
}


-(UILabel*)getPayLabel
{
    return _orderWay;
}


-(UILabel*)getPhoneLabel
{
    return _orderPhone;
}

-(UILabel*)getAddressLabel
{
    return _orderAddress;
}





@end
