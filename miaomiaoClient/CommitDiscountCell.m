//
//  CommitDiscountCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/6/10.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "CommitDiscountCell.h"

@implementation CommitDiscountCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _cellImageView.image = [UIImage imageNamed:@"orderInfo_discount"];
    _cellImageView.contentMode = UIViewContentModeScaleAspectFit;
    _cellLabel.font = DEFAULTFONT(15);
    _cellLabel.textColor = DEFAULTGRAYCOLO;
    _cellLabel.text = @"代金券";
    
    
    _firstLabel.textColor = DEFAULTNAVCOLOR;
    _firstLabel.font = DEFAULTFONT(15);
    return self;
}

-(void)setLayout
{
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-13-[_cellImageView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_cellImageView)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_cellImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_cellImageView]-5-[_cellLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_cellImageView,_cellLabel)]];

    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_cellLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_firstLabel]-1-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_firstLabel)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_firstLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];

}
@end
