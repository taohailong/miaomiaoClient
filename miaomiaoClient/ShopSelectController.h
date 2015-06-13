//
//  ShopSelectController.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-13.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShopInfoData;
@class ShopSelectController;
@protocol ShopSelectProtocol <NSObject>

-(void)shopSelectOverWithShopID:(ShopInfoData*)shopID;

@end
@interface ShopSelectController : UIViewController
@property(nonatomic,weak)id<ShopSelectProtocol>delegate;
@end
