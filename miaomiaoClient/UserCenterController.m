//
//  UserCenterController.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-15.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "UserCenterController.h"
#import "OrderListController.h"
#import "AddressViewController.h"
#import "SuggestViewController.h"
#import "SettingViewController.h"
#import "WXApi.h"
#import "DiscountController.h"
#import "UserManager.h"
#import "THActivityView.h"
#import "SpreadViewController.h"
#import "LogViewController.h"
#import "CommentListController.h"
#import "FavoriteController.h"

@interface UserCenterController()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView* _table;
    UILabel* detailL;
    UIButton* logBt;
}
@end
@implementation UserCenterController

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self setNavigationBarAttribute:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    UserManager* user = [UserManager shareUserManager];
    if ([user isLogin]) {
        
        [logBt setTitle:[user getUserAccount] forState:UIControlStateNormal];
        logBt.enabled = NO;
        detailL.text = @"";
    }
    else
    {
        logBt.enabled = YES;
        [logBt setTitle:@"点击登陆" forState:UIControlStateNormal];
        detailL.text = @"登录下单更多惊喜";
    }
     [self setNavigationBarAttribute:YES];
   
}

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
        color = DEFAULTBLACK;
        [self.navigationController.navigationBar setTintColor:color];
        
        color = FUNCTCOLOR(64, 64, 64);
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    NSDictionary * dict = @{NSForegroundColorAttributeName:color,NSFontAttributeName:DEFAULTFONT(18)};
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
}



-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatHeadView];
    
    
    _table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    [self.view addSubview:_table];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorColor = FUNCTCOLOR(229, 229, 229);
    _table.backgroundColor = FUNCTCOLOR(243, 243, 243);

    _table.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-220-[_table]-49-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    
    UIBarButtonItem* rightBar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"userCenter_set"] style:UIBarButtonItemStyleDone target:self action:@selector(showSettingViewController)];
    self.navigationItem.rightBarButtonItem = rightBar;

}


