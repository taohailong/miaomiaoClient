//
//  PCollectionHeadView.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/7/1.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "PCollectionHeadView.h"
@interface PCollectionHeadView()
{
    UIView* _backView;
    UIView* _headView;
    UIImageView*_accessTypeView;
}
@end
@implementation PCollectionHeadView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    _backView = [[UIView alloc]init];
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_backView];
    
    
    _headView = [[UIView alloc]init];
    _headView.backgroundColor = DEFAULTNAVCOLOR;
    _headView.translatesAutoresizingMaskIntoConstraints = NO;
    [_backView addSubview:_headView];
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction)];
    [_backView addGestureRecognizer:gesture];
    
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.font = DEFAULTFONT(16);
    _titleLabel.textColor = DEFAULTBLACK;
    [_backView addSubview:_titleLabel];
    
    _endLabe = [[UILabel alloc]init];
    _endLabe.translatesAutoresizingMaskIntoConstraints = NO;
    _endLabe.font = DEFAULTFONT(12);
    _endLabe.textColor = DEFAULTGRAYCOLO;
    [_backView addSubview:_endLabe];


    _accessTypeView = [[UIImageView alloc]init];
    _accessTypeView.translatesAutoresizingMaskIntoConstraints = NO;
    [_backView addSubview:_accessTypeView];
    _accessTypeView.image = [UIImage imageNamed:@"accessType_arrow"];
    
    [self setLayout];
    return self;
}

-(void)setLayout
{
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_backView]-1-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backView)]];
    
    
    
    
    [_backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_headView(7)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_headView)]];

    [_backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_headView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_headView)]];
    
    
    
    
    [_backView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_backView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [_backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_headView]-5-[_titleLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_headView,_titleLabel)]];

    
    [_backView addConstraint:[NSLayoutConstraint constraintWithItem:_accessTypeView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_backView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [_backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_accessTypeView]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_accessTypeView)]];
    

    
    
    [_backView addConstraint:[NSLayoutConstraint constraintWithItem:_endLabe attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_backView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [_backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_endLabe]-5-[_accessTypeView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_accessTypeView,_endLabe)]];
}

-(void)setTitleLabelStr:(NSString*)str
{
    _titleLabel.text = str;
}


-(void)setDetailStr:(NSString*)str
{
    _endLabe.text = str;
}

-(void)setHeadBk:(CollectionHeadBk)bk
{
    _bk = bk;
}

-(void)tapGestureAction
{
    if (_bk) {
        _bk();
    }
}

@end
