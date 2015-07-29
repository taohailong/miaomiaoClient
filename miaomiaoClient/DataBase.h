//
//  DataBase.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/7/28.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ShopBase.h"
@interface DataBase : NSObject
+(DataBase*)shareDataBase;
-(void)insertShopWithID:(NSString*)shopID shopName:(NSString*)name;
-(NSArray*)getAllShops;
@end
