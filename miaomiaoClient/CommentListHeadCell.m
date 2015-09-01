//
//  CommentListHeadCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/8/21.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "CommentListHeadCell.h"

@implementation CommentListHeadCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _cellImageView.image = [UIImage imageNamed:@"commentListShop"];
    _cellLabel.textColor = FUNCTCOLOR(153, 153, 153);
    _cellLabel.font = DEFAULTFONT(12);
    
    
    _firstLabel.textColor = FUNCTCOLOR(153,153 , 153);
    _firstLabel.font = DEFAULTFONT(15);
    
    [self setLayout];
    return self;
}


-(void)setLayout
{
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_cellImageView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_cellImageView)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_cellImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_cellImageView]-5-[_firstLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_cellImageView,_firstLabel)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_firstLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];

    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_cellLabel]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_cellLabel )]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_cellLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
}

@end
