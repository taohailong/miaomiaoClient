//
//  DiscountCoverView.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/6/11.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "DiscountCoverView.h"
@interface DiscountCoverView()
{


}
@end
@implementation DiscountCoverView
-(id)initDiscountCoverViewWithTitle:(NSString*)str
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
    
    
    
    
    UIImageView* contentImage = [[UIImageView alloc]init];
    contentImage.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:contentImage];
    contentImage.image = [UIImage imageNamed:@"discount_cover"];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:contentImage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
     [self addConstraint:[NSLayoutConstraint constraintWithItem:contentImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-35]];
    
    UILabel* moneyLabel = [[UILabel alloc]init];
    moneyLabel.textColor = FUNCTCOLOR(237, 80, 82);
    moneyLabel.text = str ;
    moneyLabel.font = DEFAULTFONT(40);
    moneyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:moneyLabel];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:moneyLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:moneyLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-110]];
    

    
    
    
    UILabel* titleLabel = [[UILabel alloc]init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:titleLabel];
    titleLabel.font = DEFAULTFONT(25);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"喵喵送你";
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel]-10-[contentImage]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel,contentImage)]];
 
    [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    
    
    
    
    UILabel* detailLabel = [[UILabel alloc]init];
    detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:detailLabel];
    detailLabel.textColor = [UIColor whiteColor];
    detailLabel.font = DEFAULTFONT(14);
    detailLabel.text = @"喵喵一下 便利到家";
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[contentImage]-10-[detailLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentImage,detailLabel)]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:detailLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    

    
    UIButton* tapBt = [UIButton buttonWithType:UIButtonTypeCustom];
    tapBt.translatesAutoresizingMaskIntoConstraints = NO;
    [tapBt addTarget:self action:@selector(removeConverView) forControlEvents:UIControlEventTouchUpInside];
    [tapBt setImage:[UIImage imageNamed:@"discount_getTicket"] forState:UIControlStateNormal];
    [self addSubview:tapBt];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[detailLabel]-30-[tapBt]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(detailLabel,tapBt)]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:tapBt attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    
    
    UILabel* bottomLabel = [[UILabel alloc]init];
    bottomLabel.textColor = [UIColor whiteColor];
    bottomLabel.font = DEFAULTFONT(12);
    bottomLabel.text = @"领取后，我在个人中心哦";
    bottomLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:bottomLabel];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[tapBt]-10-[bottomLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tapBt,bottomLabel)]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:bottomLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];


    
    return self;
}

-(void)show
{
    UIWindow* win = [UIApplication sharedApplication].keyWindow;
    [win addSubview:self];
}

-(void)removeConverView
{
    [self removeFromSuperview];
}

@end
