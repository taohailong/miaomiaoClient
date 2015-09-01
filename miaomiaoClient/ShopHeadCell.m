//
//  ShopHeadCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/7/2.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "ShopHeadCell.h"
#import "CommentScoreView.h"
@interface ShopHeadCell()
{
    UILabel* _scoreLabel;
    CommentScoreView* _scoreView;
    UIView* horizontalSeparate;
    UIView* verticalSeparate1;
}
@end
@implementation ShopHeadCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    horizontalSeparate = [[UIView alloc]init];
    horizontalSeparate.translatesAutoresizingMaskIntoConstraints = NO;
    horizontalSeparate.backgroundColor = FUNCTCOLOR(221, 221, 221);

    [self.contentView addSubview:horizontalSeparate];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[horizontalSeparate]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(horizontalSeparate)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-70-[horizontalSeparate(0.5)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(horizontalSeparate)]];
    
    verticalSeparate1 = [[UIView alloc]init];
    verticalSeparate1.translatesAutoresizingMaskIntoConstraints = NO;
    verticalSeparate1.backgroundColor = FUNCTCOLOR(210, 210, 210);
    [self.contentView addSubview:verticalSeparate1];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[horizontalSeparate]-5-[verticalSeparate1]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(horizontalSeparate,verticalSeparate1)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[verticalSeparate1(0.5)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(verticalSeparate1)]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:verticalSeparate1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];

    
    _fifthLabel = [[UILabel alloc]init];
    _fifthLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_fifthLabel];
    
    
    _firstLabel.textColor = FUNCTCOLOR(64, 64, 64);
    _firstLabel.font = DEFAULTFONT(18);
    
   
    _secondLabel.textColor = DEFAULTBLACK;
    _secondLabel.font = DEFAULTFONT(15);
    _secondLabel.text = @"起送价";
    
    
    _thirdLabel.textColor = DEFAULTBLACK;
    _thirdLabel.font = DEFAULTFONT(15);
    _thirdLabel.text = @"配送费";
    
    
    _fourthLabel.textColor = DEFAULTBLACK;
    _fourthLabel.font = DEFAULTFONT(13);
    
    _fifthLabel.textColor = DEFAULTBLACK;
    _fifthLabel.font = DEFAULTFONT(13);
    
    _scoreView = [[CommentScoreView alloc]init];
    [_scoreView setStarTypeIsBig:YES];
    _scoreView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_scoreView];
    
    _scoreLabel = [[UILabel alloc]init];
    _scoreLabel.font = DEFAULTFONT(18);
    _scoreLabel.textColor = FUNCTCOLOR(255, 215, 53);
    _scoreLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_scoreLabel];
    return self;
}

-(void)setLayout
{
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_firstLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_firstLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_firstLabel)]];

    
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_scoreView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:-22]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_scoreView(126)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scoreView)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_firstLabel]-7-[_scoreView(22)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_firstLabel,_scoreView)]];
    
    
    
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_scoreView]-3-[_scoreLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scoreView,_scoreLabel)]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_scoreLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_scoreView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    
    
    
    
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[horizontalSeparate]-8-[_secondLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(horizontalSeparate,_secondLabel)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_secondLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:0.5 constant:0]];
    
    
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_secondLabel]-6-[_fourthLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_secondLabel,_fourthLabel)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_fourthLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:0.5 constant:0]];

    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[horizontalSeparate]-8-[_thirdLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(horizontalSeparate,_thirdLabel)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_thirdLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.5 constant:0]];
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_thirdLabel]-6-[_fifthLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_thirdLabel,_fifthLabel)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_fifthLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.5 constant:0]];

}

-(UILabel*)getFifthLabel
{
    return _fifthLabel;
}


-(void)setCommentScore:(float)score
{
    [_scoreView setScore:score];
    _scoreLabel.text = [NSString stringWithFormat:@"%.1f分",score];
}

@end
