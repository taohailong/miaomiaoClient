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

#import "NetWorkRequest.h"

#import "WXApi.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@interface CommitOrderController ()<UITableViewDataSource,UITableViewDelegate,AddressSelectProtocol,CustomActionProtocol>
{
    UILabel* _moneyLabel;
    UIButton* _commitBt;
    UILabel* _discountLabel;
    
    int _currentRow;
    CommitPayMethod _combinePays;
    NSArray* _payArr;
    __weak UITextField* _respondField;
    NSDictionary* _addressDic;
    UITableView* _table;
    NSMutableArray* _productArr;
    float _totalMoney;
    AddressData* _address;
    OrderPayWay _payWay;
    NSArray* _discountArr;
    __weak DiscountData* _currentDiscount;
    
}
@property(nonatomic,strong)NSString* leaveMes;
@end
@implementation CommitOrderController
@synthesize leaveMes;
-(id)initWithProductArr:(NSMutableArray *)productArr WithTotalMoney:(float)money
{
    self = [super init];
    
    _productArr = productArr;
    _totalMoney = money;
    
    UserManager* user = [UserManager shareUserManager];
//    [self setPayWayMethod:user.combinPay];
    [self setPayWayMethod:All_payCommit];
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
            _payArr = @[@"支付宝",@"微信支付",@"货到付款",@""];
            _payWay = OrderPayInZfb;
            break;
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"订单";
    self.view.backgroundColor = [UIColor whiteColor];
//    _payWay = OrderPayInZfb;
    
    _table = [[UITableView alloc]initWithFrame:self.view.bounds    style:UITableViewStyleGrouped];
    [self.view addSubview:_table];
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
    
    [def addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    
    /* 注册键盘的显示/隐藏事件 */
    [def addObserver:self selector:@selector(keyboardShown:)
                name:UIKeyboardWillShowNotification
											   object:nil];
    
    
    [def addObserver:self selector:@selector(keyboardHidden:)name:UIKeyboardWillHideNotification
											   object:nil];
    
}

- (void)keyboardShown:(NSNotification *)aNotification
{
    
    NSDictionary *info = [aNotification userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGSize keyboardSize = [aValue CGRectValue].size;
    [self accessViewAnimate:-keyboardSize.height];
    
}

- (void)keyboardHidden:(NSNotification *)aNotification
{
    [self accessViewAnimate:-45.0];
}

-(void)accessViewAnimate:(float)height
{
    [UIView animateWithDuration:.2 delay:0 options:0 animations:^{
        
        for (NSLayoutConstraint * constranint in self.view.constraints)
        {
            if (constranint.firstItem==_table&&constranint.firstAttribute==NSLayoutAttributeBottom) {
                constranint.constant = height;
            }
        }
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)textFieldChanged:(NSNotification*)noti
{
    _respondField = (UITextField*)noti.object;
}



-(void)getAddress
{
    __weak CommitOrderController* wself = self;
    NetWorkRequest* req = [[NetWorkRequest alloc]init];
    [req getAddressWithBk:^(NSArray* respond, NetWorkStatus err) {
      
        if (err == NetWorkErrorCanntConnect) {
            THActivityView* loadView = [[THActivityView alloc]initWithNetErrorWithSuperView:wself.view];
            
            [loadView setErrorBk:^{
                [wself getAddress];
            }];
            return ;
        }
        
        if (err == NetWorkErrorTokenInvalid) {
            return;
        }
        
        if (respond.count) {
            _address = respond[0];
        }
        
        [_table reloadData];
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
    UserManager* manager = [UserManager shareUserManager];
    if (manager.shop.minPrice>_totalMoney) {
        THActivityView* warnView = [[THActivityView alloc]initWithString:@"总价低于起送价格！"];
        [warnView show];
        return;
    }
    
    if (_currentDiscount.minMoney>_totalMoney) {
        THActivityView* warnView = [[THActivityView alloc]initWithString:@"代金券不可用！"];
        [warnView show];
        return;
    }
    
    
    
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];
    
    THActivityView* fullView = [[THActivityView alloc]initViewOnWindow];
    [fullView loadViewAddOnWindow];
    
    __weak CommitOrderController* wself = self;
    OrderPayWay wway = _payWay;
    
    NetWorkRequest* req = [[NetWorkRequest alloc]init];
    [req commitOrderWithProducts:_productArr WithMessage:self.leaveMes?self.leaveMes:@"" WithPayWay:_payWay WithDiscount:_currentDiscount WithAddress:_address.addressID WithShopID:manager.shopID WithBk:^(id respond, NetWorkStatus error) {
        
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
    
    
    _discountLabel = [[UILabel alloc]init];
    _discountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_discountLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

    _discountLabel.textColor = DEFAULTGRAYCOLO;
    _discountLabel.font = DEFAULTFONT(11);
    [footView addSubview:_discountLabel];
    
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[_discountLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_discountLabel)]];
    
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_discountLabel(>=0)]-4-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_discountLabel)]];
   
    
    _moneyLabel = [[UILabel alloc]init];
    _moneyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _moneyLabel.textColor = DEFAULTNAVCOLOR;
    _moneyLabel.font = DEFAULTFONT(16);
    [footView addSubview:_moneyLabel];
    
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[_moneyLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_moneyLabel)]];
    
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_moneyLabel]-6-[_discountLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_moneyLabel,_discountLabel)]];
    _moneyLabel.text = [NSString stringWithFormat:@"总计：¥%.2f",_totalMoney];

    
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
    [_commitBt setTitleColor:DEFAULTNAVCOLOR forState:UIControlStateDisabled];
    _commitBt.titleLabel.font = DEFAULTFONT(15);
