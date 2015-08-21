//
//  SearchProductController.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-19.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "SearchProductController.h"
#import "ShopCarView.h"
#import "LogViewController.h"
#import "CommitOrderController.h"
#import "ProductCell.h"
#import "NetWorkRequest.h"
#import "THActivityView.h"
#import "UserManager.h"
#import "ShopCarShareData.h"
#import "ProductInfoController.h"
#import "CarButton.h"
#import "ProductShopCarController.h"


@interface SearchProductController()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{

    UITableView* _table;
    __weak ShopCarView* _shopCar;
    UISearchBar* search;
//    NSMutableArray* _shopCarArr;
    CarButton* _carBt;
    NSMutableArray* _dataArr;
}
@end
@implementation SearchProductController


-(void)viewDidAppear:(BOOL)animated
{
    [search becomeFirstResponder];
    [_table reloadData];
    
    [self updateShopCarData];
}

-(void)viewWillDisappear:(BOOL)animated
{
   [search resignFirstResponder];
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"商品搜索";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _carBt = [CarButton buttonWithType:UIButtonTypeCustom];
    [_carBt setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    _carBt.frame = CGRectMake(0, 0, 45, 45);
    [_carBt addTarget:self action:@selector(showShopCarView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBar = [[UIBarButtonItem alloc]initWithCustomView:_carBt];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    
    
    
    _table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    [self.view addSubview:_table];
    _table.delegate = self;
    _table.dataSource = self;
    _table.translatesAutoresizingMaskIntoConstraints = NO;
    _table.separatorColor = [UIColor clearColor];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_table attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_table]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    
    [self creatSearchBar];
    [self registeNotificationCenter];
}

#pragma mark-keyboard

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
    
    //    _table.contentInset = UIEdgeInsetsMake(0, 0, -height, 0);
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



#pragma mark-searBar

-(void)creatSearchBar
{
    search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
    search.placeholder = @"搜索商品";
    search.delegate = self;
    search.tintColor = DEFAULTNAVCOLOR;
//    search.barTintColor = FUNCTCOLOR(228, 228, 228);
    _table.tableHeaderView = search;
   
}
    
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [searchBar setShowsCancelButton:YES animated:YES];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
    
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

    if (searchBar.text.length) {
       [searchBar resignFirstResponder];
//         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [searchBar setShowsCancelButton:NO animated:YES];
       [self searchThroughNetWithCharacter:searchBar.text];
    }
        
}
#pragma mark-updateShopCar

-(void)updateShopCarData
{
    ShopCarShareData* share = [ShopCarShareData shareShopCarManager];
    [_carBt setButtonTitleText:[NSString stringWithFormat:@"%d",[share getCarCount]]];
}

#pragma mark-btAction

-(void)showShopCarView
{
//    ShopCarShareData* share = [ShopCarShareData shareShopCarManager];
//    if ([share getCarCount] ==0)
//    {
//        return;
//    }
    
    ProductShopCarController* shopCar = [[ProductShopCarController alloc]init];
    [self.navigationController pushViewController:shopCar animated:YES];
}


-(void)showLogView
{
    LogViewController* log = [[LogViewController alloc]init];
    [self.navigationController pushViewController:log animated:YES];
}


-(void)shopCarChanged:(ShopProductData*)product
{
    
    
}


#pragma mark------------tableView------------------

-(void)searchThroughNetWithCharacter:(NSString*)character
{
    UserManager* manager = [UserManager shareUserManager];
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];

    __weak SearchProductController* wself = self;
    NetWorkRequest* req = [[NetWorkRequest alloc]init];
    [req seachProductWithShopID:manager.shopID WithCharacter:character WithBk:^(NSMutableArray* respond, NetWorkStatus status) {
        
        [loadView removeFromSuperview];
        
        if (NetWorkSuccess == status) {
            [wself parseTableData:respond];
        }
    }];
    [req startAsynchronous];
}

-(void)parseTableData:(NSMutableArray*)arr
{
    _dataArr = arr;
    if (_dataArr.count) {
        _table.separatorColor = nil;
        [_table reloadData];
    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellID = @"ids";
    ProductCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    ShopProductData* data = _dataArr[indexPath.row];
    __weak ShopProductData* wData = data;
    __weak SearchProductController* wSelf = self;
    
    
    ShopCarShareData* shareData = [ShopCarShareData shareShopCarManager];
    int count =  [shareData getProductCountWithID:data.pID];
    data.count = count;
    
    [cell setCountText:data.count];
    [cell setCountBk:^(BOOL isAdd, int count) {
        
        wData.count = count;
        [wSelf addProductToShopCar:wData];
        
    }];
    
    [cell setPriceStr:[NSString stringWithFormat:@"%.1f", data.price]];
    [cell setTitleStr:data.pName];
    [cell setPicUrl:data.pUrl];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShopProductData* product = _dataArr[indexPath.row];
    ProductInfoController* infoController = [[ProductInfoController alloc]initWithProductData:product];
    
    [self.navigationController pushViewController:infoController animated:YES];
}


-(void)addProductToShopCar:(ShopProductData*)product
{
    ShopCarShareData* shareData = [ShopCarShareData shareShopCarManager];
    
    [shareData addOrChangeShopWithProduct:product];
    [self updateShopCarData];
}

-(void)reloadTableView
{
    [_table reloadData];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
