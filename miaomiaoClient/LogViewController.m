//
//  LogViewController.m
//  miaomiaoShop
//
//  Created by 陶海龙 on 15-4-22.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "LogViewController.h"
#import "THActivityView.h"
#import "UserManager.h"
#import "NetWorkRequest.h"
#import "NSString+ZhengZe.h"
#import "LogInCell.h"
@interface LogViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>
{
    
    UITableView* _table;
    __weak UITextField* _phoneField;
    __weak UITextField* _pwField;
     UIButton* _logBt;
    UIButton* _verifyBt;
    NSTimer* _timer;
    logCallBack _completeBk;
    int _countDown;
    UILabel* _voiceLabel;
//    UITextField* _respondField;
}
@property(nonatomic,strong)NSString* phoneStr;
@property(nonatomic,strong)NSString* pwStr;
@end

@implementation LogViewController
@synthesize phoneStr,pwStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"手机验证";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel* titleLabel = [[UILabel alloc]init];
    titleLabel.font = DEFAULTFONT(13);
    titleLabel.textColor = DEFAULTBLACK;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:titleLabel];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[titleLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    
    titleLabel.text = @"为方便同步、查询订单信息，请先使用手机号码登陆 ";

    _table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _table.translatesAutoresizingMaskIntoConstraints = NO;
    _table.delegate = self;
    _table.dataSource = self;
    [_table registerClass:[LogInCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_table];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel]-10-[_table]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel,_table)]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_table attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    
    
    
    _verifyBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [_verifyBt setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_verifyBt addTarget:self action:@selector(accessVerifyNu:) forControlEvents:UIControlEventTouchUpInside];
    _verifyBt.frame = CGRectMake(0, 0, 80, 30);
    _verifyBt.titleLabel.font = DEFAULTFONT(15);
    _verifyBt.layer.masksToBounds = YES;
    _verifyBt.layer.cornerRadius = 6;
    _verifyBt.layer.borderWidth = 1;
    _verifyBt.layer.borderColor = DEFAULTNAVCOLOR.CGColor;
    [_verifyBt setBackgroundImage:[UIImage imageNamed:@"button_back_red"] forState:UIControlStateHighlighted];
    [_verifyBt setTitleColor:DEFAULTNAVCOLOR forState:UIControlStateNormal];
    [_verifyBt setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_verifyBt setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    
    UIView* tableFoot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_table.frame), 100)];
