//
//  ShopSearchHeadView.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/7/27.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ ShopSearchBk)(void);
@interface ShopSearchHeadView : UITableViewHeaderFooterView
//-(id)initWithSearchBk:(ShopSearchBk)bk;
-(void)setSearchBk:(ShopSearchBk)bk;

-(void)setTitleStr:(NSString*)str;
@end
