//
//  OrderInfoTopCell.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/6/3.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _ButtonActionSort{
  ButtonActionOne,
  ButtonActionTwo,
  ButtonActionThress
}ButtonActionSort;
typedef void (^GeneralButtonBk)(ButtonActionSort actionType);

@interface OrderInfoTopCell : UITableViewCell
{
    GeneralButtonBk _generalBk;
}
-(void)setGeneralButtonActionBk:(GeneralButtonBk)bk;
-(UIButton*)getCellButtonWithType:(ButtonActionSort)type;
-(void)setCellImage:(UIImage*)image;
-(UILabel*)getCellLabel;
@end
