//
//  ProductShopCarController.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/7/8.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "ProductShopCarController.h"

@implementation ProductShopCarController


-(void)viewWillAppear:(BOOL)animated
{}

-(void)viewWillDisappear:(BOOL)animated
{}

-(void)goShoppingAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)keyboardShown:(NSNotification *)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGSize keyboardSize = [aValue CGRectValue].size;
    [self accessViewAnimate:-keyboardSize.height+60];
}

@end
