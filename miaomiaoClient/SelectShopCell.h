//
//  SelectShopCell.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-13.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectShopCell : UITableViewCell
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UILabel* secondLabel;
@property(nonatomic,strong)UILabel* thirdLabel;
@property(nonatomic,strong)UILabel* fourthLabel;
-(UILabel*)getStatusLabel;
-(void)setFifthLabelStr:(NSString*)str;
-(void)setServerArr:(NSArray*)arr withSizeDic:(NSMutableDictionary*)dic
;
@end
