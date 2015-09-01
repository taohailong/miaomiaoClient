//
//  ShopInfoCommentCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/8/24.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "ShopInfoCommentCell.h"

@implementation ShopInfoCommentCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _telphoneL = [[UILabel alloc]init];
    _telphoneL.font = DEFAULTFONT(16);
    _telphoneL.textColor = FUNCTCOLOR(102, 102, 102);
    _telphoneL.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_telphoneL];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_telphoneL]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_telphoneL)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_telphoneL]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_telphoneL)]];
    
    
    
    
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.font = DEFAULTFONT(12);
    _timeLabel.textColor = FUNCTCOLOR(153, 153, 153);
    _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_timeLabel];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_timeLabel]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_timeLabel)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_timeLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_timeLabel)]];
    

    
    _scoreView = [[CommentScoreView alloc]init];
    _scoreView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_scoreView];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_scoreView(88)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scoreView)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_telphoneL]-0-[_scoreView(15)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_telphoneL,_scoreView)]];
    
    
    
    
    _commentLabel = [[UILabel alloc]init];
    _commentLabel.numberOfLines = 0;
    _commentLabel.font = DEFAULTFONT(12);
    _commentLabel.textColor = FUNCTCOLOR(175, 175, 175);
    _commentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_commentLabel];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_commentLabel]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_commentLabel)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_scoreView]-10-[_commentLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scoreView,_commentLabel)]];
    
    return self;
}

-(void)setTelphone:(NSString*)text
{
    _telphoneL.text = text;
}


-(void)setScore:(float)score
{
    [_scoreView setScore:score];
}


-(void)setTime:(NSString*)time
{
    _timeLabel.text = time;
}

-(void)setCommentText:(NSString*)text
{
    _commentLabel.text = text;
}




@end
