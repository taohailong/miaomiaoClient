//
//  DiscountController.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-21.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscountData.h"

@protocol DiscountProtocol <NSObject>

-(void)discountViewSelectActionComplete:(DiscountData*)data;

@end
@interface DiscountController : UIViewController

@end
