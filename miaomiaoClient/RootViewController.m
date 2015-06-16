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
#import "ShopProductListView.h"
#import "ShopCategoryListView.h"
#import "UserCenterController.h"
#import "NetWorkRequest.h"
#import "UserManager.h"
#import "ShopCarShareData.h"
#import "ShopCarCoverView.h"
#import "ShopCarView.h"
#import "ShopProductData.h"
#import "CommitOrderController.h"
#import "NavigationTitleView.h"
#import "ShopInfoData.h"
#import "SearchProductController.h"
#import "THActivityView.h"
#import "ProductCoverView.h"
#import "LocationManager.h"



@interface RootViewController ()<ShopSelectProtocol,ShopCategoryProtocol,NavigationTieleViewProtocol,UIAlertViewDelegate,ShopProductListProtocol>
{
    BOOL _carViewNeedHidden;
    float _totalMoney;
    IBOutlet   ShopProductListView* _productListV;
    IBOutlet ShopCategoryListView* _categoryListV;
//    NSString* _currentShop;
    IBOutlet ShopCarView* _shopCar;
//    NSMutableArray* _shopCarArr;
    __weak ShopCarCoverView* _carCoverView;
    
}
@end

@implementation RootViewController


-(void)setNavigationBarAttribute
{
    UIColor * color = [UIColor whiteColor];
    
    //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api
    NSDictionary * dict = @{UITextAttributeTextColor:color,UITextAttributeFont:DEFAULTFONT(18)};
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

-(void)viewWillAppear:(BOOL)animated
{
    _shopCar.hidden = NO;
    _carViewNeedHidden = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    UserManager* manager = [UserManager shareUserManager];
    if (manager.shopID==nil) {
        [self showSelectShopView:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (_carViewNeedHidden==YES) {
        return;
    }
    _shopCar.hidden = animated;

}


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


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    _shopCarArr = [[NSMutableArray alloc]init];
    
    self.navigationItem.titleView = [self navgationTitleView];
    [self setNavigationBarAttribute];
    
    UIBarButtonItem* leftBar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"root_set"] style:UIBarButtonItemStyleDone target:self action:@selector(showUserCenter)];
    self.navigationItem.leftBarButtonItem = leftBar;
    
    UIBarButtonItem* rightBar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"root_search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchProductAction)];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    [self creatShopCarView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopCarChanged:) name:PSHOPCARCHANGE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiShowLogView) name:PNEEDLOG object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanShopCar) name:PSHOPCARCLEAN object:nil];
    
    
    
    UserManager* manager = [UserManager shareUserManager];
    [self getShopInfoWithShopID:manager.shopID];
    
    if (manager.shopID!=nil) {
       [self checkLocation];
    }
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



#pragma mark-----------shopCar view Table------------------------

-(void)creatShopCarView
{
    _shopCar = [[ShopCarView alloc]init];
    _shopCar.tag = 100;
    _shopCar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.navigationController.view addSubview:_shopCar];
    [self.navigationController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_shopCar]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_shopCar)]];
    
    [self.navigationController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_shopCar(50)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_shopCar)]];
    
    __weak RootViewController* wself = self;
    [_shopCar setCommitBk:^{
        [wself checkIfCommit];
    }];
    
    
    [_shopCar setShopCarInfoBk:^{
        [wself showShopCarInfoView];
    }];

}


-(void)showShopCarInfoView
{
    ShopCarShareData* shareData = [ShopCarShareData shareShopCarManager];
    NSMutableArray*shopCarArr = [shareData getShopCarArr];
    
    if (shopCarArr.count==0) {
        return;
    }
    
    [self.navigationController.view bringSubviewToFront:_shopCar];
    __weak ShopCarView* wShopCarView = _shopCar;
    ShopCarCoverView *coverView = [[ShopCarCoverView alloc]initCoverView];
    
    
    [coverView setShopCarData:shopCarArr];
    [coverView setRemoveBk:^{
        [wShopCarView carIconRecoverBackAnimation:YES];
    }];
    [self.navigationController.view insertSubview:coverView belowSubview:_shopCar];
    _carCoverView = coverView;
    
    
    float originalHeight = (shopCarArr.count+1)*45.0;
    float height = SCREENHEIGHT*0.6<originalHeight?SCREENHEIGHT*0.6:originalHeight;
    [_shopCar setCarIconAnimationWithHeight:height];
    
    
}


-(void)cleanShopCar
{
//    for (ShopProductData* obj in _shopCarArr) {
//        obj.count = 0;
//    }
//    [_shopCarArr removeAllObjects];
//    _totalMoney = 0;
     ShopCarShareData* carData = [ShopCarShareData shareShopCarManager];
    [carData clearCache];
    [_shopCar setMoneyLabel: 0];
    [_shopCar setCountOfProduct:0];
    [_productListV reloadTable];
}


