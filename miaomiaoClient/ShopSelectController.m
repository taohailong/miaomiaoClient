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
#import "ShopSearchHeadView.h"
#import "DataBase.h"
#import "ShopSelectAreaCell.h"
typedef enum _TableResultType
{
   TableSearchBegin,
   TableSearchProceed,
   TableNormal
}TableResultType;

@interface ShopSelectController()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UITableView* _table;
//    NSMutableArray* _dataArr;
    NSMutableArray* _areaArr;
    NSArray* _searchArr;
    
//    int * flag;
//    UILabel* locationLabel;
    UISearchBar* _search;
    NSMutableArray* _bestArr;
    UISearchDisplayController* searchController;
    NSMutableArray* _nearArr;
    NSString* _area;
    TableResultType _isSearch;
    THActivityView* _emptyWarn;
    UIView* _footView;
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
    [_table registerClass:[ShopTableHeadView class] forHeaderFooterViewReuseIdentifier:@"ShopTableHeadView"];
    
    [_table registerClass:[ShopSearchHeadView class] forHeaderFooterViewReuseIdentifier:@"ShopSearchHeadView"];
    [_table registerClass:[ShopSelectAreaCell class] forCellReuseIdentifier:@"ShopSelectAreaCell"];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorColor = FUNCTCOLOR(210, 210, 210);
    _table.translatesAutoresizingMaskIntoConstraints = NO;
    _table.backgroundColor = FUNCTCOLOR(243, 243, 243);
    [self.view addSubview:_table];

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
    [self creatTableFootView];
    [self setTableSearchType:TableNormal];
}

-(void)setTableSearchType:(TableResultType)type
{
    if (type == TableNormal) {
        _table.tableFooterView = _footView;
    }
    else
    {
        _table.tableFooterView = nil;
    }
    _isSearch = type;
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

-(void)creatTableFootView
{
    NSArray* strArr = [self getAllSearchShops];
    
    if (strArr.count == 0) {
        return;
    }

    _footView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0)];
    
    _footView.backgroundColor = [UIColor whiteColor];

    CGRect frame = CGRectMake(15, 8, 0, 20);
    
    for (ShopBase* sub in strArr)
    {
       CGSize size = [sub.shopName sizeWithAttributes:@{NSFontAttributeName:DEFAULTFONT(14)}];
       size.width += 10;
       if (size.width + frame.origin.x +15 >SCREENWIDTH)
       {
          frame.origin.y += 25;
          frame.origin.x = 15;
       }
        frame.size.width = size.width;
        
        UIButton* bt = [UIButton buttonWithType:UIButtonTypeCustom];
         bt.tag = [sub.shopID integerValue];
        bt.frame = frame;
        [bt addTarget:self action:@selector(toHistoryShop:) forControlEvents:UIControlEventTouchUpInside];
        bt.titleLabel.font = DEFAULTFONT(14);
        [bt setTitleColor:FUNCTCOLOR(255, 255, 255) forState:UIControlStateNormal];
        [bt setTitle:sub.shopName forState:UIControlStateNormal];
        [bt setBackgroundColor:FUNCTCOLOR(221, 221, 221)];
        
        [bt setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_footView addSubview:bt];
        frame.origin.x += size.width +15;
        bt.layer.masksToBounds = YES;
        bt.layer.cornerRadius = 4;
            }
    _footView.frame = CGRectMake(0, 0, SCREENWIDTH, frame.origin.y+frame.size.height+5);
   
}

-(void)toHistoryShop:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(shopSelectOverWithShopID:)])
    {
        ShopInfoData* shop = [[ShopInfoData alloc]init];
        shop.shopID = [NSString stringWithFormat:@"%ld",(long)button.tag];
        [self.delegate shopSelectOverWithShopID:shop];
        [self controllerDismiss];
    }
}


#pragma mark--------searchBar ---delegate-----------------

-(void)creatSearchBar
{
//    UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 105)];
//    backView.backgroundColor = [UIColor whiteColor];
    
    _search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 45)];
//    _search.translatesAutoresizingMaskIntoConstraints = NO;
    _search.delegate = self;
    _search.placeholder = @"搜索小区";
    _search.tintColor = DEFAULTNAVCOLOR;
    _table.tableHeaderView = _search;
    
