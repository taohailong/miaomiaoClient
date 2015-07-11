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
#import "ShopCategoryData.h"
#import "ShopProductData.h"
#import "ProductInfoController.h"
#import "CommonWebController.h"
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
    
    NSArray* _categoryArr;
    NSArray* _picArr;
    NSMutableArray* _picUrls;
    CGPoint _tabItemPoint;
    NSMutableDictionary* _animationDic;
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
        [self.navigationController.navigationBar setBarTintColor:FUNCTCOLOR(254, 87, 84)];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    else
    {
        if (self.navigationController.viewControllers.count == 1) {
            return;
        }
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        color = DEFAULTBLACK;
        [self.navigationController.navigationBar setTintColor:color];
        color = FUNCTCOLOR(64, 64, 64);
        
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
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
    [_collectionView reloadData];
    
  
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self setNavigationBarAttribute:NO];
    
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _animationDic = [[NSMutableDictionary alloc]init];
    
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
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[seachBt]-5-[_collectionView]-49-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(seachBt,_collectionView)]];
    
    
    
    UIBarButtonItem* rightBar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"root_right"] style:UIBarButtonItemStylePlain target:self action:@selector(showShopInfoViewController)];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShopInfo) name:SHOPROOTCHANGE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiShowLogView) name:PNEEDLOG object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarNuChanged) name:PSHOPCARCHANGE object:nil];

    
    UserManager* manager = [UserManager shareUserManager];
    
    if (manager.shopID!=nil) {
        [self checkLocation];
        [self updateNavigationView];
    }
    [self getShopInfo];
}


#pragma mark-TabBar

-(void)tabBarNuChanged
{
    ShopCarShareData* shareData = [ShopCarShareData shareShopCarManager];
    UIViewController* second = self.tabBarController.viewControllers[2];
    
    NSString* badgeStr = nil;
    int nu = [shareData getCarCount];
    
    if (nu==0) {
        badgeStr = nil;
    }
    else
    {
        badgeStr = [NSString stringWithFormat:@"%d",nu];
    }
        
    second.tabBarItem.badgeValue = badgeStr;
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
    [requ getShopInfoWithShopID:manager.shopID WithBk:^(id respond, NetWorkStatus status) {
        
        [loadView removeFromSuperview];
        if (status==NetWorkSuccess) {
            [wself getShopProduct:respond];
        }
        else 
        {
            THActivityView* loadView = [[THActivityView alloc]initWithNetErrorWithSuperView:wself.view];
            [loadView setErrorBk:^{
                [wself getShopInfo];
            }];
        }
    }];
    
    [requ startAsynchronous];
}


-(void)getShopProduct:(NSDictionary*)data
{
    ShopInfoData* shop = data[ROOTSHOP];
    UserManager* manager = [UserManager shareUserManager];
    [manager setCurrentShop:shop];//顺序

    
    if (shop.shopStatue == ShopClose) {
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该店铺已打烊，无法配送商品" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    [self updateNavigationView];
    
    _categoryArr = data[ROOTCATEGORY];
    _picArr = data[ROOTPIC];
    
    _picUrls = [[NSMutableArray alloc]init];
    
    for (NSDictionary* dic in _picArr) {
        [_picUrls addObject:dic[@"image"]];
    }
    [_collectionView reloadData];
    
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
    return 1+_categoryArr.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    ShopCategoryData* category = _categoryArr[section-1];
    return category.products.count;
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
    ShopCategoryData* category = _categoryArr[indexPath.section -1];
    [head setTitleLabelStr:category.categoryName];
    [head setDetailStr:@"查看更多"];
    __weak RootViewController* wSelf = self;
    __weak ShopCategoryData* wCategory = category;
    [head setHeadBk:^{
        [wSelf collectionViewDidSelectHeadViewWithData:wCategory];
    }];
    return head;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return CGSizeMake(SCREENWIDTH, SCREENWIDTH*0.4);
    }
    return CGSizeMake((SCREENWIDTH-2)/3, 145);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{//水平间隙
    return 0.5;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{//垂直间隙
    return 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        AdvertiseCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AdvertiseCollectionCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell setImageDataArr:_picUrls];
        return cell;
    }
    
    ShopCategoryData* category = _categoryArr[indexPath.section-1];
    ShopProductData* product = category.products[indexPath.row];
    __weak ShopProductData* wProduct = product;
    __weak RootViewController* wSelf = self;
    __weak NSIndexPath* windex = indexPath;
    PCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PCollectionCell" forIndexPath:indexPath];
    
    [cell setCountBk:^(int count) {
        wProduct.count = count;
        [wSelf collectionViewAtIndex:windex productChanged:wProduct];
    }];
    ShopCarShareData* shareData = [ShopCarShareData shareShopCarManager];

    [cell  setCountText:[shareData getProductCountWithID:product.pID]];
    [cell setPicUrl:product.pUrl];
    [cell setTitleStr:product.pName];
    [cell setPriceStr:[NSString stringWithFormat:@"%.1f",product.price]];
    return cell;
}

//headView 点击方法
-(void)collectionViewDidSelectHeadViewWithData:(ShopCategoryData*)data
{
    UserManager* manager = [UserManager shareUserManager];
    manager.specifyCategory = data.categoryID;
    self.tabBarController.selectedIndex = 1;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShopCategoryData* category = _categoryArr[indexPath.section -1];
    ShopProductData* product = category.products[indexPath.row];
    ProductInfoController* infoController = [[ProductInfoController alloc]initWithProductData:product];
    infoController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:infoController animated:YES];
}


