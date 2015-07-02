//
//  ShopCarTableView.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-18.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ShopCarClean)(void);
@interface ShopCarTableView : UIView
{
    ShopCarClean _cleanBk;
}
-(void)setShopCarData:(NSArray*)carArr;

-(void)setCleanBk:(ShopCarClean)bk;
@end
