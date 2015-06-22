//
//  CommitOrderController.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-14.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopProductData.h"
typedef enum _CommitPayMethod
{
   AliPayCommit,
   Ali_WxPayCommit,
   Ali_CashPayCommit,
   Wx_CashPayCommit,
   WxPayCommit,
   CashPayCommit,
   All_payCommit
}CommitPayMethod;

@interface CommitOrderController : UIViewController

//@property(nonatomic,strong)NSString* shopID;

-(id)initWithProductArr:(NSMutableArray*)productArr WithTotalMoney:(float)money;
-(void)setPayWayMethod:(CommitPayMethod)method;
@end
