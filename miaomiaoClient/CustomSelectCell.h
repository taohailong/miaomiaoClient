//
//  CustomSelectCell.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-28.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSelectCell : UITableViewCell
{
    BOOL _isNeedSeparate;
}

-(void)setNeedSeparate:(BOOL)flag;
@end
