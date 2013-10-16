//
//  DrawFaceViewController.m
//  MyBigFace
//
//  Created by Suncry on 13-10-16.
//  Copyright (c) 2013年 ipointek. All rights reserved.
//

#import "DrawFaceViewController.h"
#import "WriteViewController.h"
@interface DrawFaceViewController ()

@end

@implementation DrawFaceViewController

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
- (IBAction)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)next
{
    WriteViewController *writeViewController = [[WriteViewController alloc]init];
    [self.navigationController pushViewController:writeViewController animated:YES];
}

@end
