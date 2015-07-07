//
//  AddressData.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-14.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressData : NSObject
@property(nonatomic,strong)NSString* address;
@property(nonatomic,strong)NSString* phoneNu;
@property(nonatomic,strong)NSString* addressID;
@property(nonatomic,assign)int isDefault;
@end
