//
//  CommentController.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/8/21.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "CommentController.h"
#import "NetWorkRequest.h"
#import "THActivityView.h"
#import "NSString+ZhengZe.h"
@implementation CommentController
@synthesize orderID;
@synthesize shopID;
@synthesize order;
@synthesize delegate;
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = FUNCTCOLOR(237, 237, 237);
    self.title = @"评价";
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:nil];
//    
    [self creatSubView];
}

-(void)creatSubView
{
    UIView* headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor whiteColor];
    headView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:headView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-74-[headView(50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(headView)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[headView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(headView)]];
    
    UILabel* titleL = [[UILabel alloc]init];
    titleL.textColor = FUNCTCOLOR(102, 102, 102);
    titleL.font = DEFAULTFONT(16);
    titleL.text = @"整体评价：";
    titleL.translatesAutoresizingMaskIntoConstraints = NO;
    [headView addSubview:titleL];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:titleL attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[titleL]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleL)]];

    
    _firstBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _firstBt.tag = 1;
    _firstBt.translatesAutoresizingMaskIntoConstraints = NO;
    [headView addSubview:_firstBt];
    [_firstBt addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    [_firstBt setImage:[UIImage imageNamed:@"starBig_empty"] forState:UIControlStateNormal];
    [_firstBt setImage:[UIImage imageNamed:@"starBig_full"] forState:UIControlStateSelected];
    
    [headView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[titleL]-5-[_firstBt]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleL,_firstBt)]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_firstBt attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    
    _secondBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _secondBt.tag = 2;
    _secondBt.translatesAutoresizingMaskIntoConstraints = NO;
    [headView addSubview:_secondBt];
    [_secondBt addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    [_secondBt setImage:[UIImage imageNamed:@"starBig_empty"] forState:UIControlStateNormal];
    [_secondBt setImage:[UIImage imageNamed:@"starBig_full"] forState:UIControlStateSelected];
    
    [headView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_firstBt]-5-[_secondBt]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_firstBt,_secondBt)]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_secondBt attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_firstBt attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    
    
    _thirdBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _thirdBt.tag = 3;
    _thirdBt.translatesAutoresizingMaskIntoConstraints = NO;
    [headView addSubview:_thirdBt];
    [_thirdBt addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    [_thirdBt setImage:[UIImage imageNamed:@"starBig_empty"] forState:UIControlStateNormal];
    [_thirdBt setImage:[UIImage imageNamed:@"starBig_full"] forState:UIControlStateSelected];
    
    [headView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_secondBt]-5-[_thirdBt]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_secondBt,_thirdBt)]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_thirdBt attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_firstBt attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    
    
    
    
    _fourthBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _fourthBt.tag = 4;
    _fourthBt.translatesAutoresizingMaskIntoConstraints = NO;
    [headView addSubview:_fourthBt];
    [_fourthBt addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    [_fourthBt setImage:[UIImage imageNamed:@"starBig_empty"] forState:UIControlStateNormal];
    [_fourthBt setImage:[UIImage imageNamed:@"starBig_full"] forState:UIControlStateSelected];
    
    [headView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_thirdBt]-5-[_fourthBt]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_thirdBt,_fourthBt)]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_fourthBt attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    _fifthBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _fifthBt.tag = 5;
    _fifthBt.translatesAutoresizingMaskIntoConstraints = NO;
    [headView addSubview:_fifthBt];
    [_fifthBt addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    [_fifthBt setImage:[UIImage imageNamed:@"starBig_empty"] forState:UIControlStateNormal];
    [_fifthBt setImage:[UIImage imageNamed:@"starBig_full"] forState:UIControlStateSelected];
    
    [headView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_fourthBt]-5-[_fifthBt]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_fourthBt,_fifthBt)]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_fifthBt attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_firstBt attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [self commentAction:_fifthBt];
    
    
    UIView* bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:bottomView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[headView]-10-[bottomView(120)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(headView,bottomView)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bottomView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bottomView)]];

    
    _textView = [[UITextView alloc]init];
    _textView.text = @"你的意见很重要！快来评价一下吧...";
    _textView.delegate = self;
    _textView.tag = 1;
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.textColor = FUNCTCOLOR(221, 221, 221);
    _textView.font = DEFAULTFONT(14);
    _textView.translatesAutoresizingMaskIntoConstraints = NO;
    [bottomView addSubview:_textView];
    
    [bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_textView]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textView)]];
    
    [bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[_textView]-27-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textView)]];

    
    _indicateLabel = [[UILabel alloc]init];
    _indicateLabel.text = @"还能输入140个字";
    _indicateLabel.textColor = FUNCTCOLOR(221, 221, 221);
    _indicateLabel.font = DEFAULTFONT(12);
    _indicateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [bottomView addSubview:_indicateLabel];
    
    [bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_indicateLabel]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_indicateLabel)]];
    
    [bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_indicateLabel]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_indicateLabel)]];
    
    
    
    UIButton* commitBt = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBt.titleLabel.font = DEFAULTFONT(18);
    [commitBt setTitle:@"提交评价" forState:UIControlStateNormal];
    [commitBt setBackgroundImage:[UIImage imageNamed:@"button_back_red"] forState:UIControlStateNormal];
    [commitBt addTarget:self action:@selector(commitCommentAction:) forControlEvents:UIControlEventTouchUpInside];
    commitBt.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:commitBt];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[commitBt]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(commitBt)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[commitBt(50)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(commitBt)]];
    
}

