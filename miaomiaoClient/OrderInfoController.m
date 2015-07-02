//
//  OrderInfoController.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/6/3.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "OrderInfoController.h"
#import "ShopProductData.h"
#import "OrderInfoContent.h"
#import "OrderInfoProductCell.h"
#import "OrderInfoServerCell.h"
#import "OrderInfoStatistics.h"
#import "OrderInfoStatusCell.h"
#import "OrderInfoTopCell.h"
#import "THActivityView.h"
#import "NetWorkRequest.h"
#import "DateFormateManager.h"
@interface OrderInfoController()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    int _mySection;
    UITableView* _table;
    OrderData* _orderData;
}
@end
@implementation OrderInfoController

-(id)initWithOrderInfoData:(OrderData *)order
{
    self = [super init];
    _orderData = order;
    if (_orderData.orderStatusType ==OrderStatusCancel||_orderData.orderStatusType ==OrderStatus_Zfb_WaitPay||_orderData.orderStatusType ==OrderStatus_Wx_WaitPay) {
         _mySection = -1;
    }
    else
    {
        _mySection = 0;
    }
   
    return self;
}

-(void)viewDidLoad
{
    self.title = @"订单详情";
    _table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    _table.separatorColor = FUNCTCOLOR(229, 229, 229);
    
    _table.allowsSelection = NO;
    
    _table.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    if (IOS_VERSION(7.0)) {
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];

    }
    else
    {
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];

    }
   
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    else if (section == 2+_mySection)
    {
        return _orderData.productArr.count+3;
    }
    else if (section == 3+_mySection)
    {
        return 2;
    }
    else if (section== 4+_mySection)
    {
        return 2;
    }
    else
    {
        return 1;
    }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        if (_orderData.orderStatusType==OrderStatusCancel||_orderData.orderStatusType==OrderStatusConfirm||_orderData.orderStatusType==OrderStatus_Zfb_WaitPay||_orderData.orderStatusType==OrderStatus_Wx_WaitPay) {
            return 55;
        }
        return 105;
    }
    else if (indexPath.section == 2+_mySection)
    {
        if (indexPath.row == _orderData.productArr.count+2) {
            return 80;
        }
        if (indexPath.row == 0) {
            return 40;
        }
        return 45;
    }
    else if (indexPath.section == 3+_mySection)
    {
        if (indexPath.row==0) {
            return 40;
        }
        return 173;
    }
    
    else if(indexPath.section==4+_mySection)
    {
        if (indexPath.row==0) {
            return 40;
        }
        return 63;
    }
    else
    {
        if (_orderData.orderStatusType == OrderStatusWaitConfirm)
        {
            return 80;
        }
        return 110;
    }

}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==4&&_orderData.orderStatusType != OrderStatusCancel) {
        return 10;
    }
    
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_mySection==-1) {
        return 4;
    }
    return 5;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        OrderInfoTopCell* cell = [tableView dequeueReusableCellWithIdentifier:@"top"];
        if (cell==nil) {
            cell = [[OrderInfoTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"top"];
        }
        
        __weak OrderInfoController* wself = self;
        [cell  setGeneralButtonActionBk:^(ButtonActionSort actionType) {
            [wself parseOrderAction:actionType];
        }];
        UILabel* title = [cell getCellLabel];
        UIButton* button3 = [cell getCellButtonWithType:ButtonActionThress];
        UIButton* button2 = [cell getCellButtonWithType:ButtonActionTwo];
         UIButton* button1 = [cell getCellButtonWithType:ButtonActionOne];
        
        if (_orderData.orderStatusType == OrderStatusConfirm)
        {
            
            [cell setCellImage:[UIImage imageNamed:@"orderInfo_complete"]];
            button3.hidden = YES;
//           [button3 setTitle:@"评价一下" forState:UIControlStateNormal];
            title.text = @"订单已完成";
            button2.hidden = YES;
            button1.hidden = YES;
        }
        else if (_orderData.orderStatusType == OrderStatusDeliver)
        {
            [cell setCellImage:[UIImage imageNamed:@"orderInfo_waitConfirm"]];
            
            [button3 setTitle:@"确认收货" forState:UIControlStateNormal];
            title.text = @"您的订单正在配送中";
            button2.hidden = NO;
            button1.hidden = NO;

        }
        else if (_orderData.orderStatusType == OrderStatusWaitConfirm)
        {
            [cell setCellImage:[UIImage imageNamed:@"orderInfo_waitConfirm"]];
            [button3 setTitle:@"确认收货" forState:UIControlStateNormal];
            title.text = @"下单成功，马上为您配送";
            button2.hidden = NO;
            button1.hidden = NO;

        }
        
        else if (_orderData.orderStatusType == OrderStatus_Wx_WaitPay||_orderData.orderStatusType ==OrderStatus_Zfb_WaitPay)
        {
            [cell setCellImage:[UIImage imageNamed:@"orderInfo_cancel"]];
            button3.hidden = YES;
            title.text = @"订单支付失败";
            button2.hidden = YES;
            button1.hidden = YES;

        }
        else
        {
            [cell setCellImage:[UIImage imageNamed:@"orderInfo_cancel"]];
            button3.hidden = YES;
            title.text = @"订单已取消";
            button2.hidden = YES;
            button1.hidden = YES;
       }
        
        return cell;
    }
    
    
    else if (indexPath.section==2+_mySection)
    {
        if (indexPath.row==_orderData.productArr.count+2)
        {
            OrderInfoStatistics* statisticsCell = [tableView dequeueReusableCellWithIdentifier:@"static"];
            if (statisticsCell== nil)
            {
                statisticsCell = [[OrderInfoStatistics alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"static"];
                UILabel* fistLabel = [statisticsCell getFLabel];
                fistLabel.font = DEFAULTFONT(13);
                fistLabel.textColor = FUNCTCOLOR(189, 189, 189);
                
                UILabel* secondLabel = [statisticsCell getSLabel];
                secondLabel.font = fistLabel.font;
                secondLabel.textColor = DEFAULTNAVCOLOR;
                
                UILabel* thirdLabel = [statisticsCell getThirdLabel];
                thirdLabel.font = secondLabel.font;
                thirdLabel.textColor = fistLabel.textColor;
                
                UILabel* fourthLabel = [statisticsCell getFourthLabel];
                fourthLabel.font = DEFAULTFONT(17);
                fourthLabel.textColor = DEFAULTNAVCOLOR;
            }
            
            UILabel* fistLabel = [statisticsCell getFLabel];
            fistLabel.text =[NSString stringWithFormat:@"商品金额：¥%@",_orderData.totalMoney];
            
            UILabel* secondLabel = [statisticsCell getSLabel];
            secondLabel.text = [NSString stringWithFormat:@"代金券：¥%.2f",_orderData.discountMoney];
            
            UILabel* thirdLabel = [statisticsCell getThirdLabel];
            thirdLabel.text = @"配送费：¥0";
            
            UILabel* fourthLabel = [statisticsCell getFourthLabel];
            float money = [_orderData.totalMoney floatValue] - _orderData.discountMoney;
            
            fourthLabel.text = [NSString stringWithFormat:@"总计：¥%.2f",money<0?0.01:money];
            return statisticsCell;
        }
        
// /////////////////////商品信息／／／／／／／／／／／／／／／／／
        
        OrderInfoProductCell* productCell = [tableView dequeueReusableCellWithIdentifier:@"product"];
        if (productCell==nil) {
            productCell = [[OrderInfoProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"product"];
        }
        
//          [productCell setCellImageWith:nil];
        UILabel* titleLabel = [productCell getContentLabel];
        UILabel* countLabel = [productCell getCountLabel];
        UILabel* moneyLabel = [productCell getMoneyLabel];
        titleLabel.textColor = DEFAULTGRAYCOLO;
        titleLabel.font = DEFAULTFONT(14);
        countLabel.textColor =titleLabel.textColor;
        countLabel.font = titleLabel.font;
        moneyLabel.textColor = titleLabel.textColor;
        moneyLabel.font = titleLabel.font;
        
        if (indexPath.row ==0) {
            titleLabel.textColor = DEFAULTBLACK;
            titleLabel.font = DEFAULTFONT(15);
            titleLabel.text = _orderData.shopName;
            [productCell setCellImageWith:[UIImage imageNamed:@"orderInfo_ShopIcon"]];
        }
        else if (indexPath.row==_orderData.productArr.count+1)
        {
            titleLabel.text = @"代金券";
            countLabel.text = _orderData.discountMoney==0?@"X0":@"X1";
            moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",_orderData.discountMoney];
            [productCell setCellImageWith:[UIImage imageNamed:@"orderInfo_discount"]];

        }
        else
        {
            ShopProductData* product = _orderData.productArr[indexPath.row-1];
            [productCell setCellImageWithUrl:product.pUrl];
            titleLabel.text = product.pName;
            countLabel.text = [NSString stringWithFormat:@"X%d",product.count];
            moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",product.price];
       }
        
        return productCell;
    }
    
    
    else if (indexPath.section == 3+_mySection)
    {
        if (indexPath.row==0)
        {
            OrderInfoProductCell* cell = [tableView dequeueReusableCellWithIdentifier:@"product"];
            if (cell==nil) {
                 cell = [[OrderInfoProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"product"];
            }
            [cell setCellImageWith:[UIImage imageNamed:@"orderInfo_content"]];
            UILabel* titleLabel = [cell getContentLabel];
            titleLabel.font = DEFAULTFONT(15);
            titleLabel.textColor = DEFAULTBLACK;
            UILabel* countLabel = [cell getCountLabel];
            UILabel* moneyLabel = [cell getMoneyLabel];
            titleLabel.text = @"订单详情";
            countLabel.text = @"";
            moneyLabel.text = @"";
            return cell;
        }
       
        OrderInfoContent* cell = [tableView dequeueReusableCellWithIdentifier:@"32"];
        if (cell==nil) {
            cell = [[OrderInfoContent alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"32"];
        }
        
        UILabel* nuLabel = [cell getNuLabel];
        NSString* nuStr = [NSString stringWithFormat:@"订单编号：%@",_orderData.orderNu];
        NSMutableAttributedString* nuAttribute = [[NSMutableAttributedString alloc]initWithString:nuStr];
        
        [nuAttribute addAttributes:@{NSFontAttributeName:DEFAULTFONT(13),NSForegroundColorAttributeName:DEFAULTBLACK} range:NSMakeRange(0, 4)];
        
        [nuAttribute addAttributes:@{NSFontAttributeName:DEFAULTFONT(13),NSForegroundColorAttributeName:DEFAULTGRAYCOLO} range:NSMakeRange(4, nuStr.length-4)];
        nuLabel.attributedText =  nuAttribute;
        

        UILabel* timeLabel = [cell getOrderTimeLabel];
        NSString* timeStr = [NSString stringWithFormat:@"下单时间：%@",_orderData.orderTime];
        NSMutableAttributedString* timeAtt = [[NSMutableAttributedString alloc]initWithString:timeStr attributes:@{NSFontAttributeName:DEFAULTFONT(13)}];
        [timeAtt addAttributes:@{NSForegroundColorAttributeName:DEFAULTBLACK} range:NSMakeRange(0, 4)];
        [timeAtt addAttributes:@{NSForegroundColorAttributeName:DEFAULTGRAYCOLO} range:NSMakeRange(4, timeStr.length-4)];
        timeLabel.attributedText = timeAtt;
        
        
        UILabel* payLabel = [cell getPayLabel];
        NSString* payStr = [NSString stringWithFormat:@"支付方式：%@",[_orderData getPayMethod]];
        NSMutableAttributedString* payAtt = [[NSMutableAttributedString alloc]initWithString:payStr attributes:@{NSFontAttributeName:DEFAULTFONT(13),NSForegroundColorAttributeName:DEFAULTNAVCOLOR}];
//        [payAtt addAttributes:@{NSForegroundColorAttributeName:DEFAULTBLACK} range:NSMakeRange(0, 4)];
//        [payAtt addAttributes:@{NSForegroundColorAttributeName:DEFAULTGRAYCOLO} range:NSMakeRange(4, payStr.length-4)];
        payLabel.attributedText = payAtt;

        
        UILabel* phoneLabel = [cell getPhoneLabel];
        NSString* phoneStr = [NSString stringWithFormat:@"手机号码：%@",_orderData.telPhone];
        NSMutableAttributedString* phoneAtt = [[NSMutableAttributedString alloc]initWithString:phoneStr attributes:@{NSFontAttributeName:DEFAULTFONT(13)}];
        [phoneAtt addAttributes:@{NSForegroundColorAttributeName:DEFAULTBLACK} range:NSMakeRange(0, 4)];
        [phoneAtt addAttributes:@{NSForegroundColorAttributeName:DEFAULTGRAYCOLO} range:NSMakeRange(4, phoneStr.length-4)];
        
        phoneLabel.attributedText = phoneAtt;
        
        
        UILabel* addLabel = [cell getAddressLabel];
        
        NSString* addStr = [NSString stringWithFormat:@"收货地址：%@",_orderData.orderAddress];
        NSMutableAttributedString* addAtt = [[NSMutableAttributedString alloc]initWithString:addStr attributes:@{NSFontAttributeName:DEFAULTFONT(13)}];
        [addAtt addAttributes:@{NSForegroundColorAttributeName:DEFAULTBLACK} range:NSMakeRange(0, 4)];
        [addAtt addAttributes:@{NSForegroundColorAttributeName:DEFAULTGRAYCOLO} range:NSMakeRange(4, addStr.length-4)];
        addLabel.attributedText = addAtt;
        
        return cell;
    
    }
    
    else if(indexPath.section == 4+_mySection)
    {
        if (indexPath.row==0)
        {
            OrderInfoProductCell* cell = [tableView dequeueReusableCellWithIdentifier:@"product"];
            if (cell==nil) {
                cell = [[OrderInfoProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"product"];
            }
            
            UILabel* titleLabel = [cell getContentLabel];
            titleLabel.font = DEFAULTFONT(15);
            titleLabel.textColor = DEFAULTBLACK;
            UILabel* countLabel = [cell getCountLabel];
            UILabel* moneyLabel = [cell getMoneyLabel];
            titleLabel.text = @"售后保障";
            countLabel.text = @"";
            moneyLabel.text = @"";
            [cell setCellImageWith:[UIImage imageNamed:@"orderInfo_server"]];
            return cell;
        }
        
        OrderInfoServerCell* cell = [tableView dequeueReusableCellWithIdentifier:@"52"];
        if (cell==nil) {
            cell = [[OrderInfoServerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"52"];
        }
        
        return cell;
    }

    else
    {
        OrderInfoStatusCell* cell = [tableView dequeueReusableCellWithIdentifier:@"1"];
        if (cell==nil) {
            cell = [[OrderInfoStatusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"1"];
        }
        [cell setOrderStatus:_orderData.orderStatusType];
        return cell;
    }

    
}


-(void)parseOrderAction:(ButtonActionSort)type
{
    if (type ==  ButtonActionOne)
    {
        
        DateFormateManager* timeManager = [DateFormateManager shareDateFormateManager];
        [timeManager setDateStyleString:@"yy-MM-dd HH:mm"];
        
        int minutes = [timeManager figreOutIntervalMinuteSinceNowWithTime:_orderData.orderTime];
        
        if (minutes>=60) {
            [self cancelOrder];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"下单一小时未送达可取消订单，还差%d分钟",60-minutes] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
        }

    }
    else if (type == ButtonActionTwo)
    {
        DateFormateManager* timeManager = [DateFormateManager shareDateFormateManager];
        [timeManager setDateStyleString:@"yy-MM-dd HH:mm"];
        int minutes = [timeManager figreOutIntervalMinuteSinceNowWithTime:_orderData.orderTime];
        
        if (minutes>=15) {
            [self remindOrder];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"15分钟后可以确认，还差%d分钟",15-minutes] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
        }

    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定要收货吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

#pragma mark-------------alert delegate----------------

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex == buttonIndex) {
        return;
    }
    [self confirmOrder];
}



-(void)confirmOrder
{
    __weak OrderData* worder = _orderData;
    __weak UITableView* wtable = _table;
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];
    
    NetWorkRequest* request = [[NetWorkRequest alloc]init];
    [request confirmOrderWithOrder:worder WithBk:^(id respond, NetWorkStatus status) {
        
        NSString* str = nil;
        
        [loadView removeFromSuperview];
        if (status==NetWorkSuccess) {
            str = @"确认订单成功！";
            worder.orderStatusType = OrderStatusConfirm;
            worder.orderStatue = @"订单完成";
            [wtable reloadData];
        }
        else
        {
            str = respond;
        }
        
        THActivityView* showStr = [[THActivityView alloc]initWithString:str];
        [showStr show];
    }];
    [request startAsynchronous];
}
-(void)cancelOrder
{
    __weak OrderData* worder = _orderData;
    __weak UITableView* wtable = _table;
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];
    
    NetWorkRequest* request = [[NetWorkRequest alloc]init];
    [request cancelOrderWithOrder:worder WithBk:^(id respond, NetWorkStatus status) {
        NSString* str = nil;
        
        [loadView removeFromSuperview];
        if (status==NetWorkSuccess) {
            worder.orderStatusType = OrderStatusCancel;
            worder.orderStatue = @"用户取消";
            _mySection = -1;
            
            [wtable reloadData];
            str = @"取消成功，喵喵客服马上和您联系！";
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

-(void)remindOrder
{
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];
    NetWorkRequest* request = [[NetWorkRequest alloc]init];
    [request remindOrderWithOrder:_orderData WithBk:^(id respond, NetWorkStatus status) {
        NSString* str = nil;
        
        [loadView removeFromSuperview];
        if (status==NetWorkSuccess) {
            str = @"催单成功，马上为您送达！";
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



@end
