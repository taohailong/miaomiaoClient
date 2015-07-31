//
//  PCategoryController.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/6/30.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "PCategoryController.h"
#import "ProductInfoController.h"
#import "ShopProductListView.h"
#import "ShopCategoryListView.h"
#import "LogViewController.h"
#import "NavigationTitleView.h"
#import "UserManager.h"
#import "ShopInfoData.h"
#import "ShopSelectController.h"
#import "SearchProductController.h"
#import "ShopInfoViewController.h"
#import "ShopCarShareData.h"
@interface PCategoryController()<ShopCategoryProtocol,ShopProductListProtocol,NavigationTieleViewProtocol,ShopSelectProtocol>
{
    ShopProductListView* _productListV;
    ShopCategoryListView* _categoryListV;
}
@end
@implementation PCategoryController

-(void)viewDidAppear:(BOOL)animated
{
//  其他界面更改商品数据后 更新
    [_productListV reloadTable];
    
    UserManager* user = [UserManager shareUserManager];
    if (user.specifyCategory != nil) {
        [self showSpecifyCategoryWithCategory:user.specifyCategory];
        user.specifyCategory = nil;
    }
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


-(void)viewWillAppear:(BOOL)animated
{
    [self setNavigationBarAttribute:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self setNavigationBarAttribute:NO];
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = [self navgationTitleView];
    
    
    
    UIBarButtonItem* rightBar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"root_right"] style:UIBarButtonItemStylePlain target:self action:@selector(showShopInfoViewController)];
    self.navigationItem.rightBarButtonItem = rightBar;

    
    
    UIButton* seachBt = [UIButton buttonWithType:UIButtonTypeCustom];
    seachBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    seachBt.translatesAutoresizingMaskIntoConstraints = NO;
    [seachBt setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [seachBt setImage:[UIImage imageNamed:@"root_search"] forState:UIControlStateNormal];
    seachBt.layer.cornerRadius = 4;
    seachBt.layer.masksToBounds = YES;
    seachBt.backgroundColor = FUNCTCOLOR(228, 228, 228);
    [seachBt setTitleColor:FUNCTCOLOR(163, 163, 163) forState:UIControlStateNormal];
    [self.view addSubview:seachBt];
    seachBt.titleLabel.font = DEFAULTFONT(15);
    [seachBt setTitle:@" 搜索商品" forState:UIControlStateNormal];
    [seachBt addTarget:self action:@selector(searchProductAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[seachBt]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(seachBt)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-70-[seachBt(30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(seachBt)]];

    
    
    
    
    UIView* separateView =  [[UIView alloc]init];
    separateView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:separateView];
    separateView.backgroundColor = FUNCTCOLOR(210, 210, 210);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[separateView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separateView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[seachBt]-5-[separateView(0.5)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(seachBt,separateView)]];
    
    
    
    _productListV = [[ShopProductListView alloc]init];
    _productListV.backgroundColor = [UIColor greenColor];
    _productListV.translatesAutoresizingMaskIntoConstraints = NO;
    _productListV.delegate = self;
    [self.view addSubview:_productListV];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[separateView]-0-[_productListV]-49-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separateView,_productListV)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_productListV]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_productListV)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_productListV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.7 constant:0]];
    
    
    _categoryListV = [[ShopCategoryListView alloc]init];
    _categoryListV.translatesAutoresizingMaskIntoConstraints = NO;
    _categoryListV.delegate = self;
    [self.view addSubview:_categoryListV];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[separateView]-0-[_categoryListV]-49-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separateView,_categoryListV)]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_categoryListV]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_categoryListV)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_categoryListV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.3 constant:0]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNetCategoryData) name:SHOPCATEGORYCHANGED object:nil];
    [self getNetCategoryData];
    
}



-(void)searchProductAction
{
    SearchProductController* searchView = [[SearchProductController alloc]init];
    searchView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchView animated:YES];
}

#pragma btAction

