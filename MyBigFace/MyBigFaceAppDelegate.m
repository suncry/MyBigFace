//
//  MyBigFaceAppDelegate.m
//  MyBigFace
//
//  Created by Suncry on 13-10-16.
//  Copyright (c) 2013年 ipointek. All rights reserved.
//

#import "MyBigFaceAppDelegate.h"
#import "HomeViewController.h"
#import "UMSocial.h"
#import "MobClick.h"
@implementation MyBigFaceAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //设置默认的统计功能
    [MobClick startWithAppkey:@"528c287f56240be0d93b99ad"];

    //设置分享key
    [UMSocialData setAppKey:@"528c287f56240be0d93b99ad"];
    //设置微信AppId，url地址传nil，将默认使用友盟的网址
    [UMSocialConfig setWXAppId:@"wx8f001b50bdfd23d0" url:nil];
    //设置微信分享应用类型，用户点击消息将跳转到应用，或者到下载页面
    //UMSocialWXMessageTypeImage 为纯图片类型
//    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;

    //分享图文样式到微信朋友圈显示字数比较少，只显示分享标题
    [UMSocialData defaultData].extConfig.title = @"分享了一条来自@Whisper微喷 的消息。——微喷，喷出你的秘密吧！";
    //如果是ios6 隐藏状态栏
    if (IOS_VERSION_7_OR_ABOVE) {
//        NSLog(@"IOS_VERSION_7_OR_ABOVE");
    } else {
//        NSLog(@"NOT IOS_VERSION_7_OR_ABOVE");
        [application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }

    
    HomeViewController * homeViewController = [[HomeViewController alloc] init];
    UINavigationController *navigationController =[[UINavigationController alloc]initWithRootViewController:homeViewController];
//    navigationController.navigationBarHidden = YES;
    self.window.rootViewController = navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

@end
