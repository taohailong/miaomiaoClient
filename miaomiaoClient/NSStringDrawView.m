//
//  NSStringDrawView.m
//  Archiver
//
//  Created by 陶海龙 on 15/7/24.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "NSStringDrawView.h"
#import <CoreText/CoreText.h>
@implementation NSStringDrawView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

-(void)setStringAndParseSize:(NSArray*)strs
{
    if (_strArr == strs) {
        return;
    }
    _strArr = strs;

    _drawElement = [[NSMutableDictionary alloc]init];
    
    for (NSString* temp in strs)
    {
        CGSize size = [temp sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];

        [_drawElement setObject:NSStringFromCGSize(size)  forKey:temp];
    }
}


-(void)setStings:(NSArray *)strs withSizeDic:(NSMutableDictionary*)dic
{
    if (_strArr == strs) {
        return;
    }
    _strArr = strs;
    _drawElement = dic;
}



- (void)drawRect:(CGRect)rect {
    
    if (_strArr==nil||_drawElement==nil) {
        return;
    }
    NSString* server = @"服务范围：";
    [server drawAtPoint:CGPointMake(0, 1) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:FUNCTCOLOR(153, 153, 153)}];
    
    
    int loop = 0;//两行以后的不再显示
    CGRect vframe = CGRectMake(55, 0, 0, 0);
    for (NSString* str in _strArr)
    {
        CGSize strSize = CGSizeFromString(_drawElement[str]);

        if (strSize.width+SPACEWIDTH + vframe.origin.x + HORIZONTALSPACE*2 >CGRectGetWidth(self.frame))
        {
            loop++;
            if (loop==3) {
                return;
            }
            vframe.origin.y += strSize.height+VERTICALSPACE*2+SPACEHEIGHT;
            vframe.origin.x = 1;
        }
        vframe.size.width = strSize.width +HORIZONTALSPACE*2;
        vframe.size.height = strSize.height+VERTICALSPACE*2;
        
        UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:vframe  cornerRadius:5.0f];
        
        [FUNCTCOLOR(243, 243, 243) setFill];
        [roundedRect fillWithBlendMode:kCGBlendModeNormal alpha:1];
        [str drawInRect:CGRectMake(CGRectGetMinX(vframe)+HORIZONTALSPACE,CGRectGetMinY(vframe)+VERTICALSPACE,strSize.width , strSize.height) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:FUNCTCOLOR(197, 197,197)}];
        vframe.origin.x += vframe.size.width + SPACEWIDTH;
    }
    
    
    
  
    //    CGMutablePathRef Path = CGPathCreateMutable();
    //    CGContextRef contexts = UIGraphicsGetCurrentContext();
    //
    //    CGContextSetTextMatrix(contexts, CGAffineTransformIdentity);
    //
    //    CGContextSaveGState(contexts);
    //
    //
    //    CGContextTranslateCTM(contexts , 0 ,self.bounds.size.height);
    //    CGContextScaleCTM(contexts, 1.0 ,-1.0);
    
    
    //        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString( (__bridge_retained CFAttributedStringRef)str);
    //
    //
    //        CGPathAddRect(Path, NULL ,CGRectMake(CGRectGetMinX(vframe)+SPACEWIDTH/2, CGRectGetHeight(self.frame)- (CGRectGetMinY(vframe)+SPACEHEIGHT/2)-strSize.height,strSize.width , strSize.height));
    //
    //        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    //        CTFrameDraw(frame,contexts);
    //
    //
    //
    //
    //        CFRelease(frame);
    //        CFRelease(framesetter);
    
   
    
//     CGContextRestoreGState(contexts);
    
 //    CGContextMoveToPoint(contexts, 0, 30);
    
//    CGContextTranslateCTM(contexts , 0 ,self.bounds.size.height);
//    
//    //缩放x，y轴方向缩放，－1.0为反向1.0倍,坐标系转换,沿x轴翻转180度
//    CGContextScaleCTM(contexts, 1.0 ,-1.0);
//
//    
//     CGContextTranslateCTM(contexts , 0 ,0);
    
    
    
    
    
//    CGPathRelease(Path);
    
    


    return;
    
    CGFloat width = 80;
    
    CGFloat height = 20;
    
    // 简便起见，这里把圆角半径设置为长和宽平均值的1/10
    
    CGFloat radius = (width + height) * 0.05;
    
    // 获取CGContext，注意UIKit里用的是一个专门的函数
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    // 移动到初始点
    
    CGContextMoveToPoint(context, radius, 0);
    
    // 绘制第1条线和第1个1/4圆弧，右上圆弧
    
    CGContextAddLineToPoint(context, width - radius,0);
    
    CGContextAddArc(context, width - radius, radius, radius, -0.5 *M_PI,0.0, 0);
    
    // 绘制第2条线和第2个1/4圆弧，右下圆弧
    
    CGContextAddLineToPoint(context, width, height - radius);
    
    CGContextAddArc(context, width - radius, height - radius, radius,0.0,0.5 * M_PI,0);
    
    // 绘制第3条线和第3个1/4圆弧，左下圆弧
    
    CGContextAddLineToPoint(context, radius, height);
    
    CGContextAddArc(context, radius, height - radius, radius,0.5 *M_PI, M_PI,0);
    
    // 绘制第4条线和第4个1/4圆弧，左上圆弧
    
    CGContextAddLineToPoint(context, 0, radius);
    
    CGContextAddArc(context, radius, radius, radius,M_PI,1.5 * M_PI,0);
    
    // 闭合路径
    
    CGContextClosePath(context);
    
    // 填充半透明红色
    
    CGContextSetRGBFillColor(context,1.0,0.0,0.0,0.5);
    
    CGContextDrawPath(context,kCGPathFill);    // Drawing code
}


@end
