//
//  CommitOrderController.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-14.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "CommitOrderController.h"
#import "ProductCell.h"
#import "CommitFillCell.h"
#import "AddressViewController.h"
#import "THActivityView.h"

#import "OrderListController.h"
#import "ConfirmAddressCell.h"
#import "ConfirmAddressOneCell.h"
#import "CustomSelectCell.h"
#import "ShopCarShareData.h"
#import "CommitDiscountCell.h"
#import "UICustomActionView.h"
#import "DiscountData.h"
#import "CommitPDetailCell.h"
#import "NetWorkRequest.h"

#import "WXApi.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@interface CommitOrderController ()<UITableViewDataSource,UITableViewDelegate,AddressSelectProtocol,CustomActionProtocol>
{
    UILabel* _moneyLabel;
    UIButton* _commitBt;
//    UILabel* _discountLabel;
    
    int _currentRow;
    CommitPayMethod _combinePays;
    NSArray* _payArr;
    __weak UITextField* _respondField;
    NSDictionary* _addressDic;
    UITableView* _table;
//    NSMutableArray* _productArr;
//    float _totalMoney;
    AddressData* _address;
    OrderPayWay _payWay;
    NSArray* _discountArr;
    __weak DiscountData* _currentDiscount;
    
}

@end
@implementation CommitOrderController
@synthesize leaveMes;
-(id)init
{
    self = [super init];
    
    UserManager* user = [UserManager shareUserManager];
    [self setPayWayMethod:user.shop.combinPay];
//    [self setPayWayMethod:All_payCommit];
    return self;
}

-(void)setPayWayMethod:(CommitPayMethod)method
{
    _combinePays = method;
    switch (method) {
        case Ali_CashPayCommit:
             _payArr = @[@"支付宝支付",@"货到付款",@""];
            _payWay = OrderPayInZfb;
            break;
            
        case AliPayCommit:
            _payArr = @[@"支付宝支付",@""];
            _payWay = OrderPayInZfb;
            break;
    
        case Wx_CashPayCommit:
            _payArr = @[@"微信支付",@"货到付款",@""];
            _payWay = OrderPayInWx;
            break;
 
        case WxPayCommit:
            _payArr = @[@"微信支付",@""];
            _payWay = OrderPayInWx;
            break;
            
        case Ali_WxPayCommit:
            _payArr = @[@"支付宝支付",@"微信支付",@""];
            _payWay = OrderPayInZfb;
            break;

        case CashPayCommit:
            _payArr = @[@"货到付款"];
            _payWay = OrderPayInCash;
            break;

        default:
            _payArr = @[@"支付宝支付",@"微信支付",@"货到付款",@""];
            _payWay = OrderPayInZfb;
            break;
    }
}


-(void)viewDidAppear:(BOOL)animated
{
    NSNotificationCenter *def = [NSNotificationCenter defaultCenter];
    [def addObserver:self selector:@selector(showOrderListViewContrller) name:PPAYSUCCESS object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSNotificationCenter *def = [NSNotificationCenter defaultCenter];
    [def removeObserver:self];
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"订单";
    self.view.backgroundColor = [UIColor whiteColor];

    
    _table = [[UITableView alloc]initWithFrame:self.view.bounds    style:UITableViewStyleGrouped];
    [self.view addSubview:_table];
    
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_table registerClass:[ConfirmAddressOneCell class] forCellReuseIdentifier:@"ConfirmAddressOneCell"];
    
    [_table registerClass:[CommitPDetailCell class] forCellReuseIdentifier:@"CommitPDetailCell"];
    [_table registerClass:[ConfirmAddressCell class] forCellReuseIdentifier:@"ConfirmAddressCell"];
    [_table registerClass:[CommitDiscountCell class] forCellReuseIdentifier:@"CommitDiscountCell"];
    [_table registerClass:[CustomSelectCell class] forCellReuseIdentifier:@"CustomSelectCell"];
    
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorColor = FUNCTCOLOR(229, 229, 229);
    _table.backgroundColor = FUNCTCOLOR(243, 243, 243);
    _table.translatesAutoresizingMaskIntoConstraints = NO;
  
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_table attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_table attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-45]];

    
    [self creatShopCarView];
    [self getAddress];
    [self requestDiscountData];
    [self registeNotificationCenter];
}

