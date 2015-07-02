//
//  PosterScorllView.h
//  yiwugou
//
//  Created by yiwugou on 13-8-13.
//  Copyright (c) 2013年 yiwugou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PosterScorllView;
@protocol PosterProtocol <NSObject>

-(void)posterViewDidSelectAtIndex:(NSInteger)index WithData:(id)data;


@end
@interface PosterScorllView : UIView<UIScrollViewDelegate>
{
    UIScrollView* scroll ;
    NSArray* dataArr ;
    UIPageControl* page;
    NSMutableArray* imageArr;
}
@property(nonatomic,weak)id<PosterProtocol>delegate;
-(void)invalidTimer;
-(void)loadImageViewsWithData:(NSArray*)arr
;
@end
