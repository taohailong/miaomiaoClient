//
//  PCollectionHeadView.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/7/1.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CollectionHeadBk) (void);
@interface PCollectionHeadView : UICollectionReusableView
{
    CollectionHeadBk _bk;
    UILabel* _titleLabel;
    UILabel* _endLabe;
    NSInteger _section;
}

-(void)setHeadBk:(CollectionHeadBk)bk;
-(void)setTitleLabelStr:(NSString*)str;
-(void)setDetailStr:(NSString*)str;
@end
