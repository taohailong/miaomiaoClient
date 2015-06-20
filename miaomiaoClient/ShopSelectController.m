//
//  ShopSelectController.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-13.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "ShopSelectController.h"
#import "NetWorkRequest.h"
#import "THActivityView.h"
#import "ShopTableHeadView.h"
#import "SelectShopCell.h"
#import "ShopInfoData.h"
#import "UserManager.h"

@interface ShopSelectController()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UITableView* _table;
    NSMutableArray* _dataArr;
    int * flag;
    UILabel* locationLabel;
    UISearchBar* _search;
}
@end
@implementation ShopSelectController
@synthesize delegate;

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"切换店铺";
    
    _table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
//    _table.backgroundColor = DEFAULTNAVCOLOR;
    [self.view addSubview:_table];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorColor = [UIColor clearColor];
    _table.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (IOS_VERSION(7.0))
    {
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_table]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
       
    }
    else
    {
       [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_table]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    }
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_table attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];

    [self creatSearchBar];
    [self startLocation];
    [self registeNotificationCenter];
}


#pragma mark----------keyboard-----------------

-(void)registeNotificationCenter
{
    /*注册成功后  重新链接服务器*/
    
    NSNotificationCenter *def = [NSNotificationCenter defaultCenter];
    
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
    [self accessViewAnimate:0.0];
}

-(void)accessViewAnimate:(float)height
{
    [UIView animateWithDuration:.28 delay:0 options:0 animations:^{
        
        for (NSLayoutConstraint * constranint in self.view.constraints)
        {
            if (constranint.firstItem==_table&&constranint.firstAttribute==NSLayoutAttributeBottom) {
                constranint.constant = height;
            }
        }
        
    } completion:^(BOOL finished) {
        
    }];
}




#pragma mark--------searchBar ---delegate-----------------



-(void)creatSearchBar
{
    UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 80)];
    
    _search = [[UISearchBar alloc]init];
    _search.translatesAutoresizingMaskIntoConstraints = NO;
    _search.delegate = self;
    _search.placeholder = @"搜索商铺";
    [backView addSubview:_search];
    
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_search]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_search)]];
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_search(45)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_search)]];

    
    UIButton* locationBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:locationBt];
//    locationBt.backgroundColor = [UIColor blackColor];
    [locationBt setTitleColor:DEFAULTNAVCOLOR forState:UIControlStateNormal];
    locationBt.titleLabel.font = DEFAULTFONT(15);
    [locationBt addTarget:self action:@selector(startLocation) forControlEvents:UIControlEventTouchUpInside];
    locationBt.translatesAutoresizingMaskIntoConstraints = NO;
    [locationBt setTitle:@"重新定位" forState:UIControlStateNormal];
    [locationBt setImage:[UIImage imageNamed:@"selectShop_location"] forState:UIControlStateNormal];
    [locationBt setTitleEdgeInsets:UIEdgeInsetsMake(0, -38, 0, 0)];
    [locationBt setImageEdgeInsets:UIEdgeInsetsMake(0, 60, 0, 0)];
    
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[locationBt]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(locationBt)]];
    
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_search]-[locationBt(35)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_search,locationBt)]];

    
    
    locationLabel = [[UILabel alloc]init];
    locationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    locationLabel.textColor = FUNCTCOLOR(102, 102, 102);
    locationLabel.font = DEFAULTFONT(15);
    [backView addSubview:locationLabel];
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[locationLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(locationLabel)]];
    
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_search]-[locationLabel(35)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_search,locationLabel)]];
    
    _table.tableHeaderView = backView;
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    [searchBar setShowsCancelButton:YES animated:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:65/255.0 green:159/255.0 blue:252/255.0 alpha:0.5]];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [searchBar resignFirstResponder];
        [searchBar setShowsCancelButton:NO animated:YES];
         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self searchThroughNetWithCharacter:searchBar.text withSearch:searchBar];
    }
    
}

