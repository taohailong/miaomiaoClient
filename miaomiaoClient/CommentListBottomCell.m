//
//  CommentListBottomCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/8/21.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "CommentListBottomCell.h"

@implementation CommentListBottomCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _scoreView = [[CommentScoreView alloc]init];
    _scoreView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_scoreView];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_scoreView(88)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scoreView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_scoreView(15)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scoreView)]];
    
    
    _scoreLabel = [[UILabel alloc]init];
    _scoreLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_scoreLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_scoreLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_scoreView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_scoreView]-5-[_scoreLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scoreLabel,_scoreView)]];
    
    _commentLabel = [[UILabel alloc]init];
    _commentLabel.numberOfLines = 0;
    _commentLabel.textColor = FUNCTCOLOR(102, 102, 102);
    _commentLabel.font = DEFAULTFONT(13);
    _commentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_commentLabel];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_commentLabel]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_commentLabel)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_scoreLabel]-6-[_commentLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scoreLabel,_commentLabel)]];
    
    return self;
}


-(void)setScore:(float)score
{
    [_scoreView setScore:score];
    _scoreLabel.text = [NSString stringWithFormat:@"%.1f分",score];
}


-(void)setCommentText:(NSString*)text
{
    _commentLabel.text = text;
}


@end