-(void)shopCarChanged:(NSNotification*)noti
{
//    ShopProductData* product = (ShopProductData*) noti.object;
//    if (product==nil) {
//        return;
//    }
//    
//    [_productListV checkExsitShopCarData:product];
//    
//    BOOL exsit = NO;
//    float totalMoney = 0;
//    int count = 0;
//    
//    for (int i = 0 ;i< _shopCarArr.count;i++) {
//        
//        ShopProductData* obj = _shopCarArr[i];
//        if ([obj.pID isEqualToString:product.pID]) {
//            exsit = YES;
//            obj.count = product.count;
//        }
//        if (obj.count==0) {
//            [_shopCarArr removeObject:obj];
//            i--;
//            continue;
//        }
//        count += obj.count;
//        totalMoney+= obj.price*obj.count;
//    }
//    
//    if (exsit==NO) {
//       [_shopCarArr addObject:product];
//        count += product.count;
//        totalMoney+= product.price * product.count;
//    }
//    
//    [_productListV reloadTable];
//
//    _totalMoney = totalMoney;
//    [_shopCar setMoneyLabel: totalMoney];
//    [_shopCar setCountOfProduct:count];
    
    
     ShopCarShareData* carData = [ShopCarShareData shareShopCarManager];
    
    
    [_shopCar setMoneyLabel:[carData getTotalMoney]];
    [_shopCar setCountOfProduct:[carData getCarCount]];
    
    [_productListV reloadTable];
}




-(void)searchProductAction
{
    _carViewNeedHidden = YES;
    SearchProductController* searchView = [[SearchProductController alloc]init];
    [searchView setTotalMoney:_totalMoney];
//    [searchView setShopCarArr:_shopCarArr];
    [self.navigationController pushViewController:searchView animated:YES];
}




-(void)showUserCenter
{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UTOKEN]==nil)
    {
        __weak RootViewController* wself = self;
        [self showLogView:^{
            
            UserCenterController* userView = [[UserCenterController alloc]init];
            [wself.navigationController pushViewController:userView animated:YES];
        }];
        return;
    }
    UserCenterController* userView = [[UserCenterController alloc]init];
    [self.navigationController pushViewController:userView animated:YES];
    
}


-(void)checkIfCommit
{
    if (_carCoverView) {
        [_carCoverView removeFromSuperview];
        [_shopCar carIconRecoverBackAnimation:NO];
    }
    
    ShopCarShareData* shareData = [ShopCarShareData shareShopCarManager];
    NSMutableArray* shopCarArr = [shareData getShopCarArr];
    
    if (shopCarArr.count==0) {
        return;
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UTOKEN]==nil)
    {
        __weak RootViewController* wself = self;
        [self showLogView:^{
            
            CommitOrderController* order = [[CommitOrderController alloc]initWithProductArr:shopCarArr WithTotalMoney:[shareData getTotalMoney]];
            [wself.navigationController pushViewController:order animated:YES];
        } ];
        return;
    }
    
    CommitOrderController* order = [[CommitOrderController alloc]initWithProductArr:shopCarArr WithTotalMoney:[shareData getTotalMoney]];
    [self.navigationController pushViewController:order animated:YES];
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


#pragma mark-------------navigationTitleDelegate-----

-(UIView*)navgationTitleView
{
    NavigationTitleView* titleView = [[NavigationTitleView alloc]initWithFrame:CGRectMake(0, 0, 200, 42)];
    titleView.delegate = self;
    //    titleView.backgroundColor = [UIColor redColor];
    return titleView;
}


-(void)navigationTitleViewDidTouchWithView:(NavigationTitleView *)titleView
{
    
    [self showSelectShopView:NO];
}


#pragma mark---------------shoplist delegate----------

//商品 delegate
-(void)didSelectProductIndex:(ShopProductData *)product
{
    ProductCoverView* coverView = [[ProductCoverView alloc]initWithSuperView:self.navigationController.view];
    [coverView setImageViewWithAnimation:YES Url:product.pUrl];

}

//分类 delegate
-(void)didSelectCategoryIndexWith:(NSString *)categoryID WithShopID:(NSString *)shopID
{
    UserManager* user = [UserManager shareUserManager];
   
   [_productListV setCategoryIDToGetData:categoryID WithShopID: user.shopID];
}
//商铺选择 delegate
-(void)shopSelectOverWithShopID:(ShopInfoData *)shop
{
    if (shop.shopStatue==ShopClose)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您选择的商铺已打烊，请选择其他商铺！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 10;
        [alert show];
        return;
    }
    
    UserManager* manager = [UserManager shareUserManager];
    manager.shopID = shop.shopID;
    
    [manager setShopID:shop.shopID WithLongitude:shop.longitude WithLatitude:shop.latitude];
    manager.shopMinPrice = shop.minPrice;

    
    NavigationTitleView* title = (NavigationTitleView*)self.navigationItem.titleView;
    UILabel* textLabel = [title getTextLabel];
    UILabel* detail = [title getDetailLabel];
    textLabel.text = [NSString stringWithFormat:@"%@",shop.shopName];
    detail.text = [NSString stringWithFormat:@"营业时间:%@-%@",shop.openTime?shop.openTime:@"00:00",shop.closeTime?shop.closeTime:@"24:00"];
    
  
    _totalMoney = 0;
    [_shopCar setMinPrice:shop.minPrice];
    [_shopCar setMoneyLabel:_totalMoney];
    
    [_productListV clearAllData];
    [_categoryListV initNetDataWithShopID:shop.shopID];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10) {
       [self showSelectShopView:YES];
    }
    else
    {
        if (alertView.cancelButtonIndex==buttonIndex) {
            return;
        }
        [self showSelectShopView:NO];
    }

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
