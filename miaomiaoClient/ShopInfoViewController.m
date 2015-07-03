//
//  ShopInfoViewController.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/7/2.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "ShopInfoViewController.h"
#import "ShopHeadCell.h"
#import "ShopDetailCell.h"
#import "UserManager.h"
@interface ShopInfoViewController()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView* _table;
}
@end

@implementation ShopInfoViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"店铺详情";
    _table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_table registerClass:[ShopDetailCell class] forCellReuseIdentifier:@"ShopDetailCell"];
    
    [_table registerClass:[ShopHeadCell class] forCellReuseIdentifier:@"ShopHeadCell"];
    _table.separatorColor = [UIColor clearColor];
    _table.translatesAutoresizingMaskIntoConstraints = NO;
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    
    UIBarButtonItem* rightBar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"shopInfo_phone"] style:UIBarButtonItemStylePlain target:self action:@selector(makeTelphone)];
    self.navigationItem.rightBarButtonItem = rightBar;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 120;
    }
    return 146;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section

{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        UserManager* manager = [UserManager shareUserManager];
        ShopHeadCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ShopHeadCell"];
        [cell setLayout];
        UILabel* f = [cell getFirstLabel];
        f.text = manager.shop.shopName;
        
        UILabel* fouth = [cell getFourthLabel];
        fouth.text = [NSString stringWithFormat:@"¥%.1f",manager.shop.minPrice];
        
        UILabel* fifth = [cell getFifthLabel];
        fifth.text = [NSString stringWithFormat:@"¥%.1f",manager.shop.deliverCharge];;
        return cell;
    }

    else
    {
        UserManager* manager = [UserManager shareUserManager];
        ShopDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailCell"];
        [cell setFirstLStr:manager.shop.shopAddress];
        [cell setSecondLStr:[NSString stringWithFormat:@"%@-%@",[manager.shop getOpenTime],[manager.shop getCloseTime]]];
        [cell setThirdLStr:[NSString stringWithFormat:@"%.1f",manager.shop.minPrice]];
        [cell setFourthLStr:[NSString stringWithFormat:@"%.1f",manager.shop.minPrice]];
        [cell setFifthLStr:manager.shop.telPhoneNu];
        return cell;
    }

}


-(void)makeTelphone
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"联系商家" message:@"是否拨打电话" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==alertView.cancelButtonIndex) {
        return;
    }
    UserManager* manager = [UserManager shareUserManager];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",manager.shop.telPhoneNu]]];
}


@end
