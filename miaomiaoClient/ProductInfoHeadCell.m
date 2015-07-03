//
//  ProductInfoHeadCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/7/2.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "ProductInfoHeadCell.h"

@implementation ProductInfoHeadCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    return self;
}

-(void)layoutSubviews
{
//    NSLog(@" %@ %@",NSStringFromCGRect(self.frame),NSStringFromCGRect(self.contentView.frame));
    [super layoutSubviews];
    [self setScrollView];
}

-(void)setScrollView
{
    if (_scrollView) {
        return;
    }
    _scrollView = [[PosterScorllView alloc]
                   initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:_scrollView];
    [_scrollView loadImageViewsWithData:_picArr];
}


-(void)setProductImages:(NSArray*)arr
{
    _picArr = arr;
}


-(void)posterViewDidSelectAtIndex:(NSInteger)index WithData:(id)data
{

}
@end
