//
//  ProductCell.h
//  miaomiaoShop
//
//  Created by 陶海龙 on 15-4-23.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CountChanged)(BOOL isAdd,int count);
@interface ProductCell : UITableViewCell
{
    UIImageView* _productImageView;
    UILabel* _titleL;
    UILabel* _priceL;
    UILabel* _statueLabel;
    
    UIButton* _addBt;
    UIButton* _subtractBt;
    UILabel* _countLabel;
    
    CountChanged _countBk;
}
-(UIImageView*)getImageView;
-(void)setCountText:(int)count;
-(void)setCountBk:(CountChanged)completeBk;
-(void)setPicUrl:(NSString*)url;
-(void)setTitleStr:(NSString*)title;
-(void)setPriceStr:(NSString*)price;
-(void)setProductOnOff:(BOOL)flag;
@end
