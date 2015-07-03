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


@interface PCategoryController()<ShopCategoryProtocol,ShopProductListProtocol,NavigationTieleViewProtocol>
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
    [self updateNavgationTitleView];
}



-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = [self navgationTitleView];
    
    UIButton* seachBt = [UIButton buttonWithType:UIButtonTypeCustom];
    seachBt.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:seachBt];
    seachBt.backgroundColor = [UIColor redColor];
    [seachBt setTitle:@"搜索商品" forState:UIControlStateNormal];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[seachBt]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(seachBt)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-70-[seachBt(30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(seachBt)]];
    
    UIView* separateView =  [[UIView alloc]init];
    separateView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:separateView];
    separateView.backgroundColor = DEFAULTGRAYCOLO;
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
    
    UserManager* manager =[UserManager shareUserManager];
    [_categoryListV initNetDataWithShopID:manager.shopID];
}




#pragma mark-------------navigationTitleDelegate-----－－－－－－－

-(UIView*)navgationTitleView
{
    NavigationTitleView* titleView = [[NavigationTitleView alloc]initWithFrame:CGRectMake(0, 0, 250, 42)];
    titleView.delegate = self;
    return titleView;
}

-(void)updateNavgationTitleView
{
    UserManager* manager = [UserManager shareUserManager];
    ShopInfoData* shop = manager.shop;
    NavigationTitleView* title = (NavigationTitleView*)self.navigationItem.titleView;
    UILabel* textLabel = [title getTextLabel];
    UILabel* detail = [title getDetailLabel];
    textLabel.text = [NSString stringWithFormat:@"%@",shop.shopName];
    detail.text = [NSString stringWithFormat:@"营业时间:%@-%@",[shop getOpenTime],[shop getCloseTime]];
}


-(void)navigationTitleViewDidTouchWithView:(NavigationTitleView *)titleView
{
    
//    [self showSelectShopView:NO];
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
}
//商铺选择 delegate
-(void)shopSelectOverWithShopID:(ShopInfoData *)shop
{
    UserManager* manager = [UserManager shareUserManager];
    [manager setCurrentShop:shop];
    
    [self updateNavgationTitleView];
        
    [_productListV clearAllData];
    [_categoryListV initNetDataWithShopID:shop.shopID];
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
            if (distance>1.0)
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"当前店铺不在您的附近哦！" delegate:self cancelButtonTitle:@"继续购物" otherButtonTitles:@"重新选择店铺", nil];
                [alert show];
                
            }
        }
        
    }];
    
}


#pragma mark--------------loginView-------------------------------

-(void)showLogView:(void(^)(void))block
{
    LogViewController* log = [self.storyboard instantiateViewControllerWithIdentifier:@"LogViewController"];
    [log setLogResturnBk:^(BOOL success) {
        if (success) {
            block();
        }
    }];
    [self.navigationController pushViewController:log animated:YES];
}


@end
