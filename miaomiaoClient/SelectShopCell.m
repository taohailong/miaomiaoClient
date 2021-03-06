//
//  SelectShopCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-13.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "SelectShopCell.h"
#import "NSStringDrawView.h"
@interface SelectShopCell()
{
    UILabel* _scoreLabel;
    UILabel* _statusL;
    UILabel* _fifthLabel;
    NSStringDrawView* _drawView;
    CommentScoreView* _scoreView;
    
    UIButton* _favoriteBt;
    FavoriteBk _favoriteBk;
    
    UIImageView* _contentImage3;
    UIImageView* _contentImage2;
    UIImageView* _contentImage1;
}
@end
@implementation SelectShopCell
@synthesize titleLabel,secondLabel,thirdLabel,fourthLabel;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
//    UIView* backView = [[UIView alloc]init];
//    backView.backgroundColor = [UIColor whiteColor];
//    backView.translatesAutoresizingMaskIntoConstraints = NO;
//    [self addSubview:backView];
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[backView]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backView)]];
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-1-[backView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backView)]];

    
    
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.textColor = FUNCTCOLOR(64, 64, 64);
    self.titleLabel.font = DEFAULTFONT(16);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[titleLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[titleLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];

    _statusL = [[UILabel alloc]init];
    _statusL.textAlignment = NSTextAlignmentCenter;
    _statusL.layer.cornerRadius = 4;
    _statusL.layer.masksToBounds = YES;
    _statusL.backgroundColor = FUNCTCOLOR(221, 221, 221);
    _statusL.translatesAutoresizingMaskIntoConstraints = NO;
    _statusL.textColor = [UIColor whiteColor];
    _statusL.font = DEFAULTFONT(12);

    [self.contentView addSubview:_statusL];

    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_statusL attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    UILabel* titleL = self.titleLabel;
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[titleL]-10-[_statusL(45)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleL,_statusL)]];

//    scoreView
    
    
    _scoreView = [[CommentScoreView alloc]init];
    _scoreView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_scoreView];
    
    UILabel* t = self.titleLabel;
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_scoreView(88)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scoreView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[t]-0-[_scoreView(15)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(t,_scoreView)]];
    
    
    
    _scoreLabel = [[UILabel alloc]init];
    _scoreLabel.font = DEFAULTFONT(13);
    _scoreLabel.textColor = FUNCTCOLOR(255, 215, 53);
    _scoreLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_scoreLabel];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_scoreView]-5-[_scoreLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scoreView,_scoreLabel)]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_scoreLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_scoreView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
///////////////////////self.titleLabel//////////////////
    
    _contentImage1 = [[UIImageView alloc]init];
    _contentImage1.translatesAutoresizingMaskIntoConstraints = NO;
    _contentImage1.image = [UIImage imageNamed:@"selectShop_distance"];
    [self.contentView addSubview:_contentImage1];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_contentImage1]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentImage1)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel]-25-[_contentImage1]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel,_contentImage1)]];

    
    self.secondLabel = [[UILabel alloc]init];
    self.secondLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.secondLabel.textColor = FUNCTCOLOR(153, 153, 153);

    self.secondLabel.font = DEFAULTFONT(12);
    [self.contentView addSubview:self.secondLabel];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.secondLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_contentImage1 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_contentImage1]-4-[secondLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentImage1,secondLabel)]];

   ////////////////////////////
    
    
    _contentImage2 = [[UIImageView alloc]init];
    _contentImage2.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_contentImage2];
    
    _contentImage2.image = [UIImage imageNamed:@"selectShop_time"];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[secondLabel]-15-[_contentImage2]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(secondLabel,_contentImage2)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel]-25-[_contentImage2]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel,_contentImage2)]];

    
    self.thirdLabel = [[UILabel alloc]init];
    self.thirdLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.thirdLabel.font = self.secondLabel.font;
    self.thirdLabel.textColor = self.secondLabel.textColor;
    [self.contentView addSubview:self.thirdLabel];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.thirdLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_contentImage2 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_contentImage2]-4-[thirdLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentImage2,thirdLabel)]];
    
    
    
    ////////////////////
    
    