-(void)registeNotificationCenter
{
    /*注册成功后  重新链接服务器*/
    
    NSNotificationCenter *def = [NSNotificationCenter defaultCenter];
    
    [def addObserver:self selector:@selector(showOrderListViewContrller) name:PPAYSUCCESS object:nil];
}



-(void)getAddress
{
    __weak UITableView* wTable = _table;
    __weak CommitOrderController* wself = self;
    NetWorkRequest* req = [[NetWorkRequest alloc]init];
    [req getDefaultAddressWithBk:^(id respond, NetWorkStatus status) {
        
        if (status == NetWorkErrorCanntConnect) {
            THActivityView* loadView = [[THActivityView alloc]initWithNetErrorWithSuperView:wself.view];
            
            [loadView setErrorBk:^{
                [wself getAddress];
            }];
            return ;
        }
        
        if (status == NetWorkErrorTokenInvalid) {
            return;
        }
        _address = respond;
    
        [wTable reloadData];
        NSLog(@"req is %@",respond);
    }];
    [req startAsynchronous];
}

-(void)commitOrderAction
{
   
    if (_address==nil) {
        THActivityView* warnView = [[THActivityView alloc]initWithString:@"请选择地址！"];
        [warnView show];
        return;
    }
   
    ShopCarShareData* managerData = [ShopCarShareData shareShopCarManager];
    
    if (_currentDiscount.minMoney>[managerData getTotalMoney])
    {
        THActivityView* warnView = [[THActivityView alloc]initWithString:@"代金券不可用！"];
        [warnView show];
        return;
    }
    
    
    UserManager* manager = [UserManager shareUserManager];
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];
    
    THActivityView* fullView = [[THActivityView alloc]initViewOnWindow];
    [fullView loadViewAddOnWindow];
    
    __weak CommitOrderController* wself = self;
    OrderPayWay wway = _payWay;
    
    NetWorkRequest* req = [[NetWorkRequest alloc]init];
    [req commitOrderWithProducts:[managerData getShopCarArr] WithMessage:self.leaveMes?self.leaveMes:@"" WithPayWay:_payWay WithDiscount:_currentDiscount WithAddress:_address.addressID WithShopID:manager.shopID WithBk:^(id respond, NetWorkStatus error) {
        
        [fullView removeFromSuperview];
        [loadView removeFromSuperview];
        
        if(error==NetWorkErrorTokenInvalid)
        {
            return ;
        }
        
        if(error==NetWorkErrorCanntConnect)
        {
            THActivityView* warnView = [[THActivityView alloc]initWithString:(NSString *)respond];
            [warnView show];
            return;
        }
        
        if (wway==OrderPayInWx) {
            [wself performWeixinPayWithOrder:respond];
        }
        else if (wway==OrderPayInZfb)
        {
            [wself performZhifubaoPayWithOrder:respond];
        }
        else
        {
            [wself showOrderListViewContrller];
        }
    }];
    [req startAsynchronous];

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
    __weak CommitOrderController* wself = self;
    NSString* orderString = dic[@"payInfo"];
    
    [[AlipaySDK defaultService] payOrder: orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        
        if([resultDic[@"resultStatus"] intValue] != 9000)
        {
            THActivityView* showStr = [[THActivityView alloc]initWithString:resultDic[@"memo"]];
            [showStr show];
        }
        else
        {
            [wself showOrderListViewContrller];
        }
            NSLog(@"reslut = %@",resultDic);
    }];
    
}

#pragma mark-----------shopcarView---------------


