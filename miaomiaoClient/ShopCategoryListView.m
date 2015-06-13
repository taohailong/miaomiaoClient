//
//  ShopCategoryList.m
//  miaomiaoShop
//
//  Created by 陶海龙 on 15-4-23.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "ShopCategoryListView.h"
#import "ShopCategoryData.h"
#import "NetWorkRequest.h"
#import "THActivityView.h"

@implementation ShopCategoryListView
@synthesize delegate;
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self creatTableView];
      return self;
}

-(id)init
{
    self = [super init];
    [self creatTableView];
    return self;
}


-(void)creatTableView
{
    
    _table = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    _table.showsVerticalScrollIndicator = NO;
    [self addSubview:_table];
    _table.delegate = self;
    _table.dataSource = self;
//    _table.separatorColor = FUNCTCOLOR(229, 229, 229);
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    _table.tableFooterView = view;

    
    if ([_table respondsToSelector:@selector(setSeparatorInset:)]) {
        [_table setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    
    if ([_table respondsToSelector:@selector(setLayoutMargins:)]) {
        [_table setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    
    _table.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];

}


-(void)setDataArrAndSelectOneRow:(NSMutableArray *)dataArr
{
    if (dataArr.count==0) {
        return;
    }
    _dataArr = dataArr;
    [_table reloadData];

    [_table selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    if ([self.delegate respondsToSelector:@selector(didSelectCategoryIndexWith:WithShopID:)]) {
        ShopCategoryData* data = _dataArr[0];
        [self.delegate didSelectCategoryIndexWith:data.categoryID WithShopID:_currentShopID ];
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSString* cellID = @"ids";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];

//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = FUNCTCOLOR(243, 243, 243);
//        UIView* separateView = [[UIView alloc]init];
//        separateView.backgroundColor = FUNCTCOLOR(229, 229, 229);
//        separateView.translatesAutoresizingMaskIntoConstraints = NO;
//        [cell.contentView addSubview:separateView];
//        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[separateView(0.5)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separateView)]];
//        
//        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[separateView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separateView)]];

        cell.textLabel.font = DEFAULTFONT(16);
        cell.textLabel.textColor = DEFAULTBLACK;
        cell.selectedBackgroundView = [self  tableSelectView];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    ShopCategoryData* data = _dataArr[indexPath.row];
    
        cell.textLabel.text = data.categoryName;
        cell.textLabel.textColor = DEFAULTBLACK;

    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didSelectCategoryIndexWith:WithShopID:)]) {
        ShopCategoryData* data = _dataArr[indexPath.row];
        [self.delegate didSelectCategoryIndexWith:data.categoryID WithShopID:data.shopID];
    }
//    [tableView reloadData];
}


-(void)initNetDataWithShopID:(NSString*)shopID
{
    _currentShopID = shopID;
     THActivityView* loadV = [[THActivityView alloc]initActivityViewWithSuperView:self.superview];
    
    __weak ShopCategoryListView* wself = self;
    NetWorkRequest* categoryReq = [[NetWorkRequest alloc]init];
    [categoryReq shopGetCategoryWithShopID:shopID callBack:^(NSMutableArray *respond, NetWorkStatus error) {
        
        [loadV removeFromSuperview];
        
        if (error != NetWorkSuccess) {
            THActivityView* loadView = [[THActivityView alloc]initWithNetErrorWithSuperView:wself.superview];
            
            [loadView setErrorBk:^{
                [wself initNetDataWithShopID:shopID];
            }];
            return ;
        }

        if (respond) {
          [self setDataArrAndSelectOneRow:respond];
        }
     }];
    [categoryReq startAsynchronous];
    
}

-(UIView*)tableSelectView
{
    UIView* selectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 44)];
    selectView.backgroundColor = [UIColor whiteColor];
    
    
//    UIView* headView = [[UIView alloc]init];
//    headView.backgroundColor = [UIColor whiteColor];
//    headView.translatesAutoresizingMaskIntoConstraints = NO;
//    [selectView addSubview:headView];
//    [selectView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-13-[headView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(headView)]];
//    [selectView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[headView(1)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(headView)]];
//
    
    
    
//    UIView* bottomView = [[UIView alloc]init];
//    bottomView.backgroundColor = [UIColor whiteColor];
//    bottomView.translatesAutoresizingMaskIntoConstraints = NO;
//    [selectView addSubview:bottomView];
//    [selectView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-13-[bottomView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bottomView)]];
//    [selectView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomView(1)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bottomView)]];

    
    
    UIView* colorView = [[UIView alloc]init];
    colorView.backgroundColor = DEFAULTNAVCOLOR;
    colorView.translatesAutoresizingMaskIntoConstraints = NO;
    [selectView addSubview:colorView];
    
    [selectView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-1-[colorView(7)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(colorView)]];
    [selectView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[colorView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(colorView)]];
    
    
    
      return selectView;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    
}


@end
