//
//  OrderInfoProductCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/6/4.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "OrderInfoProductCell.h"
#import "UIImageView+WebCache.h"

@interface OrderInfoProductCell()
{
    UIImageView* _cellImage;
    UILabel* _contentLabel;
    UILabel* _countLabel;
    UILabel* _moneyLabel;
    NSArray* _imageVLayouts;
    NSLayoutConstraint* _ImageScaleLayout;
}
@end
@implementation OrderInfoProductCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _cellImage = [[UIImageView alloc]init];
    _cellImage.contentMode = UIViewContentModeScaleAspectFit;
    _cellImage.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_cellImage];
    
    
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_contentLabel];
    
    
    
    _countLabel = [[UILabel alloc]init];
    _countLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_countLabel];
    
    
    
    _moneyLabel = [[UILabel alloc]init];
    _moneyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_moneyLabel];
    
    [self setLayout];
    
    return self;
}

-(void)setLayout
{
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-13-[_cellImage]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_cellImage)]];
    
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_cellImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];

    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_cellImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_cellImage   attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_cellImage]-10-[_contentLabel]->=85-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_cellImage,_contentLabel)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_moneyLabel]-13-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_moneyLabel)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_moneyLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_countLabel]-15-[_moneyLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_countLabel,_moneyLabel)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_countLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
}



-(void)setCellImageWithUrl:(NSString *)url
{
    _imageVLayouts = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_cellImage]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_cellImage)];
    
    [self.contentView addConstraints:_imageVLayouts];
    
    _ImageScaleLayout = [NSLayoutConstraint constraintWithItem:_cellImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_cellImage   attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    
    
    [self.contentView addConstraint:_ImageScaleLayout];
    [_cellImage setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"Default_Image"]];
}

-(void)setCellImageWith:(UIImage*)image
{
//    _ImageScaleLayout.active = NO;
//    [NSLayoutConstraint deactivateConstraints:_imageVLayouts];
    
    if (_ImageScaleLayout) {
       [self.contentView removeConstraint:_ImageScaleLayout];
    }
    if (_imageVLayouts) {
        [self.contentView removeConstraints:_imageVLayouts];
    }
   
    _cellImage.image = image;
    
}


-(UILabel*)getContentLabel
{
    return _contentLabel;
}


-(UILabel*)getCountLabel
{
    return _countLabel;
}

-(UILabel*)getMoneyLabel
{
    return _moneyLabel;
}




@end
