//
//  ProductInfoHeadCell.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/7/2.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PosterScorllView.h"
@interface ProductInfoHeadCell : UITableViewCell<PosterProtocol>
{
    NSArray* _picArr;
    PosterScorllView* _scrollView;
}
-(void)setProductImages:(NSArray*)arr;
//-(void)setScrollView;
@end
