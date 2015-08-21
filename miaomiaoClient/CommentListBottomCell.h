//
//  CommentListBottomCell.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/8/21.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentScoreView.h"
@interface CommentListBottomCell : UITableViewCell
{
    CommentScoreView* _scoreView ;
    UILabel* _scoreLabel;
    UILabel* _commentLabel;
}
-(void)setScore:(float)score;
-(void)setCommentText:(NSString*)text;
@end
