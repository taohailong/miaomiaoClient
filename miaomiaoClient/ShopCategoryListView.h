//
//  ShopCategoryList.h
//  miaomiaoShop
//
//  Created by 陶海龙 on 15-4-23.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopCategoryListView;

@protocol ShopCategoryProtocol <NSObject>


-(void)didSelectMainCategory:(NSString*)categoryID WithName:(NSString*)name;
-(void)didSelectSubCategory:(NSString*)categoryID WithName:(NSString*)name;

-(void)didSelectCategoryIndexWith:(NSString*)categoryID WithShopID:(NSString*)shopID;

@end
@interface ShopCategoryListView : UIView<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
     int* _flag;
    NSInteger _selectIndex;
    UITableView* _table;
    NSMutableArray* _dataArr;
    NSString* _currentShopID;
    NSString* _specifyCategory;
}
@property(nonatomic,weak)IBOutlet id<ShopCategoryProtocol>delegate;

-(void)setDataArrAndSelectOneRow:(NSMutableArray *)dataArr;
-(void)initNetDataWithShopID:(NSString*)shopID WithSpecifyCategory:(NSString*)cate;
-(void)showSpecifyCategory:(NSString*)category;
@end
