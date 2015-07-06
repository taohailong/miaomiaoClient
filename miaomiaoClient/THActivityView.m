//
//  THActivityVIew.m
//  xiuba
//
//  Created by 陶海龙 on 14-5-29.
//  Copyright (c) 2014年 hongnuo. All rights reserved.
//

#import "THActivityView.h"
//#import "YFGIFImageView.h"
@interface THActivityView()
{
}
@end

@implementation THActivityView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(id)initViewOnWindow
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    UIActivityIndicatorView * activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.center = self.center;
    [self addSubview:activity];
    [activity startAnimating];
    return self;
}

-(void)loadViewAddOnWindow
{
    UIWindow* win = [UIApplication sharedApplication].keyWindow;
    [win addSubview:self];
}

#pragma mark-------------------------


//-(void)activityRoseOnWindow
//{
//    UIWindow* win = [UIApplication sharedApplication].keyWindow;
//    [win addSubview:self];
//    
//    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
//    dispatch_after(time, dispatch_get_main_queue(), ^{
//        [self removeFromSuperview];
//    });
//}

- (void)popOutsideWithDuration:(NSTimeInterval)duration
{
    UIWindow* win = [UIApplication sharedApplication].keyWindow;
    [win addSubview:self];
    
    self.transform = CGAffineTransformMakeScale(2.5, 2.5);
    __weak typeof(self) weakSelf = self;
	[UIView animateKeyframesWithDuration:duration delay:0 options:0 animations: ^{
	    [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 /4.0 animations: ^{
            typeof(self) strongSelf = weakSelf;
	        strongSelf.transform = CGAffineTransformMakeScale(0.0, 0.0);
		}];
	} completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    

}



-(id)initActivityView
{
    self = [self initLoadingWithStr:@"请稍后..."];
    return self;
}

-(id)initActivityViewWithSuperView:(UIView*)superView
{
//    self = [self initWithLoadGif];
    
    self = [self initLoadingWithStr:@"请稍后..."];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.center = CGPointMake(CGRectGetWidth(superView.frame)/2, CGRectGetHeight(superView.frame)/2) ;
    [superView addSubview:self];
    
//    [superView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
//    
//    [superView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    return self;

}


#pragma mark---------------fullLoadingView-----------------


-(id)initFullViewTransparentWithSuperView:(UIView *)superView
{
    
    self = [super init];
    if (superView==nil) {
        return self;
    }

    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    [superView addSubview:self];
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[self]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self)]];
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[self]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self)]];
    
    return self;

}


-(id)initLoadingWithStr:(NSString*)str
{
    self = [super initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    if (self)
    {
        self.backgroundColor = [UIColor blackColor];
        UIActivityIndicatorView * activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activity.center = self.center;
        [self addSubview:activity];
        [activity startAnimating];
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 8;
        
        UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 75, 100, 20)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = DEFAULTFONT(16);
        titleLabel.text = str;
        [self addSubview:titleLabel];
    }
    return self;
}

//-(id)initWithLoadGif
//{
//    self = [super initWithFrame:CGRectMake(0, 0, 190, 140)];
//    
//    if (self)
//    {
//        YFGIFImageView* imageV = [[YFGIFImageView alloc]initWithFrame:self.frame];
//        imageV.gifPath = [[NSBundle mainBundle] pathForResource:@"LoadingGif" ofType:@"gif"];
//        [imageV startGIF];
//        [self addSubview:imageV];
//    }
//    return self;
//
//}


#pragma mark---------------error---------------------------

