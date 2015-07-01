//
//  PCollectionCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/6/30.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "PCollectionCell.h"
#import "UIImageView+WebCache.h"
@implementation PCollectionCell
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    _productImageView = [[UIImageView alloc]init];
    _productImageView.contentMode = UIViewContentModeScaleAspectFit;
    _productImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_productImageView];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_productImageView]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_productImageView)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_productImageView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_productImageView)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_productImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_productImageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    
    
    
    _titleL = [[UILabel alloc]init];
    _titleL.font = DEFAULTFONT(14);
    _titleL.translatesAutoresizingMaskIntoConstraints = NO;
    _titleL.textColor = DEFAULTGRAYCOLO;
    _titleL.numberOfLines = 0;
    _titleL.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_titleL];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_titleL]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleL)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_productImageView]-5-[_titleL]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_productImageView,_titleL)]];
    
    
    _priceL = [[UILabel alloc]init];
    _priceL.font = DEFAULTFONT(14);
    _priceL.translatesAutoresizingMaskIntoConstraints = NO;
    _priceL.textColor = DEFAULTNAVCOLOR;
    [self.contentView addSubview:_priceL];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_priceL attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_titleL attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleL]-5-[_priceL]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleL,_priceL)]];
    
   
    
    
    _countLabel = [[UILabel alloc]init];
    _countLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_countLabel];
    _countLabel.textColor = DEFAULTNAVCOLOR;
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.adjustsFontSizeToFitWidth = YES  ;
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_priceL]-10-[_countLabel(18)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_priceL,_countLabel)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_countLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_priceL attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    
    
    
    _addBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _addBt.tag  = 1;
    [_addBt setImage:[UIImage imageNamed:@"product_addBt"] forState:UIControlStateNormal];
    
    [_addBt addTarget:self action:@selector(setCountOfProduct:) forControlEvents:UIControlEventTouchUpInside];
    _addBt.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_addBt];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_addBt]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_addBt)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_addBt]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_addBt)]];

    return self;
}


-(void)setCountBk:(CollectionPChanged)completeBk
{
    if (completeBk) {
        _countBk = completeBk;
    }
}

-(void)setCountText:(int)count
{
    _countLabel.text = [NSString stringWithFormat:@"%d",count];
}


-(void)setPicUrl:(NSString *)url
{
    [_productImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"Default_Image"]];
}

-(void)setTitleStr:(NSString *)title
{
    _titleL.text = title;
}

-(void)setPriceStr:(NSString *)price
{
    _priceL.text = [NSString stringWithFormat:@"¥%@",price];
}


-(void)setCountOfProduct:(UIButton*)bt
{
    int count = [_countLabel.text intValue];
    count++;
    [self setCountText:count];//放在block 之前 防止block 中有释放self的操作导致 self 的代码崩溃
    
    if (_countBk) {
        _countBk(count);
    }
    
}



@end