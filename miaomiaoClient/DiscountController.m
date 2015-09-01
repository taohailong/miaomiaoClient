//
//  DiscountController.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-21.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "DiscountController.h"
#import "DiscountCell.h"
#import "NetWorkRequest.h"
#import "THActivityView.h"
#import "LastViewOnTable.h"
#import "DiscountActionCell.h"
@interface DiscountController()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _table;
    NSMutableArray* _dataArr;
}
@end
@implementation DiscountController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的代金券";
    
    
    _dataArr = [[NSMutableArray alloc]init];
    _table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.backgroundColor = FUNCTCOLOR(243, 243, 243);
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    _table.allowsSelection = NO;
    
    if ([_table respondsToSelector:@selector(setSeparatorInset:)])
    {
        [_table setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_table respondsToSelector:@selector(setLayoutMargins:)]) {
        [_table setLayoutMargins:UIEdgeInsetsZero];
    }

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    [self getLoadDataFromNet];
}



-(void)getLoadDataFromNet
{
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];
    
     __weak DiscountController* wself = self;
    NetWorkRequest* req = [[NetWorkRequest alloc]init];
    [req getDiscountTicketListWithIndex:_dataArr.count WithBk:^(NSArray* respond, NetWorkStatus status) {
         [loadView removeFromSuperview];
        if (status == NetWorkSuccess) {
            [wself reloadData:respond];
        }
        else if (status == NetWorkErrorUnKnow)
        {
            THActivityView* err = [[THActivityView alloc]initWithString:(NSString*)respond];
            [err show];
        }
        else
        {
           
        }
    }];
    [req startAsynchronous];
}


-(void)loadMoreDataFromNet
{
    __weak DiscountController* wself = self;
    NetWorkRequest* req = [[NetWorkRequest alloc]init];
    [req getDiscountTicketListWithIndex:_dataArr.count WithBk:^(NSArray* respond, NetWorkStatus status) {
       
        if (status == NetWorkSuccess) {
            [wself addMoreData:respond];
        }
        else if(status == NetWorkErrorUnKnow)
        {
            THActivityView* err = [[THActivityView alloc]initWithString:(NSString*)respond];
            [err show];
        }
    }];
    
    [req startAsynchronous];
}


-(void)reloadData:(NSArray*)arr
{
    [_dataArr addObjectsFromArray:arr];
    
    if (_dataArr.count ==0) {
        THActivityView* warnView = [[THActivityView alloc]initEmptyDataWarnViewWithString:@"您还没有优惠券哦" WithImage:@"discountList_null" WithSuperView:self.view];
        warnView.tag = 0;
    }
    
    
    [_table reloadData];
    [self addLoadMoreViewWithCount:arr.count];
}


-(void)addMoreData:(NSArray*)arr
{
    [_dataArr addObjectsFromArray:arr];
    [_table reloadData];
    [self addLoadMoreViewWithCount:arr.count];
    
}

-(void)addLoadMoreViewWithCount:(long)count
{
    _table.separatorColor = nil;
    if (count<20) {
        _table.tableFooterView = [[UIView alloc]init];
    }
    else
    {
        _table.tableFooterView = [[LastViewOnTable alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiscountData* data = _dataArr[indexPath.row];
    
    DiscountActionCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[DiscountActionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell setLayout];
    }

    [cell setTitleLabelAttribute:[NSString stringWithFormat:@"%.0f",data.discountMoney]];
    
    UILabel* secondLabel = [cell getSecondLabel];
    if (data.minMoney==0) {
        secondLabel.text = @"代金券";
    }
    else
    {
        NSString* str = [NSString stringWithFormat:@"代金券【满%d元使用】",(int)data.minMoney];
        NSMutableAttributedString* att = [[NSMutableAttributedString alloc]initWithString:str];
//        NSAttributedString* discount = nil;
//        discount = [[NSAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName:FUNCTCOLOR(255, 166, 60),NSFontAttributeName:DEFAULTFONT(13)}];
//        [att appendAttributedString:discount];
        secondLabel.attributedText = att;
    }
    
    UILabel* fourthLabel = [cell getFourthLabel];
    fourthLabel.text = [NSString stringWithFormat:@"有效期：%@至%@",data.startTime,data.deadTime];

    [cell setTicketStatus:data.valid];
    return  cell;
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
        [self loadMoreDataFromNet];
    }
    
}


@end
