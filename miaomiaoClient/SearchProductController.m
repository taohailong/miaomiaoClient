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

@interface SearchProductController()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    float _totalMoney;
    UITableView* _table;
    __weak ShopCarView* _shopCar;
//    NSMutableArray* _shopCarArr;
    NSMutableArray* _dataArr;
}
@end
@implementation SearchProductController


-(void)setTotalMoney:(float)money
{
    _totalMoney = money;
}

//-(void)setShopCarArr:(NSMutableArray*)shopArr
//{
//    _shopCarArr = shopArr;
//}


-(void)viewWillAppear:(BOOL)animated
{
    UIView* topView = (UIView*)[self.navigationController.view viewWithTag:100];
    if ([topView isKindOfClass:[ShopCarView class]]) {
        topView.hidden = NO;
    }

    
//    UIView* topView = [self.navigationController.view.subviews lastObject];
//    if ([topView isKindOfClass:[ShopCarView class]]) {
//        _shopCar = (ShopCarView*)topView;
//        topView.hidden = NO;
//    }
}

-(void)viewWillDisappear:(BOOL)animated
{
//    UIView* topView = [self.navigationController.view.subviews lastObject];
    UIView* topView = (UIView*)[self.navigationController.view viewWithTag:100];
    if ([topView isKindOfClass:[ShopCarView class]]) {
        topView.hidden = YES;
    }
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"商品搜索";
    self.view.backgroundColor = [UIColor whiteColor];
    _table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    [self.view addSubview:_table];
    _table.delegate = self;
    _table.dataSource = self;
    _table.translatesAutoresizingMaskIntoConstraints = NO;
    _table.separatorColor = [UIColor clearColor];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_table]-48-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    
    [self creatSearchBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:PSEARCHTABLERELOAD object:nil];
}


-(void)creatSearchBar
{
    UISearchBar* search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
    search.placeholder = @"搜索商品";
    search.delegate = self;
    _table.tableHeaderView = search;
    [search becomeFirstResponder];
}
    
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [searchBar setShowsCancelButton:YES animated:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

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
       [searchBar resignFirstResponder];
         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [searchBar setShowsCancelButton:NO animated:YES];
       [self searchThroughNetWithCharacter:searchBar.text];
    }
        
}



//-(void)creatShopCarView
//{
//    UserManager* manager = [UserManager shareUserManager];
//    
//    _shopCar = [[ShopCarView alloc]init];
//    _shopCar.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    [_shopCar setMinPrice: manager.shopMinPrice];
//    [_shopCar setMoneyLabel:_totalMoney];
//    [self  shopCarChanged:nil];
//    
//    [self.view addSubview:_shopCar];
//    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_shopCar]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_shopCar)]];
//    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_table]-0-[_shopCar]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table,_shopCar)]];
//    
//    __weak SearchProductController* wself = self;
//    [_shopCar setCommitBk:^{
//        [wself checkIfCommit];
//    }];
//}
//
//
//-(void)checkIfCommit
//{
//    if (_shopCarArr.count==0) {
//        return;
//    }
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:UTOKEN]==nil) {
//        [self showLogView];
//        return;
//    }
//    
//    CommitOrderController* order = [[CommitOrderController alloc]initWithProductArr:_shopCarArr WithTotalMoney:_totalMoney];
//    [self.navigationController pushViewController:order animated:YES];
//}



-(void)showLogView
{
    LogViewController* log = [self.storyboard instantiateViewControllerWithIdentifier:@"LogViewController"];
    [self.navigationController pushViewController:log animated:YES];
//    [self presentViewController:log animated:YES completion:^{}];
}



-(void)shopCarChanged:(ShopProductData*)product
{
    
//    BOOL contain = [_shopCarArr containsObject:product];
//    if (contain==NO&&product) {
//        [_shopCarArr addObject:product];
//    }
//    
//    float totalMoney = 0;
//    int count = 0;
//    for (ShopProductData* obj in _shopCarArr) {
//        
//        if (obj.count==0) {
//            [_shopCarArr removeObject:obj];
//            break;
//        }
//        count += obj.count;
//        totalMoney+= obj.price*obj.count;
//    }
//    
//    _totalMoney = totalMoney;
//    [_shopCar setMoneyLabel:totalMoney];
//    [_shopCar setCountOfProduct:count];
    
}


#pragma mark------------tableView------------------

-(void)searchThroughNetWithCharacter:(NSString*)character
{
    UserManager* manager = [UserManager shareUserManager];
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];
//    character = @"哈";
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

//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        for (ShopProductData* obj in _dataArr) {
//            
//            for (ShopProductData* compare in _shopCarArr) {
//                if ([compare.pID isEqualToString:obj.pID]) {
//                    obj.count  = compare.count;
//                }
//            }
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            if (_dataArr.count) {
//                _table.separatorColor = nil;
//                [_table reloadData];
//            }
// 
//        });
//    });
    

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
    
    [cell setPriceStr:[NSString stringWithFormat:@"%.2f", data.price]];
    [cell setTitleStr:data.pName];
    [cell setPicUrl:data.pUrl];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


-(void)addProductToShopCar:(ShopProductData*)product
{
    ShopCarShareData* shareData = [ShopCarShareData shareShopCarManager];
    
    [shareData addOrChangeShopWithProduct:product];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PSHOPCARCHANGE object:product];
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
