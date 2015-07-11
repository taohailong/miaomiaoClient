//
//  UICustomActionView.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/6/10.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UICustomActionView,DiscountData;
@protocol CustomActionProtocol <NSObject>

-(void)actionViewSelectWithData:(id)obj;

@end
@interface UICustomActionView : UIView

@property(nonatomic,weak)id<CustomActionProtocol>delegate;
-(void)setSelectDiscount:(DiscountData*)dis;
-(void)showPopView;
-(void)setMinPrice:(float)minPrice;
-(id)initWithTitle:(NSString*)title WithDataArr:(NSArray*)arr;
@end
