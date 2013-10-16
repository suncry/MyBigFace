//
//  FaceViewController.m
//  MyBigFace
//
//  Created by Suncry on 13-10-16.
//  Copyright (c) 2013年 ipointek. All rights reserved.
//

#import "FaceViewController.h"
#import "HomeViewController.h"
#import "SettingViewController.h"
#import "NewsViewController.h"
#import "MMDrawerController.h"
@interface FaceViewController ()

@end

@implementation FaceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender
{
    SettingViewController * leftDrawer = [[SettingViewController alloc] init];
    HomeViewController * center = [[HomeViewController alloc] init];
    NewsViewController * rightDrawer = [[NewsViewController alloc] init];
    MMDrawerController * drawerController = [[MMDrawerController alloc]
                                             initWithCenterViewController:center
                                             leftDrawerViewController:leftDrawer
                                             rightDrawerViewController:rightDrawer];
    
    [drawerController setMaximumRightDrawerWidth:280];
    [drawerController setMaximumLeftDrawerWidth:280];
    
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeTapCenterView];
    
    
    UINavigationController *navigationController =[[UINavigationController alloc]initWithRootViewController:drawerController];
    navigationController.navigationBarHidden = YES;
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
