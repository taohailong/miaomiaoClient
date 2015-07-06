//
//  DiscountActionCell.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/6/10.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "DiscountActionCell.h"
@interface DiscountActionCell()
{
    UIImageView* _leftImage;
    UIImageView* _statusImage;
    UIView* backView;
}
@end
@implementation DiscountActionCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.contentView.backgroundColor = FUNCTCOLOR(243, 243, 243);
 ;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    backView = [[UIView alloc]init];
    backView.translatesAutoresizingMaskIntoConstraints = NO;
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[backView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backView)]];
     [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[backView]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backView)]];
    
    [_firstLabel removeFromSuperview];
    [backView addSubview:_firstLabel];
    

    _firstLabel.textColor = [UIColor whiteColor];
    _firstLabel.backgroundColor = DEFAULTNAVCOLOR;
    _firstLabel.textAlignment = NSTextAlignmentCenter;
//    _firstLabel.enabled = NO;
    
    [_secondLabel removeFromSuperview];
    [backView addSubview:_secondLabel];

    _secondLabel.textColor = DEFAULTBLACK;
    _secondLabel.font = DEFAULTFONT(14);
    
    
    [_thirdLabel removeFromSuperview];
    [backView addSubview:_thirdLabel];

    _thirdLabel.textColor = DEFAULTGRAYCOLO;
    _thirdLabel.font = DEFAULTFONT(11);
    
    
    [_fourthLabel removeFromSuperview];
    [backView addSubview:_fourthLabel];

    _fourthLabel.textColor = DEFAULTGRAYCOLO;
    _fourthLabel.font = DEFAULTFONT(11);
    
    
    _leftImage = [[UIImageView alloc]init];
    _leftImage.translatesAutoresizingMaskIntoConstraints = NO;
    _leftImage.image = [UIImage imageNamed:@"action_discountCell_separate"];
    [backView addSubview:_leftImage];
    
    _statusImage = [[UIImageView alloc]init];
    //_statusImage.backgroundColor = [UIColor redColor];
    _statusImage.translatesAutoresizingMaskIntoConstraints = NO;
    [backView addSubview:_statusImage];
    
  

    return self;
}

-(void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType
{
    if (accessoryType==UITableViewCellAccessoryCheckmark) {
        self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"commit_selectCell"]];
    }
    else
    {
        self.accessoryView = nil;
        [super setAccessoryType:accessoryType];
    }
}



-(void)setLayout
{
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_firstLabel(85)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_firstLabel)]];
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_firstLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_firstLabel)]];
    
    

    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_firstLabel]-0-[_leftImage]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_firstLabel,_leftImage)]];
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_leftImage]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_leftImage)]];

    
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_leftImage]-20-[_secondLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_leftImage,_secondLabel)]];
    
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[_secondLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_secondLabel)]];

    
    
    
    
    [backView addConstraint:[NSLayoutConstraint constraintWithItem:_fourthLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_secondLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_fourthLabel]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_fourthLabel)]];
    
    
    
    [backView addConstraint:[NSLayoutConstraint constraintWithItem:_thirdLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_secondLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];

    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_thirdLabel]-10-[_fourthLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_thirdLabel,_fourthLabel)]];
    
    
    
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[_statusImage]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_statusImage)]];
    
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_statusImage]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_statusImage)]];
}


-(void)setTitleLabelAttribute:(NSString*)str
{
    NSString* titleStr = [NSString stringWithFormat:@"¥%@",str];
    NSMutableAttributedString* attribute = [[NSMutableAttributedString alloc]initWithString:titleStr attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [attribute addAttribute:NSFontAttributeName value:DEFAULTFONT(15) range:NSMakeRange(0, 1)];
    
    [attribute addAttribute:NSFontAttributeName value:DEFAULTFONT(27) range:NSMakeRange(1, titleStr.length-1)];
    _firstLabel.attributedText = attribute;
}


-(void)setTicketStatus:(DiscountTicketStatus)status
{
    if (status == DiscountStatusValid) {
        _firstLabel.backgroundColor = DEFAULTNAVCOLOR;
        _statusImage.hidden = YES;
        _leftImage.image = [UIImage imageNamed:@"discountCell_separate_valid"];
    }
    else if (status == DiscountStatusUsed)
    {
        _statusImage.hidden = NO;
        _statusImage.image = [UIImage imageNamed:@"discount_used"];
        _leftImage.image = [UIImage imageNamed:@"discountCell_separate_invalid"];
        _firstLabel.backgroundColor = FUNCTCOLOR(210, 210, 210);
    }
    else
    {
        _statusImage.image = [UIImage imageNamed:@"discount_invalid"];
        _leftImage.image = [UIImage imageNamed:@"discountCell_separate_invalid"];
        _statusImage.hidden = NO;
        _firstLabel.backgroundColor = FUNCTCOLOR(210, 210, 210);
    }
}



@end
