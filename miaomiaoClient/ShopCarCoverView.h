//
//  ShopCarCoverView.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-29.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCarTableView.h"
typedef void (^CoverRemoveBk)(void);
@interface ShopCarCoverView : UIView
{
    CoverRemoveBk _removeBk;
}
-(id)initCoverView;
-(void)setShopCarData:(NSMutableArray*) products;
-(void)setRemoveBk:(CoverRemoveBk)bk;

-(void)removeCoverViewAnimation:(BOOL)flag;
@end