#pragma mark-------------------table--------------------



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (flag[section])//为1时展开
    {
        NSDictionary* dic = _dataArr[section];
        NSArray* arr = dic[@"shops"];
        return arr.count;
    }
    
    return 0 ;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 68;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    ShopTableHeadView* headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"head"];

    NSDictionary* dic = _dataArr[section];
    NSArray* shopArr = dic[@"shops"];
    if (headView==nil)
    {
         headView = [[ShopTableHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 68)];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headViewTap:)];
        [headView addGestureRecognizer:tap];

    }
  
    headView.tag = section;
    headView.titleLabel.text = dic[@"name"];
    headView.detailLabel.text = dic[@"address"];
    
    if (shopArr.count) {
        headView.countLabel.text = [NSString stringWithFormat:@"%ld家店",(unsigned long)shopArr.count];
        headView.countLabel.hidden = NO;
    }
    else
    {
        headView.countLabel.hidden = YES;
    }
    headView.distanceLabel.text = dic[@"distance"];
    return headView;
 
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* str  = @"ids";
   SelectShopCell* cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:str];
    if (cell==nil) {
        cell = [[SelectShopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    NSDictionary* dic = _dataArr[indexPath.section];
    NSArray* arr = dic[@"shops"];
    ShopInfoData* shop = arr[indexPath.row];
    
    UILabel* statusL = [cell getStatusLabel];
    statusL.text = shop.shopStatue==ShopClose?@"打烊":@"营业中";
    cell.titleLabel.text = [NSString stringWithFormat:@"● %@",shop.shopName];
    cell.secondLabel.text = [NSString stringWithFormat:@"早%@－晚%@ ",shop.openTime,shop.closeTime];
    cell.thirdLabel.text = [NSString stringWithFormat:@"%.1f元起送",shop.minPrice];
    cell.fourthLabel.text = shop.shopAddress;
    
    return cell;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(shopSelectOverWithShopID:)])
    {
        NSDictionary* dic = _dataArr[indexPath.section];
        NSArray* arr = dic[@"shops"];
        
        ShopInfoData* shop = arr[indexPath.row];
        if (shop.shopStatue == ShopClose) {
            
            THActivityView* showStr = [[THActivityView alloc]initWithString:@"该店铺已打烊！"];
            [showStr show];
            return;
        }
        [self.delegate shopSelectOverWithShopID:shop];
        [self controllerDismiss];
    }
}


#pragma mark----------------location----------------



-(void)searchThroughNetWithCharacter:(NSString*)character withSearch:(UISearchBar*)searchBar
{
    __weak UISearchBar* wsearch = searchBar;
    __weak ShopSelectController* wself = self;
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];
    
    NetWorkRequest* req = [[NetWorkRequest alloc]init];
    [req seachShopWithCharacter:character WithBk:^(NSMutableArray* respond, NetWorkStatus status) {
        
        [wsearch setShowsCancelButton:NO animated:YES];
        [wsearch resignFirstResponder];
        [loadView removeFromSuperview];
        if (status==NetWorkSuccess) {
            [wself receiveData:respond];
        }
        
    }];
    
    [req startAsynchronous];
}


-(void)getShopThroughLatitude:(float)latitude Withlongitude:(float)longitude
{
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];
    
    __weak ShopSelectController* wself = self;
    NetWorkRequest* req = [[NetWorkRequest alloc]init];
    [req throughLocationGetShopWithlatitude:latitude WithLong:longitude WithBk:^(NSMutableArray* respond, NetWorkStatus error) {
        
        [loadView removeFromSuperview];
        
        if (error != NetWorkSuccess)
        {
            THActivityView* loadView = [[THActivityView alloc]initWithNetErrorWithSuperView:wself.view];
            
            [loadView setErrorBk:^{
                [wself getShopThroughLatitude:latitude Withlongitude:longitude];
            }];
            return ;
        }
        if (respond) {
            [wself receiveData:respond];
        }
        
    }];
    [req startAsynchronous];
}

-(void)receiveData:(NSMutableArray*)arr
{
    if (arr.count) {
        NSDictionary* dic = arr[0];
        locationLabel.text = dic[@"distance"];
    }
    else
    {
        locationLabel.text = @"周围没有商铺,请搜索商铺!";
        return;
    }
    _dataArr = arr;
    if (flag) {
        free(flag);
    }
    flag = calloc(sizeof(int),_dataArr.count );
    [_table reloadData];
}




-(void)headViewTap:(UIGestureRecognizer*)gesture
{
    NSDictionary* dic = _dataArr[gesture.view.tag];
    NSArray* arr = dic[@"shops"];
    if (arr.count==1)
    {
        if ([self.delegate respondsToSelector:@selector(shopSelectOverWithShopID:)]) {
            
            ShopInfoData* shop = arr[0];
            
            if (shop.shopStatue == ShopClose) {
                
                THActivityView* showStr = [[THActivityView alloc]initWithString:@"该店铺已打烊！"];
                [showStr show];
                
                return;
            }

            [self.delegate shopSelectOverWithShopID:shop];
            [self controllerDismiss];
        }
        return;
    }
    else if(arr.count==0)
    {
        UIAlertView* warnView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"小喵正在努力覆盖您选择的小区,敬请期待哦！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [warnView show];
        return;
    }
    flag[gesture.view.tag] = !flag[gesture.view.tag];
    [_table reloadData];
}

-(void)startLocation
{
    __weak ShopSelectController* wself = self;
    __weak UILabel* wLabel  = locationLabel;
    UserManager* manager = [UserManager shareUserManager];
    [manager startLocationWithBk:^(BOOL success, float longitude, float latitude) {
        if (success) {
            [wself getShopThroughLatitude:latitude Withlongitude:longitude];
        }
        else
        {
//#if DEBUG
#if 0
            longitude = 116.416989;
            latitude = 40.082632;
            [wself getShopThroughLatitude:latitude Withlongitude:longitude];
#endif            
           wLabel.text = @"定位失败，请搜索商铺!";
        }
    }];
    
    
}



#pragma mark-------------dissView---------

-(void)controllerDismiss
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }

}


-(void)dealloc
{
    free(flag);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
