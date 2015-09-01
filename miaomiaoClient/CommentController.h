//
//  CommentController.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/8/21.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderData.h"
@class CommentController;
@protocol CommentProtocol <NSObject>

-(void)commentCommitCompleteProtocol;

@end
@interface CommentController : UIViewController<UITextViewDelegate>
{
    UIButton* _firstBt;
    UIButton* _secondBt;
    UIButton* _thirdBt;
    UIButton* _fourthBt;
    UIButton* _fifthBt;
    UITextView* _textView;
    UILabel* _indicateLabel;
    int _score;
    int _lenth;
}
@property(nonatomic,strong)NSString* orderID;
@property(nonatomic,strong)NSString* shopID;
@property(nonatomic,strong)OrderData* order;
@property(nonatomic,weak)id<CommentProtocol>delegate;


@end
