//
//  NSStringDrawView.h
//  Archiver
//
//  Created by 陶海龙 on 15/7/24.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SPACEWIDTH 5
#define SPACEHEIGHT 5
#define HORIZONTALSPACE 5
#define VERTICALSPACE 2.5

@interface NSStringDrawView : UIView
{
    NSMutableAttributedString* _attributeS;
//    CGSize strSize;
    NSArray* _strArr;
    NSMutableDictionary* _drawElement;
}
-(void)setStringAndParseSize:(NSArray*)strs;


-(void)setStings:(NSArray *)strs withSizeDic:(NSMutableDictionary*)dic;
@end
