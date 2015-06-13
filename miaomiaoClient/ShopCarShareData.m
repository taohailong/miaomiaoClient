//
//  ShopCarShareData.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/6/3.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "ShopCarShareData.h"
#define PRODUCTID @"product_id"
#define PRODUCTCOUNT @"product_count"
@implementation ShopCarShareData
+(ShopCarShareData*)shareShopCarManager
{
    static ShopCarShareData* shareUser = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        
        shareUser = [[self alloc]init];
    });
    return shareUser;
}

-(id)init
{
    self = [super init];
    _shopArr = [[NSMutableArray alloc]init];
    _shopDic = [[NSMutableDictionary alloc]init];
    return self;
}

-(void)clearCache
{
    _totalCount = 0;
    _totalMoney = 0;
    [_shopArr removeAllObjects];
    [_shopDic removeAllObjects];
}


-(NSMutableArray*)getShopCarArr
{
    return _shopArr;
}

-(int)getProductCountWithID:(NSString *)pID
{
    NSNumber* count = _shopDic[pID];
    return [count intValue];
}

-(int)getCarCount
{
    return _totalCount;
}

-(float)getTotalMoney
{
    return _totalMoney;
}

-(void)addOrChangeShopWithProduct:(ShopProductData *)pData
{
    NSNumber* count = _shopDic[pData.pID];
    if (count == nil) {
        
        [_shopDic setObject:[NSNumber numberWithInt:pData.count] forKey:pData.pID];
        [_shopArr addObject:pData];
        
        _totalCount += pData.count;
        _totalMoney+= pData.price * pData.count;
    }
    else
    {
        if (pData.count==0) {
            [_shopDic removeObjectForKey:pData.pID];
        }
        else
        {
            [_shopDic setObject:[NSNumber numberWithInt:pData.count] forKey:pData.pID];
        }
        _totalCount = 0;
        _totalMoney = 0.0;
        
        for (int i = 0 ;i< _shopArr.count;i++) {
            
            ShopProductData* obj = _shopArr[i];
            if ([obj.pID isEqualToString:pData.pID]) {
                obj.count = pData.count;
            }
            if (obj.count==0) {
                [_shopArr removeObject:obj];
                i--;
                continue;
            }
            _totalCount += obj.count;
            _totalMoney+= obj.price * obj.count;
        }
        
     }
}

@end
