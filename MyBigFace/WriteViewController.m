//
//  WriteViewController.m
//  MyBigFace
//
//  Created by Suncry on 13-10-16.
//  Copyright (c) 2013年 ipointek. All rights reserved.
//

#import "WriteViewController.h"

@interface WriteViewController ()

@end

@implementation WriteViewController

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
    //加载脸
    [self loadFace];
    //使textView成为焦点
    [mytextView becomeFirstResponder];
    
    
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//使用前一页面画的笑脸
- (void)loadFace
{
    NSData *imageData;
    imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"myFace"];
    
    if(imageData != nil)
    {
        [myFaceImageView setImage:[NSKeyedUnarchiver unarchiveObjectWithData: imageData]];
    }

}
@end
