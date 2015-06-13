//
//  OrderInfoTopCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/6/3.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "OrderInfoTopCell.h"
@interface OrderInfoTopCell()
{
    UIImageView* _cellImage;
    UIButton* _oneButton;
    UIButton* _secondButton;
    UIButton* _thirdButton;
    UILabel* _cellLabel;
}
@end
@implementation OrderInfoTopCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _cellImage = [[UIImageView alloc]init];
    _cellImage.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_cellImage];
    
    _cellLabel = [[UILabel alloc]init];
    _cellLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _cellLabel.font = DEFAULTFONT(15);
    _cellLabel.textColor = DEFAULTGRAYCOLO;
    [self.contentView addSubview:_cellLabel];
    
    
    _oneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _oneButton.translatesAutoresizingMaskIntoConstraints = NO;
    _oneButton.tag = 1;
    
    [_oneButton setImage:[UIImage imageNamed:@"orderInfo_bt_cancel"] forState:UIControlStateNormal];
    [_oneButton setTitle:@"取消订单" forState:UIControlStateNormal];
    _oneButton.titleLabel.font = DEFAULTFONT(12);
    [_oneButton setTitleEdgeInsets:UIEdgeInsetsMake(48, -25, 20, 0)];
    [_oneButton setImageEdgeInsets:UIEdgeInsetsMake(0, 12, 15, 0)];

    [_oneButton setTitleColor:DEFAULTNAVCOLOR forState:UIControlStateNormal];
    [_oneButton addTarget:self action:@selector(generalButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_oneButton];
    
    
    _thirdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _thirdButton.translatesAutoresizingMaskIntoConstraints = NO;
    _thirdButton.titleLabel.font = DEFAULTFONT(16.0);
    _thirdButton.tag = 3;
    _thirdButton.layer.cornerRadius = 4;
    _thirdButton.layer.masksToBounds = YES;
    [_thirdButton setBackgroundImage:[UIImage imageNamed:@"button_back_red"] forState:UIControlStateNormal];
    [_thirdButton addTarget:self action:@selector(generalButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_thirdButton];

    
    
    _secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _secondButton.translatesAutoresizingMaskIntoConstraints = NO;
    _secondButton.titleLabel.font = DEFAULTFONT(12);
    [_secondButton setTitleEdgeInsets:UIEdgeInsetsMake(48, -25, 20, 0)];
    [_secondButton setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 15, 0)];
    [_secondButton setTitle:@"催 单" forState:UIControlStateNormal];
    [_secondButton setTitleColor:DEFAULTNAVCOLOR forState:UIControlStateNormal];
    [_secondButton setImage:[UIImage imageNamed:@"orderInfo_alarm"] forState:UIControlStateNormal];
    _secondButton.tag = 2;
    [_secondButton addTarget:self action:@selector(generalButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_secondButton];
    
    [self setLayout];
    return self;
}

-(void)setLayout
{
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-13-[_cellImage]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_cellImage)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_cellImage]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_cellImage)]];
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_cellImage]-5-[_cellLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_cellImage,_cellLabel)]];
     [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_cellLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_cellLabel)]];
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_secondButton(35)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_secondButton)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_secondButton(45)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_secondButton)]];
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_oneButton(50)]-12-[_secondButton]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_oneButton,_secondButton)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_oneButton(45)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_oneButton)]];

    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-13-[_thirdButton]-13-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_thirdButton)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-60-[_thirdButton(30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_thirdButton)]];

}


-(UIButton*)getCellButtonWithType:(ButtonActionSort)type
{
    UIButton* returnBt = nil;
    switch (type) {
        case ButtonActionOne:
            returnBt = _oneButton;
            break;
         case ButtonActionTwo:
            returnBt = _secondButton;
            break;
         case ButtonActionThress:
            returnBt = _thirdButton;
            break;
        default:
            break;
    }
    return returnBt;
}

-(void)setGeneralButtonActionBk:(GeneralButtonBk)bk
{
    _generalBk = bk;
}

-(void)setCellImage:(UIImage *)image
{
    _cellImage.image = image;
}

-(UILabel*)getCellLabel
{
    return _cellLabel;
}

-(void)generalButtonAction:(UIButton*)sender
{
    if (_generalBk) {
        if (sender.tag==1) {
            _generalBk(ButtonActionOne);
        }
        else if (sender.tag==2)
        {
          _generalBk(ButtonActionTwo);
        }
        else
        {
          _generalBk(ButtonActionThress);
        }
    }

}

@end
