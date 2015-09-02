//
//  ShopSearchHeadView.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/7/27.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "ShopSearchHeadView.h"
@interface ShopSearchHeadView()
{
    UILabel* _titleL;
    UIButton* _locationBt;
    ShopSearchBk _bk;
}
@end
@implementation ShopSearchHeadView

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    [self creatSubView];
    return self;
}

//-(id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    [self creatSubView];
//    return self;
//}


//-(id)init
//{
//    self = [super init];
//    [self creatSubView];
//
//    return self;
//}



-(void)creatSubView
{
    UIView* back = [[UIView alloc]init];
    back.translatesAutoresizingMaskIntoConstraints = NO;
    back.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:back];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[back]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(back)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[back]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(back)]];
    
    _titleL = [[UILabel alloc]init];
    _titleL.font = DEFAULTFONT(14);
    _titleL.textColor = FUNCTCOLOR(153, 153, 153);
    _titleL.translatesAutoresizingMaskIntoConstraints = NO;
    [back addSubview:_titleL];
    
    [back addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_titleL]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleL)]];
    [back addConstraint:[NSLayoutConstraint constraintWithItem:_titleL attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:back attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    
    
    
    _locationBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _locationBt.translatesAutoresizingMaskIntoConstraints = NO;
    [back addSubview:_locationBt];
    
    [_locationBt setTitleColor:DEFAULTNAVCOLOR forState:UIControlStateNormal];
    _locationBt.titleLabel.font = DEFAULTFONT(14);
    [_locationBt addTarget:self action:@selector(startLocation) forControlEvents:UIControlEventTouchUpInside];
    _locationBt.translatesAutoresizingMaskIntoConstraints = NO;
    [_locationBt setTitle:@"重新定位" forState:UIControlStateNormal];
    [_locationBt setImage:[UIImage imageNamed:@"selectShop_location"] forState:UIControlStateNormal];
    [_locationBt setTitleEdgeInsets:UIEdgeInsetsMake(0, -32, 0, 5)];
    [_locationBt setImageEdgeInsets:UIEdgeInsetsMake(0, 58, 0, -5)];
    
    [back addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_locationBt]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_locationBt)]];
    
    [back addConstraint:[NSLayoutConstraint constraintWithItem:_locationBt attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:back attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];


}



-(void)setTitleStr:(NSString*)str
{
    _titleL.text = str;
}

-(void)startLocation
{
    if (_bk) {
        _bk();
    }
}

-(void)setSearchBk:(ShopSearchBk)bk
{
    _bk = bk;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
