//
//  ProductCoverView.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-28.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCoverView : UIView

-(id)initWithSuperView:(UIView*)superView;
-(void)setImageViewWithAnimation:(BOOL)animation Url:(NSString*)url;
@end
