//
//  NSAttributedString+Frame.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-28.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "NSAttributedString+Frame.h"
#import <CoreText/CoreText.h>
@implementation NSAttributedString (Frame)


-(CGSize)sizeConstrainedToSize:(CGSize)maxSize
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge_retained CFAttributedStringRef)self);
    CFRange fitCFRange = CFRangeMake(0,0);
    
    CGSize sz = CTFramesetterSuggestFrameSizeWithConstraints(framesetter,CFRangeMake(0,0),NULL,maxSize,&fitCFRange);
    if (framesetter) CFRelease(framesetter);
//    if (fitRange) *fitRange = NSMakeRange(fitCFRange.location, fitCFRange.length);
    //    return CGSizeMake( floorf(sz.width) , floorf(sz.height) );
    return CGSizeMake(floorf(sz.width+1) , floorf(sz.height+1) ); // take 1pt of margin for security
}

@end
