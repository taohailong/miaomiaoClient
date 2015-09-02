//
//  SelectShopFavoriteCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/9/2.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "SelectShopFavoriteCell.h"

@implementation SelectShopFavoriteCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _firstLabel.font = DEFAULTFONT(15);
    _firstLabel.textColor = FUNCTCOLOR(64, 64, 64);
    
    
    _cellLabel.font = DEFAULTFONT(12);
    _cellLabel.textColor = FUNCTCOLOR(153, 153, 153);

    _cellImageView.image = [UIImage imageNamed:@"selectShop_address"];
    
    [self setLayout];
    return self;
}

-(void)setLayout
{
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_firstLabel]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_firstLabel)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[_firstLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_firstLabel)]];
    
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_cellImageView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_cellImageView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_cellImageView]-7-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_cellImageView)]];

    

    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_cellLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_cellImageView attribute:NSLayoutAttributeCenterY  multiplier:1.0 constant:0]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_cellImageView]-5-[_cellLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_cellImageView,_cellLabel)]];
}
@end
