//
//  MyBigFaceAppDelegate.m
//  MyBigFace
//
//  Created by Suncry on 13-10-16.
//  Copyright (c) 2013年 ipointek. All rights reserved.
//

#import "MyBigFaceAppDelegate.h"
#import "HomeViewController.h"
#import "SettingViewController.h"
#import "NewsViewController.h"
#import "MMDrawerController.h"
#import "UMSocial.h"

@implementation MyBigFaceAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
//设置分享key
    [UMSocialData setAppKey:@"528c287f56240be0d93b99ad"];

    
    
    SettingViewController * leftDrawer = [[SettingViewController alloc] init];
    HomeViewController * center = [[HomeViewController alloc] init];
    UINavigationController *navigationController =[[UINavigationController alloc]initWithRootViewController:center];
//    navigationController.navigationBarHidden = YES;

    
    
    NewsViewController * rightDrawer = [[NewsViewController alloc] init];
    MMDrawerController * drawerController = [[MMDrawerController alloc]
                                             initWithCenterViewController:navigationController
                                             leftDrawerViewController:leftDrawer
                                             rightDrawerViewController:rightDrawer];
    
    [drawerController setMaximumRightDrawerWidth:280];
    [drawerController setMaximumLeftDrawerWidth:280];
    
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeTapCenterView];
    
    
//    UINavigationController *navigationController =[[UINavigationController alloc]initWithRootViewController:drawerController];
//    navigationController.navigationBarHidden = YES;

    self.window.rootViewController = drawerController;
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

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
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

@end
