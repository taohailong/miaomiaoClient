//
//  ShopCarShareData.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/6/3.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopProductData.h"
@interface ShopCarShareData : NSObject
{
    NSMutableArray* _shopArr;
    NSMutableDictionary* _shopDic;
    float _totalMoney;
    int _totalCount;
}
+(ShopCarShareData*)shareShopCarManager;

-(NSMutableArray*)getShopCarArr;
-(int)getProductCountWithID:(NSString*)pID;
-(void)addOrChangeShopWithProduct:(ShopProductData*)pData;
-(int)getCarCount;
-(float)getTotalMoney;
-(void)clearCache;
@end
