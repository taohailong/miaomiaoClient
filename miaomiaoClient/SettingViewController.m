//
//  SettingViewController.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-22.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "SettingViewController.h"
#import "UserManager.h"
#import "THActivityView.h"
#import "AboutController.h"
#import "ASIHTTPRequest.h"

@interface SettingViewController()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
{
    UITableView* _table;
}
@end
@implementation SettingViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置";
    
    _table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorColor = FUNCTCOLOR(229, 229, 229);
    [self.view addSubview:_table];
    
    if ([_table respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [_table setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        
    }
    
    if ([_table respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [_table setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        
    }

}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 11;
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .5;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSString* str = @"ids";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = DEFAULTGRAYCOLO;
        cell.textLabel.font = DEFAULTFONT(16);
    }
    if (indexPath.section==1) {
        cell.textLabel.textColor = DEFAULTNAVCOLOR;
        cell.textLabel.text = @"退 出";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    
    
    if (indexPath.row==1) {
        cell.textLabel.text = @"检查更新";
        cell.imageView.image = [UIImage imageNamed:@"setView_update"];
    }
    else
    {
       cell.textLabel.text = @"关于喵喵";
       cell.imageView.image = [UIImage imageNamed:@"setView_about"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"提示"
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:@"退出登陆"
                                      otherButtonTitles:nil,nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
    
    }
    else if (indexPath.row==1)
    {
//        [self checkVersion];
    }
    else
    {
        [self showAboutView];
    }
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
    
}


-(void)checkVersion
{
    
    THActivityView* loading = [[THActivityView alloc]initActivityViewWithSuperView:self.view];
    
    ASIHTTPRequest* req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://itunes.apple.com/cn/lookup?id=994411007"]];//
 
    __weak SettingViewController* wself = self;
    __weak ASIHTTPRequest* wreq = req;
    [req setCompletionBlock:^{
        [loading removeFromSuperview];
        [wself parseData:wreq.responseData];
    }];
    [req setFailedBlock:^{
         [loading removeFromSuperview];
    }];
    [req startAsynchronous];
}

-(void)parseData:(NSData*)data
{
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
    
    NSArray *infoArray = [dic objectForKey:@"results"];
    if (infoArray.count==0) {
        return;
    }
    NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
    NSString *latestVersion = [releaseInfo objectForKey:@"version"];
//    NSString *trackViewUrl = [releaseInfo objectForKey:@"trackViewUrl"];
    
   
   if(![latestVersion isEqualToString:VERSION])
   {
       UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"发现有新版本" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
       [alert show];
   }
   else
   {
       THActivityView* alert  = [[THActivityView alloc]initWithString:@"已是最新版本"];
       [alert show];
    }
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.cancelButtonIndex == buttonIndex) {
        return;
    }
    [self userLogout];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex == buttonIndex) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/miao-miao-shang-jia/id994411007?mt=8"];
    [[UIApplication sharedApplication]openURL:url];
}


-(void)showAboutView
{
    AboutController* about = [[AboutController alloc]init];
    [self.navigationController pushViewController:about animated:YES];
}

-(void)userLogout
{
    __weak SettingViewController* wself = self;
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];
    UserManager* manager = [UserManager shareUserManager];
    [manager removeUserAccountWithBk:^(BOOL success, id respond) {
        [loadView removeFromSuperview];
        if (success) {
            [wself.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            THActivityView* show = [[THActivityView alloc]initWithString:respond];
            [show show];
        }
    }];
}

@end
