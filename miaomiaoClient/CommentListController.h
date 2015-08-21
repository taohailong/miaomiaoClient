//
//  CommentListController.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/8/21.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentListController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _table ;
    NSMutableArray* _dataArr;
}

@end
