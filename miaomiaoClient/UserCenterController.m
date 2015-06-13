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

@interface UserCenterController()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIActionSheetDelegate>
{
    UITableView* _table;
}
@end
@implementation UserCenterController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人中心";
    _table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    [self.view addSubview:_table];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorColor = FUNCTCOLOR(229, 229, 229);
    _table.backgroundColor = FUNCTCOLOR(243, 243, 243);
    if ([_table respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [_table setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        
    }
    
    if ([_table respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [_table setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        
    }

    
    
    _table.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    
    UIBarButtonItem* rightBar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"userCenter_set"] style:UIBarButtonItemStyleDone target:self action:@selector(showSettingViewController)];
    self.navigationItem.rightBarButtonItem = rightBar;

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
        cell.textLabel.textColor = DEFAULTGRAYCOLO;
        cell.textLabel.font = DEFAULTFONT(16);
    }
    
    NSString* text = nil;
    NSString* imageStr = nil;
    if (indexPath.section==0) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (indexPath.row)
        {
            case 0:
               
                text = [[UserManager shareUserManager] getUserAccount];
                imageStr = @"userCenter_user";
                
                break;
                
            case 1:
                text = @"我的订单";
                imageStr = @"userCenter_Order";
                break;
            case 2:
                text = @"我的代金券";
                imageStr = @"userCenter_discount";
                break;
            case 3:
                text = @"我的收货地址";
                imageStr = @"userCenter_address";
                break;
  
            default:
                text = @"";
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
    if (indexPath.section==0)
    {
        switch (indexPath.row) {
            case 0:
                [self showActionLogOutView];
                break;
                
            case 1:
                [self showOrderListView];
                break;
            case 2:
                [self showDiscountView];
               
                break;
            case 3:
                 [self showAddressView];
                break;

            default:
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


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
    
}


#pragma mark---------------------action-----------------

-(void)showSettingViewController
{
    SettingViewController* setView = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:setView animated:YES];
}


-(void)showOrderListView
{
    OrderListController* orderList = [[OrderListController alloc]init];
    [self.navigationController pushViewController:orderList animated:YES];
}


-(void)showDiscountView
{
    DiscountController* discountView = [[DiscountController alloc]init];
    [self.navigationController pushViewController:discountView animated:YES];
}

-(void)showAddressView
{
    AddressViewController* address = [[AddressViewController alloc]init];
    [self.navigationController pushViewController:address animated:YES];
}

-(void)showSuggestView
{
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SuggestViewController* suggestView = [story instantiateViewControllerWithIdentifier:@"SuggestViewController"];
    [self.navigationController pushViewController:suggestView animated:YES];

}


#pragma mark------------delegate--------------------


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==alertView.cancelButtonIndex) {
        return;
    }

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-881-6807"]];
}

-(void)showActionLogOutView
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"提示"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"退出登陆"
                                  otherButtonTitles:nil,nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.cancelButtonIndex == buttonIndex) {
        return;
    }
    [self userLogout];
}

-(void)userLogout
{
    __weak UserCenterController* wself = self;
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];
    UserManager* manager = [UserManager shareUserManager];
    [manager removeUserAccountWithBk:^(BOOL success) {
        [loadView removeFromSuperview];
        if (success) {
            [wself.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            THActivityView* show = [[THActivityView alloc]initWithString:@"退出失败！"];
            [show show];
        }
    }];
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
