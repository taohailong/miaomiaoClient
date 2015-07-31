//
//  ShopTableHeadView.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-13.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "ShopTableHeadView.h"

@interface ShopTableHeadView()
{
}
@end
@implementation ShopTableHeadView
@synthesize titleLabel,detailLabel,countLabel,distanceLabel;


-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
//    self.backgroundView = [[UIView alloc]init];
//    self.backgroundView.backgroundColor = [UIColor redColor];
    [self creatSubView];
    return self;
}
-(void)creatSubView
{
//    UIView* back = [[UIView alloc]init];
//    back.translatesAutoresizingMaskIntoConstraints = NO;
//    back.backgroundColor = [UIColor whiteColor];
//    [self addSubview:back];
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[back]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(back)]];
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[back]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(back)]];
    
    self.contentView.backgroundColor = FUNCTCOLOR(243, 243, 243);
    titleLabel = [[UILabel alloc]init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:titleLabel];
    titleLabel.font = DEFAULTFONT(16);
    titleLabel.textColor = FUNCTCOLOR(173.0, 173.0, 173.0);
    [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[titleLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];

}

//-(id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
 //
//    countLabel = [[UILabel alloc]init];
//    countLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    [self addSubview:countLabel];
//    countLabel.backgroundColor = DEFAULTNAVCOLOR;
//    countLabel.textColor = [UIColor whiteColor];
//    countLabel.textAlignment = NSTextAlignmentCenter;
//    countLabel.layer.cornerRadius = 6;
//    countLabel.layer.masksToBounds = YES;
//    countLabel.font = DEFAULTFONT(14);
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[countLabel(>=50)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(countLabel)]];
//    
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[countLabel(>=25)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(countLabel)]];
//    
//    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:countLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
//    
   
    
////////////////////////////////////////////
    
//    UIImageView* addressImage = [[UIImageView alloc]init];
//    addressImage.translatesAutoresizingMaskIntoConstraints = NO;
//    [addressImage setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
////    addressImage.backgroundColor = [UIColor redColor];
//    [self addSubview:addressImage];
//    addressImage.image = [UIImage imageNamed:@"selectShophead_address"];
//    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:addressImage attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
//    
//    
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel]-5-[addressImage]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel,addressImage)]];
//
//
//    
//    detailLabel = [[UILabel alloc]init];
//    detailLabel.textColor = FUNCTCOLOR(153.0, 153.0, 153.0) ;    detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    [self addSubview:detailLabel];
//    detailLabel.font = DEFAULTFONT(13);
//    
//    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:detailLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:addressImage attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
//    
//    
//    
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[addressImage]-5-[detailLabel]-58-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(addressImage,detailLabel)]];
//
//
//    
////    ////////////////////////////////////////////////////
//    
//    UIImageView* distanceImage = [[UIImageView alloc]init];
//    distanceImage.translatesAutoresizingMaskIntoConstraints = NO;
//    [self addSubview:distanceImage];
//    distanceImage.image = [UIImage imageNamed:@"selectShop_distance"];
//
//    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:distanceImage attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[detailLabel]-4-[distanceImage]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(detailLabel,distanceImage)]];
//
//    
//    
//    distanceLabel = [[UILabel alloc]init];
//    distanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    distanceLabel.textColor = detailLabel.textColor;
//    distanceLabel.font = detailLabel.font;
//    [self addSubview:distanceLabel];
//    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:distanceLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:distanceImage attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
//    
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[distanceImage]-4-[distanceLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(distanceImage,distanceLabel)]];
//
//    return self;
//}


@end
