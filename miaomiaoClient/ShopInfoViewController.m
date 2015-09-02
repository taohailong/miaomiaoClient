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
#import "NetWorkRequest.h"
#import "CommentData.h"
#import "THActivityView.h"
#import "LastViewOnTable.h"
#import "ShopInfoCommentCell.h"
#import "OneLabelTableHeadView.h"
@interface ShopInfoViewController()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView* _table;
    NSMutableArray* _dataArr;
}
@end

@implementation ShopInfoViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"店铺详情";
    
    _dataArr = [[NSMutableArray alloc]init];
    
    _table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_table setAllowsSelection:NO];
    _table.backgroundColor = FUNCTCOLOR(243, 243, 243);
    [_table registerClass:[ShopDetailCell class] forCellReuseIdentifier:@"ShopDetailCell"];
    [_table registerClass:[ShopInfoCommentCell class] forCellReuseIdentifier:@"ShopInfoCommentCell"];
    [_table registerClass:[ShopHeadCell class] forCellReuseIdentifier:@"ShopHeadCell"];
    
    [_table registerClass:[OneLabelTableHeadView class] forHeaderFooterViewReuseIdentifier:@"OneLabelTableHeadView"];
    _table.separatorColor = FUNCTCOLOR(221, 221, 221);
    _table.translatesAutoresizingMaskIntoConstraints = NO;
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    
    
    UIButton* phoneBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneBt setImage:[UIImage imageNamed:@"shopInfo_phone"] forState:UIControlStateNormal];
    phoneBt.frame = CGRectMake(0, 0, 30, 40);
    [phoneBt addTarget:self action:@selector(makeTelphone) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* rightBar1 = [[UIBarButtonItem alloc]initWithCustomView:phoneBt];
    
    
    
    UIButton* favoriteBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [favoriteBt setImage:[UIImage imageNamed:@"selectShop_favorite"] forState:UIControlStateNormal];
    [favoriteBt setImage:[UIImage imageNamed:@"selectShop_nofavorite"] forState:UIControlStateSelected];
    favoriteBt.frame = CGRectMake(0, 0, 20, 40);
    [favoriteBt addTarget:self action:@selector(favoriteAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* rightBar2 = [[UIBarButtonItem alloc]initWithCustomView:favoriteBt];

    
    self.navigationItem.rightBarButtonItems = @[rightBar2,rightBar1];
    
    [self getShopCommentData];

}

-(void)getShopCommentData
{
    __weak ShopInfoViewController* wself = self;
    NetWorkRequest* req = [[NetWorkRequest alloc]init];
    [req getShopCommentFromIndex:_dataArr.count completeBlock:^(id respond, NetWorkStatus status) {
        if (status == NetWorkSuccess) {
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
    [_dataArr addObjectsFromArray:arr];
    [_table reloadData];
    [self addLoadMoreViewWithCount:arr.count];
}


-(void)addLoadMoreViewWithCount:(int)count
{
    if (count<20) {
        _table.tableFooterView = [[UIView alloc]init];
    }
    else
    {
        _table.tableFooterView = [[LastViewOnTable alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    }
}


#pragma mark-Table

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_dataArr.count!=0) {
        return 3;
    }
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return _dataArr.count;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
      CommentData* comment = _dataArr[indexPath.row];
      CGSize size = [comment calculateStringHeightWithFont:DEFAULTFONT(12) WithSize:CGSizeMake(SCREENWIDTH-30, 10000)];
        return 60+size.height;
    }
    
    if (indexPath.section == 0) {
        return 120;
    }
    return 146;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
       OneLabelTableHeadView* head = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"OneLabelTableHeadView"];
        UILabel* title = [head getFirstLabel];
        title.text = @"用户评价";
        title.font = DEFAULTFONT(16);
        title.textColor = FUNCTCOLOR(102, 102, 102);
        return head;
    }
    return nil;
}




-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 25;
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section

{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 2) {
        ShopInfoCommentCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ShopInfoCommentCell"];
        CommentData* comment = _dataArr[indexPath.row];
        [cell setScore:comment.score];
        [cell setTelphone:comment.telphone];
        [cell setTime:comment.creatTime];
        [cell setCommentText:comment.comments];
        return cell;
    }
    
    if (indexPath.section==0) {
        
        UserManager* manager = [UserManager shareUserManager];
        ShopHeadCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ShopHeadCell"];
        [cell setLayout];
        [cell setCommentScore:manager.shop.score];
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
        [cell setSecondLStr:[NSString stringWithFormat:@"%@",[manager.shop getBusinessHours]]];
        [cell setThirdLStr:[NSString stringWithFormat:@"%.1f",manager.shop.minPrice]];
        [cell setFourthLStr:[NSString stringWithFormat:@"%.1f",manager.shop.deliverCharge]];
        [cell setFifthLStr:manager.shop.telPhoneNu];
        return cell;
    }

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
        [self getShopCommentData];
    }
    
}


-(void)favoriteAction
{
    UserManager* manager = [UserManager shareUserManager];
    
    UIBarButtonItem* favorite = self.navigationItem.rightBarButtonItems[0];
    UIButton* favoriteBt = (UIButton*)favorite.customView;
    if (favoriteBt.selected == YES) {
        [self cancelFavoriteShop:manager.shop];
    }
    else
    {
       [self setFavoriteShop:manager.shop];
    }
    favoriteBt.selected = !favoriteBt.selected;
}


#pragma mark-Favorite

-(void)setFavoriteShop:(ShopInfoData*)shop
{
    UIBarButtonItem* favorite = self.navigationItem.rightBarButtonItems[0];
    __weak UIButton* favoriteBt = (UIButton*)favorite.customView;
    NetWorkRequest* req = [[NetWorkRequest alloc]init];
    [req setFavoriteShop:shop withCompleteBk:^(id respond, NetWorkStatus status) {
        if (status == NetWorkSuccess) {
            favoriteBt.selected = YES;
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
    UIBarButtonItem* favorite = self.navigationItem.rightBarButtonItems[1];
    __weak UIButton* favoriteBt = (UIButton*)favorite.customView;

    NetWorkRequest* req = [[NetWorkRequest alloc]init];
    [req cancelFavoriteShop:shop withCompleteBk:^(id respond, NetWorkStatus status) {
        if (status == NetWorkSuccess) {
            favoriteBt.selected = NO;
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


-(void)makeTelphone
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"联系商家" message:@"是否拨打商铺电话" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
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