-(void)creatShopCarView
{
    UIView* footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor whiteColor];
    footView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:footView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[footView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(footView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[footView(45)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table,footView)]];
    
    UIView* separater = [[UIView alloc]init];
    separater.backgroundColor = FUNCTCOLOR(210, 210, 210);
    separater.translatesAutoresizingMaskIntoConstraints = NO;
    [footView addSubview:separater];
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[separater]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separater)]];
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[separater(0.5)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separater)]];
    
    
//    _discountLabel = [[UILabel alloc]init];
//    _discountLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    [_discountLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
//
//    _discountLabel.textColor = DEFAULTGRAYCOLO;
//    _discountLabel.font = DEFAULTFONT(11);
//    [footView addSubview:_discountLabel];
//    
//    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[_discountLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_discountLabel)]];
//    
//    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_discountLabel(>=0)]-4-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_discountLabel)]];
   
    
    _moneyLabel = [[UILabel alloc]init];
    _moneyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _moneyLabel.textColor = DEFAULTNAVCOLOR;
    _moneyLabel.font = DEFAULTFONT(16);
    [footView addSubview:_moneyLabel];
    
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[_moneyLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_moneyLabel)]];
    [footView addConstraint:[NSLayoutConstraint constraintWithItem:_moneyLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:footView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    
//    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_moneyLabel]-6-[_discountLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_moneyLabel,_discountLabel)]];
    
    
    [self updateShopCar];
    
    _commitBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _commitBt.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSString* btTitle = nil;
    switch (_payWay) {
        case OrderPayInCash:
            btTitle = @"货到付款";
            break;
        case OrderPayInWx:
            btTitle = @"微信支付";
            break;
         case OrderPayInZfb:
            btTitle = @"支付宝支付";
            break;
        default:
            break;
    }
    
    [_commitBt setTitle:btTitle forState:UIControlStateNormal];
    [_commitBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_commitBt setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    _commitBt.titleLabel.font = DEFAULTFONT(15);

    [_commitBt setBackgroundImage:[UIImage imageNamed:@"button_back_red"] forState:UIControlStateNormal];
    [_commitBt setBackgroundImage:[UIImage imageNamed:@"shopcar_disable_bt"] forState:UIControlStateDisabled];
    
    [_commitBt addTarget:self action:@selector(commitOrderAction) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:_commitBt];
    
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_commitBt(>=100)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_commitBt)]];
    
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_commitBt]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_commitBt)]];
    
 
}

-(void)shopCarChangedWithData:(ShopProductData*)productData
{
    ShopCarShareData* shareData = [ShopCarShareData shareShopCarManager];
    [shareData addOrChangeShopWithProduct:productData];
    
    [self updateShopCar];
    [_table reloadData];
}

-(void)updateShopCar
{
    ShopCarShareData* shareData = [ShopCarShareData shareShopCarManager];
    
   float totalMoney = [shareData getTotalMoney];
    
    UserManager* manager = [UserManager shareUserManager];
    
//    if (_currentDiscount&&_payWay!=OrderPayInCash)
//    {
        float disountMoney = totalMoney-_currentDiscount.discountMoney;
        
        disountMoney = disountMoney>0?disountMoney:0.01;
        
        NSMutableAttributedString* att = [[NSMutableAttributedString alloc]initWithString:@"总计：" attributes:@{NSForegroundColorAttributeName:DEFAULTBLACK}];
        
        NSAttributedString* att1 = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%.2f",disountMoney] attributes:@{NSForegroundColorAttributeName:DEFAULTNAVCOLOR}];
        
        [att appendAttributedString:att1];
        _moneyLabel.attributedText = att;
        
    
    NSString* btTitle = nil;
    switch (_payWay)
    {
        case OrderPayInCash:
            btTitle = @"货到付款";
            break;
        case OrderPayInWx:
            btTitle = @"微信支付";
            break;
        case OrderPayInZfb:
            btTitle = @"支付宝支付";
            break;
        default:
            break;
    }
    _commitBt.enabled = YES;
    [_commitBt setTitle:btTitle forState:UIControlStateNormal];
}


