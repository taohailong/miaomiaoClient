//
//  CommitProductCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/7/10.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "CommitProductCell.h"

@implementation CommitProductCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _firstLabel.font = DEFAULTFONT(14);
    _firstLabel.textColor = FUNCTCOLOR(189, 189, 189);
    
    _secondLabel.font = DEFAULTFONT(14);
    _secondLabel.textColor = FUNCTCOLOR(189, 189, 189);
    
    _thirdLabel.font = DEFAULTFONT(14);
    _thirdLabel.textColor = FUNCTCOLOR(189, 189, 189);
    [self setLayout];
    return self;
}
-(void)setLayout
{
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_firstLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_firstLabel)]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_firstLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_thirdLabel]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_thirdLabel)]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_thirdLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_secondLabel]-25-[_thirdLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_secondLabel,_thirdLabel)]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_secondLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

-(void)setFirstLabelText:(NSString*)text
{
    _firstLabel.text = text;
}

-(void)setSecondLabelText:(NSString*)text
{
    _secondLabel.text = text;
}

-(void)setThirdLabelText:(NSString*)text
{
    _thirdLabel.text = text;
}


@end
