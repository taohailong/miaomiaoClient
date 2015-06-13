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
    _countLayer.backgroundColor = DEFAULTNAVCOLOR.CGColor;
//    _countLayer.frame = CGRectMake(35, 10, 0, 0);
    _countLayer.position = CGPointMake(42, 13);
    [self.layer addSublayer:_countLayer];
    
     return self;
}

-(void)setButtonTitleText:(NSString*)str
{
    NSMutableAttributedString* content = [[NSMutableAttributedString alloc] initWithString:str];
    [content addAttribute:NSFontAttributeName value:DEFAULTFONT(13) range:NSMakeRange(0, str.length)];
    [content addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, str.length)];
    [_countLayer setDrawString:content];

}


@end