#pragma mark-----------table---------------------



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1)
    {
        switch (_combinePays) {
                
            case AliPayCommit:
                return _payWay==OrderPayInCash?1:2;
                
            case Ali_WxPayCommit:
                return _payWay==OrderPayInCash?2:3;
                
            case Ali_CashPayCommit:
                return _payWay==OrderPayInCash?2:3;
                
            case Wx_CashPayCommit:
                return _payWay==OrderPayInCash?2:3;
                
            case CashPayCommit:
                return 1;
   
            case WxPayCommit:
                return _payWay==OrderPayInCash?1:2;
            default:
                break;
        }
        
        return _payWay==OrderPayInCash?3:4;
    }
    else if (section == 2)
    {
        ShopCarShareData* dataManager = [ShopCarShareData shareShopCarManager];
        return [dataManager getShopCarArr].count+3;
    }
    else
    {
        return 1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==2)
    {
        return 30;
    }
     return 45;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//     __weak CommitOrderController* wSelf = self;
    if (indexPath.section==0)
    {
        if (_address==nil)
        {
            ConfirmAddressOneCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmAddressOneCell"];
            cell.backgroundColor = FUNCTCOLOR(216, 228, 237);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UILabel* titleLabel = [cell getTitleLabel];
            titleLabel.font = DEFAULTFONT(15);
            titleLabel.text = @"添加地址";
            return cell;

        }
        else
        {
           ConfirmAddressCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmAddressCell"];
            cell.backgroundColor = FUNCTCOLOR(229, 228, 250);
            UILabel* titleL = [cell getTitleLabel];
            titleL.font = DEFAULTFONT(15);
            titleL.text = [NSString stringWithFormat:@"%@",_address.phoneNu];
            
            UILabel* content = [cell getDetailLabel];
            content.font = DEFAULTFONT(12);
            content.text = [NSString stringWithFormat:@"%@",_address.address];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
           return cell;
        }
        
    }
    else if (indexPath.section == 2)
    {
        ShopCarShareData* dataManager = [ShopCarShareData shareShopCarManager];
        NSArray* arr = [dataManager getShopCarArr];
        
        CommitPDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CommitPDetailCell"];
        
        if (arr.count == indexPath.row) {
            
           cell.textLabel.text = [NSString stringWithFormat:@"商品总价：¥%.1f",[dataManager  getTotalMoney]];
           cell.textLabel.textColor = FUNCTCOLOR(189, 189, 189);
        }
        else if (arr.count+1 == indexPath.row)
        {
           cell.textLabel.text = [NSString stringWithFormat:@"代金券：¥%.1f",_currentDiscount.discountMoney];
          cell.textLabel.textColor = DEFAULTNAVCOLOR;
           
        }
        else if (arr.count+2 == indexPath.row)
        {
            UserManager* uManager = [UserManager shareUserManager];
            cell.textLabel.text = [NSString stringWithFormat:@"配送费：¥%.1f",uManager.shop.minPrice];
            cell.textLabel.textColor = FUNCTCOLOR(189, 189, 189);
        }
        else
        {
            ShopProductData* pData = arr[indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"商品名称：%@ X%d",pData.pName,pData.count];
           cell.textLabel.textColor = FUNCTCOLOR(189, 189, 189);
        }
        return cell;
    
    }
    else
    {
        if (indexPath.row == _payArr.count-1 &&_combinePays!=CashPayCommit)
        {
            CommitDiscountCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CommitDiscountCell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell setLayout];

            UILabel*detailLabel = [cell getFirstLabel];
            
            if (_currentDiscount)
            {
                detailLabel.text = [NSString stringWithFormat:@"%@",_currentDiscount.discountTitle];
            }
            else
            {
               detailLabel.text = [NSString stringWithFormat:@"有%d张代金券未使用",(int)_discountArr.count];
            }
        
            return cell;
        }
        NSString* cellTitle = _payArr[indexPath.row];
        
        CustomSelectCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell5"];
        if (cell==nil) {
            cell = [[CustomSelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell5"];
            cell.textLabel.font = DEFAULTFONT(15);
            cell.textLabel.textColor = DEFAULTGRAYCOLO;
        }
        
        cell.textLabel.text = cellTitle;
        
        if (indexPath.row == _currentRow) {
           cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
           cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        [self showAddressView];
        
    }
    else if(indexPath.section==1)
    {
        NSString* btTitle = _payArr[indexPath.row];
        
        if ([btTitle isEqualToString: @"货到付款"]) {
            _payWay = OrderPayInCash;
        }
        else if ([btTitle isEqualToString: @"支付宝支付"])
        {
            _payWay = OrderPayInZfb;
        }
        else if([btTitle isEqualToString: @"微信支付"])
        {
            if ([WXApi isWXAppInstalled]==NO)
            {
               THActivityView* warn  = [[THActivityView alloc]initWithString:@"没有安装微信客户端"];
               [warn show];
               return;
            }
            _payWay = OrderPayInWx;
        }
        else
        {
           [self showDiscountView];
           return;
        }
        
        _currentRow = indexPath.row;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        
        [self updateShopCar];
        [_commitBt setTitle:btTitle forState:UIControlStateNormal];
    }
    else
    {
    
    
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1||section==2) {
        return 30;
    }
    return 10;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString* str ;
    if (section==1) {
        
       str =@"   支付方式";
    }
    else if (section==2)
    {
      str = @"   明细";
    }
    else
    {
        return nil;
    }
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
    title.textColor = DEFAULTBLACK;
    title.font = DEFAULTFONT(16);
    title.text = str;
    return title;
}


#pragma mark-----------------table select action------------------

-(void)requestDiscountData
{
    __weak CommitOrderController* wself = self;
    NetWorkRequest* req = [[NetWorkRequest alloc]init];
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];
    
    [req getValidDiscountTicketWithBk:^(id respond, NetWorkStatus status) {
        
        [loadView removeFromSuperview];
        if (status == NetWorkSuccess) {
            [wself reloadTableAfterGetDiscountData:respond];
        }
        else
        {
            THActivityView* warnView = [[THActivityView alloc]initWithString:respond];
            [warnView show];
        }
    }];
    [req startAsynchronous];
}

