//
//  UICustomActionView.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/6/10.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "UICustomActionView.h"
#import "DiscountActionCell.h"
#import "DiscountData.h"
#import "THActivityView.h"
#import "NetWorkRequest.h"
@interface UICustomActionView()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _table;
    NSArray* _dataArr;
    UIView* backView;
    float _totalMoney;
}
@end
@implementation UICustomActionView
@synthesize delegate;

-(id)initWithTitle:(NSString*)title WithDataArr:(NSArray*)arr
{
    
    self = [super initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    
    
    _dataArr = arr;
    UIView* tapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    [self addSubview:tapView];
    tapView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.5];

    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewGesture:)];
    [tapView addGestureRecognizer:tap];
 
    
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENWIDTH, SCREENWIDTH, SCREENHEIGHT*0.6)];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    
    UILabel* titleLable = [[UILabel alloc]init];
    titleLable.translatesAutoresizingMaskIntoConstraints = NO;
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.backgroundColor = FUNCTCOLOR(243, 243, 243);
    [backView addSubview:titleLable];
    
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLable(35)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLable)]];
    
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[titleLable]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLable)]];
    
    titleLable.font = DEFAULTFONT(15);
    titleLable.text = title;
    titleLable.textAlignment = NSTextAlignmentCenter;
    
    
    UIView* separateTitleView = [[UIView alloc]init];
    separateTitleView.translatesAutoresizingMaskIntoConstraints = NO;
    [backView addSubview:separateTitleView];
    separateTitleView.backgroundColor = FUNCTCOLOR(210, 210, 210);
    
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[separateTitleView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separateTitleView)]];
    
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLable]-0-[separateTitleView(0.5)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLable,separateTitleView)]];

    
    
    
    
    _table = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorColor = FUNCTCOLOR(243, 243, 243);
    _table.backgroundColor = FUNCTCOLOR(243, 243, 243);
    [backView addSubview:_table];
    _table.translatesAutoresizingMaskIntoConstraints = NO;

    
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[separateTitleView]-0-[_table]-44-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separateTitleView,_table)]];
    
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    
    
    UIView* separateView = [[UIView alloc]init];
    separateView.translatesAutoresizingMaskIntoConstraints = NO;
    [backView addSubview:separateView];
    separateView.backgroundColor = FUNCTCOLOR(210, 210, 210);
    
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[separateView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separateView)]];
    
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_table]-0-[separateView(0.5)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table,separateView)]];

    
    
    UIButton* cancelBt = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBt.translatesAutoresizingMaskIntoConstraints = NO;
    cancelBt.layer.masksToBounds = YES;
    cancelBt.layer.cornerRadius = 6;
    cancelBt.layer.borderColor = DEFAULTNAVCOLOR.CGColor;
    cancelBt.layer.borderWidth = 1;
    [cancelBt setBackgroundImage:[UIImage imageNamed:@"button_back_red"] forState:UIControlStateHighlighted];
    [cancelBt setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [backView addSubview:cancelBt];
    [cancelBt addTarget:self action:@selector(hidPopView) forControlEvents:UIControlEventTouchUpInside];
    [cancelBt setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBt setTitleColor:DEFAULTNAVCOLOR forState:UIControlStateNormal];
    
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[cancelBt]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(cancelBt)]];
    
    
    [backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cancelBt(32)]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(cancelBt)]];
    
    UIWindow* window =  [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];

    return self;
}


-(void)setMinPrice:(float)minPrice
{
    _totalMoney = minPrice;
}


-(void)showPopView
{
   [UIView animateWithDuration:.2 animations:^{
      
       backView.frame = CGRectMake(0, SCREENHEIGHT*0.4, CGRectGetWidth(backView.frame), CGRectGetHeight(backView.frame));
   } completion:^(BOOL finished) {
       
    }];
}


-(void)hidPopView
{
    [UIView animateWithDuration:.2 animations:^{
        
        backView.frame = CGRectMake(0, SCREENHEIGHT, CGRectGetWidth(backView.frame), CGRectGetHeight(backView.frame));
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];

}



//-(void)requestDiscountData
//{
//    __weak UICustomActionView* wself = self;
//    
//    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:backView];
//    
//    NetWorkRequest* req = [[NetWorkRequest alloc]init];
//    [req getValidDiscountTicketWithBk:^(id respond, NetWorkStatus status) {
//        [loadView removeFromSuperview];
//        if (status == NetWorkSuccess) {
//            [wself reloadTableAfterGetData:respond];
//        }
//        else
//        {
//            THActivityView* warnView = [[THActivityView alloc]initWithString:respond];
//            [warnView show];
//        }
//    }];
//    [req startAsynchronous];
//}
//
//-(void)reloadTableAfterGetData:(NSArray*)arr
//{
//    _dataArr = arr;
//    [_table reloadData];
//}




-(void)tapViewGesture:(UIGestureRecognizer*)gesture
{
    [self hidPopView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiscountActionCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[DiscountActionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
       
        [cell setLayout];
    }
    
    DiscountData* data = _dataArr[indexPath.row];
    
    [cell setTitleLabelAttribute:[NSString stringWithFormat:@"%.0f",data.discountMoney]];
    
    UILabel* secondLabel = [cell getSecondLabel];
    if (data.minMoney==0) {
        secondLabel.text = @"代金券";
    }
    else
    {
        NSString* str = [NSString stringWithFormat:@"【满%d元使用】",(int)data.minMoney];
        NSMutableAttributedString* att = [[NSMutableAttributedString alloc]initWithString:@"代金券"];
        NSAttributedString* discount = nil;
        if (_totalMoney<data.minMoney) {
            
            discount = [[NSAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName:FUNCTCOLOR(255, 166, 60),NSFontAttributeName:DEFAULTFONT(13)}];
        }
        else
        {
             discount = [[NSAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName:DEFAULTBLACK,NSFontAttributeName:DEFAULTFONT(13)}];
           
        }
        
        [att appendAttributedString:discount];
        secondLabel.attributedText = att;
    }
    
    UILabel* fourthLabel = [cell getFourthLabel];
    fourthLabel.text = [NSString stringWithFormat:@"有效期：%@至%@",data.startTime,data.deadTime];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(actionViewSelectWithData:)]) {
        
        DiscountData* data = _dataArr[indexPath.row];
        if (data.minMoney>_totalMoney)
        {
            THActivityView* show = [[THActivityView alloc]initWithString:[NSString stringWithFormat:@"未满%.2f元",data.minMoney]];
            [show show];
            return;
        }

        [self.delegate actionViewSelectWithData:data];
        [self hidPopView];
    }
    
}


@end