-(id)initWithNetErrorWithSuperView:(UIView*)su
{
    self = [super init];
    if (su==nil) {
        return self;
    }
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [su addSubview:self];
    self.backgroundColor = [UIColor whiteColor];
    [su addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[self]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self)]];
    
    [su addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[self]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self)]];
    
    UIButton* reloadBt = [UIButton buttonWithType:UIButtonTypeCustom];
    reloadBt.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:reloadBt];
    [reloadBt addTarget:self action:@selector(performReloadAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:reloadBt attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:reloadBt attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:10]];
    
    [reloadBt setImage:[UIImage imageNamed:@"LoadingErr"] forState:UIControlStateNormal] ;

    
    UILabel* nameL = [[UILabel alloc]init];
    nameL.translatesAutoresizingMaskIntoConstraints = NO;
    nameL.text = @"没有网络...";
    nameL.font = DEFAULTFONT(17);
    nameL.textColor = DEFAULTBLACK;
    [self addSubview:nameL];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:nameL attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:reloadBt attribute:NSLayoutAttributeTop multiplier:1.0 constant:-15]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:nameL attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:reloadBt attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    

    return self;
}

-(void)setErrorBk:(void(^)(void))completeBk
{
    _errorBk = completeBk;
}

-(void)performReloadAction
{
    [self removeFromSuperview];

    if (_errorBk) {
       _errorBk();
        _errorBk = nil;
    }
    
}


#pragma mark-----------------showString----------------

-(void)show
{
    UIWindow* window =  [UIApplication sharedApplication].delegate.window;
    self.center = CGPointMake(window.center.x, window.center.y-20);
    [window addSubview:self];

//    NSLog(@"key %@ window %@",[UIApplication sharedApplication].keyWindow,window);
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1.8 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
          [self removeFromSuperview];
    });

    
//    [UIView animateWithDuration:1.8 animations:^{
//        self.alpha = .99;
//        
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
//    
}

-(id)initWithString:(NSString*)str
{
    CGSize size = [str sizeWithFont:[UIFont boldSystemFontOfSize:17]];
    
    if(size.width>[UIScreen mainScreen].bounds.size.width)
    {
        size.width = [UIScreen mainScreen].bounds.size.width;
    }

    self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height+15)];
    if (self)
    {
        self.backgroundColor = [UIColor blackColor];
//        self.alpha = 0.95;
        
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        
        UILabel* label = [[UILabel alloc]initWithFrame:self.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14.5];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.adjustsFontSizeToFitWidth = YES;
        label.text = str;
        [self addSubview:label];
        
    }
    return self;
}



#pragma mark-------------empty data warn view---------

-(id)initEmptyDataWarnViewWithString:(NSString*)str WithImage:(NSString*)imageStr WithSuperView:(UIView*)superView
{
    
    self = [super init];
    if (superView == nil) {
        return self;
    }
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [superView addSubview:self];
    self.backgroundColor = [UIColor whiteColor];
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[self]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self)]];
    
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[self]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self)]];
    
    UIImageView* image = [[UIImageView alloc]init];
    image.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:image];
    image.image = [UIImage imageNamed:imageStr];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:image attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:image attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-30]];
    
    
    
    UILabel* nameL = [[UILabel alloc]init];
    nameL.translatesAutoresizingMaskIntoConstraints = NO;
    nameL.text = str;
    nameL.font = DEFAULTFONT(17);
    nameL.textColor = DEFAULTGRAYCOLO;
    [self addSubview:nameL];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:nameL attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:image attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:nameL attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];

    return self;
}


-(void)addBtWithTitle:(NSString*)btTitle WithBk:(void(^)(void))actionBk
{
    
    UIButton* reloadBt = [UIButton buttonWithType:UIButtonTypeCustom];

    reloadBt.layer.cornerRadius = 4;
    reloadBt.layer.masksToBounds = YES;
    reloadBt.layer.borderColor = DEFAULTNAVCOLOR.CGColor;
    reloadBt.layer.borderWidth = 1;
    [reloadBt setTitleColor:DEFAULTNAVCOLOR forState:UIControlStateNormal];
    reloadBt.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:reloadBt];
    [reloadBt addTarget:self action:@selector(performReloadAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:reloadBt attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:90]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:reloadBt attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
   
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[reloadBt(>=120)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(reloadBt)]];
    
    [reloadBt setTitle:btTitle forState:UIControlStateNormal];
//    [reloadBt setBackgroundImage:[UIImage imageNamed:@"button_back_red"] forState:UIControlStateNormal] ;
   
    
    _errorBk = actionBk;
}



-(void)dealloc
{
    NSLog(@"VIEW dealloc");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