-(void)collectionViewAtIndex:(NSIndexPath*)indexPath productChanged:(ShopProductData*)data
{
    
    PCollectionCell* cell = (PCollectionCell*)[_collectionView cellForItemAtIndexPath:indexPath];
    
    CGPoint start = [self.view convertPoint:[cell getImageView].center fromView:cell];
    
    if (_tabItemPoint.x==0&&_tabItemPoint.y==0) {
        
        UIView* endView = [self viewForTabBarItemAtIndex:2];
        _tabItemPoint = [self.tabBarController.view convertPoint:endView.center fromView:self.tabBarController.tabBar];
    }
    [self bezierPathAnimation:start endPoint:_tabItemPoint WithAnimationView:[cell getImageView]];
    

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
    NavigationTitleView* titleView = [[NavigationTitleView alloc]initWithFrame:CGRectMake(0, 0, 250, 42)];
    titleView.delegate = self;
    return titleView;
}


-(void)updateNavigationView
{
    NavigationTitleView* title = (NavigationTitleView*)self.navigationItem.titleView;

    UILabel* textLabel = [title getTextLabel];
    UILabel* detail = [title getDetailLabel];
    
    UserManager* manager = [UserManager shareUserManager];
    textLabel.text = [manager getCurrentShopName];
//    detail.text = [NSString stringWithFormat:@"配送至:%@附近",[manager getCurrentShopArea]];
     detail.text = [manager getCurrentShopArea];

}

-(void)navigationTitleViewDidTouchWithView:(NavigationTitleView *)titleView
{
    [self showSelectShopView:NO];
}


#pragma mark---------------delegate----------

//商铺选择 delegate
-(void)shopSelectOverWithShopID:(ShopInfoData *)shop
{
    ShopCarShareData* dataManager = [ShopCarShareData shareShopCarManager];
    [dataManager clearCache];
    
    UserManager* manager = [UserManager shareUserManager];
    [manager setCurrentShop:shop];
    [self updateNavigationView];
    [self getShopInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOPCATEGORYCHANGED object:nil];
}

//广告点击代理方法

-(void)posterViewDidSelectAtIndex:(NSInteger)index WithData:(id)data
{
    CommonWebController* web = [[CommonWebController alloc]initWithUrl:_picArr[index][@"redirect"]];
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
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
    LogViewController* log = [[LogViewController alloc]init];
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
    LogViewController* log = [[LogViewController alloc]init];
    log.hidesBottomBarWhenPushed = YES;
    [log setLogResturnBk:^(BOOL success) {}];
    [self.navigationController pushViewController:log animated:YES];
}



#pragma mark-tabItemFrame

-(UIView*)viewForTabBarItemAtIndex:(NSInteger)index
{
    CGRect tabBarRect = self.tabBarController.tabBar.frame;
    NSInteger buttonCount = self.tabBarController.tabBar.items.count;
    CGFloat containingWidth = tabBarRect.size.width/buttonCount;
    CGFloat originX = containingWidth * index ;
    CGRect containingRect = CGRectMake( originX, 0, containingWidth, self.tabBarController.tabBar.frame.size.height );
    CGPoint center = CGPointMake( CGRectGetMidX(containingRect), CGRectGetMidY(containingRect));
    return [ self.tabBarController.tabBar hitTest:center withEvent:nil ];
    
}

-(void)bezierPathAnimation:(CGPoint)startPoint endPoint:(CGPoint)endpoint WithAnimationView:(UIView*)view
{
    CALayer *layer = [[CALayer alloc]init];
    
    layer.contents = view.layer.contents;
    layer.frame = view.frame;
    layer.contentsGravity = @"resizeAspect";
    layer.opacity = 1;
    layer.position = startPoint;
    [self.tabBarController.view.layer addSublayer:layer];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //动画起点
    [path moveToPoint:startPoint];
    
    //贝塞尔曲线控制点
//    float sx = startPoint.x;
    
    float sy = startPoint.y;
   
    float ex = endpoint.x;
    
//    float ey = endpoint.y;
    
    float x = ex;
    //
    float y = sy;
//    float x = sx + (ex - sx) / 3;
//    
//    float y = sy + (ey - sy) * 0.9 - 200;
    
    CGPoint centerPoint=CGPointMake(x, y);
    
    [path addQuadCurveToPoint:endpoint controlPoint:centerPoint];
  
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    animation.path = path.CGPath;
    
    [layer addAnimation:animation forKey:@"buy"];
    
    
    CABasicAnimation* sizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    sizeAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 5, 5)];
    
    
    CAAnimationGroup * animationGroup = [[CAAnimationGroup alloc] init];
    
    animationGroup.animations = @[animation,sizeAnimation];
    
    animationGroup.duration = 0.7;
//    animationGroup.duration = 15;

    animationGroup.removedOnCompletion = NO;
    
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [layer addAnimation:animationGroup forKey:@"GroupAnimation"];
    
    
    dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 0.702* NSEC_PER_SEC);
    dispatch_after(timer, dispatch_get_main_queue(), ^{
        [layer removeFromSuperlayer];
    });
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
