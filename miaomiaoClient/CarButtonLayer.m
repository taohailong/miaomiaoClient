//
//  CarButtonLayer.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-28.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "CarButtonLayer.h"
#import <CoreText/CoreText.h>
#import "NSAttributedString+Frame.h"

@implementation CarButtonLayer

-(id)init
{
    self = [super init];
    self.contentsScale = [UIScreen mainScreen].scale;
    self.masksToBounds = YES;
    return self;
}


-(void)setDrawString:(NSAttributedString *)strAttribute
{
    _currentAttribute = strAttribute;
    
    _contentSize = [strAttribute sizeConstrainedToSize:CGSizeMake(100, 50)];
    
    if ( _contentSize.height>_contentSize.width) {
       self.bounds = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds), _contentSize.height+2, _contentSize.height+2);
       self.cornerRadius = _contentSize.height/2;
    }
    else
    {
        self.bounds = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds), _contentSize.width+2, _contentSize.height+2);
        self.cornerRadius = _contentSize.height/2;
    }
    
    [self setNeedsDisplay];
}

-(void)drawInContext:(CGContextRef)ctx
{
    if (_currentAttribute==nil) {
        return;
    }
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge_retained  CFAttributedStringRef)_currentAttribute);
    
    CGMutablePathRef Path = CGPathCreateMutable();
    CGPathAddRect(Path, NULL ,CGRectMake((self.bounds.size.width-_contentSize.width)/2, 1 ,self.bounds.size.width , self.bounds.size.height-2));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    
    
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    
    CGContextSaveGState(ctx);
    
    CGContextTranslateCTM(ctx , 0 ,self.bounds.size.height);
    
    //缩放x，y轴方向缩放，－1.0为反向1.0倍,坐标系转换,沿x轴翻转180度
    CGContextScaleCTM(ctx, 1.0 ,-1.0);
    
    CTFrameDraw(frame,ctx);
    
    CGContextRestoreGState(ctx);
    
    CFRelease(frame);
    CGPathRelease(Path);
    CFRelease(framesetter);
}
@end