//    [backView addSubview:_search];
//    
//    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_search]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_search)]];
//    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_search(45)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_search)]];
//
//    
//    
//    UIView* separateV =  [[UIView alloc]init];
//    separateV.translatesAutoresizingMaskIntoConstraints = NO;
//    [backView addSubview:separateV];
//    separateV.backgroundColor = FUNCTCOLOR(228, 228, 228);
//    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[separateV]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separateV)]];
//    
//    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_search]-[separateV(10)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_search,separateV)]];
//    
//
//    
//    
//    
//    
//    UIButton* locationBt = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backView addSubview:locationBt];
//    
//    [locationBt setTitleColor:DEFAULTNAVCOLOR forState:UIControlStateNormal];
//    locationBt.titleLabel.font = DEFAULTFONT(15);
//    [locationBt addTarget:self action:@selector(startLocation) forControlEvents:UIControlEventTouchUpInside];
//    locationBt.translatesAutoresizingMaskIntoConstraints = NO;
//    [locationBt setTitle:@"重新定位" forState:UIControlStateNormal];
//    [locationBt setImage:[UIImage imageNamed:@"selectShop_location"] forState:UIControlStateNormal];
//    [locationBt setTitleEdgeInsets:UIEdgeInsetsMake(0, -38, 0, 0)];
//    [locationBt setImageEdgeInsets:UIEdgeInsetsMake(0, 60, 0, 0)];
//    
//    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[locationBt]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(locationBt)]];
//    
//    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[separateV]-3-[locationBt(35)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separateV,locationBt)]];
//
//    
//    
//    
//    
//    locationLabel = [[UILabel alloc]init];
//    locationLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    locationLabel.textColor = FUNCTCOLOR(102, 102, 102);
//    locationLabel.font = DEFAULTFONT(15);
//    [backView addSubview:locationLabel];
//    
//    
//    [backView addConstraint:[NSLayoutConstraint constraintWithItem:locationLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:locationBt attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
//    
//    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[locationLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(locationLabel)]];
//
//    
//    
//    UIView* bottom = [[UIView alloc]init];
//    bottom.translatesAutoresizingMaskIntoConstraints = NO;
//    [backView addSubview:bottom];
//    bottom.backgroundColor = FUNCTCOLOR(228, 228, 228);
//    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottom]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bottom)]];
//    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottom(10)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bottom)]];
//    _table.tableHeaderView = backView;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
   NSLog(@"test %@ %@",searchText,searchBar.text);
    if (searchBar.text.length) {
        [self searchThroughNetWithCharacter:searchBar.text];
    }
}



-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [searchBar setShowsCancelButton:YES animated:YES];
    
    
//    [_areaArr removeAllObjects];
    [self setTableSearchType:TableSearchBegin];
    
    [_emptyWarn removeFromSuperview];
    _emptyWarn = nil;
    
    if (searchBar.text.length) {
        [self searchThroughNetWithCharacter:searchBar.text];
    }
    else
    {
        [_table reloadData];
    }

}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self setTableSearchType:TableNormal];
//    _isSearch = 0;
    [_table reloadData];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
//    _isSearch = -1;
    if (searchBar.text.length) {
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [searchBar resignFirstResponder];
        [searchBar setShowsCancelButton:NO animated:YES];

        [self searchThroughNetWithCharacter:searchBar.text withSearch:searchBar];
    }
    
}

