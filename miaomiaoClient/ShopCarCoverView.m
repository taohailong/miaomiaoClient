//
//  ShopCarCoverView.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-29.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "ShopCarCoverView.h"
@interface ShopCarCoverView()
{
    ShopCarTableView* _shopTable;
}
@end
@implementation ShopCarCoverView
-(id)initCoverView
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewGesture:)];
    [self addGestureRecognizer:tap];
    return self;
}

-(void)setRemoveBk:(CoverRemoveBk)bk
{
    _removeBk = bk;
}


-(void)tapViewGesture:(UIGestureRecognizer*)gesture
{
    [self removeCoverViewAnimation:YES];
}

-(void)setShopCarData:(NSMutableArray *)products
{
    float originalHeight = (products.count+1)*45.0;
    float height = SCREENHEIGHT*0.6<originalHeight?SCREENHEIGHT*0.6:originalHeight;
    _shopTable = [[ShopCarTableView alloc]initWithFrame:CGRectMake(0,  SCREENHEIGHT-50, SCREENWIDTH, height)];
    [_shopTable setShopCarData:products];
    
    __weak ShopCarCoverView* wself = self;
    [_shopTable setCleanBk:^{
        [wself  tapViewGesture:nil];
    }];
    [self addSubview:_shopTable];
    
    [UIView animateWithDuration:.28 animations:^{
        _shopTable.frame = CGRectMake(0, SCREENHEIGHT-height-50, SCREENWIDTH, CGRectGetHeight(_shopTable.frame));
    }];
}

-(void)removeCoverViewAnimation:(BOOL)flag
{
    if (_removeBk) {
        _removeBk();
        _removeBk = NULL;
    }
    
    if (flag)
    {
        [UIView animateWithDuration:.28 animations:^{
            _shopTable.frame = CGRectMake(0,  SCREENHEIGHT-50, SCREENWIDTH, CGRectGetHeight(_shopTable.frame));
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
    else
    {
        [self removeFromSuperview];
    }
}


-(void)dealloc
{

}

@end
