//
//  ShopCarViewController.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/7/2.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "ShopCarViewController.h"
#import "ProductCell.h"
#import "ShopProductData.h"
#import "CommitFillCell.h"
#import "ShopCarShareData.h"
#import "UserManager.h"
#import "THActivityView.h"
#import "CommitOrderController.h"
#import "LogViewController.h"
@interface ShopCarViewController()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel* _moneyLabel;
    NSMutableArray* _productArr;
    UITableView* _table;
    __weak UITextField* _respondField;
    __weak THActivityView* _emptyView;
    UIButton* commitBt;
}
@end
@implementation ShopCarViewController
@synthesize leaveMes;

-(void)setNavigationBarAttribute:(BOOL)flag
{
    UIColor * color = nil;
    if (flag)
    {
        color = [UIColor whiteColor];
        [self.navigationController.navigationBar setTintColor:color];
        [self.navigationController.navigationBar setBarTintColor:FUNCTCOLOR(254, 87, 84)];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    else
    {
        if (self.navigationController.viewControllers.count == 1) {
            return;
        }
        color = FUNCTCOLOR(64, 64, 64);
        [self.navigationController.navigationBar setTintColor:color];
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    NSDictionary * dict = @{NSForegroundColorAttributeName:color,NSFontAttributeName:DEFAULTFONT(18)};
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
}


-(void)viewWillAppear:(BOOL)animated
{
    [self setNavigationBarAttribute:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self setNavigationBarAttribute:NO];
}


-(void)viewDidAppear:(BOOL)animated
{
    [self updateShopCar];
    [_table reloadData];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"购物车";
    self.view.backgroundColor = [UIColor whiteColor];
    

//    UIToolbar
    [self creatShopCarView];
    [self registeNotificationCenter];
//    NSLog(@"rect is %@",self.navigationController.tabBarController.tabBarItem.v);
//    CGRect frame = [self.navigationController.tabBarController.view convertRect:self.navigationController.tabBarController.view.frame fromView:self.navigationController.tabBarController.tabBarItem];
    
//    self.tabBarItem
}


#pragma mark-TabBar


-(void)goShoppingAction
{
    self.tabBarController.selectedIndex = 0;
}


#pragma mark-----------shopcarView---------------


-(void)creatShopCarView
{
    UIView* footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor whiteColor];
    footView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:footView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[footView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(footView)]];
    
    id bottom = self.bottomLayoutGuide;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[footView(50)]-0-[bottom]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(footView,bottom)]];
    
    UIView* separater = [[UIView alloc]init];
    separater.backgroundColor = FUNCTCOLOR(210, 210, 210);
    separater.translatesAutoresizingMaskIntoConstraints = NO;
    [footView addSubview:separater];
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[separater]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separater)]];
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[separater(0.5)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separater)]];
    
    _moneyLabel = [[UILabel alloc]init];
    _moneyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _moneyLabel.textColor = DEFAULTNAVCOLOR;
    _moneyLabel.font = DEFAULTFONT(16);
    [footView addSubview:_moneyLabel];
    
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[_moneyLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_moneyLabel)]];
    
    [footView addConstraint:[NSLayoutConstraint constraintWithItem:_moneyLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:footView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    
    
    commitBt = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBt.translatesAutoresizingMaskIntoConstraints = NO;
    
    [commitBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitBt setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    commitBt.titleLabel.font = DEFAULTFONT(15);
    [commitBt setBackgroundImage:[UIImage imageNamed:@"button_back_red"] forState:UIControlStateNormal];
    [commitBt setBackgroundImage:[UIImage imageNamed:@"shopcar_disable_bt"] forState:UIControlStateDisabled];

    
    [commitBt addTarget:self action:@selector(showCommitViewController) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:commitBt];
    
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[commitBt(>=100)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(commitBt)]];
    
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[commitBt]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(commitBt)]];
    [footView addConstraint:[NSLayoutConstraint constraintWithItem:commitBt attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:footView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    
    _table = [[UITableView alloc]initWithFrame:self.view.bounds    style:UITableViewStyleGrouped];
    [self.view addSubview:_table];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorColor = FUNCTCOLOR(229, 229, 229);
    _table.backgroundColor = FUNCTCOLOR(243, 243, 243);
    _table.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_table attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_table attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:footView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];

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
    __weak ShopCarViewController* wSelf = self;
    if([shareData getCarCount] == 0&&_emptyView==nil)
    {
        THActivityView* warnView = [[THActivityView alloc]initEmptyDataWarnViewWithString:@"购物车为空哦，快去逛逛吧" WithImage:@"shopCar_emptyImage" WithSuperView:self.view];
        [warnView addBtWithTitle:@"去下单" WithBk:^{
             [wSelf goShoppingAction];
        }];
        _emptyView = warnView;
        return;
    }
    else if (_emptyView!=nil&&[shareData getCarCount] != 0)
    {
        [_emptyView removeFromSuperview];
    }
    
    
    float totalMoney = [shareData getTotalMoney];
    NSMutableAttributedString* att = [[NSMutableAttributedString alloc]initWithString:@"总计：" attributes:@{NSForegroundColorAttributeName:DEFAULTBLACK}];
    
    NSAttributedString* att1 = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%.2f",totalMoney] attributes:@{NSForegroundColorAttributeName:DEFAULTNAVCOLOR}];
    
    [att appendAttributedString:att1];
    _moneyLabel.attributedText = att;
    
    UserManager* manager = [UserManager shareUserManager];
    float flag = manager.shop.minPrice - totalMoney ;
    if (flag<=0)
    {
        commitBt.enabled = YES;
        [commitBt setTitle:@"去结算" forState:UIControlStateNormal];
    }
    else
    {
        commitBt.enabled = NO;
        [commitBt setTitle:[NSString stringWithFormat:@"还差¥%.1f",flag] forState:UIControlStateNormal];
    }
    
}