-(void)reloadTableAfterGetDiscountData:(NSArray*)arr
{
    _discountArr = arr;
    [_table reloadData];
}


-(void)showDiscountView
{
    if (_discountArr.count==0&&_discountArr) {
        return;
    }
    else if(_discountArr==nil)
    {
        [self requestDiscountData];
    }
    else
    {
        ShopCarShareData* managerData = [ShopCarShareData shareShopCarManager];
        UICustomActionView* actionView = [[UICustomActionView alloc]initWithTitle:@"选择代金券" WithDataArr:_discountArr];
        actionView.delegate = self;
        [actionView setMinPrice:[managerData getTotalMoney]];
        [actionView showPopView];
    }
}


-(void)actionViewSelectWithData:(DiscountData*)obj
{
    _currentDiscount = obj;
    [_table reloadData];
    [self updateShopCar];
}

#pragma mark------------------

-(void)showAddressView
{
    AddressViewController* addView = [[AddressViewController alloc]init];
    addView.delegate = self;
    [self.navigationController pushViewController:addView animated:YES];
}

#pragma mark-------------------address delegate--------------------

-(void)selectAddressOverWithAddress:(AddressData *)data
{
    _address = data;
    [_table reloadData];
}

#pragma mark---------orderList----------------


-(void)showOrderListViewContrller
{
    OrderListController* orderList = [[OrderListController alloc]init];
    
    [self.navigationController pushViewController:orderList animated:YES];
    orderList.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:orderList action:@selector(backToRoot)];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PSHOPCARCLEAN object:nil];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
