//
//  ProductCoverView.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-28.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "ProductCoverView.h"
#import "UIImageView+WebCache.h"

@interface ProductCoverView ()
{
    UIImageView* _contentImage;
}
@end
@implementation ProductCoverView
-(id)initWithSuperView:(UIView*)superView
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewGesture:)];
    [self addGestureRecognizer:tap];
    
    _contentImage = [[UIImageView alloc]init];
    [self addSubview:_contentImage];
    
    [superView addSubview:self];
    return self;
}

-(void)setImageViewWithAnimation:(BOOL)animation Url:(NSString*)url
{
    _contentImage.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENWIDTH);
    
    [_contentImage setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"Default_Image"]];
    
    if (animation) {
        
        [UIView animateWithDuration:.2 animations:^{
            
            _contentImage.frame = CGRectMake(0, SCREENHEIGHT-SCREENWIDTH, SCREENWIDTH, SCREENWIDTH);
        }];
    }
    else
    {
         _contentImage.frame = CGRectMake(0, SCREENHEIGHT-SCREENWIDTH, SCREENWIDTH, SCREENWIDTH);
    }
}

-(void)tapViewGesture:(UIGestureRecognizer*)gesture
{
    [self removeFromSuperview];
}

@end
