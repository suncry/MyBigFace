//
//  WriteViewController.m
//  MyBigFace
//
//  Created by Suncry on 13-10-16.
//  Copyright (c) 2013年 ipointek. All rights reserved.
//

#import "WriteViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"

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
    [self setupMenuButton];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (IBAction)back
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
- (void)nextPage
{
    [self upLoadFace];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//使用前一页面画的笑脸
- (void)loadFace
{
    NSData *imageData;
    imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"myFace"];
    
    if(imageData != nil)
    {
//        [myFaceImageView setImage:[NSKeyedUnarchiver unarchiveObjectWithData: imageData]];
        [myFaceImageView setImage:[UIImage imageWithData:imageData]];

    }
}
-(void)setupMenuButton{
    //设置标题
    self.navigationItem.title = @"画心情";
    //左按钮
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(nextPage)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    //    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    
}
- (void)upLoadFace
{
    NSString *urlString = [NSString stringWithFormat:@"http://112.124.15.6:8001/face/upload"];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:url];
    [requestForm setRequestMethod:@"POST"];
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm addRequestHeader:@"X-Token" value:[[NSUserDefaults standardUserDefaults]stringForKey:@"token"]];
    NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"myFace"];
    [requestForm setData:imageData forKey:@"image"];
    [requestForm setPostValue:mytextView.text forKey:@"content"];
    [requestForm setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"lng"] forKey:@"lng"];
    [requestForm setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"lat"] forKey:@"lat"];
//    NSLog(@"上传时的lng == %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"lng"]);
//    NSLog(@"上传时的lat == %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"lat"]);

    
    __block ASIHTTPRequest *requestFormBlock = requestForm;
    [requestForm setCompletionBlock :^{
    }];
    [requestForm setFailedBlock :^{
        // 请求响应失败，返回错误信息
        NSError *error = [requestFormBlock error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
    }];
    [requestForm startAsynchronous];
}
@end
