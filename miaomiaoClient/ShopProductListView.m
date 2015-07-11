//
//  ShopProductListView.m
//  miaomiaoShop
//
//  Created by 陶海龙 on 15-4-23.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "ShopProductListView.h"
#import "ProductCell.h"
#import "ShopProductData.h"
#import "LastViewOnTable.h"
#import "NetWorkRequest.h"
#import "UserManager.h"
#import "THActivityView.h"
#import "ShopCarShareData.h"

@interface ShopProductListView()
{
    NSMutableArray* _dataArr;
     NSString* _currentCategoryID;
    NSString* _currentShopID;
    CGPoint _tabItemPoint;
    NSMutableDictionary* _allDataDic;
//    NSMutableDictionary* _shopCarPrdouctDic;
}
@property(nonatomic,assign)BOOL isLoading;
@end


@implementation ShopProductListView
@synthesize isLoading;
@synthesize delegate;
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self creatSubView];
    return self;
}

-(id)init
{
    self = [super init];
    [self creatSubView];
    return self;
}





-(void)creatSubView
{
   
    _dataArr = [[NSMutableArray alloc]init];
    _allDataDic = [[NSMutableDictionary alloc]init];
    _table = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    _table.separatorColor = [UIColor clearColor];
    [self addSubview:_table];
    _table.delegate = self;
    _table.dataSource = self;
    
    //    [self addLoadMoreViewWithCount:0];
    if ([_table respondsToSelector:@selector(setSeparatorInset:)]) {
        [_table setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_table respondsToSelector:@selector(setLayoutMargins:)]) {
        [_table setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
    _table.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];

}


-(void)clearAllData
{
    [_allDataDic removeAllObjects];
}



-(void)reloadTable
{
    [_table reloadData];
}

-(void)setCategoryIDToGetData:(NSString *)categoryID WithShopID:(NSString *)shopID
{
    __weak ShopProductListView* wSelf = self;
    self.isLoading = NO;
    
    _currentCategoryID = categoryID;
    _currentShopID = shopID;
    
    if (_allDataDic[categoryID]) {
    
        _dataArr = _allDataDic[categoryID];
        [self addLoadMoreViewWithCount:_dataArr.count];
        [_table reloadData];
        if (_dataArr.count) {
          [_table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
        }
        
        return;
    }
    
    
    THActivityView* fullView = [[THActivityView alloc]initFullViewTransparentWithSuperView:self.superview];
    
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.superview];
    
    
    NetWorkRequest* productReq = [[NetWorkRequest alloc]init];
    
    [productReq shopGetProductWithShopID:shopID withCategory:categoryID fromIndex:0 WithCallBack:^(id backDic, NetWorkStatus error) {
        
        [loadView removeFromSuperview];
        [fullView removeFromSuperview];
        
        if (error!=NetWorkSuccess ) {
            THActivityView* loadView = [[THActivityView alloc]initWithNetErrorWithSuperView:wSelf.superview];
            
            [loadView setErrorBk:^{
                [wSelf setCategoryIDToGetData:categoryID WithShopID:shopID];
            }];
            return ;
        }

        if (backDic) {
        
           [wSelf setDataArrReloadTable:backDic];
        }
        
    }];
    [productReq startAsynchronous];

}


-(void)loadMoreDataFromNet
{
    if (self.isLoading==YES) {
        return;
    }
    self.isLoading = YES;
    
    
    THActivityView* fullView = [[THActivityView alloc]initFullViewTransparentWithSuperView:self.superview];
    
    NetWorkRequest* productReq = [[NetWorkRequest alloc]init];
    __weak ShopProductListView* wSelf = self;
    
    [productReq shopGetProductWithShopID:_currentShopID withCategory:_currentCategoryID fromIndex:_dataArr.count WithCallBack:^(id backDic, NetWorkStatus error) {
        
        [fullView removeFromSuperview];
        wSelf.isLoading = NO;
        
        if (error!=NetWorkSuccess ) {
            THActivityView* loadView = [[THActivityView alloc]initWithNetErrorWithSuperView:wSelf.superview];
            
            [loadView setErrorBk:^{
                [wSelf loadMoreDataFromNet];
            }];
            return ;
        }

        [wSelf addDataArr:backDic];
     
    }];
    [productReq startAsynchronous];

}

-(void)setDataArrReloadTable:(NSMutableArray *)dataArr
{
    _dataArr = dataArr;
    
    [_allDataDic setObject:_dataArr forKey:_currentCategoryID];
    [_table reloadData];
    
    if (_dataArr.count) {
       [_table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
    [self addLoadMoreViewWithCount:dataArr.count];
}


-(void)addDataArr:(NSMutableArray*)da
{
    if (da) {
        [_dataArr addObjectsFromArray:da];
        [_table reloadData];
    }
    
    [self addLoadMoreViewWithCount:da.count];
}

-(void)addLoadMoreViewWithCount:(long)count
{
    if (count==0) {
        _table.separatorColor = [UIColor clearColor];
       
    }
    else
    {
       _table.separatorColor = FUNCTCOLOR(221, 221, 221);
    }
    
    if (count<20) {
        _table.tableFooterView = nil;
    }
    else
    {
        _table.tableFooterView = [[LastViewOnTable alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH*0.71, 50)];
    }
 }




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
   
    ShopProductData* data = _dataArr[indexPath.row];
    __weak ShopProductData* wData = data;
    __weak ShopProductListView* wSelf = self;

    ShopCarShareData* shareData = [ShopCarShareData shareShopCarManager];
    int count =  [shareData getProductCountWithID:data.pID];
    data.count = count;

    [cell setCountText:data.count];
    NSInteger row = indexPath.row;
    [cell setCountBk:^(BOOL isAdd, int count) {
      
         wData.count = count;
        [wSelf addProductAtIndex:row product:wData isAdd:isAdd];
       
    }];
    
    [cell setPriceStr:[NSString stringWithFormat:@"%.2f", data.price]];
    [cell setTitleStr:data.pName];
    [cell setPicUrl:data.pUrl];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(didSelectProductIndex:)]) {
         ShopProductData* data = _dataArr[indexPath.row];
        [self.delegate didSelectProductIndex:data];
    }
}


