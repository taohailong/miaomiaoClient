//
//  OrderInfoProductCell.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/6/4.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderInfoProductCell : UITableViewCell
-(void)setCellImageWith:(UIImage*)image;
-(void)setCellImageWithUrl:(NSString*)url;
-(UILabel*)getContentLabel;
-(UILabel*)getCountLabel;
-(UILabel*)getMoneyLabel;
@end
