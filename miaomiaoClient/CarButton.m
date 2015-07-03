//
//  CarButton.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-27.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "CarButton.h"
#import "CarButtonLayer.h"
@interface CarButton()
{
    CarButtonLayer* _countLayer ;
}
@end
@implementation CarButton

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    _countLayer = [[CarButtonLayer alloc]init];
    _countLayer.backgroundColor = [UIColor whiteColor].CGColor;
    _countLayer.borderWidth = 1;
    _countLayer.borderColor = DEFAULTNAVCOLOR.CGColor;
    _countLayer.position = CGPointMake(42, 17);
    [self.layer addSublayer:_countLayer];
    
     return self;
}

-(void)setButtonTitleText:(NSString*)str
{
    if ([str intValue]==0) {
         [self setImage:[UIImage imageNamed:@"shopCar_Icon_0"] forState:UIControlStateNormal];
        [_countLayer removeFromSuperlayer];
        return;
    }
    else
    {
        [self setImage:[UIImage imageNamed:@"shopCarIcon"] forState:UIControlStateNormal];
        [self.layer addSublayer:_countLayer];
    }

    NSMutableAttributedString* content = [[NSMutableAttributedString alloc] initWithString:str];
    [content addAttribute:NSFontAttributeName value:DEFAULTFONT(11) range:NSMakeRange(0, str.length)];
    [content addAttribute:NSForegroundColorAttributeName value:DEFAULTNAVCOLOR range:NSMakeRange(0, str.length)];
    [_countLayer setDrawString:content];
}


@end