-(void)showLogContoller
{
    __weak ShopCarViewController* wself = self;
    LogViewController* log = [self.storyboard instantiateViewControllerWithIdentifier:@"LogViewController"];
    [log setLogResturnBk:^(BOOL success) {
        
        CommitOrderController* readyOrder = [[CommitOrderController alloc]init];
        readyOrder.leaveMes = self.leaveMes;
        readyOrder.hidesBottomBarWhenPushed = YES;
        [wself.navigationController pushViewController:readyOrder animated:YES];
    }];
    log.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:log animated:YES];

}


-(void)showCommitViewController
{
    UserManager* manager = [UserManager shareUserManager];
    
    ShopCarShareData* shareData = [ShopCarShareData shareShopCarManager];
    float totalMoney = [shareData getTotalMoney];
    if (manager.shop.minPrice>totalMoney) {
        THActivityView* warnView = [[THActivityView alloc]initWithString:@"总价低于起送价格！"];
        [warnView show];
        return;
    }
    
    if ([manager isLogin] == NO) {
        [self showLogContoller];
        return;
    }
    
    
    CommitOrderController* readyOrder = [[CommitOrderController alloc]init];
    readyOrder.leaveMes = self.leaveMes;
    readyOrder.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:readyOrder animated:YES];
}

#pragma mark-tableview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1)
    {
        ShopCarShareData* share = [ShopCarShareData shareShopCarManager];
        return [share getShopCarArr].count;
    }
   return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1)
    {
        return 70;
    }
    return 45;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak ShopCarViewController* wSelf = self;
  
    if (indexPath.section==0)
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (cell==nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UserManager* manager = [UserManager shareUserManager];
        
        NSMutableAttributedString* strAttribute = [[NSMutableAttributedString alloc]initWithString:@"配送时间："  attributes:@{NSForegroundColorAttributeName:DEFAULTBLACK,NSFontAttributeName:DEFAULTFONT(15)}];
        NSString* str = nil;
        
        if (manager.shop.shopStatue == ShopClose) {
             str =  [NSString stringWithFormat:@"明日%@前送达",[manager.shop getOpenTimeAddThirtyMins]];
        }
        else
        {
           str = @"30分钟送达";
        }
        NSAttributedString* att = [[NSAttributedString alloc]initWithString:str attributes:@{NSFontAttributeName:DEFAULTFONT(14),NSForegroundColorAttributeName:DEFAULTNAVCOLOR}];
        
        [strAttribute appendAttributedString:att];
        cell.textLabel.attributedText = strAttribute ;
        return cell;
    }
    
    else if (indexPath.section==1)
    {
        ProductCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (cell==nil) {
            cell = [[ProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        ShopCarShareData* manager = [ShopCarShareData shareShopCarManager];
        NSArray* pArr = [manager getShopCarArr];
        ShopProductData* data = pArr[indexPath.row];
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
    else
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
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==2||section==4) {
        return 10;
    }
    return .5;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return 30;
    }
    return 10;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
    title.textColor = DEFAULTBLACK;
    title.font = DEFAULTFONT(16);
    if (section==1) {
        
        title.text =@"   商品信息";
    }
    return title;
}

#pragma mark- textField


-(void)registeNotificationCenter
{
    /*注册成功后  重新链接服务器*/
    NSNotificationCenter *def = [NSNotificationCenter defaultCenter];
    
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
    [self accessViewAnimate:-keyboardSize.height+110];
}

- (void)keyboardHidden:(NSNotification *)aNotification
{
    [self accessViewAnimate:0.0];
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


@end
