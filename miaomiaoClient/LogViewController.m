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

@interface LogViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>
{
    
    UITableView* _table;
    IBOutlet UITextField* phoneField;
    IBOutlet UITextField* pwField;
    IBOutlet UIButton* _logBt;
    IBOutlet UIButton* _verifyBt;
    NSTimer* _timer;
    logCallBack _completeBk;
    int _countDown;
}
@end

@implementation LogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"手机验证";
//   229
//    self.navigationController.delegate = self;
    
    _verifyBt.layer.masksToBounds = YES;
    _verifyBt.layer.cornerRadius = 6;
    _verifyBt.layer.borderWidth = 1;
    _verifyBt.layer.borderColor = DEFAULTNAVCOLOR.CGColor;
    [_verifyBt setBackgroundImage:[UIImage imageNamed:@"button_back_red"] forState:UIControlStateHighlighted];
    [_verifyBt setTitleColor:DEFAULTNAVCOLOR forState:UIControlStateNormal];
    [_verifyBt setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_verifyBt setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    
    
    phoneField.leftViewMode =UITextFieldViewModeAlways;
    UIImageView* phoneLeftV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    phoneLeftV.contentMode = UIViewContentModeScaleAspectFit;
    phoneLeftV.image = [UIImage imageNamed:@"login_photo"];
    phoneField.leftView = phoneLeftV;
    
    UIView* phoneBottom = [[UIView alloc]init];
    phoneBottom.translatesAutoresizingMaskIntoConstraints = NO;
    phoneBottom.backgroundColor = FUNCTCOLOR(229, 229, 229);
    [self.view addSubview:phoneBottom];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[phoneBottom]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(phoneBottom)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[phoneField]-10-[phoneBottom(0.5)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(phoneField,phoneBottom)]];

    
    
    pwField.leftViewMode =UITextFieldViewModeAlways;
    UIImageView* pwLeftV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    pwLeftV.image = [UIImage imageNamed:@"login_pw"];
    pwLeftV.contentMode = UIViewContentModeScaleAspectFit;
    pwField.leftView = pwLeftV;

    
    UIView* pwBottom = [[UIView alloc]init];
    pwBottom.translatesAutoresizingMaskIntoConstraints = NO;
    pwBottom.backgroundColor = FUNCTCOLOR(229, 229, 229);
    [self.view addSubview:pwBottom];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pwBottom]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pwBottom)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pwField]-10-[pwBottom(0.5)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pwField,pwBottom)]];

    
    [_logBt setTitle:@"确 认" forState:UIControlStateNormal];
    [_logBt setTitleColor:DEFAULTNAVCOLOR forState:UIControlStateNormal];
    [_logBt setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [_logBt setBackgroundImage:[UIImage imageNamed:@"button_back_red"] forState:UIControlStateHighlighted];
    _logBt.layer.masksToBounds = YES;
    _logBt.layer.cornerRadius = 6;
    _logBt.layer.borderWidth = 1;
    _logBt.layer.borderColor = DEFAULTNAVCOLOR.CGColor;
    
//    [self registeNotificationCenter];
    // Do any additional setup after loading the view.
}



-(IBAction)accessVerifyNu:(id)sender
{
    if (![NSString verifyIsMobilePhoneNu:phoneField.text]) {
        
        THActivityView* showStr = [[THActivityView alloc]initWithString:@"号码格式不正确！"];
        [showStr show];
        return;
    }
    
    [pwField becomeFirstResponder];
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];
    
    __weak LogViewController* wself = self;
    NetWorkRequest* req = [[NetWorkRequest alloc]init];
    [req getVerifyCodeWithAccount:phoneField.text   WithBk:^(id respond, NetWorkStatus error) {
        
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


-(IBAction)logAction:(id)sender
{
    if (phoneField.text.length==0||pwField.text.length==0) {
        THActivityView* alter = [[THActivityView alloc]initWithString:@"账号或密码无效！"];
        [alter show];
        return;
    }
    
    [phoneField resignFirstResponder];
    [pwField resignFirstResponder];
    
    THActivityView* loading = [[THActivityView alloc]initActivityView];
    loading.center = self.view.center;
    [self.view addSubview:loading];
    
    __weak LogViewController* wSelf = self;
    
    UserManager* user = [UserManager shareUserManager];
    [user logInWithPhone:phoneField.text Pass:pwField.text logBack:^(BOOL success) {
        
        if (success) {
    
            [wSelf logViewDismiss];
        }
        else
        {
            [wSelf timerInvalid];
            THActivityView* alter = [[THActivityView alloc]initWithString:@"登录失败！"];
            [alter show];
            [loading removeFromSuperview];
        }
    }];
   
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










-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREENWIDTH, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* str = @"ids";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
//    if (indexPath.row==0) {
//        [cell.contentView addSubview:<#(UIView *)#>]
//    }
//    
    
    return cell;

}

//-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if (viewController==self) {
//        return;
//    }
//    
//   
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
