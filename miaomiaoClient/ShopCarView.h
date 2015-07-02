//
//  ShopCarView.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-14.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CommitShopCar)(void);
typedef void (^ShowCarInfo)(void);
@interface ShopCarView : UIView
//@property(nonatomic,weak)UILabel* countLabel;
//@property(nonatomic,weak)UILabel* moneyLabel;
-(void)setCountOfProduct:(int)count;
-(void)setMoneyLabel:(float)money;
-(void)setMinPrice:(float)price;
-(void)setCommitBk:(CommitShopCar)completeBk;
-(void)setShopCarInfoBk:(ShowCarInfo)completeBk;

-(void)carIconRecoverBackAnimation:(BOOL)flag;
-(void)setCarIconAnimationWithHeight:(float)height;
@end
