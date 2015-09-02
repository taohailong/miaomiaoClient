//
//  FavoriteController.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/9/1.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "FavoriteController.h"
#import "SelectShopCell.h"
#import "ShopInfoData.h"
@implementation FavoriteController
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    _table = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorColor = FUNCTCOLOR(221, 221, 221);
    _table.backgroundColor = FUNCTCOLOR(243, 243, 243);
    [_table registerClass:[SelectShopCell class] forCellReuseIdentifier:@"SelectShopCell"];
    _table.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_table];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    [self getDataThroughNet];
}

-(void)getDataThroughNet
{
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];
    
    __weak FavoriteController* wself = self;
    NetWorkRequest* req = [[NetWorkRequest alloc]init];
    [req getFavoriteList:^(id respond, NetWorkStatus status) {
        
        [loadView removeFromSuperview];
        if (status==NetWorkSuccess) {
            [wself parseData:respond];
        }
        else if (status == NetWorkErrorTokenInvalid)
        {
        }
        else
        {
            THActivityView* warn = [[THActivityView alloc]initWithString:respond];
            [warn show];
        }
    }];
    [req startAsynchronous];
}

-(void)parseData:(NSMutableArray*)arr
{
    if(arr.count==0)
    {
        THActivityView* warnView = [[THActivityView alloc]initEmptyDataWarnViewWithString:@"您还没有收藏店铺" WithImage:@"favorite_noData" WithSuperView:self.view];
        warnView.tag = 0;
        return;
    }
    _dataArr = arr;
    [_table reloadData];
}

#pragma mark-tableView


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopInfoData* shop = _dataArr[indexPath.section];
    if ([shop onlyOneLine]) {
        return 120;
    }
    else
    {
        return 147;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectShopCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SelectShopCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ShopInfoData* shop = _dataArr[indexPath.section];
    
    UILabel* statusL = [cell getStatusLabel];
    if (shop.shopStatue == ShopClose) {
        statusL.hidden = NO;
        statusL.text = @"已打烊";
    }
    else
    {
        statusL.hidden = YES;
    }
    __weak FavoriteController* wself = self;
    __weak ShopInfoData* wdata = shop;
    [cell setFavoriteBk:^{
        if (wdata.favorite==YES) {
            [wself cancelFavoriteShop:wdata];
        }
        else
        {
            [wself setFavoriteShop:wdata];
        }
    }];
    [cell setFavorite:shop.favorite];
    cell.titleLabel.text = shop.shopName;
    [cell setScore:shop.score];
    
    UIImageView* contentImage1 = [cell getFirstImageView];
    contentImage1.image = [UIImage imageNamed:@"selectShop_time"];
    
    UIImageView* contentImage2 = [cell getSecondImageView];
    contentImage2.image = [UIImage imageNamed:@"selectShop_minPrice"];
    
    
    UIImageView* contentImage3 = [cell getThirdImageView];
    contentImage3.image = nil;
    
    cell.secondLabel.text = [NSString stringWithFormat:@"%@－%@",[shop getOpenTime],[shop getCloseTime]];
    cell.thirdLabel.text = [NSString stringWithFormat:@"%.1f元起送",shop.minPrice];
//    [cell setFifthLabelStr:] ;
    cell.fourthLabel.text = shop.shopAddress;
    [cell setServerArr:[shop getServerArr] withSizeDic:[shop getServerSizeDic]];
    return cell;
    
}


#pragma mark-Favorite

-(void)setFavoriteShop:(ShopInfoData*)shop
{
    __weak UITableView* wtable = _table;
    NetWorkRequest* req = [[NetWorkRequest alloc]init];
    [req setFavoriteShop:shop withCompleteBk:^(id respond, NetWorkStatus status) {
        if (status == NetWorkSuccess) {
            shop.favorite = YES;
            [wtable reloadData];
        }
        else if (NetWorkErrorTokenInvalid == status)
        {
        }
        else
        {
            THActivityView* warnView = [[THActivityView alloc]initWithString:respond];
            [warnView show];
        }
    }];
    [req startAsynchronous];
}

-(void)cancelFavoriteShop:(ShopInfoData*)shop
{
    __weak UITableView* wtable = _table;
    __weak NSMutableArray*warr = _dataArr;
    NetWorkRequest* req = [[NetWorkRequest alloc]init];
    [req cancelFavoriteShop:shop withCompleteBk:^(id respond, NetWorkStatus status) {
        if (status == NetWorkSuccess) {
//            shop.favorite = NO;
            [warr removeObject:shop];
            [wtable reloadData];
        }
        else if (NetWorkErrorTokenInvalid == status)
        {
        }
        else
        {
            THActivityView* warnView = [[THActivityView alloc]initWithString:respond];
            [warnView show];
        }
    }];
    [req startAsynchronous];
}

@end
