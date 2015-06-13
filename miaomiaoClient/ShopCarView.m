//
//  ShopCarView.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-14.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "ShopCarView.h"
#import "CarButton.h"
@interface ShopCarView()
{
//    UIButton* _showBt;
    
//    NSLayoutConstraint* _showBt_countLayout;
    CarButton* _showBt;
    UILabel* _countLabel;
    UILabel* _moneyLabel;
    UIButton* _commitBt;
    CommitShopCar _commitBk;
    ShowCarInfo _showCarBk;
    float _minPrice;
}
@end
@implementation ShopCarView


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self creatSubView];
    return self;
}

-(id)init
{
    self = [super init];
    [self creatSubView];
    return self;
}


-(void)setMinPrice:(float)price
{
    _minPrice = price;
    [_commitBt setTitle:[NSString stringWithFormat:@"差%.2f元送",_minPrice] forState:UIControlStateNormal];
//     [_showBt setTitle:@"" forState:UIControlStateNormal];
    [_showBt setButtonTitleText:@"0"];
}

-(void)creatSubView
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIView* separater = [[UIView alloc]init];
    separater.backgroundColor = FUNCTCOLOR(210, 210, 210);
    separater.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:separater];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[separater]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separater)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[separater(0.5)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separater)]];
    
//    _showBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _showBt = [[CarButton alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
    _showBt.titleLabel.font = DEFAULTFONT(11);

    [_showBt setImage:[UIImage imageNamed:@"shopCarIcon"] forState:UIControlStateNormal];
    [_showBt setImage:[UIImage imageNamed:@"shopCarIcon"] forState:UIControlStateDisabled];
    _showBt.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_showBt addTarget:self action:@selector(showShopInfoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_showBt];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[_showBt]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_showBt)]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_showBt attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:-3]];
    
//   [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(-3)-[_showBt]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_showBt)]];


//    _countLabel = [[UILabel alloc]init];
//    _countLabel.font = [UIFont systemFontOfSize:15];
//    _countLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    [self addSubview:_countLabel];
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_showBt]-10-[_countLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_showBt,_countLabel)]];
//    
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_countLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_countLabel)]];

//    UILabel* moneyTitle = [[UILabel alloc]init];
//    moneyTitle.font = [UIFont systemFontOfSize:15];
//    moneyTitle.translatesAutoresizingMaskIntoConstraints = NO;
//    [self addSubview:moneyTitle];
//    moneyTitle.text = @"总计";
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_showBt]-10-[moneyTitle]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_showBt,moneyTitle)]];
//    
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[moneyTitle]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(moneyTitle)]];

    
    
    _moneyLabel = [[UILabel alloc]init];
    _moneyLabel.textColor = FUNCTCOLOR(102, 102, 102);
    _moneyLabel.font = DEFAULTFONT(16);
    _moneyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_moneyLabel];
    
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_showBt]-10-[_moneyLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_showBt,_moneyLabel)]];
    NSLayoutConstraint* showBt_countLayout = [NSLayoutConstraint constraintWithItem:_moneyLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_showBt attribute:NSLayoutAttributeRight multiplier:1.0 constant:10];
    [self addConstraint:showBt_countLayout];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:_moneyLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    
    
    _commitBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _commitBt.titleLabel.font = DEFAULTFONT(15);
    _commitBt.translatesAutoresizingMaskIntoConstraints = NO;
   
    [_commitBt setTitleColor:DEFAULTGRAYCOLO forState:UIControlStateHighlighted];
    _commitBt.layer.borderColor = DEFAULTNAVCOLOR.CGColor;
    _commitBt.layer.borderWidth = 1;
    _commitBt.layer.masksToBounds = YES;
    _commitBt.layer.cornerRadius = 6;
    
    
    [self addSubview:_commitBt];
    [_commitBt addTarget:self action:@selector(commitShopCarAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_commitBt(>=100)]-16-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_commitBt)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_commitBt attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
}


-(void)setCarIconAnimationWithHeight:(float)height
{
    _showBt.enabled = NO;
   [self layoutIfNeeded];
   [UIView animateWithDuration:.28 animations:^{
       
       for (NSLayoutConstraint * constranint in self.constraints)
       {
           if (constranint.firstItem==_showBt&&constranint.firstAttribute==NSLayoutAttributeTop) {
               constranint.constant = -height-3;
               continue;
           }
           
           if (constranint.firstItem==_moneyLabel&&constranint.firstAttribute==NSLayoutAttributeLeft) {
               constranint.constant = -47;
           }
       }

        [self layoutIfNeeded];
       
   } completion:^(BOOL finished) {
       
   }];

}

-(void)carIconRecoverBackAnimation:(BOOL)flag
{
    _showBt.enabled = YES;
    
    [self layoutIfNeeded];
    [UIView animateWithDuration:.28 animations:^{
        
        for (NSLayoutConstraint * constranint in self.constraints)
        {
            if (constranint.firstItem==_showBt&&constranint.firstAttribute==NSLayoutAttributeTop) {
                constranint.constant = -3;
                continue;
            }
            
            if (constranint.firstItem==_moneyLabel&&constranint.firstAttribute==NSLayoutAttributeLeft) {
                
                constranint.constant = 10;
            }

        }
        if (flag==NO) {
            return ;
        }
        [self layoutIfNeeded];
    }];

}


-(void)setCountOfProduct:(int)count
{
    if (count>9) {
       [_showBt setTitleEdgeInsets:UIEdgeInsetsMake(0, -28, 20, 0)];
    }
    else
    {
      [_showBt setTitleEdgeInsets:UIEdgeInsetsMake(0, -21, 20, 0)];
    }
   
    [_showBt setButtonTitleText:[NSString stringWithFormat:@"%d",count]];
}

-(void)setMoneyLabel:(float)money
{
    _moneyLabel.text = [NSString stringWithFormat:@"总计：¥%.2f",money];
    
    if (money>=_minPrice)
    {
        _commitBt.backgroundColor = DEFAULTNAVCOLOR;
        [_commitBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitBt setTitle:@"去结算" forState:UIControlStateNormal];
    }
    else
    {
        _commitBt.backgroundColor = [UIColor whiteColor];
       [_commitBt setTitleColor:DEFAULTNAVCOLOR forState:UIControlStateNormal];
       [_commitBt setTitle:[NSString stringWithFormat:@"差%.2f元起送",_minPrice-money] forState:UIControlStateNormal];
    }
    
}


-(void)setShopCarInfoBk:(ShowCarInfo)completeBk
{
    _showCarBk = completeBk;
}

-(void)setCommitBk:(CommitShopCar)completeBk
{
    _commitBk = completeBk;
}

-(void)commitShopCarAction:(UIButton*)sender
{
    if ([sender.currentTitle isEqualToString:@"去结算"])
    {
        if (_commitBk) {
            _commitBk();
        }
    }
}


-(void)showShopInfoAction:(UIButton*)bt
{
    if (_showCarBk) {
        _showCarBk();
    }

}


@end
