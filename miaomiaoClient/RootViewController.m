//
//  ViewController.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-7.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "RootViewController.h"
#import "LogViewController.h"
#import "ShopSelectController.h"
#import "NetWorkRequest.h"
#import "UserManager.h"
#import "ShopCarShareData.h"
#import "ShopProductData.h"
#import "NavigationTitleView.h"
#import "ShopInfoData.h"
#import "SearchProductController.h"
#import "THActivityView.h"
#import "LocationManager.h"
#import "PCollectionCell.h"
#import "AdvertiseCollectionCell.h"
#import "PCollectionHeadView.h"
#import "ShopInfoViewController.h"


@interface RootViewController ()<ShopSelectProtocol,NavigationTieleViewProtocol,UIAlertViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PosterProtocol>
{
    UICollectionView* _collectionView;
    BOOL _carViewNeedHidden;
    float _totalMoney;
}
@end

@implementation RootViewController


-(void)setNavigationBarAttribute:(BOOL)flag
{
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    UIColor * color = nil;
    if (flag)
    {
        color = [UIColor whiteColor];
        [self.navigationController.navigationBar setTintColor:color];
        [self.navigationController.navigationBar setBarTintColor:DEFAULTNAVCOLOR];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    else
    {
        color = FUNCTCOLOR(64, 64, 64);
        [self.navigationController.navigationBar setTintColor:color];
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    NSDictionary * dict = @{NSForegroundColorAttributeName:color,NSFontAttributeName:DEFAULTFONT(18)};
        
    self.navigationController.navigationBar.titleTextAttributes = dict;
}


-(void)viewWillAppear:(BOOL)animated
{
    [self setNavigationBarAttribute:YES];
    UserManager* manager = [UserManager shareUserManager];
    if (manager.shopID==nil) {
        [self showSelectShopView:YES];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self setNavigationBarAttribute:NO];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.titleView = [self navgationTitleView];
   
    
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
    [seachBt setTitleColor:DEFAULTBLACK forState:UIControlStateNormal];
    [seachBt addTarget:self action:@selector(searchProductAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[seachBt]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(seachBt)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-70-[seachBt(30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(seachBt)]];
    
    
    UICollectionViewFlowLayout* flow = [[UICollectionViewFlowLayout alloc]init];

    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flow];
    _collectionView.backgroundColor = FUNCTCOLOR(243, 243, 243);
    [_collectionView registerClass:[PCollectionCell class] forCellWithReuseIdentifier:@"PCollectionCell"];
    [_collectionView registerClass:[AdvertiseCollectionCell class] forCellWithReuseIdentifier:@"AdvertiseCollectionCell"];
    
    [_collectionView registerClass:[PCollectionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PCollectionHeadView"];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_collectionView];
    

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[seachBt]-5-[_collectionView]-48-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(seachBt,_collectionView)]];
    
    
    
    UIBarButtonItem* rightBar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"root_right"] style:UIBarButtonItemStylePlain target:self action:@selector(showShopInfoViewController)];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShopInfo) name:SHOPROOTCHANGE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiShowLogView) name:PNEEDLOG object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarNuChanged) name:PSHOPCARCHANGE object:nil];

    
    UserManager* manager = [UserManager shareUserManager];
    
    if (manager.shopID!=nil) {
        [self checkLocation];
    }
    [self getShopInfo];
}


#pragma mark-TabBar

-(void)tabBarNuChanged
{
    ShopCarShareData* shareData = [ShopCarShareData shareShopCarManager];
    UIViewController* second = self.tabBarController.viewControllers[2];
    second.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[shareData getCarCount]];
}



#pragma mark-network

-(void)getShopInfo
{
    UserManager* manager = [UserManager shareUserManager];
    if (manager.shopID==nil) {
        return;
    }
    __weak RootViewController* wself = self;
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];
    
    NetWorkRequest* requ = [[NetWorkRequest alloc]init];
    [requ getShopInfoWithShopID:manager.shopID WithBk:^(ShopInfoData* respond, NetWorkStatus status) {
        
        [loadView removeFromSuperview];
        if (status==NetWorkSuccess) {
            [wself getShopProduct:respond];
        }
        else if (status == NetWorkErrorCanntConnect)
        {
            THActivityView* loadView = [[THActivityView alloc]initWithNetErrorWithSuperView:wself.view];
            [loadView setErrorBk:^{
                [wself getShopInfo];
            }];
        }
    }];
    
    [requ startAsynchronous];
}


-(void)getShopProduct:(ShopInfoData*)shop
{
    UserManager* manager = [UserManager shareUserManager];
    [manager setCurrentShop:shop];
    [self updateNavigationView:shop];
}



#pragma mark-buttonAction

