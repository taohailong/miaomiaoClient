//
//  AddressViewController.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-14.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressData.h"
#import "NetWorkRequest.h"
#import "THActivityView.h"
@class AddressViewController;
@protocol AddressSelectProtocol <NSObject>

-(void)selectAddressOverWithAddress:(AddressData*)data;

@end
@interface AddressViewController : UIViewController
{
  __weak AddressData* _defaultArr;
    UITableView* _table;
    NSMutableArray* _dataArr;
}
@property(nonatomic,weak)id<AddressSelectProtocol>delegate;
@end