//    selectShop_minPrice
    _contentImage3 = [[UIImageView alloc]init];
    _contentImage3.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_contentImage3];
    
    _contentImage3.image = [UIImage imageNamed:@"selectShop_minPrice"];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[thirdLabel]-15-[_contentImage3]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(thirdLabel,_contentImage3)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentImage3 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.thirdLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    
    _fifthLabel = [[UILabel alloc]init];
    _fifthLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _fifthLabel.textColor = self.secondLabel.textColor;
    _fifthLabel.font = self.secondLabel.font;
    [self.contentView addSubview:_fifthLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_fifthLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_contentImage3 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_contentImage3]-4-[_fifthLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentImage3,_fifthLabel)]];

    
    
    
//  ///////////////////////////self.secondLabel/////
    
    UIImageView* contentImage4 = [[UIImageView alloc]init];
    contentImage4.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:contentImage4];
    
    contentImage4.image = [UIImage imageNamed:@"selectShop_address"];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[contentImage4]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentImage4)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_contentImage1]-10-[contentImage4]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentImage1,contentImage4)]];
    
    
    
    self.fourthLabel = [[UILabel alloc]init];
    self.fourthLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.fourthLabel.textColor = self.secondLabel.textColor;
    self.fourthLabel.font = self.secondLabel.font;
    [self.contentView addSubview:self.fourthLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.fourthLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contentImage4 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[contentImage4]-4-[fourthLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentImage4,fourthLabel)]];

//  ////////////////////////
    
    
    UIImageView* contentImage5 = [[UIImageView alloc]init];
    contentImage5.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:contentImage5];
    contentImage5.image = [UIImage imageNamed:@"selectShop_server"];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[contentImage5]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentImage5)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[contentImage4]-10-[contentImage5]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentImage4,contentImage5)]];
    
    _drawView = [[NSStringDrawView alloc]initWithFrame:CGRectZero];
    _drawView.backgroundColor = [UIColor clearColor];
    _drawView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_drawView];
    
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_drawView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentImage4  attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[contentImage5]-4-[_drawView]-2-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentImage5,_drawView)]];
    
     [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[contentImage4]-8-[_drawView]-3-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentImage4,_drawView)]];
    
//favoriteView
    
    _favoriteBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _favoriteBt.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_favoriteBt];
    [_favoriteBt addTarget:self action:@selector(favoriteAction:) forControlEvents:UIControlEventTouchUpInside];
    [_favoriteBt setImage:[UIImage imageNamed:@"selectShop_favorite"] forState:UIControlStateSelected];
    [_favoriteBt setImage:[UIImage imageNamed:@"selectShop_nofavorite"] forState:UIControlStateNormal];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_favoriteBt]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_favoriteBt)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_favoriteBt]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_favoriteBt)]];
    
    return self;
}

-(UILabel*)getStatusLabel
{
    return _statusL;
}

-(void)setFifthLabelStr:(NSString*)str
{
    if (str) {
        _fifthLabel.text = str;
    }
    
}

-(void)setServerArr:(NSArray*)arr withSizeDic:(NSMutableDictionary*)dic
{
    [_drawView setStings:arr withSizeDic:dic];
}

-(void)setScore:(float)score
{
    [_scoreView setScore:score];
    _scoreLabel.text = [NSString stringWithFormat:@"%.1f分",score];
}

-(UIButton*)getFavoriteView
{
    return _favoriteBt;
}

-(void)setFavorite:(BOOL)fav
{
    if (fav) {
        _favoriteBt.selected = YES;
    }
    else
    {
       _favoriteBt.selected = NO;
    }
}

-(void)setFavoriteBk:(FavoriteBk)bk
{
    _favoriteBk = bk;
}


-(void)favoriteAction:(UIButton*)bt
{
    if (_favoriteBk) {
        _favoriteBk();
    }
}


-(UIImageView*)getFirstImageView
{
    return _contentImage1;
}

-(UIImageView*)getSecondImageView
{
    return _contentImage2;
}

-(UIImageView*)getThirdImageView
{
    return _contentImage3;
}



@end