//    tableFoot.backgroundColor = [UIColor redColor];
    _table.tableFooterView = tableFoot;
    
    
    _logBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _logBt.translatesAutoresizingMaskIntoConstraints = NO;
    [tableFoot addSubview:_logBt];
    [_logBt setTitle:@"确 认" forState:UIControlStateNormal];
    [_logBt setTitleColor:DEFAULTNAVCOLOR forState:UIControlStateNormal];
    [_logBt setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [_logBt setBackgroundImage:[UIImage imageNamed:@"button_back_red"] forState:UIControlStateHighlighted];
    _logBt.layer.masksToBounds = YES;
    _logBt.layer.cornerRadius = 6;
    _logBt.layer.borderWidth = 1;
    _logBt.layer.borderColor = DEFAULTNAVCOLOR.CGColor;

    [_logBt addTarget:self action:@selector(logAction:) forControlEvents:UIControlEventTouchUpInside];
    [tableFoot addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_logBt]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_logBt)]];
    
    [tableFoot addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_logBt(35)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_logBt)]];
    
    
    
    
    
    _voiceVerifyBt = [UIButton buttonWithType:UIButtonTypeCustom];
    
    NSMutableAttributedString* voiceStr = [[NSMutableAttributedString alloc]initWithString:@"收不到短信？使用语音验证码" attributes:@{NSFontAttributeName:DEFAULTFONT(13)}];
    [voiceStr addAttributes:@{NSForegroundColorAttributeName:DEFAULTGRAYCOLO} range:NSMakeRange(0, 8)];
    [voiceStr addAttributes:@{NSForegroundColorAttributeName:DEFAULTNAVCOLOR} range:NSMakeRange(8, 5)];
    
    [_voiceVerifyBt setAttributedTitle:voiceStr forState:UIControlStateNormal];
    _voiceVerifyBt.translatesAutoresizingMaskIntoConstraints = NO;
    [tableFoot addSubview:_voiceVerifyBt];
    
    [_voiceVerifyBt addTarget:self action:@selector(voiceVerifyPhoneAction:) forControlEvents:UIControlEventTouchUpInside];
    [tableFoot addConstraint:[NSLayoutConstraint constraintWithItem:_voiceVerifyBt attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:tableFoot attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [tableFoot addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_logBt]-15-[_voiceVerifyBt]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_logBt,_voiceVerifyBt)]];
    
    
    _voiceLabel = [[UILabel alloc]init];
    _voiceLabel.font = DEFAULTFONT(15);
    _voiceLabel.textColor = DEFAULTBLACK;
    _voiceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [tableFoot addSubview:_voiceLabel];
    
    [tableFoot addConstraint:[NSLayoutConstraint constraintWithItem:_voiceLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:tableFoot attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:5]];
    
    [tableFoot addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_voiceVerifyBt]-5-[_voiceLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_voiceVerifyBt,_voiceLabel)]];
    

    [self registeNotificationCenter];
    // Do any additional setup after loading the view.
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak LogViewController* wself = self;
    LogInCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row == 0) {
        
        UITextField* phoneField = [cell getTextFieldView];
        _phoneField = phoneField;
        phoneField.keyboardType = UIKeyboardTypeNumberPad;
        phoneField.leftViewMode =UITextFieldViewModeAlways;
        UIImageView* phoneLeftV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        phoneLeftV.contentMode = UIViewContentModeScaleAspectFit;
        phoneLeftV.image = [UIImage imageNamed:@"login_photo"];
        phoneField.leftView = phoneLeftV;

        [cell setFieldBlock:^(NSString *text) {
            wself.phoneStr = text;
        }];
    }
    else
    {
        UITextField* pwField = [cell getTextFieldView];
        _pwField = pwField;
        pwField.keyboardType = UIKeyboardTypeNumberPad;
        pwField.translatesAutoresizingMaskIntoConstraints = NO;
        pwField.leftViewMode =UITextFieldViewModeAlways;
        UIImageView* pwLeftV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        pwLeftV.image = [UIImage imageNamed:@"login_pw"];
        pwLeftV.contentMode = UIViewContentModeScaleAspectFit;
        pwField.leftView = pwLeftV;

        [cell setFieldBlock:^(NSString *text) {
            wself.pwStr = text;
        }];
        cell.accessoryView = _verifyBt;
    }

    return cell;
}


-(void)accessVerifyNu:(id)sender
{
    if (![NSString verifyIsMobilePhoneNu:self.phoneStr]) {
        
        THActivityView* showStr = [[THActivityView alloc]initWithString:@"号码格式不正确"];
        [showStr show];
        return;
    }
    [_pwField becomeFirstResponder];
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];
    
    __weak LogViewController* wself = self;
    NetWorkRequest* req = [[NetWorkRequest alloc]init];
    [req getVerifyCodeWithAccount:self.phoneStr   WithBk:^(id respond, NetWorkStatus error) {
        
        [loadView removeFromSuperview];
        if (error==NetWorkSuccess) {
            [wself startCountdown];
        }
        NSLog(@"%@",respond);
    }];

    [req startAsynchronous];
}

-(void)startCountdown
{
    _countDown = 60;
    [_verifyBt setTitle:[NSString stringWithFormat:@"还差%d秒",_countDown] forState:UIControlStateDisabled];
    _verifyBt.enabled = NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeRunLoop) userInfo:nil repeats:YES];

}

-(void)timeRunLoop
{
    _countDown--;
    [_verifyBt setTitle:[NSString stringWithFormat:@"还差%d秒",_countDown] forState:UIControlStateDisabled];
    
    if (_countDown==0) {
        _verifyBt.enabled = YES;
        [_timer invalidate];
    }
}


-(void)timerInvalid
{
    _verifyBt.enabled = YES;
    [_timer invalidate];
}



