//
//  CommentListController.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/8/21.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "CommentListController.h"
#import "NetWorkRequest.h"
#import "CommentListHeadCell.h"
#import "CommentListBottomCell.h"
#import "CommentData.h"
#import "LastViewOnTable.h"
@implementation CommentListController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的评论";
    _table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_table registerClass:[CommentListBottomCell class] forCellReuseIdentifier:@"CommentListBottomCell"];
    [_table registerClass:[CommentListHeadCell class] forCellReuseIdentifier:@"CommentListHeadCell"];
    _table.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_table];
    _table.delegate = self;
    _table.dataSource = self;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_table]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_table]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    
    _dataArr = [[NSMutableArray alloc]init];
    [self getNetData];
    
}

-(void)getNetData
{
    if (_table.tableFooterView.frame.size.height>10) {
        return;
    }
    __weak CommentListController* wself = self;
    NetWorkRequest* req = [[NetWorkRequest alloc]init];
    [req getAllUserCommentWithIndex:_dataArr.count ompleteBlock:^(id respond, NetWorkStatus status) {
        
        if (status == NetWorkSuccess) {
            [wself parseData:respond];
        }
        else if (status == NetWorkErrorTokenInvalid)
        {
           
        }
        else
        {
        
        }
    }];
    [req startAsynchronous];
}

-(void)parseData:(NSArray*)arr
{
    [_dataArr addObjectsFromArray:arr];
    [self addLoadMoreViewWithCount:arr.count];
    [_table reloadData];
}

-(void)addLoadMoreViewWithCount:(int)count
{
    if (count<20) {
        _table.tableFooterView = [[UIView alloc]init];
    }
    else
    {
        _table.tableFooterView = [[LastViewOnTable alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    }
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 35;
    }
    CommentData* data = _dataArr[indexPath.section];
    CGSize size = [data calculateStringHeightWithFont:DEFAULTFONT(13) WithSize:CGSizeMake(SCREENWIDTH-30, 1000)];
    return 40 + size.height;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentData* data = _dataArr[indexPath.section];
    
    if (indexPath.row==0) {
        CommentListHeadCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CommentListHeadCell"];
        UILabel* left = [cell getFirstLabel];
        left.text = data.shopName;
        
        UILabel* right = [cell getCellLabel];
        right.text = data.creatTime;
        return cell;
    }
    CommentListBottomCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CommentListBottomCell"];
    [cell setScore:data.score];
    [cell setCommentText:data.comments];
    return cell;

}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y =  bounds.size.height - inset.bottom;
    float h = size.height;
    
    
    NSLog(@"h-offset is %lf",h-offset.y-y);
    if(h - offset.y-y <50 && _table.tableFooterView.frame.size.height>10)
    {
        [self getNetData];
    }
    
}


@end
