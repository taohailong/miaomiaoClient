//
//  OrderListController.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-15.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "OrderListController.h"
#import "NetWorkRequest.h"
#import "OrderData.h"
#import "OrderFootCell.h"
#import "OrderHeadCell.h"
#import "OrderProductCell.h"
#import "ShopProductData.h"
#import "LastViewOnTable.h"
#import "THActivityView.h"
#import "OrderFootSpecialCell.h"
#import "DateFormateManager.h"
#import "OrderInfoController.h"
#import "OrderFootOneBtCell.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>

@interface OrderListController()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView* _table;
    NSMutableArray *_orderArr;
    __weak OrderData* _selectOrderData;
}
@property(nonatomic,assign)BOOL isLoading;
@end

@implementation OrderListController
@synthesize isLoading;

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [_table reloadData];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的订单";
    
    _table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _table.separatorColor = FUNCTCOLOR(229, 229, 229);
    _table.backgroundColor = FUNCTCOLOR(243, 243, 243);
    [self.view addSubview:_table];
    _table.delegate = self;
    _table.dataSource = self;
    
    
    _table.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    [self getOrderList];
    
    NSNotificationCenter *def = [NSNotificationCenter defaultCenter];
    [def addObserver:self selector:@selector(getOrderList) name:PPAYSUCCESS object:nil];
}

-(void)getOrderList
{
    THActivityView* loadV = [[THActivityView alloc]initActivityViewWithSuperView:self.view];
    
     __weak OrderListController* wSelf = self;
    NetWorkRequest* req = [[NetWorkRequest alloc]init];
    [req getAllOrdersWithFromIndex:0 WithBk:^(NSMutableArray* respond, NetWorkStatus status) {
        
        [loadV removeFromSuperview];
        if (status==NetWorkSuccess) {
            if (respond.count==0) {
                THActivityView* warnView = [[THActivityView alloc]initEmptyDataWarnViewWithString:@"您没有订单哦，赶快下单吧！" WithImage:@"warn_emptyImage" WithSuperView:self.view];
                [warnView addBtWithTitle:@"去下单" WithBk:^{
                    [wSelf backToRoot];
                }];
            }
            
            _orderArr = respond;
            [_table reloadData];
            [wSelf addLoadMoreViewWithCount:(int)respond.count];
        }
       
    }];
    [req startAsynchronous];

}

-(void)loadMoreDataFromNet
{
    if (self.isLoading==YES) {
        return;
    }
    
    self.isLoading = YES;
    
    
   
    NetWorkRequest* productReq = [[NetWorkRequest alloc]init];
    __weak OrderListController* wSelf = self;
    
    [productReq getAllOrdersWithFromIndex:_orderArr.count+1 WithBk:^(NSMutableArray* respond, NetWorkStatus status){
         wSelf.isLoading = NO;
         if(status==NetWorkSuccess)
         {
           [wSelf addDataArr:respond];
         }
         else
         {
        
         }
    }];
    [productReq startAsynchronous];
    
}

-(void)addDataArr:(NSMutableArray*)da
{
    if (da) {
        [_orderArr addObjectsFromArray:da];
        [_table reloadData];
    }
    
    [self addLoadMoreViewWithCount:da.count];
}


