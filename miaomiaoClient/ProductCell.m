//
//  ProductCell.m
//  miaomiaoShop
//
//  Created by 陶海龙 on 15-4-23.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "ProductCell.h"
#import "UIImageView+WebCache.h"
@interface ProductCell()
{
}

@end
@implementation ProductCell
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self creatSubViews];
    return self;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self creatSubViews];
    return self;
}

-(void)creatSubViews
{
    _productImageView = [[UIImageView alloc]init];
    _productImageView.contentMode = UIViewContentModeScaleAspectFit;
    _productImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_productImageView];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_productImageView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_productImageView)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_productImageView]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_productImageView)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_productImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_productImageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    
    
    
    _titleL = [[UILabel alloc]init];
    _titleL.font = DEFAULTFONT(14);
    _titleL.translatesAutoresizingMaskIntoConstraints = NO;
    _titleL.textColor = DEFAULTGRAYCOLO;
    _titleL.numberOfLines = 0;
    _titleL.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_titleL];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_productImageView]-8-[_titleL]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_productImageView,_titleL)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_titleL(<=50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleL)]];
  
    
    _priceL = [[UILabel alloc]init];
    _priceL.font = DEFAULTFONT(14);
    _priceL.translatesAutoresizingMaskIntoConstraints = NO;
    _priceL.textColor = DEFAULTNAVCOLOR;
    [self.contentView addSubview:_priceL];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_productImageView]-8-[_priceL]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_productImageView,_priceL)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_priceL]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_priceL)]];
    
    
    _addBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _addBt.tag  = 1;
//    _addBt.backgroundColor = [UIColor redColor];
    [_addBt setImage:[UIImage imageNamed:@"product_addBt"] forState:UIControlStateNormal];
    
    [_addBt addTarget:self action:@selector(setCountOfProduct:) forControlEvents:UIControlEventTouchUpInside];
    _addBt.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_addBt];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_addBt]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_addBt)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_addBt attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_priceL attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    
    
    
    _countLabel = [[UILabel alloc]init];
    _countLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_countLabel];
    _countLabel.textColor = DEFAULTNAVCOLOR;
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.adjustsFontSizeToFitWidth = YES  ;
    _countLabel.font = DEFAULTFONT(15);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_countLabel]-2-[_addBt]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_countLabel,_addBt)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_countLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_addBt attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_countLabel(25)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_countLabel)]];
    
    
    _subtractBt = [UIButton buttonWithType:UIButtonTypeCustom];
//    _subtractBt.backgroundColor = [UIColor redColor];
    [_subtractBt setImage:[UIImage imageNamed:@"product_subtractBt"] forState:UIControlStateNormal];
    
    _subtractBt.hidden = YES;
     [_subtractBt addTarget:self action:@selector(setCountOfProduct:) forControlEvents:UIControlEventTouchUpInside];
       _subtractBt.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_subtractBt];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_subtractBt]-2-[_countLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_subtractBt,_countLabel)]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_subtractBt attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_addBt  attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];

 }


-(void)setCountBk:(CountChanged)completeBk
{
    if (completeBk) {
        _countBk = completeBk;
    }
}

-(void)setCountText:(int)count
{
     _countLabel.text = [NSString stringWithFormat:@"%d",count];
    if (count>0) {
        _countLabel.hidden = NO;
        _subtractBt.hidden = NO;
    }
    else
    {
        _countLabel.hidden = YES;
        _subtractBt.hidden = YES;
    }
    
}

-(void)setProductOnOff:(BOOL)flag
{
    _statueLabel.hidden = flag;
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
    BOOL isAdd = YES;
    if (bt.tag)
    {
        count++;
    }
    else
    {
        isAdd = NO;
        count--;
        count = count<0?0:count;
    }
    
    [self setCountText:count];//放在block 之前 防止block 中有释放self的操作导致 self 的代码崩溃
    
    if (_countBk) {
        _countBk(isAdd,count);
    }

    
//    _countLabel.text = [NSString stringWithFormat:@"%d",count];

}


@end
