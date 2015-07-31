//
//  ShopSelectAreaCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/7/29.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "ShopSelectAreaCell.h"
@interface ShopSelectAreaCell()
{
    UILabel* _titleL;
    
    UIImageView* _detailImage;
    UILabel* _detailL;
}
@end
@implementation ShopSelectAreaCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.contentView.backgroundColor = [UIColor whiteColor];
    _titleL = [[UILabel alloc]init];
    _titleL.translatesAutoresizingMaskIntoConstraints = NO;
    _titleL.font = DEFAULTFONT(14);
    _titleL.textColor = FUNCTCOLOR(153, 153, 153);
    [self.contentView addSubview:_titleL];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_titleL]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleL)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_titleL]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleL)]];
    
    _detailImage = [[UIImageView alloc]init];
    _detailImage.image = [UIImage imageNamed:@"selectShop_address"];
    _detailImage.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_detailImage];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_detailImage]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_detailImage)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleL]-10-[_detailImage]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleL,_detailImage)]];
    
    
    _detailL = [[UILabel alloc]init];
    _detailL.font = DEFAULTFONT(12);
    _detailL.textColor = FUNCTCOLOR(194, 194, 194);
    _detailL.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_detailL];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_detailImage]-5-[_detailL]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_detailImage,_detailL)]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_detailL attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_detailImage attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];

    return self;
}

-(void)setTitleStr:(NSString*)str
{
    if (str) {
        _titleL.text = str;
    }
}


-(void)setDetailStr:(NSString*)str
{
    if (str) {
        _detailL.text = str;
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
