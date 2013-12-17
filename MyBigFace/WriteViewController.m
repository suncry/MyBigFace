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
    //使textView成为焦点
    [mytextView becomeFirstResponder];
    [self setupMenuButton];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)nextPage
{
    [self upLoadFace];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)setupMenuButton{
    //设置标题
    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    t.font = [UIFont systemFontOfSize:24];
    t.textColor = [UIColor whiteColor];
    t.backgroundColor = [UIColor clearColor];
    t.textAlignment = NSTextAlignmentCenter;
    t.text = @"画心情";
    self.navigationItem.titleView = t;
    //左按钮
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(nextPage)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    //    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    
}
- (void)upLoadFace
{
    NSString *urlString = [NSString stringWithFormat:@"http://112.124.15.6:8003/face/upload"];
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
        NSString *faceString = [requestFormBlock responseString];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSMutableDictionary *dict = [jsonParser objectWithString:faceString];
        NSLog(@"上传face 返回的dict == %@",dict);
    }];
    [requestForm setFailedBlock :^{
        // 请求响应失败，返回错误信息
        NSError *error = [requestFormBlock error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
        
    }];
    [requestForm startAsynchronous];
}
//如果输入超过规定的字数100，就不再让输入
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location>=140)
    {
        NSLog(@"输入超过了140个字的限制!");

        return  NO;
    }
    else
    {
        return YES;
    }
}
@end
