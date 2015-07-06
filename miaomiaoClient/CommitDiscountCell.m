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

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor); CGContextFillRect(context, rect); //上分割线，
    CGContextSetStrokeColorWithColor(context, FUNCTCOLOR(229, 229, 229).CGColor);
    CGContextStrokeRect(context, CGRectMake(1, -1, rect.size.width - 2, 1));
    
    //下分割线 CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"e2e2e2"].CGColor); CGContextStrokeRect(context, CGRectMake(5, rect.size.height, rect.size.width - 10, 1));
}


@end
