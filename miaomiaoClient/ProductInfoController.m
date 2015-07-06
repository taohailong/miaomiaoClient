//
//  ProuductInfoController.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/7/2.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "ProductInfoController.h"
#import "ProductInfoDetailCell.h"
#import "ProductInfoHeadCell.h"
#import "CarButton.h"
#import "ShopCarShareData.h"
@interface ProductInfoController()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _table;
    UILabel* _countLabel;
    ShopProductData* _product;
    CarButton* _carBt;
}

@end
@implementation ProductInfoController

-(id)initWithProductData:(ShopProductData*)product
{
    self = [super init];
    _product = product;
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"商品详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _carBt = [CarButton buttonWithType:UIButtonTypeCustom];
    [_carBt setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
//    _carBt.backgroundColor = [UIColor blackColor];
    _carBt.frame = CGRectMake(0, 0, 45, 45);
    [_carBt addTarget:self action:@selector(showShopList) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBar = [[UIBarButtonItem alloc]initWithCustomView:_carBt];
    self.navigationItem.rightBarButtonItem = rightBar;
    [self updateShopCarBt];
    
    
    _table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _table.translatesAutoresizingMaskIntoConstraints = NO;
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorColor = FUNCTCOLOR(221, 221, 221);
    _table.tableFooterView = [[UIView alloc]init];
    [_table registerClass:[ProductInfoDetailCell class] forCellReuseIdentifier:@"ProductInfoDetailCell"];
    [_table registerClass:[ProductInfoHeadCell class] forCellReuseIdentifier:@"ProductInfoHeadCell"];
    
    [self.view addSubview:_table];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_table]-50-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];

    
    [self creatFootView];
}

-(void)updateShopCarBt
{
    ShopCarShareData* shopManager = [ShopCarShareData shareShopCarManager];
    [_carBt setButtonTitleText:[NSString stringWithFormat:@"%d",[shopManager getCarCount]]];
}


-(void)creatFootView
{
    UIView* separate = [[UIView alloc]init];
    separate.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:separate];
   
    separate.backgroundColor = DEFAULTGRAYCOLO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[separate]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separate)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[separate(0.5)]-51-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separate)]];
    
    
    
    
    UIButton* _addBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _addBt.tag  = 1;
    [_addBt setImage:[UIImage imageNamed:@"product_addBt"] forState:UIControlStateNormal];
    
    [_addBt addTarget:self action:@selector(setCountOfProduct:) forControlEvents:UIControlEventTouchUpInside];
    _addBt.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_addBt];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_addBt]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_addBt)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_addBt]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_addBt)]];
    
    
    
    _countLabel = [[UILabel alloc]init];
    _countLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_countLabel];
    
    _countLabel.textColor = DEFAULTNAVCOLOR;
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.adjustsFontSizeToFitWidth = YES  ;
    _countLabel.font = DEFAULTFONT(15);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_countLabel(18)]-3-[_addBt]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_countLabel,_addBt)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_countLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_addBt attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    
    _countLabel.text = [NSString stringWithFormat:@"%d",_product.count];
    
    
    UIButton* _subtractBt = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_subtractBt setImage:[UIImage imageNamed:@"product_subtractBt"] forState:UIControlStateNormal];
    
    [_subtractBt addTarget:self action:@selector(setCountOfProduct:) forControlEvents:UIControlEventTouchUpInside];
    _subtractBt.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_subtractBt];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_subtractBt]-3-[_countLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_subtractBt,_countLabel)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_subtractBt attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_addBt attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_subtractBt]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_subtractBt)]];

    
    
    UILabel* title = [[UILabel alloc]init];
    title.text = @"添加商品:";
    title.textColor = DEFAULTBLACK;
    title.translatesAutoresizingMaskIntoConstraints = NO;
    title.font = DEFAULTFONT(16);
    [self.view addSubview:title];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[title]-5-[_subtractBt]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_subtractBt,title)]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_addBt attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}


-(void)showShopList
{


}



-(void)setCountOfProduct:(UIButton*)bt
{
    int count = [_countLabel.text intValue];
    BOOL isAdd = YES;
    if (bt.tag)
    {
        count++;
    }
    else
    {
        isAdd = NO;
        count--;
        count = count<0?0:count;
    }
    
    _product.count = count;
    _countLabel.text = [NSString stringWithFormat:@"%d",count];
    
    ShopCarShareData* manager = [ShopCarShareData shareShopCarManager];
    [manager  addOrChangeShopWithProduct:_product];
    [self updateShopCarBt];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0) {
        return 150;
    }
    return 75;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        if (indexPath.row==0) {
            ProductInfoHeadCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ProductInfoHeadCell"];
            [cell setProductImages:@[_product.pUrl]];
            return cell;
        }
        else
        {
            ProductInfoDetailCell*cell = [tableView dequeueReusableCellWithIdentifier:@"ProductInfoDetailCell"];
            [cell setProductName:_product.pName];
            [cell setProductPrice:[NSString stringWithFormat:@"%.1f",_product.price]];
            return cell;
        }
    }
    
    return nil;

}




@end