-(void)creatHeadView
{
    UIView* redView = [[UIView alloc]init];
    redView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:redView];
    redView.backgroundColor = DEFAULTNAVCOLOR;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[redView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(redView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[redView(140)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(redView)]];
  
    
    UILabel*  titleL = [[UILabel alloc]init];
    titleL.translatesAutoresizingMaskIntoConstraints = NO;
    titleL.font = DEFAULTFONT(18);
    [redView addSubview:titleL];
    titleL.textColor = [UIColor whiteColor];
    titleL.text = @"我的";
    [redView addConstraint:[NSLayoutConstraint constraintWithItem:titleL attribute:NSLayoutAttributeCenterX  relatedBy:NSLayoutRelationEqual toItem:redView attribute:NSLayoutAttributeCenterX  multiplier:1.0 constant:0]];
    
    [redView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[titleL]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleL)]];

    UIButton* setBt = [UIButton buttonWithType:UIButtonTypeCustom];
    setBt.translatesAutoresizingMaskIntoConstraints = NO;
    [setBt setImage:[UIImage imageNamed:@"userCenter_set"] forState:UIControlStateNormal];
    [redView addSubview:setBt];
    [setBt addTarget:self action:@selector(showSettingViewController) forControlEvents:UIControlEventTouchUpInside];
    [redView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[setBt]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(setBt)]];
    [redView addConstraint:[NSLayoutConstraint constraintWithItem:setBt attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:titleL attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    
    UIImageView* userIcon = [[UIImageView alloc]init];
    userIcon.translatesAutoresizingMaskIntoConstraints = NO;
    [redView addSubview:userIcon];
    userIcon.image = [UIImage imageNamed:@"user_userIcon"];
    [redView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[userIcon]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(userIcon)]];
    [redView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[userIcon]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(userIcon)]];
    
    logBt = [UIButton buttonWithType:UIButtonTypeCustom];
    logBt.titleLabel.font = DEFAULTFONT(15);
    logBt.translatesAutoresizingMaskIntoConstraints = NO;
    [redView addSubview:logBt];
    [logBt addTarget:self action:@selector(logBtAction) forControlEvents:UIControlEventTouchUpInside];
    [redView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[userIcon]-10-[logBt]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(userIcon,logBt)]];
    [redView addConstraint:[NSLayoutConstraint constraintWithItem:userIcon attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:logBt attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
//    [redView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[logBt]-6-[detailL]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(logBt,detailL)]];

    
    
    
    
    UIButton* orderBt = [UIButton buttonWithType:UIButtonTypeCustom];
    orderBt.titleLabel.font = DEFAULTFONT(16);
    orderBt.translatesAutoresizingMaskIntoConstraints = NO;
    [orderBt addTarget:self action:@selector(showOrderListView) forControlEvents:UIControlEventTouchUpInside];
    [orderBt setTitleColor:DEFAULTBLACK forState:UIControlStateNormal];
    [self.view addSubview:orderBt];
    [orderBt setImage:[UIImage imageNamed:@"userCenter_Order"]
                forState:UIControlStateNormal];
    
    [orderBt setTitleEdgeInsets:UIEdgeInsetsMake(40, -31, -6, 0)];
    [orderBt setImageEdgeInsets:UIEdgeInsetsMake(0, 18, 24, 0)];
    
    [orderBt setTitle:@"全部订单" forState:UIControlStateNormal];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[redView]-10-[orderBt(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(redView,orderBt)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[orderBt(90)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(orderBt)]];

   [self.view addConstraint:[NSLayoutConstraint constraintWithItem:orderBt attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:0.5 constant:0]];
    
    
    UIButton* discountBt = [UIButton buttonWithType:UIButtonTypeCustom];
    discountBt.titleLabel.font = DEFAULTFONT(16);
    discountBt.translatesAutoresizingMaskIntoConstraints = NO;
    [discountBt setTitleColor:DEFAULTBLACK forState:UIControlStateNormal];
    [self.view addSubview:discountBt];
    [discountBt addTarget:self action:@selector(showDiscountView) forControlEvents:UIControlEventTouchUpInside];
    [discountBt setTitle:@"我的优惠券" forState:UIControlStateNormal];
    [discountBt setImage:[UIImage imageNamed:@"userCenter_discount"]
       forState:UIControlStateNormal];
    
    [discountBt setTitleEdgeInsets:UIEdgeInsetsMake(40, -31, -6, 0)];
    [discountBt setImageEdgeInsets:UIEdgeInsetsMake(0, 18, 24, 0)];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[redView]-10-[discountBt(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(redView,discountBt)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[discountBt(90)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(discountBt)]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:discountBt attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.5 constant:0]];
    
    UIView* separateView = [[UIView alloc]init];
    separateView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:separateView];
    separateView.backgroundColor  = FUNCTCOLOR(221, 221, 221);
     [self.view addConstraint:[NSLayoutConstraint constraintWithItem:separateView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[separateView(0.5)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separateView)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[redView]-15-[separateView(50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(redView,separateView)]];
    
    UIView* horizontalSe = [[UIView alloc]init];
    horizontalSe.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:horizontalSe];
    horizontalSe.backgroundColor  = FUNCTCOLOR(229, 229, 229);
//    horizontalSe.backgroundColor  = [UIColor redColor];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[horizontalSe]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(horizontalSe)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-219.5-[horizontalSe(0.5)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(horizontalSe)]];
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 12;
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .5;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 4;
    }
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* str = @"str";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.textLabel.textColor = DEFAULTBLACK;
        cell.textLabel.font = DEFAULTFONT(16);
    }
    
    NSString* text = nil;
    NSString* imageStr = nil;
    if (indexPath.section==0) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (indexPath.row)
        {
            case 0:
                text = @"我的收货地址";
                imageStr = @"userCenter_address";
                break;
                
            case 1:
                text = @"推荐码";
                imageStr = @"userCenter_spread";

                break;
            case 2:
                text = @"我的评论";
                imageStr = @"userCenter_comment";
                break;
                
            case 3:
                text = @"我的店铺";
                imageStr = @"userCenter_favorite";

                break;
        }
    }
    else
    {
        if (indexPath.row==0)
        {
            text = @"意见反馈";
            imageStr = @"userCenter_suggest";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
        {
            text = @"联系客服：400-881-6807";
            imageStr = @"userCenter_phone";
        }
    }
    
    cell.imageView.image = [UIImage imageNamed:imageStr];
    cell.textLabel.text = text;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UserManager* manager = [UserManager shareUserManager];
    UserCenterController* wSelf = self;
    if (indexPath.section==0)
    {
        switch (indexPath.row) {
            case 0:
                if ([manager isLogin] == NO)
                {
                    [self showLogView:^{
                      [wSelf showAddressView];
                    }];
                }
                else
                {
                    [self showAddressView];
                }
                break;
            case 1:
                
                if ([manager isLogin] == NO)
                {
                    [self showLogView:^{
                        [wSelf showSpeardViewController];
                    }];
                }
                else
                {
                    [self showSpeardViewController];
                }
                break;
            case 2:
                
                if ([manager isLogin] == NO)
                {
                    [self showLogView:^{
                        [wSelf showCommentViewController];
                    }];
                }
                else
                {
                    [self showCommentViewController];
                }
                break;
            case 3:
                
                if ([manager isLogin] == NO)
                {
                    [self showLogView:^{
                        [wSelf showFavoriteController];
                    }];
                }
                else
                {
                    [self showFavoriteController];
                }
     
                break;
        }
        
    }
    else if (indexPath.row==0)
    {
        [self showSuggestView];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"联系客服" message:@"是否拨打喵喵客服电话：400-881-6807？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}


#pragma mark---------------------action-----------------


-(void)showCommentViewController
{
    CommentListController* comment= [[CommentListController alloc]init];
    comment.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:comment animated:YES];
}


-(void)showSettingViewController
{
    UserManager* manager = [UserManager shareUserManager];
    
    if ([manager isLogin] == NO) {
        UserCenterController* wSelf = self;
        [self showLogView:^{
            SettingViewController* setView = [[SettingViewController alloc]init];
            setView.hidesBottomBarWhenPushed = YES;
            [wSelf.navigationController pushViewController:setView animated:YES];
        }];
        return;
    }

    SettingViewController* setView = [[SettingViewController alloc]init];
    setView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setView animated:YES];
}


