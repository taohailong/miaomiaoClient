//
//  AppDelegate.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-7.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "AppDelegate.h"
#import "OpenUDID.h"
#import "WXApi.h"
#import "UserManager.h"
#import "MobClick.h"
#import <AlipaySDK/AlipaySDK.h>
#import "THActivityView.h"
@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOption
{
    UITabBarController* tab = (UITabBarController*)self.window.rootViewController;
    
    int i = 0;
    for (UIViewController* v in tab.viewControllers) {
        
        NSString* normal = nil;
        NSString* highlight  = nil;
        switch (i) {
            case 0:
                normal = @"tab_first";
                highlight = @"tab_first_selected";
                break;
            case 1:
                normal = @"tab_second";
                highlight = @"tab_second_selected";
                break;
            case 2:
                normal = @"tab_third";
                highlight = @"tab_third_selected";
                break;
            default:
                normal = @"tab_fourth";
                highlight = @"tab_fourth_selected";
                break;
        }
        i++;
        v.tabBarItem.selectedImage = [[UIImage imageNamed:highlight] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        v.tabBarItem.image = [UIImage imageNamed:normal];
       
        [v.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:DEFAULTNAVCOLOR,NSFontAttributeName:DEFAULTFONT(13)} forState:UIControlStateHighlighted];
        [v.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:DEFAULTGRAYCOLO,NSFontAttributeName:DEFAULTFONT(13)} forState:UIControlStateNormal];

    }
    
  
    
    [MobClick startWithAppkey:@"556c3da367e58e422f000f9b" reportPolicy:BATCH   channelId:nil];
    [MobClick setLogEnabled:NO];
    [MobClick checkUpdate];
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    UserManager* manager = [UserManager shareUserManager];
    [manager checkGID];
    [WXApi registerApp:@"wx8c2570b40fc89b39"];
    
#if ENTERPISE
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
#endif
 
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

-(void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]])
    {
        PayResp *response = (PayResp *)resp;
        
        if (response.errCode==WXSuccess)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:PPAYSUCCESS object:nil];
        }
        else
        {
            THActivityView* show = [[THActivityView alloc]initWithString:@"支付失败！"];
            [show show];
          
        }
    }

}



- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"])
    {
        
//        [[AlipaySDK defaultService] processAuth_V2Result:url
//                                         standbyCallback:^(NSDictionary *resultDic) {
//                                             
//                                              [[NSNotificationCenter defaultCenter] postNotificationName:PPAYSUCCESS object:nil];
//                                             NSLog(@"result = %@",resultDic);
////                                             NSString *resultStr = resultDic[@"result"];
//                                         }];
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            
            if([resultDic[@"resultStatus"] intValue] != 9000)
            {
                THActivityView* showStr = [[THActivityView alloc]initWithString:resultDic[@"memo"]];
                [showStr show];
            
            }
            else
            {
               [[NSNotificationCenter defaultCenter] postNotificationName:PPAYSUCCESS object:nil];
            }
            
             NSLog(@"result = %@",resultDic);
        }];

        
        return YES;
    }

    
    BOOL isSuc = [WXApi handleOpenURL:url delegate:self];
    NSLog(@"url %@ isSuc %d",url,isSuc == YES ? 1 : 0);
    return  isSuc;
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

void UncaughtExceptionHandler(NSException *exception) {
    NSArray *arr = [exception callStackSymbols];//得到当前调用栈信息
    NSString *reason = [exception reason];//非常重要，就是崩溃的原因
    NSString *name = [exception name];//异常类型
    
    //    NSLog(@"exception type : %@ \n crash reason : %@ \n call stack info : %@", name, reason, arr);
    
    NSString *crashLogInfo = [NSString stringWithFormat:@"exception type : %@ \n crash reason : %@ \n call stack info : %@", name, reason, arr];
    NSString *urlStr = [NSString stringWithFormat:@"mailto://taohailong@lizi-inc.com?subject=bug报告&body=请把这封邮件发出，感谢您的配合!"
                        "错误详情:%@",
                        crashLogInfo];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
}


@end