-(void)addProductAtIndex:(NSInteger)row  product:(ShopProductData*)product isAdd:(BOOL)flag
{
    
     ShopCarShareData* carData = [ShopCarShareData shareShopCarManager];
    [carData addOrChangeShopWithProduct:product];
    
    
    if (flag == NO) {
        return;
    }
    UIViewController* father = (UIViewController*)self.delegate;
    ProductCell* cell = (ProductCell*)[_table cellForRowAtIndexPath: [NSIndexPath indexPathForRow:row inSection:0]];
    
    
    UIView* startView = [cell getImageView];
    CGPoint start = [father.tabBarController.view convertPoint:startView.center fromView:cell];
    if (_tabItemPoint.x==0&&_tabItemPoint.y==0) {
        
        UIView* endView = [self viewForTabBarItemAtIndex:2];
        _tabItemPoint = [father.tabBarController.view convertPoint:endView.center fromView:father.tabBarController.tabBar];
    }
    [self bezierPathAnimation:start endPoint:_tabItemPoint WithAnimationView:[cell getImageView]];
    
}




-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y =  bounds.size.height - inset.bottom;
    float h = size.height;
    
    
    NSLog(@"h-offset is %lf",h-offset.y-y);
    if(h - offset.y-y <50 && _table.tableFooterView)
    {
        [self loadMoreDataFromNet];
    }
    
}

#pragma mark-tabItemFrame

-(UIView*)viewForTabBarItemAtIndex:(NSInteger)index
{
    UIViewController* fatherController = (UIViewController*)self.delegate;
    
    CGRect tabBarRect = fatherController.tabBarController.tabBar.frame;
    NSInteger buttonCount = fatherController.tabBarController.tabBar.items.count;
    CGFloat containingWidth = tabBarRect.size.width/buttonCount;
    CGFloat originX = containingWidth * index ;
    CGRect containingRect = CGRectMake( originX, 0, containingWidth, fatherController.tabBarController.tabBar.frame.size.height );
    CGPoint center = CGPointMake( CGRectGetMidX(containingRect), CGRectGetMidY(containingRect));
    return [fatherController.tabBarController.tabBar hitTest:center withEvent:nil ];
    
}

-(void)bezierPathAnimation:(CGPoint)startPoint endPoint:(CGPoint)endpoint WithAnimationView:(UIView*)view
{
    UIViewController* father = (UIViewController*)self.delegate;

    CALayer *layer = [[CALayer alloc]init];
    layer.contents = view.layer.contents;
    layer.frame = view.frame;
    layer.contentsGravity = @"resizeAspect";
    layer.opacity = 1;
    layer.position = startPoint;
    [father.tabBarController.view.layer addSublayer:layer];
    
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
    CGPoint centerPoint=CGPointMake(x, y);
    
    [path addQuadCurveToPoint:endpoint controlPoint:centerPoint];
    
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    animation.path = path.CGPath;
    
    [layer addAnimation:animation forKey:@"buy"];
    
    
    CABasicAnimation* sizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    sizeAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 8, 8)];
    
    
    CAAnimationGroup * animationGroup = [[CAAnimationGroup alloc] init];
    
    animationGroup.animations = @[animation,sizeAnimation];
    
    animationGroup.duration = 0.7;
    
    animationGroup.removedOnCompletion = NO;
    
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [layer addAnimation:animationGroup forKey:@"GroupAnimation"];
    
    
    dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 0.702* NSEC_PER_SEC);
    dispatch_after(timer, dispatch_get_main_queue(), ^{
        [layer removeFromSuperlayer];
    });
    
}



@end