//    _commitBt.backgroundColor = DEFAULTNAVCOLOR;
    [_commitBt setBackgroundImage:[UIImage imageNamed:@"button_back_red"] forState:UIControlStateNormal];
    [_commitBt setBackgroundImage:[UIImage imageNamed:@"button_back_white"] forState:UIControlStateDisabled];
    
    _commitBt.layer.cornerRadius = 4;
    _commitBt.layer.masksToBounds = YES;
    _commitBt.layer.borderWidth = 1;
    _commitBt.layer.borderColor = DEFAULTNAVCOLOR.CGColor;
    [_commitBt addTarget:self action:@selector(commitOrderAction) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:_commitBt];
    
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_commitBt(>=100)]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_commitBt)]];
    
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_commitBt(30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_commitBt)]];
    [footView addConstraint:[NSLayoutConstraint constraintWithItem:_commitBt attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:footView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
 
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
    
    _totalMoney = [shareData getTotalMoney];
    
    UserManager* manager = [UserManager shareUserManager];
    
    if (_currentDiscount&&_payWay!=OrderPayInCash)
    {
        float disountMoney = _totalMoney-_currentDiscount.discountMoney;
        
        disountMoney = disountMoney>0?disountMoney:0.01;
        _moneyLabel.text = [NSString stringWithFormat:@"总计：¥%.2f",disountMoney];
        
        _discountLabel.attributedText = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%.2f",_totalMoney] attributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
    }
    else
    {
        _discountLabel.attributedText = [[NSAttributedString alloc]initWithString:@""];
        _moneyLabel.text = [NSString stringWithFormat:@"总计：¥%.2f",_totalMoney];
    }
    
    NSString* btTitle = nil;
    if (_totalMoney < manager.shop.minPrice)
    {
        btTitle = [NSString stringWithFormat:@"还差%.2f元起送", manager.shop.minPrice-_totalMoney];
        _commitBt.enabled = NO;
    }
    else
    {
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
    }
     [_commitBt setTitle:btTitle forState:UIControlStateNormal];
}


#pragma mark-----------table---------------------



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==4)
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
    else if (section==2)
    {
      return _productArr.count;
    }
    
    else
    {
        return 1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==2)
    {
        return 70;
    }
     return 45;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     __weak CommitOrderController* wSelf = self;
    if (indexPath.section==0)
    {
       
        if (_address==nil)
        {
            ConfirmAddressOneCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
            if (cell==nil) {
                cell = [[ConfirmAddressOneCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell0"];
            }
             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UILabel* titleLabel = [cell getTitleLabel];
            titleLabel.font = DEFAULTFONT(15);
            titleLabel.text = @"添加地址";
            return cell;

        }
        else
        {
           ConfirmAddressCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell001"];
            if (cell==nil) {
                cell = [[ConfirmAddressCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell001"];
            }
            
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
    else if (indexPath.section==1)
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (cell==nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        NSMutableAttributedString* strAttribute = [[NSMutableAttributedString alloc]initWithString:@"配送时间：30分钟送达"  attributes:@{NSForegroundColorAttributeName:DEFAULTBLACK}];
        [strAttribute addAttribute:NSFontAttributeName  value:DEFAULTFONT(15) range:NSMakeRange(0, 5)];
        
        [strAttribute addAttribute:NSFontAttributeName  value:DEFAULTFONT(14) range:NSMakeRange(5, 6)];
        cell.textLabel.attributedText = strAttribute ;
        return cell;
    }

    else if (indexPath.section==2)
    {
        ProductCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (cell==nil) {
            cell = [[ProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        ShopProductData* data = _productArr[indexPath.row];
        __weak ShopProductData* wData = data;
       
        
        [cell setCountText:data.count];
        [cell setCountBk:^(BOOL isAdd, int count) {
            
            wData.count = count;
            [wSelf shopCarChangedWithData:wData];
        }];
        
        [cell setPriceStr:[NSString stringWithFormat:@"%.2f", data.price]];
        [cell setTitleStr:data.pName];
        [cell setPicUrl:data.pUrl];
        return cell;
    }
    else if (indexPath.section==3)
    {
        CommitFillCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (cell==nil) {
            cell = [[CommitFillCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3" WithFieldBk:^(NSString *text) {
                wSelf.leaveMes = text;
            }];
            UITextField* text = [cell getTextFieldView];
            text.placeholder = @"给卖家留言";
        }
        return cell;
    }
    else
    {
        if (indexPath.row == _payArr.count-1 &&_combinePays!=CashPayCommit)
        {
            CommitDiscountCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell6"];
            if (cell==nil)
            {
                cell = [[CommitDiscountCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell6"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell setLayout];
            }
            UILabel*detailLabel = [cell getFirstLabel];
            
            if (_currentDiscount)
            {
                detailLabel.text = [NSString stringWithFormat:@"%@元",_currentDiscount.discountTitle];
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
    [_respondField resignFirstResponder];
    
    if (indexPath.section==0) {
        [self showAddressView];
    }
    else if (indexPath.section==3)
    {
    
    }
    else if(indexPath.section==4)
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
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:UITableViewRowAnimationNone];
        
        [self updateShopCar];
        UserManager* manager = [UserManager shareUserManager];
        if (_totalMoney < manager.shop.minPrice) {
            return;
        }

        [_commitBt setTitle:btTitle forState:UIControlStateNormal];
        
    }
}

//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section==2) {
//        return @"商品信息";
//    }
//    else if (section==4)
//    {
//       return @"付款方式";
//    }
//
//    return nil;
//}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==2||section==4) {
        return 10;
    }
    return .5;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==2||section==4) {
        return 30;
    }
    else if (section==3)
    {
        return 2;
    }
    return 10;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
    title.textColor = DEFAULTBLACK;
    title.font = DEFAULTFONT(16);
    if (section==2) {
        
       title.text =@"   商品信息";
    }
    else if (section==4)
    {
      title.text = @"   付款方式";
    }
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
        UICustomActionView* actionView = [[UICustomActionView alloc]initWithTitle:@"选择代金券" WithDataArr:_discountArr];
        actionView.delegate = self;
        [actionView setMinPrice:_totalMoney];
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