#pragma mark-------------------table--------------------

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isSearch == TableSearchBegin) {
        return 1;
    }
    else if (_isSearch == TableSearchProceed)
    {
        return 2;
    }
    else
    {
        return _footView==nil?3:4;
    }
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_isSearch != TableSearchBegin&&section ==0) {
        return 50;
    }
    
    return 35;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_isSearch ==TableSearchBegin) {
        
        ShopTableHeadView* headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ShopTableHeadView"];
        headView.titleLabel.text = @"选择您所在的位置";
        return headView;
    }
    else
    {
        if (section == 0)
        {
            __weak ShopSelectController* wself = self;
            ShopSearchHeadView* headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ShopSearchHeadView"];
            [headView setSearchBk:^{
                [wself startLocation];
            }];
            [headView setTitleStr:_area];
            return headView;
        }
        else if (section == 1) {
            
            ShopTableHeadView* headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ShopTableHeadView"];
            headView.titleLabel.text = @"最优店铺";
            return headView;
        }
        else if (section == 2)
        {
            ShopTableHeadView* headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ShopTableHeadView"];
            headView.titleLabel.text = @"附近店铺";
            return headView;
        }
        else
        {
            ShopTableHeadView* headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ShopTableHeadView"];
            headView.titleLabel
            .text = @"历史店铺";
            return headView;
        }
    }
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isSearch == TableSearchBegin) {
        return _areaArr.count;
    }
    else if (_isSearch == TableSearchProceed)
    {
        if (section == 0)
        {
            return 0;
        }
        else
        {
            return _searchArr.count;
        }
    }
    else
    {
        if (section ==1)
        {
             return _bestArr.count;
        }
        else if (section == 2)
        {
             return _nearArr.count;
        }
        else
        {
            return 0;
        }
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isSearch == TableSearchBegin) {
        return 60;
    }
    
    ShopInfoData* shop = nil;
    if (_isSearch == TableNormal)
    {
        if (indexPath.section ==1) {
            shop = _bestArr[indexPath.row];
        }
        else
        {
            shop = _nearArr[indexPath.row];
        }
    }
    else
    {
        shop = _searchArr [indexPath.row];
    }
    
    if ([shop onlyOneLine]) {
        return 120;
    }
    else
    {
        return 145;
    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isSearch == TableSearchBegin) {
        ShopInfoData* shop = _areaArr[indexPath.row];
        ShopSelectAreaCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ShopSelectAreaCell"];
        [cell setTitleStr:shop.shopName];
        [cell setDetailStr:shop.shopAddress] ;
        return cell;
    }
    
    
    NSString* str  = @"ids";
    SelectShopCell* cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:str];
    if (cell==nil) {
        cell = [[SelectShopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
   
    ShopInfoData* shop = nil;
    
    if (_isSearch == TableNormal)
    {
        if (indexPath.section ==1) {
            shop = _bestArr[indexPath.row];
        }
        else
        {
            shop = _nearArr[indexPath.row];
        }
    }
    else
    {
        shop = _searchArr[indexPath.row];
    }
 
    UILabel* statusL = [cell getStatusLabel];
    if (shop.shopStatue == ShopClose) {
        statusL.hidden = NO;
        statusL.text = @"已打烊";
    }
    else
    {
        statusL.hidden = YES;
    }
   
    cell.titleLabel.text = shop.shopName;
    
    cell.secondLabel.text = [NSString stringWithFormat:@"距离：%dm",shop.distance];
    cell.thirdLabel.text = [NSString stringWithFormat:@"%@－%@",[shop getOpenTime],[shop getCloseTime]];
    [cell setFifthLabelStr:[NSString stringWithFormat:@"%.1f元起送",shop.minPrice]] ;
    cell.fourthLabel.text = shop.shopAddress;
    [cell setServerArr:[shop getServerArr] withSizeDic:[shop getServerSizeDic]];
    return cell;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isSearch == TableSearchBegin) {
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [_search setShowsCancelButton:NO animated:YES];
        [_search resignFirstResponder];

        ShopInfoData* shop = _areaArr[indexPath.row];
        [self searchShopWithAddress:shop];
        return;
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(shopSelectOverWithShopID:)])
    {
        NSArray* arr = nil;
        
        if (_isSearch == TableSearchProceed) {
            arr = _searchArr;
        }
        else  if (indexPath.section == 1) {
            arr = _bestArr;
        }
        else
        {
            arr = _nearArr;
        }
        ShopInfoData* shop = arr[indexPath.row];
        
        [self insertShopToDataBase:shop];
        [self.delegate shopSelectOverWithShopID:shop];
        [self controllerDismiss];
    }
}

#pragma mark-DataBase

-(void)insertShopToDataBase:(ShopInfoData*)shop
{
    DataBase* dataBase = [DataBase shareDataBase];
    [dataBase insertShopWithID:shop.shopID shopName:shop.shopName];
}