-(void)setLogResturnBk:(logCallBack)bk
{
    _completeBk = bk;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)logAction:(id)sender
{
    if (self.phoneStr.length==0||self.pwStr.length==0) {
        THActivityView* alter = [[THActivityView alloc]initWithString:@"账号或密码无效"];
        [alter show];
        return;
    }
    
    [_phoneField resignFirstResponder];
    [_pwField resignFirstResponder];
    
    THActivityView* loading = [[THActivityView alloc]initActivityView];
    loading.center = self.view.center;
    [self.view addSubview:loading];
    
    __weak LogViewController* wSelf = self;
    
    UserManager* user = [UserManager shareUserManager];
    [user logInWithPhone:self.phoneStr Pass:self.pwStr logBack:^(BOOL success, id respond) {
    
        if (success) {
    
            [wSelf logViewDismiss];
        }
        else
        {
            [wSelf timerInvalid];
            THActivityView* alter = [[THActivityView alloc]initWithString:respond];
            [alter show];
            [loading removeFromSuperview];
        }
    }];
   
}


-(void)voiceVerifyPhoneAction:(id)sender
{
    if (![NSString verifyIsMobilePhoneNu:self.phoneStr]) {
        
        THActivityView* showStr = [[THActivityView alloc]initWithString:@"号码格式不正确"];
        [showStr show];
        return;
    }
    
    [_pwField resignFirstResponder];
    [_phoneField resignFirstResponder];
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];
    
    __weak LogViewController* wself = self;
    NetWorkRequest* req = [[NetWorkRequest alloc]init];
    [req getPhoneVerifyCodeWithAccount:self.phoneStr WithBk:^(id respond, NetWorkStatus status) {
        [loadView removeFromSuperview];
        if (status==NetWorkSuccess) {
            [wself voiceVerifyComplete];
        }
        else
        {
            THActivityView* showStr = [[THActivityView alloc]initWithString:respond];
            [showStr show];
        }
        NSLog(@"%@",respond);
    }];
    
    [req startAsynchronous];
}

-(void)voiceVerifyComplete
{
   _voiceLabel.text = @"电话拨打中...请留意一下电话";
}





-(void)logViewDismiss
{
    [self timerInvalid];
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:NO];
    }
    else
    {
      [self dismissViewControllerAnimated:YES completion:^{}];
    }
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.002* NSEC_PER_SEC);
    
    dispatch_after(time, dispatch_get_main_queue(), ^{
        
        if (_completeBk) {
            _completeBk(YES);
        }
        _completeBk = nil;
  
    });
}



#pragma mark- textField


-(void)registeNotificationCenter
{
    /*注册成功后  重新链接服务器*/
    NSNotificationCenter *def = [NSNotificationCenter defaultCenter];
    
//    [def addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    
    /* 注册键盘的显示/隐藏事件 */
    [def addObserver:self selector:@selector(keyboardShown:)
                name:UIKeyboardWillShowNotification
											   object:nil];
    
    
    [def addObserver:self selector:@selector(keyboardHidden:)name:UIKeyboardWillHideNotification
											   object:nil];
    
}

- (void)keyboardShown:(NSNotification *)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGSize keyboardSize = [aValue CGRectValue].size;
    [self accessViewAnimate:-keyboardSize.height];
}

- (void)keyboardHidden:(NSNotification *)aNotification
{
    [self accessViewAnimate:0.0];
}

-(void)accessViewAnimate:(float)height
{
    
//    _table.contentInset = UIEdgeInsetsMake(0, 0, -height, 0);
    [UIView animateWithDuration:.2 delay:0 options:0 animations:^{
        
        for (NSLayoutConstraint * constranint in self.view.constraints)
        {
            if (constranint.firstItem==_table&&constranint.firstAttribute==NSLayoutAttributeBottom) {
                constranint.constant = height;
            }
        }
    } completion:^(BOOL finished) {
        
    }];
}

//-(void)textFieldChanged:(NSNotification*)noti
//{
//    _respondField = (UITextField*)noti.object;
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
