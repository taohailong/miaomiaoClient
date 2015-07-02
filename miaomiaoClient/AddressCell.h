//
//  AddressCell.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-22.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressCell : UITableViewCell
{
    UILabel* _textLabel;
    UILabel* _detailLabel;
    UIImageView* _contentImageView;
}
-(void)setLayout;
-(UILabel*)getTitleLabel;
-(UILabel*)getDetailLabel;
@end
