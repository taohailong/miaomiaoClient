//
//  OrderInfoStatusCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/6/3.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "OrderInfoStatusCell.h"
@interface OrderInfoStatusCell()
{
    UIButton* _oneButton;
    UIButton* _secondButton;
    UIButton* _thirdButton;
    UILabel* _bottomLabel;
    UIImageView* warnImage;
}
@end
@implementation OrderInfoStatusCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _oneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _oneButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_oneButton];
    
    _oneButton.titleLabel.font = DEFAULTFONT(12);
    [_oneButton setTitleColor:DEFAULTBLACK forState:UIControlStateDisabled];
    [_oneButton setTitleColor:DEFAULTNAVCOLOR forState:UIControlStateNormal];
    [_oneButton setTitle:@"下单成功" forState:UIControlStateNormal];
    [_oneButton setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 18, 0)];
    [_oneButton setTitleEdgeInsets:UIEdgeInsetsMake(48, -33, 10, 0)];

    [_oneButton setImage:[UIImage imageNamed:@"orderInfo_status_confirm"] forState:UIControlStateNormal];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_oneButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1/2.0 constant:-5]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_oneButton(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_oneButton)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_oneButton(50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_oneButton)]];
    
    
    
    
    _secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _secondButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_secondButton];
    
    _secondButton.titleLabel.font = DEFAULTFONT(12);
    [_secondButton setTitleColor:DEFAULTBLACK forState:UIControlStateDisabled];
    [_secondButton setTitleColor:DEFAULTNAVCOLOR forState:UIControlStateNormal];
    [_secondButton setTitle:@"配送中" forState:UIControlStateNormal];
    
    [_secondButton setImage:[UIImage imageNamed:@"orderInfo_deliver_on"] forState:UIControlStateNormal];
    [_secondButton setImage:[UIImage imageNamed:@"orderInfo_deliver"] forState:UIControlStateDisabled];
    
    [_secondButton setImageEdgeInsets:UIEdgeInsetsMake(0, 3, 18, 0)];
    [_secondButton setTitleEdgeInsets:UIEdgeInsetsMake(48, -33, 10, 0)];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_secondButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_secondButton(41)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_secondButton)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_secondButton(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_secondButton)]];
    
    
    
    
    
    _thirdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _thirdButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_thirdButton setImageEdgeInsets:UIEdgeInsetsMake(0, 3, 18, 0)];
    [_thirdButton setTitleEdgeInsets:UIEdgeInsetsMake(48, -33, 10, 0)];
    [self.contentView addSubview:_thirdButton];
    
    _thirdButton.titleLabel.font = DEFAULTFONT(12);
    [_thirdButton setTitleColor:DEFAULTBLACK forState:UIControlStateDisabled];
    [_thirdButton setTitleColor:DEFAULTNAVCOLOR forState:UIControlStateNormal];
    [_thirdButton setTitle:@"已完成" forState:UIControlStateNormal];
    
    [_thirdButton setImage:[UIImage imageNamed:@"orderInfo_status_complete_on"] forState:UIControlStateNormal];
    [_thirdButton setImage:[UIImage imageNamed:@"orderInfo_status_complete"] forState:UIControlStateDisabled];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_thirdButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.5 constant:0]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_thirdButton(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_thirdButton)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_thirdButton(41)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_thirdButton)]];
    
    
    
    UIView* oneSeparateView = [[UIView alloc]init];
    oneSeparateView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:oneSeparateView];
    oneSeparateView.backgroundColor = DEFAULTGRAYCOLO;
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:oneSeparateView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_oneButton attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-7]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[oneSeparateView(1)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(oneSeparateView)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_oneButton]-4-[oneSeparateView]-4-[_secondButton]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_oneButton,oneSeparateView,_secondButton)]];
    
    
    
    UIView* twoSeparateView = [[UIView alloc]init];
    twoSeparateView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:twoSeparateView];
    twoSeparateView.backgroundColor = DEFAULTGRAYCOLO;
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:twoSeparateView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:oneSeparateView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[twoSeparateView(1)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(twoSeparateView)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_secondButton]-4-[twoSeparateView]-4-[_thirdButton]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_secondButton,twoSeparateView,_thirdButton)]];

    
    _bottomLabel = [[UILabel alloc]init];
    _bottomLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_bottomLabel];
    _bottomLabel.font = DEFAULTFONT(11);
    _bottomLabel.textColor = FUNCTCOLOR(255, 166, 60);
    _bottomLabel.text = @"备注:配送中订单超过24小时自动完成";
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_bottomLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:13]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bottomLabel]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_bottomLabel)]];
    
    
    warnImage = [[UIImageView alloc]init];
    warnImage.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:warnImage];
    warnImage.image = [UIImage imageNamed:@"orderInfo_warn"];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_bottomLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:warnImage attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[warnImage]-2-[_bottomLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(warnImage,_bottomLabel)]];
    
    
    return self;
}

-(void)setOrderStatus:(OrderStatus)type
{
    if (type==OrderStatusWaitConfirm) {
        _oneButton.enabled = YES;
        _thirdButton.enabled = NO;
        _secondButton.enabled = NO;
        
        warnImage.hidden = YES;
        _bottomLabel.hidden = YES;
    }
    else if (type == OrderStatusDeliver)
    {
        _oneButton.enabled = YES;
        _thirdButton.enabled = NO;
        _secondButton.enabled = YES;
        
        warnImage.hidden = NO;
        _bottomLabel.hidden = NO;
    }
    else
    {
        _oneButton.enabled = YES;
        _thirdButton.enabled = YES;
        _secondButton.enabled = YES;
        
         warnImage.hidden = NO;
        _bottomLabel.hidden = NO;
    }

}
@end
