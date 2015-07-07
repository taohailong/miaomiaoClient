//
//  CommonWebController.m
//  miaomiaoShop
//
//  Created by 陶海龙 on 15-5-27.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "CommonWebController.h"
#import "UserManager.h"
@implementation CommonWebController

-(id)initWithUrl:(NSString*)url
{
    self = [super init];
    _url = url;
    return self;
}

-(void)viewDidLoad
{
    UIWebView* web = [[UIWebView alloc]init];
    [self.view addSubview:web];
    web.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[web]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(web)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[web]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(web)]];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
}
@end
