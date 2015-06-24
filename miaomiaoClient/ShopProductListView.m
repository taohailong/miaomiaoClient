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
    
    NSMutableDictionary* _allDataDic;
    NSMutableDictionary* _shopCarPrdouctDic;
}
@property(nonatomic,assign)BOOL isLoading;
@end


@implementation ShopProductListView
@synthesize isLoading;
@synthesize delegate;
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    _shopCarPrdouctDic = [[NSMutableDictionary alloc]init];//记录购物车的 @{"categoryid":@{@"shopid":product}}
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
    return self;
}

-(void)clearAllData
{
    [_allDataDic removeAllObjects];
}

//-(void)clearShopCache
//{
//    [_shopCarPrdouctDic removeAllObjects];
//}
//
//-(void)checkExsitShopCarData:(ShopProductData*)data
//{
//    NSArray* arr = _allDataDic[data.categoryID];
//    
//    if ([arr containsObject:data]) {  //是否为当前table 缓存数据
//        return;
//    }
//    for (ShopProductData* obj in arr)
//    {
//        if ([data.pID isEqualToString:obj.pID]) {
//             obj.count = data.count ;
//            return;
//        }
//    }
//    
//    
//    
//    NSMutableDictionary* categoryDic = _shopCarPrdouctDic[data.categoryID];
//    
//    if (categoryDic[data.pID]) {
//        [categoryDic setObject:data forKey:data.pID];
//    }
//    else
//    {
//        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//        [_shopCarPrdouctDic setObject:dic forKey:data.categoryID];
//        [dic setObject:data forKey:data.pID];
//    }
//
//}
//
//-(void)changeCurrentTableDataElement:(NSMutableArray*)arr
//{
//    NSMutableDictionary* dic = _shopCarPrdouctDic[_currentCategoryID];
//    if (dic.allKeys.count)
//    {
//        [arr enumerateObjectsUsingBlock:^(ShopProductData* obj, NSUInteger idx, BOOL *stop) {
//            ShopProductData* p = dic[obj.pID];
//            if (p) {
//                obj.count = p.count;
//                [dic removeObjectForKey:obj.pID];
//            }
//        }];
//    }
//
//}





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
       _table.separatorColor = nil;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(didSelectProductIndex:)]) {
         ShopProductData* data = _dataArr[indexPath.row];
        [self.delegate didSelectProductIndex:data];
    }
}


-(void)addProductToShopCar:(ShopProductData*)product
{
     ShopCarShareData* carData = [ShopCarShareData shareShopCarManager];
    [carData addOrChangeShopWithProduct:product];
    [[NSNotificationCenter defaultCenter] postNotificationName:PSHOPCARCHANGE object:product];
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



@end
