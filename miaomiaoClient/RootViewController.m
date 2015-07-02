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

@interface RootViewController ()<ShopSelectProtocol,NavigationTieleViewProtocol,UIAlertViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView* _collectionView;
    BOOL _carViewNeedHidden;
    float _totalMoney;
}
@end

@implementation RootViewController


-(void)setNavigationBarAttribute
{
    UIColor * color = [UIColor whiteColor];
    
    //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api
    NSDictionary * dict = @{NSForegroundColorAttributeName:color,NSFontAttributeName:DEFAULTFONT(18)};
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}


-(void)viewDidAppear:(BOOL)animated
{
    UserManager* manager = [UserManager shareUserManager];
    if (manager.shopID==nil) {
        [self showSelectShopView:YES];
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.titleView = [self navgationTitleView];
    [self setNavigationBarAttribute];
    
    UIButton* seachBt = [UIButton buttonWithType:UIButtonTypeCustom];
    seachBt.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:seachBt];
    seachBt.backgroundColor = [UIColor redColor];
    [seachBt setTitle:@"搜索商品" forState:UIControlStateNormal];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[seachBt]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(seachBt)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-74-[seachBt(35)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(seachBt)]];
    
    UICollectionViewFlowLayout* flow = [[UICollectionViewFlowLayout alloc]init];

    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flow];
    _collectionView.backgroundColor = [UIColor orangeColor];
    [_collectionView registerClass:[PCollectionCell class] forCellWithReuseIdentifier:@"PCollectionCell"];
    [_collectionView registerClass:[AdvertiseCollectionCell class] forCellWithReuseIdentifier:@"AdvertiseCollectionCell"];
    
    [_collectionView registerClass:[PCollectionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PCollectionHeadView"];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_collectionView];
    

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[seachBt]-10-[_collectionView]-48-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(seachBt,_collectionView)]];
    
    
    
//    UIBarButtonItem* leftBar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"root_set"] style:UIBarButtonItemStyleDone target:self action:@selector(showUserCenter)];
//    self.navigationItem.leftBarButtonItem = leftBar;
//    
//    UIBarButtonItem* rightBar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"root_search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchProductAction)];
//    self.navigationItem.rightBarButtonItem = rightBar;
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopCarChanged:) name:PSHOPCARCHANGE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiShowLogView) name:PNEEDLOG object:nil];
    
//    UserManager* manager = [UserManager shareUserManager];
//    
//    if (manager.shopID!=nil) {
//        [self checkLocation];
//    }
//    [self getShopInfoWithShopID:manager.shopID];
    
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
        return CGSizeMake(SCREENWIDTH, 140);
    }
    return CGSizeMake(SCREENWIDTH/3-1, 140);
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
        
        return cell;
    }
    
    PCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PCollectionCell" forIndexPath:indexPath];
    [cell setCountBk:^(int count) {
        
    }];
    [cell setPicUrl:nil];
    [cell setTitleStr:@"xxxx"];
    [cell setPriceStr:@"20.00"];
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



-(void)getShopInfoWithShopID:(NSString*)shop
{
    if (shop==nil) {
        return;
    }
    __weak RootViewController* wself = self;
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];
    
    NetWorkRequest* requ = [[NetWorkRequest alloc]init];
    [requ getShopInfoWithShopID:shop WithBk:^(ShopInfoData* respond, NetWorkStatus status) {
        
        [loadView removeFromSuperview];
        if (status==NetWorkSuccess) {
            [wself shopSelectOverWithShopID:respond];
        }
        else if (status == NetWorkErrorCanntConnect)
        {
            THActivityView* loadView = [[THActivityView alloc]initWithNetErrorWithSuperView:wself.view];
            [loadView setErrorBk:^{
                [wself getShopInfoWithShopID:shop];
            }];
        }
    }];

    [requ startAsynchronous];
}


-(void)searchProductAction
{
    SearchProductController* searchView = [[SearchProductController alloc]init];
    [searchView setTotalMoney:_totalMoney];
    [self.navigationController pushViewController:searchView animated:YES];
}

-(void)showSelectShopView:(BOOL)hiddenBack
{
    if ([self.navigationController.topViewController isKindOfClass:[ShopSelectController class]]) {
        return;
    }
    ShopSelectController* shops = [[ShopSelectController alloc]init];
    shops.delegate = self;
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


-(void)navigationTitleViewDidTouchWithView:(NavigationTitleView *)titleView
{
    [self showSelectShopView:NO];
}


#pragma mark---------------delegate----------

//商铺选择 delegate
-(void)shopSelectOverWithShopID:(ShopInfoData *)shop
{
    
    UserManager* manager = [UserManager shareUserManager];
    manager.shopID = shop.shopID;
    [manager parseCombinPay:shop.combinPay];
    [manager setShopID:shop.shopID WithLongitude:shop.longitude WithLatitude:shop.latitude];
    manager.shopMinPrice = shop.minPrice;

    
    NavigationTitleView* title = (NavigationTitleView*)self.navigationItem.titleView;
    UILabel* textLabel = [title getTextLabel];
    UILabel* detail = [title getDetailLabel];
    textLabel.text = [NSString stringWithFormat:@"%@",shop.shopName];
    detail.text = [NSString stringWithFormat:@"营业时间:%@-%@",shop.openTime?shop.openTime:@"00:00",shop.closeTime?shop.closeTime:@"24:00"];
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
