//
//  MNavigationController.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/7/7.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "MNavigationController.h"

@implementation MNavigationController

-(void)setNavigationBarAttribute:(BOOL)flag
{
    UIColor * color = nil;
    if (flag)
    {
        color = [UIColor whiteColor];
        [self.navigationController.navigationBar setTintColor:color];
        [self.navigationController.navigationBar setBarTintColor:DEFAULTNAVCOLOR];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    else
    {
        if (self.navigationController.viewControllers.count == 1) {
            return;
        }
        color = FUNCTCOLOR(64, 64, 64);
        [self.navigationController.navigationBar setTintColor:color];
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    NSDictionary * dict = @{NSForegroundColorAttributeName:color,NSFontAttributeName:DEFAULTFONT(18)};
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
}


-(void)viewWillAppear:(BOOL)animated
{
    [self setNavigationBarAttribute:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self setNavigationBarAttribute:NO];
}


@end
