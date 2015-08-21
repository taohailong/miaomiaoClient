//
//  CommentScoreView.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/8/21.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "CommentScoreView.h"

@implementation CommentScoreView

-(id)init
{
    self = [super init];
    self.backgroundColor = [UIColor whiteColor];
    return self;
}
-(void)setScore:(float)score
{
    if (_score>5) {
        return;
    }
    _score = score;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    int total = 5;
    
    int full = (int)_score;
    UIImage* starfull = [UIImage imageNamed:@"starSmall_full"];
    CGRect frame = CGRectMake(1, 1, 13, 13);
    for ( int i = 0; i<full; i++) {
        [starfull drawInRect:frame];
        frame.origin.x += 5+ frame.size.width;
    }
    
    float half = _score-full;
    if (half>0) {
        UIImage* starhalf = [UIImage imageNamed:@"starSmall_half"];
        [starhalf drawInRect:frame];
         frame.origin.x += 5+ frame.size.width;
    }
    
    int intEmpty = total - (int)half;
    UIImage* starempty = [UIImage imageNamed:@"starSmall_empty"];
    
    for ( int i = 0; i<intEmpty; i++) {
        
        [starempty drawInRect:frame];
        frame.origin.x += 5+ frame.size.width;
    }

}
@end
