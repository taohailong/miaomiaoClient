//
//  NSAttributedString+Frame.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-28.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSAttributedString (Frame)
// fitRange 传 NULL
//-(CGSize)sizeConstrainedToSize:(CGSize)maxSize fitRange:(NSRange*)fitRange;
-(CGSize)sizeConstrainedToSize:(CGSize)maxSize;
@end