-(NSArray*)getAllSearchShops
{
    DataBase* dataBase = [DataBase shareDataBase];
    return [dataBase getAllShops];
}


#pragma mark----------------location----------------

-(void)startLocation
{
    [_emptyWarn removeFromSuperview];
    _emptyWarn = nil;
    
    __weak ShopSelectController* wself = self;
    UserManager* manager = [UserManager shareUserManager];
    [manager startLocationWithBk:^(BOOL success, float longitude, float latitude) {
        if (success) {
            [wself getShopThroughLatitude:latitude Withlongitude:longitude];
        }
    }];
}




#pragma mark-NetApi--

-(void)searchShopWithAddress:(ShopInfoData*)shop
{
    __weak ShopSelectController* wself = self;
    NetWorkRequest* req = [[NetWorkRequest alloc]init];
    [req getShopsWithAddress:shop WithComplete:^(NSMutableArray* respond, NetWorkStatus status) {
        if (status==NetWorkSuccess) {
            
            if (respond.count == 0) {
                _emptyWarn = [[THActivityView alloc]initWithFrame:CGRectMake(0, 154, SCREENWIDTH, SCREENHEIGHT-154) withImage:@"select_shopEmptyWarn" withString:@"小喵还未覆盖您所在的位置，敬请期待哦"];
                _emptyWarn.backgroundColor = FUNCTCOLOR(243, 243, 243);
                [self.view addSubview:_emptyWarn];
            }
            [wself getShopsThroughAddressWithResult:respond];
        }
        
    }];
    
    [req startAsynchronous];
}


-(void)getShopsThroughAddressWithResult:(NSMutableArray*)arr
{
    [self setTableSearchType:TableSearchProceed];
    _searchArr = arr;
    [_table reloadData];
}


-(void)searchThroughNetWithCharacter:(NSString*)character
{
     __weak ShopSelectController* wself = self;
    NetWorkRequest* req = [[NetWorkRequest alloc]init];
    [req seachShopWithCharacter:character WithBk:^(NSMutableArray* respond, NetWorkStatus status) {
        
        if (status==NetWorkSuccess) {
            [wself getSearchResult:respond];
        }

    }];
    
    [req startAsynchronous];
}

-(void)getSearchResult:(NSMutableArray*)arr
{
    [self setTableSearchType:TableSearchBegin];
    _areaArr = arr;
    [_table reloadData];
}


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
            [wself getSearchResult:respond];
        }
    }];
    
    [req startAsynchronous];
}


-(void)getShopThroughLatitude:(float)latitude Withlongitude:(float)longitude
{
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];
    
    __weak ShopSelectController* wself = self;
    NetWorkRequest* req = [[NetWorkRequest alloc]init];
    [req throughLocationGetShopWithlatitude:latitude WithLong:longitude WithBk:^(NSDictionary* respond, NetWorkStatus error) {
        
        [loadView removeFromSuperview];
        
        if (error != NetWorkSuccess)
        {
            THActivityView* loadView = [[THActivityView alloc]initWithNetErrorWithSuperView:wself.view];
            
            [loadView setErrorBk:^{
                [wself getShopThroughLatitude:latitude Withlongitude:longitude];
            }];
            return ;
        }
        if (respond)
        {
            if (respond.count == 0) {
                _emptyWarn = [[THActivityView alloc]initWithFrame:CGRectMake(0, 154, SCREENWIDTH, SCREENHEIGHT-154) withImage:@"select_shopEmptyWarn" withString:@"小喵还未覆盖您所在的位置，敬请期待哦"];
                _emptyWarn.backgroundColor = FUNCTCOLOR(243, 243, 243);
                [self.view addSubview:_emptyWarn];
            }
            [wself receiveData:respond];
        }
        
    }];
    [req startAsynchronous];
}

-(void)receiveData:(NSDictionary*)dic
{
    [self setTableSearchType:TableNormal];
    
    _bestArr = dic[@"best"];
    _nearArr = dic[@"near"];

    _area = dic[@"area"];
    [_table reloadData];
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
//    free(flag);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
