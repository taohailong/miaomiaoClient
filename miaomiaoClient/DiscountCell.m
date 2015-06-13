//
//  DiscountCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/6/8.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "DiscountCell.h"
@interface DiscountCell()
{
    UILabel* _titleLabel;
    UILabel* _firstLabel;
    UILabel* _secondLabel;
    UILabel* _thirdLabel;
    UIView* _backView;
    UIImageView* _statusImage;
}
@end
@implementation DiscountCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.contentView.backgroundColor = FUNCTCOLOR(243, 243, 243);
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }

    
    
    
    _backView = [[UIView alloc]init];
    _backView.translatesAutoresizingMaskIntoConstraints = NO;
    _backView.backgroundColor = DEFAULTNAVCOLOR;
    [self.contentView addSubview:_backView];
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius = 4;
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-14-[_backView]-14-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backView)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_backView]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backView)]];
    
    
    UIImageView*topView = [[UIImageView alloc]init];
    topView.translatesAutoresizingMaskIntoConstraints = NO;
    [_backView addSubview:topView];
    
    UIImage* image = [UIImage imageNamed:@"discount_topImage"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    topView.image = image;

    [_backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[topView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(topView)]];
    [_backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[topView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(topView)]];
    
    
    UIView* _backView1 = [[UIView alloc]init];
    _backView1.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_backView1];
    _backView1.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-14-[_backView1]-14-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backView1)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-17-[_backView1]-17-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backView1)]];
    
    
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_backView1 addSubview:_titleLabel];
    
    [_backView1 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_titleLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
    
    [_backView1 addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_backView1 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    
    
    
    _firstLabel = [[UILabel alloc]init];
    
    _firstLabel.textColor = DEFAULTGRAYCOLO;
    _firstLabel.font = DEFAULTFONT(20);
    _firstLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_backView1 addSubview:_firstLabel];
    
    [_backView1 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_firstLabel]-35-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_firstLabel)]];
    [_backView1 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[_firstLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_firstLabel)]];
    
    
    
    _secondLabel = [[UILabel alloc]init];
    _secondLabel.font =DEFAULTFONT(13);
    _secondLabel.textColor = FUNCTCOLOR(197, 197, 197);
    _secondLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_backView1 addSubview:_secondLabel];
    
    [_backView1 addConstraint:[NSLayoutConstraint constraintWithItem:_secondLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_firstLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    
    [_backView1 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_secondLabel]-3-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_secondLabel)]];
    
    [_backView1 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_firstLabel]-5-[_secondLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_firstLabel,_secondLabel)]];
    
    
    
    _thirdLabel = [[UILabel alloc]init];
    _thirdLabel.font =DEFAULTFONT(13);
    _thirdLabel.textColor = FUNCTCOLOR(197, 197, 197);
    _thirdLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_backView1 addSubview:_thirdLabel];
    [_backView1 addConstraint:[NSLayoutConstraint constraintWithItem:_thirdLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_firstLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    
    [_backView1 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_secondLabel]-5-[_thirdLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_secondLabel,_thirdLabel)]];

    
    _statusImage = [[UIImageView alloc]init];
    //_statusImage.backgroundColor = [UIColor redColor];
    _statusImage.translatesAutoresizingMaskIntoConstraints = NO;
    [_backView1 addSubview:_statusImage];

    [_backView1 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[_statusImage]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_statusImage)]];
    
    [_backView1 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_statusImage]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_statusImage)]];
    
    return self;
}

-(void)setTicketName:(NSString*)str
{
   _firstLabel.text = str;
}

-(void)setTicketStatus:(DiscountTicketStatus)status
{
    if (status == DiscountStatusValid) {
        _backView.backgroundColor = DEFAULTNAVCOLOR;
        _titleLabel.textColor = DEFAULTBLACK;
        _statusImage.hidden = YES;
    }
    else if (status == DiscountStatusUsed)
    {
        _statusImage.hidden = NO;
        _statusImage.image = [UIImage imageNamed:@"discount_used"];
        _backView.backgroundColor = FUNCTCOLOR(197, 197, 197);
        _titleLabel.textColor = FUNCTCOLOR(197, 197, 197);
    }
    else
    {
        _statusImage.image = [UIImage imageNamed:@"discount_invalid"];
        _statusImage.hidden = NO;
        _backView.backgroundColor = FUNCTCOLOR(197, 197, 197);
        _titleLabel.textColor = FUNCTCOLOR(197, 197, 197);
    }
}


-(void)setTitleLabelAttribute:(NSString*)str
{
    NSString* titleStr = [NSString stringWithFormat:@"¥ %@",str];
    NSMutableAttributedString* attribute = [[NSMutableAttributedString alloc]initWithString:titleStr ];
    [attribute addAttribute:NSFontAttributeName value:DEFAULTFONT(18) range:NSMakeRange(0, 1)];
    
     [attribute addAttribute:NSFontAttributeName value:DEFAULTFONT(30) range:NSMakeRange(2, titleStr.length-2)];
    _titleLabel.attributedText = attribute;
 
}


-(void)setTicketMinMoney:(float)money
{
    if (money == 0) {
        _thirdLabel.text = @"";
    }
    else
    {
        _thirdLabel.text = [NSString stringWithFormat:@"满%.0f元使用",money];
    }


}



-(UILabel*)getFirstLabel
{
    return _firstLabel;
}

-(UILabel*)getSecondLabel
{
    return _secondLabel;
}

-(UILabel*)getThirdLabel
{

    return _thirdLabel;
}

@end
