//
//  ShopCarTableView.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-18.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "ShopCarTableView.h"
#import "ShopCarCell.h"
#import "ShopProductData.h"
#import "ShopCarShareData.h"

@interface ShopCarTableView()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _table;
    NSArray* _dataArr;
}
@end
@implementation ShopCarTableView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    UIButton* cleanBt = [UIButton buttonWithType:UIButtonTypeCustom];
    cleanBt.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:cleanBt];
    [cleanBt setImage:[UIImage imageNamed:@"clean_shopCar"] forState:UIControlStateNormal];
    
    [cleanBt setTitleColor:FUNCTCOLOR(196, 196, 196) forState:UIControlStateNormal];
    cleanBt.titleLabel.font = DEFAULTFONT(15);
    [cleanBt setTitle:@" 清空购物车" forState:UIControlStateNormal];
    [cleanBt addTarget:self action:@selector(cleanShopCar) forControlEvents:UIControlEventTouchUpInside];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[cleanBt]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(cleanBt)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[cleanBt]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(cleanBt)]];
    
    
    _table = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    _table.translatesAutoresizingMaskIntoConstraints = NO;
    
    _table.delegate = self;
    _table.dataSource =self;
    
//    _table.backgroundColor = [UIColor redColor];
    [self addSubview:_table];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-45-[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];

    self.backgroundColor = FUNCTCOLOR(229, 229, 229);
    return self;
}

-(void)setCleanBk:(ShopCarClean)bk
{
    _cleanBk = bk;
}


-(void)setShopCarData:(NSArray *)carArr
{
    _dataArr = carArr;
    [_table reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellID = @"ids";
    ShopCarCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ShopCarCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    ShopProductData* data = _dataArr[indexPath.row];
    __weak ShopProductData* wData = data;
    __weak ShopCarTableView* wSelf = self;
    
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

-(void)addProductToShopCar:(ShopProductData*)product
{
    ShopCarShareData* shareData = [ShopCarShareData shareShopCarManager];
    [shareData addOrChangeShopWithProduct:product];

    [[NSNotificationCenter defaultCenter] postNotificationName:PSHOPCARCHANGE object:product];
    [[NSNotificationCenter defaultCenter] postNotificationName:PSEARCHTABLERELOAD object:product];
    if (product.count==0) {
        [_table reloadData];
    }
}


-(void)cleanShopCar
{
    if (_cleanBk) {
        _cleanBk();
        _cleanBk = NULL;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:PSHOPCARCLEAN object:nil];

}

@end
