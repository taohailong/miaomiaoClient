//
//  SelectShopCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-13.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "SelectShopCell.h"
#import "NSStringDrawView.h"
@interface SelectShopCell()
{
    UILabel* _statusL;
    UILabel* _fifthLabel;
    NSStringDrawView* _drawView;
}
@end
@implementation SelectShopCell
@synthesize titleLabel,secondLabel,thirdLabel,fourthLabel;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
//    UIView* backView = [[UIView alloc]init];
//    backView.backgroundColor = [UIColor whiteColor];
//    backView.translatesAutoresizingMaskIntoConstraints = NO;
//    [self addSubview:backView];
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[backView]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backView)]];
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-1-[backView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backView)]];

    
    
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.textColor = DEFAULTBLACK;
    self.titleLabel.font = DEFAULTFONT(14);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[titleLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[titleLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];

    _statusL = [[UILabel alloc]init];
    _statusL.textAlignment = NSTextAlignmentCenter;
    _statusL.layer.cornerRadius = 4;
    _statusL.layer.masksToBounds = YES;
    _statusL.backgroundColor = FUNCTCOLOR(221, 221, 221);
    _statusL.translatesAutoresizingMaskIntoConstraints = NO;
    _statusL.textColor = [UIColor whiteColor];
    _statusL.font = DEFAULTFONT(12);
//    [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_statusL];

    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_statusL attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    UILabel* titleL = self.titleLabel;
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[titleL]-10-[_statusL(45)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleL,_statusL)]];

    
///////////////////////self.titleLabel//////////////////
    
    UIImageView* contentImage1 = [[UIImageView alloc]init];
    contentImage1.translatesAutoresizingMaskIntoConstraints = NO;
    contentImage1.image = [UIImage imageNamed:@"selectShop_distance"];
    [self.contentView addSubview:contentImage1];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[contentImage1]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentImage1)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel]-25-[contentImage1]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel,contentImage1)]];

    
    self.secondLabel = [[UILabel alloc]init];
    self.secondLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.secondLabel.textColor = FUNCTCOLOR(166, 166, 166);

    self.secondLabel.font = DEFAULTFONT(12);
    [self.contentView addSubview:self.secondLabel];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.secondLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contentImage1 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[contentImage1]-3-[secondLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentImage1,secondLabel)]];

   ////////////////////////////
    
    
    UIImageView* contentImage2 = [[UIImageView alloc]init];
    contentImage2.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:contentImage2];
    
    contentImage2.image = [UIImage imageNamed:@"selectShop_time"];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[secondLabel]-15-[contentImage2]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(secondLabel,contentImage2)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel]-25-[contentImage2]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel,contentImage2)]];

    
    self.thirdLabel = [[UILabel alloc]init];
    self.thirdLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.thirdLabel.font = self.secondLabel.font;
    self.thirdLabel.textColor = self.secondLabel.textColor;
    [self.contentView addSubview:self.thirdLabel];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.thirdLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contentImage2 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[contentImage2]-3-[thirdLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentImage2,thirdLabel)]];
    
    
    
    ////////////////////
    
    
//    selectShop_minPrice
    UIImageView* contentImage20 = [[UIImageView alloc]init];
    contentImage20.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:contentImage20];
    
    contentImage20.image = [UIImage imageNamed:@"selectShop_minPrice"];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[thirdLabel]-15-[contentImage20]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(thirdLabel,contentImage20)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:contentImage20 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.thirdLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    _fifthLabel = [[UILabel alloc]init];
    _fifthLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _fifthLabel.textColor = self.secondLabel.textColor;
    _fifthLabel.font = self.secondLabel.font;
    [self.contentView addSubview:_fifthLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_fifthLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contentImage20 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[contentImage20]-3-[_fifthLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentImage20,_fifthLabel)]];

    
    
    
//  ///////////////////////////self.secondLabel/////
    
    UIImageView* contentImage3 = [[UIImageView alloc]init];
    contentImage3.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:contentImage3];
    
    contentImage3.image = [UIImage imageNamed:@"selectShop_address"];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[contentImage3]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentImage3)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[contentImage1]-10-[contentImage3]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentImage1,contentImage3)]];
    
    
    
    self.fourthLabel = [[UILabel alloc]init];
    self.fourthLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.fourthLabel.textColor = self.secondLabel.textColor;
    self.fourthLabel.font = self.secondLabel.font;
    [self.contentView addSubview:self.fourthLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.fourthLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contentImage3 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[contentImage3]-3-[fourthLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentImage3,fourthLabel)]];

//  ////////////////////////
    
    
    UIImageView* contentImage4 = [[UIImageView alloc]init];
    contentImage4.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:contentImage4];
    contentImage4.image = [UIImage imageNamed:@"selectShop_server"];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[contentImage4]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentImage4)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[contentImage3]-10-[contentImage4]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentImage3,contentImage4)]];
    
    _drawView = [[NSStringDrawView alloc]initWithFrame:CGRectZero];
    _drawView.backgroundColor = [UIColor clearColor];
    _drawView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_drawView];
    
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_drawView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentImage4  attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[contentImage4]-3-[_drawView]-2-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentImage4,_drawView)]];
    
     [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[contentImage3]-8-[_drawView]-3-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentImage3,_drawView)]];
    
    return self;
}

-(UILabel*)getStatusLabel
{
    return _statusL;
}

-(void)setFifthLabelStr:(NSString*)str
{
    if (str) {
        _fifthLabel.text = str;
    }
    
}

-(void)setServerArr:(NSArray*)arr withSizeDic:(NSMutableDictionary*)dic
{
    [_drawView setStings:arr withSizeDic:dic];
}

@end