-(void)showShopInfoViewController
{
    ShopInfoViewController* shopInfo = [[ShopInfoViewController alloc]init];
    shopInfo.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shopInfo animated:YES];

}


#pragma mark-----------collectionView ---------------

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    return 6;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return CGSizeZero;
    }
    return CGSizeMake(SCREENWIDTH, 40);

}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    PCollectionHeadView* head = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PCollectionHeadView" forIndexPath:indexPath];

    [head setTitleLabelStr:@"哈哈镜"];
    [head setDetailStr:@"查看更多"];
    __weak RootViewController* wSelf = self;
    [head setHeadBk:^{
        [wSelf collectionViewDidSelectHeadViewWithData:nil];
    }];
    return head;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return CGSizeMake(SCREENWIDTH, 145);
    }
    return CGSizeMake(SCREENWIDTH/3-1, 145);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        AdvertiseCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AdvertiseCollectionCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell setImageDataArr:@[@"http://img1.ifensi.com/channelimg/Image/wenjing/29/3s.jpg",@"http://pic1.nipic.com/2008-09-04/2008941547677_2.jpg"]];
        return cell;
    }
    
    PCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PCollectionCell" forIndexPath:indexPath];
    [cell setCountBk:^(int count) {
        
    }];
    [cell setPicUrl:nil];
    [cell setTitleStr:@"哈哈镜哈哈镜哈哈镜"];
    [cell setPriceStr:@"20.0"];
    return cell;
}

//headView 点击方法
-(void)collectionViewDidSelectHeadViewWithData:(id)data
{
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}


-(void)collectionViewProductChanged:(ShopProductData*)data
{
    ShopCarShareData* shareData = [ShopCarShareData shareShopCarManager];
    [shareData addOrChangeShopWithProduct:data];
}


-(void)searchProductAction
{
    SearchProductController* searchView = [[SearchProductController alloc]init];
    searchView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchView animated:YES];
}

-(void)showSelectShopView:(BOOL)hiddenBack
{
    if ([self.navigationController.topViewController isKindOfClass:[ShopSelectController class]]) {
        return;
    }
    ShopSelectController* shops = [[ShopSelectController alloc]init];
    shops.delegate = self;
    shops.hidesBottomBarWhenPushed = YES;
   [self.navigationController pushViewController:shops animated:YES];
    
    if (hiddenBack) {
       shops.navigationItem.hidesBackButton = YES;
    }
}


#pragma mark-------------navigationTitleDelegate-----－－－－－－－

-(UIView*)navgationTitleView
{
    NavigationTitleView* titleView = [[NavigationTitleView alloc]initWithFrame:CGRectMake(0, 0, 200, 42)];
    titleView.delegate = self;
    return titleView;
}


-(void)updateNavigationView:(ShopInfoData*)shop
{
    NavigationTitleView* title = (NavigationTitleView*)self.navigationItem.titleView;
    UILabel* textLabel = [title getTextLabel];
    UILabel* detail = [title getDetailLabel];
    textLabel.text = [NSString stringWithFormat:@"%@",shop.shopName];
    detail.text = [NSString stringWithFormat:@"营业时间:%@-%@",[shop getOpenTime],[shop getCloseTime]];

}

-(void)navigationTitleViewDidTouchWithView:(NavigationTitleView *)titleView
{
    [self showSelectShopView:NO];
}


#pragma mark---------------delegate----------

//商铺选择 delegate
-(void)shopSelectOverWithShopID:(ShopInfoData *)shop
{
    UserManager* manager = [UserManager shareUserManager];
    [manager setCurrentShop:shop];
    [self updateNavigationView:shop];
    [self getShopInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOPCATEGORYCHANGED object:nil];
//    
}




//广告点击代理方法

-(void)posterViewDidSelectAtIndex:(NSInteger)index WithData:(id)data
{
    NSLog(@"%@",data);
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex==buttonIndex) {
        return;
    }
    [self showSelectShopView:NO];
}


#pragma mark----------loginView-----------------

-(void)showLogView:(void(^)(void))block
{
    LogViewController* log = [self.storyboard instantiateViewControllerWithIdentifier:@"LogViewController"];
    log.hidesBottomBarWhenPushed = YES;
    [log setLogResturnBk:^(BOOL success) {
        
        if (success) {
            block();
        }
    }];
    [self.navigationController pushViewController:log animated:YES];
}

-(void)notiShowLogView
{
    LogViewController* log = [self.storyboard instantiateViewControllerWithIdentifier:@"LogViewController"];
    log.hidesBottomBarWhenPushed = YES;
    [log setLogResturnBk:^(BOOL success) {}];
    [self.navigationController pushViewController:log animated:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
