//
//  CarButtonLayer.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-28.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CarButtonLayer : CALayer
{
    NSAttributedString* _currentAttribute;
    CGSize _contentSize;
}
-(void)setDrawString:(NSAttributedString*)strAttribute;
@end
