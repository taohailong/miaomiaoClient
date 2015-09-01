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
#import "CateTableHeadView.h"
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
    [_table registerClass:[CateTableHeadView class] forHeaderFooterViewReuseIdentifier:@"CateTableHeadView"];
    _table.showsVerticalScrollIndicator = NO;
    [self addSubview:_table];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorColor = FUNCTCOLOR(221, 221, 221);
//    UIView *view =[ [UIView alloc]init];
//    view.backgroundColor = [UIColor clearColor];
//    _table.tableFooterView = view;

    
    if ([_table respondsToSelector:@selector(setSeparatorInset:)]) {
        [_table setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    if ([_table respondsToSelector:@selector(setLayoutMargins:)]) {
        [_table setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    _table.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];

}

-(void)showSpecifyCategory:(NSString*)category
{
    if (_dataArr.count == 0) {
        return;
    }
    
    int section = 0;
    int row = 0;
    BOOL stop = NO;
    if (category != nil)
    {
        for (ShopCategoryData* obj in _dataArr)
        {
            row = 0;
            if ([obj.categoryID isEqualToString:category])
            {
                break;
            }
            
            
            for (ShopCategoryData* sub in obj.subClass)
            {
                if ([sub.categoryID isEqualToString:category]) {
                    stop = YES;
                    break;
                }
                row++;
            }
            
            if (stop) {
                break;
            }
            section++;
         }
    }
    _flag[_selectIndex] = 0;
    _flag[section] = 1;
    _selectIndex = section;
    [_table reloadData];
    
    NSIndexPath* path = [NSIndexPath indexPathForRow:row inSection:section];
    [self manualSelectRowAtIndex:path];
}


-(void)setDataArrAndSelectOneRow:(NSMutableArray *)dataArr
{
    if (dataArr.count==0) {
        return;
    }
    _dataArr = dataArr;
    
    
    free(_flag);
    _flag = calloc(dataArr.count, sizeof(int));
//    _flag[0] = 1;
    [_table reloadData];

    [self showSpecifyCategory:_specifyCategory];

}

-(void)manualSelectRowAtIndex:(NSIndexPath*)path
{
    // 判断是否有二级分类 有自动选择第一个，没有的话传入主分类

    ShopCategoryData* data = _dataArr[path.section];
    if (data.subClass.count==0)
    {
        if ([self.delegate respondsToSelector:@selector(didSelectSubCategory:WithName:)]) {
            
            [self.delegate didSelectSubCategory: data.categoryID WithName: data.categoryName];
        }
        
        if ([self.delegate respondsToSelector:@selector(didSelectMainCategory:WithName:)]) {
            
            [self.delegate didSelectMainCategory:data.categoryID WithName:data.categoryName];
        }
    }
    else
    {
        [self tableView:_table didSelectRowAtIndexPath:path];
        [_table selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionNone];
        [_table scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
//    [_table scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}



#pragma mark-Tableview


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ShopCategoryData* cate = _dataArr[section];
    CateTableHeadView* head = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CateTableHeadView"];
    UILabel* title = [head getFirstLabel];
    title.textColor = FUNCTCOLOR(102, 102, 102);
    title.font = DEFAULTFONT(16);
    title.highlightedTextColor = DEFAULTNAVCOLOR;
    title.text = cate.categoryName;
    
    [head setAccessImage:@"narrow_normal" selectImage:@"narrow_down_red"];
    
    if (_selectIndex == section) {
        [head setSelectView];
    }
    else
    {
        [head disSelectView];
    }
    
    __weak ShopCategoryListView* wself = self;
    [head setSelectBk:^{
        [wself tableViewHeadSelectAtSection:section];
    }];
    return head;
}





-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_flag[section]==1) {
        ShopCategoryData* data  = _dataArr[section];
        return data.subClass.count;
    }
    return 0;
}





-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSString* cellID = @"ids";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }

        cell.textLabel.font = DEFAULTFONT(14);
        cell.textLabel.textColor = FUNCTCOLOR(153, 153, 153);
        cell.textLabel.highlightedTextColor = DEFAULTNAVCOLOR;
        cell.backgroundColor = FUNCTCOLOR(243, 243, 243);
        cell.selectedBackgroundView = [self  tableCellSelectView];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    ShopCategoryData* data = _dataArr[indexPath.section];
    ShopCategoryData* subData = data.subClass[indexPath.row];
    
    cell.textLabel.text = subData.categoryName;
    cell.textLabel.textColor = DEFAULTBLACK;

    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopCategoryData* data = _dataArr[indexPath.section];
    ShopCategoryData* subData = data.subClass[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(didSelectSubCategory:WithName:)]) {
        
        [self.delegate didSelectSubCategory: subData.categoryID WithName: subData.categoryName];
    }
    
    if ([self.delegate respondsToSelector:@selector(didSelectMainCategory:WithName:)]) {
        
        [self.delegate didSelectMainCategory:data.categoryID WithName:data.categoryName];
    }

}