-(void)addLoadMoreViewWithCount:(int)count
{
    if (count<20) {
        _table.tableFooterView = nil;
    }
    else
    {
        _table.tableFooterView = [[LastViewOnTable alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0||section==1) {
         return 30;
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 35;
    }
    else if (indexPath.row==1)
    {
        return 65;
    }
    else
    {
        return 45;
    }

}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
    title.textColor = DEFAULTBLACK;
    title.font = DEFAULTFONT(16);
    if (section==0) {
        
        title.text =@"    最新订单";
    }
    else if (section==1)
    {
        title.text = @"   历史订单";
    }
    else
    {
        return nil;
    }
    return title;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    OrderData* order = _orderArr[section];
    if (order.orderStatusType==OrderStatusCancel||order.orderStatusType == OrderStatusConfirm) {
        
         return 2;
    }
    return 3 ;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _orderArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OrderData* order = _orderArr[indexPath.section];
    if (indexPath.row==0)
    {
        OrderHeadCell* cell = [tableView dequeueReusableCellWithIdentifier:@"0"];
        if (cell==nil) {
            cell = [[OrderHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"0"];
        }
        
        
        UILabel* title = [cell getTitleLabel];
        title.font = DEFAULTFONT(15);
        title.text = order.orderTime;
        
        UILabel* status = [cell getStatusLabel];
        status.font = title.font;
        status.text = order.orderStatue;
        status.textColor = DEFAULTGREENCOLOR;
        [cell setTitleImage:[UIImage imageNamed:@"order_time"]];
        return cell;
    }
    else if (2 == indexPath.row)
    {
        __weak OrderListController* wself = self;
        __weak OrderData* wOrder = order;
        
        if (order.orderStatusType != OrderStatus_Wx_WaitPay&&order.orderStatusType != OrderStatus_Zfb_WaitPay) {
            
            OrderFootCell* cell = [tableView dequeueReusableCellWithIdentifier:@"2"];
            if (cell==nil) {
                cell = [[OrderFootCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"2"];
            }
            [cell setOrderBk:^(OrderBtSelect status) {
                [wself btActionWithCategory:status WithOrder:wOrder];
            }];
            [cell setHiddenBtWithType:OrderBtFirst];
            return cell;
        }
       
        OrderFootOneBtCell* cell = [tableView dequeueReusableCellWithIdentifier:@"3"];
        if (cell==nil) {
            cell = [[OrderFootOneBtCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"3"];
        }
        [cell setOrderBk:^(OrderBtSelect status) {
            [wself orderRePay:wOrder];
        }];
       
        return cell;
    }
    else
    {
        ShopProductData* product = order.productArr[0];
        
        OrderProductCell* cell = [tableView dequeueReusableCellWithIdentifier:@"1"];
        if (cell==nil) {
            cell = [[OrderProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"1"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        [cell setCountText: [NSString stringWithFormat:@"共计：%d件",order.countOfProduct]];
        [cell setTitleText: order.shopName];
        [cell setProductUrl:product.pUrl];
        [cell setTotalMoney:[NSString stringWithFormat:@"总价：%@",order.totalMoney]];
        
        return cell;
    }

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderData* order = _orderArr[indexPath.section];
    
    OrderInfoController* infoController = [[OrderInfoController alloc]initWithOrderInfoData:order];
    [self.navigationController pushViewController:infoController animated:YES];

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
    if(h - offset.y-y <50 && _table.tableFooterView)
    {
        [self loadMoreDataFromNet];
    }
    
}

#pragma mark-cellAction


-(void)orderRePay:(OrderData*)order
{
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];
    
    THActivityView* fullView = [[THActivityView alloc]initViewOnWindow];
    [fullView loadViewAddOnWindow];
    
    __weak OrderData* worder = order;
    __weak OrderListController* wself = self;
    NetWorkRequest* req = [[NetWorkRequest alloc]init];
    [req rePayOrderWithOrder:order  WithBk:^(id respond, NetWorkStatus status) {
        
        [fullView removeFromSuperview];
        [loadView removeFromSuperview];
        
        if (status == NetWorkSuccess)
        {
            if (worder.orderStatusType == OrderStatus_Wx_WaitPay) {
                [wself performWeixinPayWithOrder:respond];
            }
            else
            {
                [wself performZhifubaoPayWithOrder:respond];
            }
        }
        else
        {
        
        }
    }];
    [req startAsynchronous];
}


-(void)btActionWithCategory:(OrderBtSelect)category WithOrder:(OrderData*)data
{
    if (category==OrderBtFirst) {
        
    }
    else if (category==OrderBtSecond)
    {
        DateFormateManager* timeManager = [DateFormateManager shareDateFormateManager];
        [timeManager setDateStyleString:@"yy-MM-dd HH:mm"];
        
       int minutes = [timeManager figreOutIntervalMinuteSinceNowWithTime:data.orderTime];

        if (minutes>=60) {
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否确认取消订单？" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
            [alert show];
            alert.tag = 100;
            _selectOrderData = data;
//            [self cancelOrderWithOrder:data];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"下单一小时未送达可取消订单，还差%d分钟",60-minutes] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    else if (category==OrderBtThird)
    {
        
        DateFormateManager* timeManager = [DateFormateManager shareDateFormateManager];
        [timeManager setDateStyleString:@"yy-MM-dd HH:mm"];
        int minutes = [timeManager figreOutIntervalMinuteSinceNowWithTime:data.orderTime];
    
        if (minutes>=15) {
            [self remindOrderWithOrder:data];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"15分钟后可催单，还差%d分钟",15-minutes] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else
    {
        _selectOrderData = data;
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否确认收货？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 10;
        [alert show];
    }
}




-(void)confirmOrderWithOrder:(OrderData*)order
{
    __weak OrderData* worder = order;
    __weak UITableView* wtable = _table;
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];

    NetWorkRequest* request = [[NetWorkRequest alloc]init];
    [request confirmOrderWithOrder:order WithBk:^(id respond, NetWorkStatus status) {
        
        [loadView removeFromSuperview];
          NSString* str = nil;
        if (status==NetWorkSuccess) {
            str = @"确认订单成功！";
            worder.orderStatusType = OrderStatusConfirm;
            worder.orderStatue = @"订单完成";
            [wtable reloadData];
        }
        else
        {
           str = (NSString*)respond;
//            str = @"确认订单失败！";
        }
        
        THActivityView* showStr = [[THActivityView alloc]initWithString:str];
        [showStr show];
    }];
    [request startAsynchronous];
}
-(void)cancelOrderWithOrder:(OrderData*)order
{
    
    __weak OrderData* worder = order;
    __weak UITableView* wtable = _table;
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];

    NetWorkRequest* request = [[NetWorkRequest alloc]init];
    [request cancelOrderWithOrder:order WithBk:^(id respond, NetWorkStatus status) {
        NSString* str = nil;
        
        [loadView removeFromSuperview];
        if (status==NetWorkSuccess) {
            worder.orderStatusType = OrderStatusCancel;
            worder.orderStatue = @"用户取消";
            [wtable reloadData];
            str = @"取消订单成功！";
        }
        else
        {
            str = @"取消失败！";
        }
        
        THActivityView* showStr = [[THActivityView alloc]initWithString:str];
        [showStr show];

    }];
    [request startAsynchronous];

}

-(void)remindOrderWithOrder:(OrderData*)order
{
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];
    NetWorkRequest* request = [[NetWorkRequest alloc]init];
    [request remindOrderWithOrder:order WithBk:^(id respond, NetWorkStatus status) {
        NSString* str = nil;
        
        [loadView removeFromSuperview];
        if (status==NetWorkSuccess) {
            str = @"催单订单成功！";
        }
        else
        {
            str = @"催单失败！";
        }
        
        THActivityView* showStr = [[THActivityView alloc]initWithString:str];
        [showStr show];

    }];
    [request startAsynchronous];
}


#pragma mark--------------------alert delegate-------------------


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex == buttonIndex) {
        return;
    }
    if (alertView.tag == 10) {
        [self confirmOrderWithOrder:_selectOrderData];
    }
    else
    {
        [self cancelOrderWithOrder:_selectOrderData];
    }
}

-(void)backToRoot
{
    [self.navigationController popToRootViewControllerAnimated:YES];

}

#pragma mark--------------pay-----------------------


//weixin
-(void)performWeixinPayWithOrder:(NSDictionary*)dic
{
    NSDictionary* source = dic;
    
    PayReq *request = [[PayReq alloc] init] ;
    request.partnerId = @"1246963001";
    request.prepayId= source[@"payInfo"][@"pre_id"];
    request.package = @"Sign=WXPay";
    request.nonceStr=  source[@"payInfo"][@"nonceStr"];
    request.timeStamp= [source[@"payInfo"][@"timestamp"] intValue];
    request.sign= source[@"payInfo"][@"sign"];;
    [WXApi sendReq:request];
}

//zhifubao

-(void)performZhifubaoPayWithOrder:(NSDictionary*)dic
{
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"wx8c2570b40fc89b39";
    __weak OrderListController* wself = self;
    NSString* orderString = dic[@"payInfo"];
    
    [[AlipaySDK defaultService] payOrder: orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        
        if([resultDic[@"resultStatus"] intValue] != 9000)
        {
            THActivityView* showStr = [[THActivityView alloc]initWithString:resultDic[@"memo"]];
            [showStr show];
        }
        else
        {
            [wself getOrderList];
        }
        NSLog(@"reslut = %@",resultDic);
    }];
    
}


@end
