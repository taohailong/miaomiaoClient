//
//  SelectShopCell.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-13.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentScoreView.h"
typedef void (^FavoriteBk)(void);

@interface SelectShopCell : UITableViewCell

@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UILabel* secondLabel;
@property(nonatomic,strong)UILabel* thirdLabel;
@property(nonatomic,strong)UILabel* fourthLabel;

-(void)setFavoriteBk:(FavoriteBk)bk;
-(void)setFavorite:(BOOL)fav;
-(UIButton*)getFavoriteView;


-(void)setScore:(float)score;
-(UILabel*)getStatusLabel;
-(void)setFifthLabelStr:(NSString*)str;
-(void)setServerArr:(NSArray*)arr withSizeDic:(NSMutableDictionary*)dic
;
-(UIImageView*)getFirstImageView;
-(UIImageView*)getSecondImageView;
-(UIImageView*)getThirdImageView;
@end