-(void)tableViewHeadSelectAtSection:(NSInteger)section
{
    _flag[section] = !_flag[section];
    
    
    NSMutableIndexSet* index = [[NSMutableIndexSet alloc]initWithIndex:section];
    
    if (_selectIndex!=section) {
        
        _flag[_selectIndex] = 0;
        [index addIndex:_selectIndex];
    }
    
    _selectIndex = section;
    
    [_table reloadSections:index withRowAnimation:UITableViewRowAnimationAutomatic];
    
    //已经展开的一级分类才可以 自动选择二级分类第一个
    if (_flag[section]==1) {
        
        [self manualSelectRowAtIndex:[NSIndexPath indexPathForRow:0 inSection:section]];
    }
}



-(void)initNetDataWithShopID:(NSString*)shopID WithSpecifyCategory:(NSString*)cate
{
    _currentShopID = shopID;
    _specifyCategory = cate;
    
     THActivityView* loadV = [[THActivityView alloc]initActivityViewWithSuperView:self.superview];
    
    __weak ShopCategoryListView* wself = self;
    NetWorkRequest* categoryReq = [[NetWorkRequest alloc]init];
    [categoryReq shopGetCategoryWithShopID:shopID callBack:^(NSMutableArray *respond, NetWorkStatus error) {
        
        [loadV removeFromSuperview];
        if (error != NetWorkSuccess)
        {
            THActivityView* loadView = [[THActivityView alloc]initWithNetErrorWithSuperView:wself.superview];
            
            [loadView setErrorBk:^{
                [wself initNetDataWithShopID:shopID WithSpecifyCategory:cate];
            }];
            return ;
        }

        if (respond) {
          [self setDataArrAndSelectOneRow:respond];
        }
     }];
    [categoryReq startAsynchronous];
    
}

-(UIView*)tableCellSelectView
{
    UIView* selectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    selectView.backgroundColor = [UIColor whiteColor];
    
    
    UIView* separateDown = [[UIView alloc]init];
    separateDown.translatesAutoresizingMaskIntoConstraints = NO;
    separateDown.backgroundColor = FUNCTCOLOR(221, 221, 221);;
    [selectView addSubview:separateDown];
    [selectView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[separateDown]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separateDown)]];
    [selectView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[separateDown(0.5)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separateDown)]];
    
    return selectView;
}


-(UIView*)tableSelectView
{
    UIView* selectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    selectView.backgroundColor = [UIColor whiteColor];
    
    UIView* separateUp = [[UIView alloc]init];
    separateUp.translatesAutoresizingMaskIntoConstraints = NO;
    separateUp.backgroundColor = FUNCTCOLOR(221, 221, 221);
    [selectView addSubview:separateUp];
    [selectView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[separateUp]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separateUp)]];
    [selectView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[separateUp(0.5)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separateUp)]];
    
    
    UIView* separateDown = [[UIView alloc]init];
    separateDown.translatesAutoresizingMaskIntoConstraints = NO;
    separateDown.backgroundColor = separateUp.backgroundColor;
    [selectView addSubview:separateDown];
    [selectView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[separateDown]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separateDown)]];
    [selectView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[separateDown(0.5)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separateDown)]];
    
    
    UIView* colorView = [[UIView alloc]init];
    colorView.backgroundColor = DEFAULTNAVCOLOR;
    colorView.translatesAutoresizingMaskIntoConstraints = NO;
    [selectView addSubview:colorView];
    
    [selectView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[colorView(5)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(colorView)]];
    [selectView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[colorView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(colorView)]];
    return selectView;
}



@end
