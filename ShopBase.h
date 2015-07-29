//
//  Shop.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/7/28.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ShopBase : NSManagedObject

@property (nonatomic, retain) NSString * shopID;
@property (nonatomic, retain) NSString * shopName;

@end
