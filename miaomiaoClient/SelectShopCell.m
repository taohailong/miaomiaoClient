//
//  SelectShopCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-13.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "SelectShopCell.h"
@interface SelectShopCell()
{
    UILabel* _statusL;
}
@end
@implementation SelectShopCell
@synthesize titleLabel,secondLabel,thirdLabel,fourthLabel;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = FUNCTCOLOR(243, 243, 243);
    
    UIView* backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:backView];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[backView]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-1-[backView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backView)]];

    
    
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [backView addSubview:self.titleLabel];
    self.titleLabel.textColor = DEFAULTNAVCOLOR;
    self.titleLabel.font = DEFAULTFONT(14);
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[titleLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[titleLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];

    _statusL = [[UILabel alloc]init];
    _statusL.textAlignment = NSTextAlignmentCenter;
    _statusL.layer.cornerRadius = 6;
    _statusL.layer.masksToBounds = YES;
    _statusL.backgroundColor = DEFAULTNAVCOLOR;
    _statusL.translatesAutoresizingMaskIntoConstraints = NO;
    _statusL.textColor = [UIColor whiteColor];
    _statusL.font = DEFAULTFONT(14);
//    [UIFont systemFontOfSize:14];
    [backView addSubview:_statusL];
    
    
//    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_statusL]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_statusL)]];
    
    [backView addConstraint:[NSLayoutConstraint constraintWithItem:_statusL attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:backView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_statusL(>=50)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_statusL)]];

    
///////////////////////self.titleLabel//////////////////
    
    UIImageView* contentImage1 = [[UIImageView alloc]init];
    contentImage1.translatesAutoresizingMaskIntoConstraints = NO;
    contentImage1.image = [UIImage imageNamed:@"selectShop_time"];
    [backView addSubview:contentImage1];
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[contentImage1]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentImage1)]];
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel]-5-[contentImage1]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel,contentImage1)]];

    
    self.secondLabel = [[UILabel alloc]init];
    self.secondLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.secondLabel.textColor = FUNCTCOLOR(199.0, 199.0, 199.0);

    self.secondLabel.font = DEFAULTFONT(13);
    [backView addSubview:self.secondLabel];
    
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel]-5-[secondLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel,secondLabel)]];
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[contentImage1]-10-[secondLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentImage1,secondLabel)]];

    
    
    
    UIImageView* contentImage2 = [[UIImageView alloc]init];
    contentImage2.translatesAutoresizingMaskIntoConstraints = NO;
    [backView addSubview:contentImage2];
    
    contentImage2.image = [UIImage imageNamed:@"selectShop_minPrice"];
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[secondLabel]-10-[contentImage2]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(secondLabel,contentImage2)]];
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel]-5-[contentImage2]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel,contentImage2)]];

    
    self.thirdLabel = [[UILabel alloc]init];
    self.thirdLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.thirdLabel.font = self.secondLabel.font;
    self.thirdLabel.textColor = self.secondLabel.textColor;
    [backView addSubview:self.thirdLabel];
    
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel]-5-[thirdLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(thirdLabel,titleLabel)]];
    
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[contentImage2]-5-[thirdLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentImage2,thirdLabel)]];
    
//  ///////////////////////////self.secondLabel/////
    
    UIImageView* contentImage3 = [[UIImageView alloc]init];
    contentImage3.translatesAutoresizingMaskIntoConstraints = NO;
    [backView addSubview:contentImage3];
    
    contentImage3.image = [UIImage imageNamed:@"selectShop_address"];
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[contentImage3]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentImage3)]];
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[secondLabel]-5-[contentImage3]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(secondLabel,contentImage3)]];
    
    
    
    self.fourthLabel = [[UILabel alloc]init];
    self.fourthLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.fourthLabel.textColor = self.secondLabel.textColor;
    self.fourthLabel.font = self.secondLabel.font;
    [backView addSubview:self.fourthLabel];
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[secondLabel]-5-[fourthLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(secondLabel,fourthLabel)]];
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[contentImage3]-10-[fourthLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentImage3,fourthLabel)]];

    return self;
}

-(UILabel*)getStatusLabel
{
    return _statusL;
}
@end
