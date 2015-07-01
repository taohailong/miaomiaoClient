//
//  AdvertiseCollectionCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/6/30.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "AdvertiseCollectionCell.h"
#import "PosterScorllView.h"

@interface AdvertiseCollectionCell ()
{
    PosterScorllView* _scorll;
}
@end

@implementation AdvertiseCollectionCell
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
//    self.backgroundColor = [UIColor blueColor];
    _scorll = [[PosterScorllView alloc]initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:_scorll];
    return self;
}

-(void)setImageDataArr:(NSArray*)arr
{
    [_scorll loadImageViewsWithData:arr];
}


@end
