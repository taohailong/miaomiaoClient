//
//  CommitOrderController.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-14.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopProductData.h"


@interface CommitOrderController : UIViewController

//@property(nonatomic,strong)NSString* shopID;

-(id)initWithProductArr:(NSMutableArray*)productArr WithTotalMoney:(float)money;
@end
