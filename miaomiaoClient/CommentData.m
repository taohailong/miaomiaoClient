//
//  CommentData.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/8/21.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "CommentData.h"

@implementation CommentData
@synthesize shopName,score,comments,creatTime;
@synthesize telphone;
-(CGSize)calculateStringHeightWithFont:(UIFont *)font WithSize:(CGSize)size
{
    if (font.pointSize == _fontSize) {
        return _size;
    }
    _fontSize = font.pointSize;
    
    if(self.comments.length==0)
    {
        return CGSizeMake(0, 0);
    }
    
    CGRect frame = [self.comments boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    _size = frame.size;
    
//    _size = [self.comments sizeWithAttributes:@{NSFontAttributeName:font}];
    return _size;
}

@end
