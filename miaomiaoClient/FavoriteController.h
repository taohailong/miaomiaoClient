//
//  FavoriteController.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/9/1.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkRequest.h"
#import "THActivityView.h"
@interface FavoriteController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _table;
    NSMutableArray* _dataArr;
}
@end
