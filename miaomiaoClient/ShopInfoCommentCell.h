//
//  ShopInfoCommentCell.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/8/24.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentScoreView.h"
@interface ShopInfoCommentCell : UITableViewCell
{
    UILabel* _telphoneL;
    CommentScoreView* _scoreView;
    UILabel* _timeLabel;
    UILabel* _commentLabel;
}
-(void)setCommentText:(NSString*)text;

-(void)setTime:(NSString*)time;

-(void)setScore:(float)score
;
-(void)setTelphone:(NSString*)text;
@end
