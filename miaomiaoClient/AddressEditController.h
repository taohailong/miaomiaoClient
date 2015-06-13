//
//  AddressEditController.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-19.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressData.h"
#import "NSString+ZhengZe.h"

@class AddressEditController;
@protocol AddressEditProtocol <NSObject>

-(void)AddressAddWithAddressData:(AddressData*)add;
-(void)AddressUpdateComplete;

@end

@interface AddressEditController : UIViewController
@property(nonatomic,weak)id<AddressEditProtocol>delegate;
-(id)initWithAddressData:(AddressData*)address;
@end