-(void)showOrderListView
{
    UserManager* manager = [UserManager shareUserManager];
    
    if ([manager isLogin] == NO) {
        UserCenterController* wSelf = self;
        [self showLogView:^{
            OrderListController* orderList = [[OrderListController alloc]init];
            orderList.hidesBottomBarWhenPushed = YES;
            [wSelf.navigationController pushViewController:orderList animated:YES];
        }];
        return;
    }

    
    OrderListController* orderList = [[OrderListController alloc]init];
    orderList.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderList animated:YES];
}


-(void)showDiscountView
{
    UserManager* manager = [UserManager shareUserManager];
    
    if ([manager isLogin] == NO) {
        UserCenterController* wSelf = self;
        [self showLogView:^{
            DiscountController* discountView = [[DiscountController alloc]init];
            discountView.hidesBottomBarWhenPushed = YES;
            [wSelf.navigationController pushViewController:discountView animated:YES];
        }];
        return;
    }
    
    DiscountController* discountView = [[DiscountController alloc]init];
    discountView.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:discountView animated:YES];
}

-(void)showAddressView
{
    AddressViewController* address = [[AddressViewController alloc]init];
    address.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:address animated:YES];
}

-(void)showSuggestView
{
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SuggestViewController* suggestView = [story instantiateViewControllerWithIdentifier:@"SuggestViewController"];
    suggestView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:suggestView animated:YES];
}

-(void)showSpeardViewController
{
    SpreadViewController* showSpreadView = [[SpreadViewController alloc]init];
    showSpreadView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:showSpreadView animated:YES];
}


-(void)showFavoriteController
{
    FavoriteController* favorite = [[FavoriteController alloc]init];
    favorite.hidesBottomBarWhenPushed = YES;
    favorite.title = @"我的店铺";
    [self.navigationController pushViewController:favorite animated:YES];
}

#pragma mark------------delegate--------------------


-(void)logBtAction
{
//    LogViewController* log = [self.storyboard instantiateViewControllerWithIdentifier:@"LogViewController"];
    LogViewController* log = [[LogViewController alloc]init];
    log.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:log animated:YES];
}


-(void)showLogView:(void(^)(void))block
{
    LogViewController* log = [[LogViewController alloc]init];
    log.hidesBottomBarWhenPushed = YES;
    [log setLogResturnBk:^(BOOL success) {
        
        if (success) {
            block();
        }
    }];
    [self.navigationController pushViewController:log animated:YES];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==alertView.cancelButtonIndex) {
        return;
    }

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-881-6807"]];
}


//-(void)wxShare
//{
//    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
//    req.text = @"人文的东西并不是体现在你看得到的方面，它更多的体现在你看不到的那些方面，它会影响每一个功能，这才是最本质的。但是，对这点可能很多人没有思考过，以为人文的东西就是我们搞一个很小清新的图片什么的。”综合来看，人文的东西其实是贯穿整个产品的脉络，或者说是它的灵魂所在。";
//    req.bText = YES;
//    req.scene = WXSceneTimeline;
//    [WXApi sendReq:req];
//
//}


@end