-(void)showShopInfoViewController
{
    ShopInfoViewController* shopInfo = [[ShopInfoViewController alloc]init];
    shopInfo.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shopInfo animated:YES];
}


#pragma mark-netApi

-(void)getNetCategoryData
{
    UserManager* manager =[UserManager shareUserManager];
    [_categoryListV initNetDataWithShopID:manager.shopID WithSpecifyCategory:manager.specifyCategory];
    [self updateNavgationTitleView];
}


#pragma mark-specifyCategory

-(void)showSpecifyCategoryWithCategory:(NSString*)category
{
    [_categoryListV showSpecifyCategory:category];
}


#pragma mark--------navigationTitleDelegate----

-(UIView*)navgationTitleView
{
    NavigationTitleView* titleView = [[NavigationTitleView alloc]initWithFrame:CGRectMake(0, 0, 250, 42)];
    titleView.delegate = self;
    return titleView;
}

-(void)updateNavgationTitleView
{
    NavigationTitleView* title = (NavigationTitleView*)self.navigationItem.titleView;
//    
//    UILabel* textLabel = [title getTextLabel];
//    UILabel* detail = [title getDetailLabel];
    
    UserManager* manager = [UserManager shareUserManager];
    [title setNavigationTitleStr: manager.shop.shopName];
    [title setNavigationDetailStr: manager.shop.shopAddress];
}


-(void)navigationTitleViewDidTouchWithView:(NavigationTitleView *)titleView
{
    ShopSelectController* shops = [[ShopSelectController alloc]init];
    shops.delegate = self;
    shops.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shops animated:YES];
}


#pragma mark---------------shoplist delegate----------

//商品 delegate
-(void)didSelectProductIndex:(ShopProductData *)product
{
    ProductInfoController* p = [[ProductInfoController alloc]initWithProductData:product];
    p.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:p animated:YES];
//    ProductCoverView* coverView = [[ProductCoverView alloc]initWithSuperView:self.navigationController.view];
//    [coverView setImageViewWithAnimation:YES Url:product.pUrl];
    
}

//分类 delegate
-(void)didSelectCategoryIndexWith:(NSString *)categoryID WithShopID:(NSString *)shopID
{
    UserManager* user = [UserManager shareUserManager];
    [_productListV setCategoryIDToGetData:categoryID WithShopID:user.shopID];
    user.specifyCategory = nil;
}
//商铺选择 delegate
-(void)shopSelectOverWithShopID:(ShopInfoData *)shop
{
    ShopCarShareData* dataManager = [ShopCarShareData shareShopCarManager];
    [dataManager clearCache];
    
    UserManager* manager = [UserManager shareUserManager];
    [manager setCurrentShop:shop];
    
    [self updateNavgationTitleView];
        
    [_productListV clearAllData];
    [_categoryListV initNetDataWithShopID:shop.shopID WithSpecifyCategory:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOPROOTCHANGE object:nil];
}





-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex==buttonIndex) {
        return;
    }
//        [self showSelectShopView:NO];
}


#pragma mark-----------location--------------


-(void)checkLocation
{
    UserManager* manager = [UserManager shareUserManager];
    __weak UserManager* wmanager = manager;
    [manager startLocationWithBk:^(BOOL success, float longitude, float latitude) {
        
        if (success)
        {
            float distance = [wmanager figureoutDistanceFromLongitude:longitude Latitude:latitude];
            if (distance>1000)
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"当前店铺不在您的附近哦" delegate:self cancelButtonTitle:@"继续购物" otherButtonTitles:@"重新选择店铺", nil];
                [alert show];
                
            }
        }
        
    }];
    
}


#pragma mark--------------loginView-------------------------------

-(void)showLogView:(void(^)(void))block
{
    LogViewController* log = [[LogViewController alloc]init];
    [log setLogResturnBk:^(BOOL success) {
        if (success) {
            block();
        }
    }];
    [self.navigationController pushViewController:log animated:YES];
}



@end
