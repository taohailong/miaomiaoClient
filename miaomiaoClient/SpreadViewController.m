//
//  SpreadViewController.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/6/19.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "SpreadViewController.h"
#import "NetWorkRequest.h"
#import "THActivityView.h"

@interface SpreadViewController()
{
    UITextField* _contentField;
}
@end
@implementation SpreadViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"推荐码";
    self.view.backgroundColor = FUNCTCOLOR(243, 243, 243);
    
    _contentField = [[UITextField alloc]init];
    _contentField.translatesAutoresizingMaskIntoConstraints = NO;
    _contentField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 36)];
    _contentField.leftViewMode = UITextFieldViewModeAlways;
    _contentField.layer.masksToBounds = YES;
    _contentField.layer.cornerRadius = 4;
    _contentField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_contentField];
    _contentField.placeholder = @"请输入推荐码";
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_contentField]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentField)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-95-[_contentField(36)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentField)]];
    
    
    
    
    UIButton* bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.layer.masksToBounds = YES;
    bt.layer.cornerRadius = 4;
    bt.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:bt];
    [bt setTitle:@"确认" forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [bt setBackgroundImage:[UIImage imageNamed:@"button_back_red"] forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(performVerifyCode) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bt attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_contentField attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bt attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_contentField attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_contentField]-35-[bt(37)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentField,bt)]];
}


-(void)performVerifyCode
{
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];
    NetWorkRequest* request = [[NetWorkRequest alloc]init];
    [request verifySpreadCode:_contentField.text WithCompleteBk:^(id respond, NetWorkStatus status) {
        [loadView removeFromSuperview];
        
        
    }];
    [request startAsynchronous];
}


@end
