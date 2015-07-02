//
//  ShopHeadCell.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/7/2.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FourLabelCell.h"
@interface ShopHeadCell :FourLabelCell
{
    UILabel* _fifthLabel;
}
-(UILabel*)getFifthLabel;
@end