-(void)commentAction:(UIButton*)bt
{
    
    if (bt.tag>=_firstBt.tag) {
        _firstBt.selected = YES;
    }
    else
    {
        _firstBt.selected = NO;
    }
    

    if (bt.tag>=_secondBt.tag) {
        _secondBt.selected = YES;
    }
    else
    {
        _secondBt.selected = NO;
    }
    
    
    if (bt.tag>=_thirdBt.tag) {
        _thirdBt.selected = YES;
    }
    else
    {
        _thirdBt.selected = NO;
    }
    
    if (bt.tag>=_fourthBt.tag) {
        _fourthBt.selected = YES;
    }
    else
    {
        _fourthBt.selected = NO;
    }
    
    
    if (bt.tag>=_fifthBt.tag) {
        _fifthBt.selected = YES;
    }
    else
    {
        _fifthBt.selected = NO;
    }
}





-(void)commitCommentAction:(UIButton*)bt
{
    int score = 0;
    if (_firstBt.selected == YES) {
        score += 1;
    }
    if (_secondBt.selected == YES) {
        score += 1;
    }

    if (_thirdBt.selected == YES) {
        score += 1;
    }
    if (_fourthBt.selected == YES) {
        score += 1;
    }
    
    if (_fifthBt.selected == YES) {
        score += 1;
    }

    
    if (score == 0) {
        THActivityView* warn = [[THActivityView alloc]initWithString:@"请打分"];
        [warn show];
        return;
    }
    NSString* comment = @"";
    if (_textView.tag == 0)
    {
        comment = _textView.text;
        BOOL emoji = [NSString stringContainsEmoji:comment];
        if (emoji) {
            THActivityView* warn = [[THActivityView alloc]initWithString:@"评论中含特殊字符"];
            [warn show];
            return;
        }
        
    }
    

    
    __weak CommentController* wself = self;
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];
    
    NetWorkRequest* req = [[NetWorkRequest alloc]init];
    [req commitCommentWithOrder:self.order comment:comment score:score completeBk:^(id respond, NetWorkStatus status) {
        [loadView removeFromSuperview];
        
        if (status==NetWorkSuccess) {
            
            [wself commitComplete];
        }
        else if (status == NetWorkErrorTokenInvalid)
        {
           
        }
        
        else
        {
            THActivityView* warn = [[THActivityView alloc]initWithString:respond];
            [warn show];
        }
    }];
    [req startAsynchronous];
}


-(void)commitComplete
{
    self.order.orderStatusType = OrderStatusConfirm;
    self.order.orderStatue = @"订单完成";
    THActivityView* warn = [[THActivityView alloc]initWithString:@"评论成功"];
    [warn show];
    
    if ([self.delegate respondsToSelector:@selector(commentCommitCompleteProtocol)]) {
        [self.delegate commentCommitCompleteProtocol];
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}


-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView.tag == 1) {
        textView.text = @"";
        textView.textColor = FUNCTCOLOR(102, 102, 102);
        textView.tag = 0;
    }
}



-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder]; //［要实现的方法］
        
        return NO;
    }
    if ([text isEqualToString:@""]) {
        return YES;
    }
    if (_lenth>139) {
        return NO;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"%@",textView.text);
    _lenth = _textView.text.length;
    _indicateLabel.text = [NSString stringWithFormat:@"还能输入%d个字",140-_lenth>0?140-_lenth:0];
}

@end
