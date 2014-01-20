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
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextPage
{
    if (mytextView.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<!" message:@"还是说点什么吧!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        // optional - add more buttons:
//        [alert addButtonWithTitle:@"Yes"];
        [alert show];

    }
    else
    {
        [self upLoadFace];
        [self.navigationController popToRootViewControllerAnimated:YES];

    }
    
}
-(void)setupMenuButton{
    if (IOS_VERSION_7_OR_ABOVE) {
        NSLog(@"IOS_VERSION_7_OR_ABOVE");
        //设置标题
        UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        t.font = [UIFont systemFontOfSize:17];
        t.textColor = [UIColor whiteColor];
        t.backgroundColor = [UIColor clearColor];
        t.textAlignment = NSTextAlignmentCenter;
        t.text = @"写心情";
        self.navigationItem.titleView = t;
        //自定义 返回按钮
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        self.navigationItem.leftBarButtonItem = backButton;
        //自定义 下一步按钮
//        UIBarButtonItem *nextButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Next"] style:UIBarButtonItemStylePlain target:self action:@selector(nextPage)];
        //next按钮
        UIBarButtonItem * nextButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(nextPage)];

        self.navigationItem.rightBarButtonItem = nextButton;
        //    self.navigationController.navigationBar.barTintColor = [UIColor redColor];

    } else {
        NSLog(@"NOT IOS_VERSION_7_OR_ABOVE");
        self.navigationController.navigationBarHidden = YES;
        //设置标题
        UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(110, 29, 100, 30)];
        t.font = [UIFont systemFontOfSize:17];
        t.textColor = [UIColor whiteColor];
        t.backgroundColor = [UIColor clearColor];
        t.textAlignment = NSTextAlignmentCenter;
        t.text = @"写心情";
        [self.view addSubview:t];
        
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [_nextBtn addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];

    }

    
}
- (void)upLoadFace
{
    NSString *urlString = [NSString stringWithFormat:@"%@/face/upload",MY_URL];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:url];
    [requestForm setRequestMethod:@"POST"];
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm addRequestHeader:@"X-Token" value:[[NSUserDefaults standardUserDefaults]stringForKey:@"token"]];
    NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"myFace"];
    [requestForm setData:imageData forKey:@"image"];
    [requestForm setPostValue:[[NSUserDefaults standardUserDefaults]stringForKey:@"address"] forKey:@"address"];
    NSLog(@"上传face时 地址为  %@",[[NSUserDefaults standardUserDefaults]stringForKey:@"address"]);
    [requestForm setPostValue:mytextView.text forKey:@"content"];

    [requestForm setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"lng"] forKey:@"lng"];
    [requestForm setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"lat"] forKey:@"lat"];
//    NSLog(@"上传时的lng == %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"lng"]);
//    NSLog(@"上传时的lat == %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"lat"]);

    
    __block ASIHTTPRequest *requestFormBlock = requestForm;
    [requestForm setCompletionBlock :^{
//        NSString *faceString = [requestFormBlock responseString];
//        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
//        NSMutableDictionary *dict = [jsonParser objectWithString:faceString];
//        NSLog(@"上传face 返回的dict == %@",dict);
    }];
    [requestForm setFailedBlock :^{
        // 请求响应失败，返回错误信息
        NSError *error = [requestFormBlock error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
        
    }];
    [requestForm startAsynchronous];
}
//如果输入超过规定的字数140，就不再让输入
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //禁止换行...实现 done 按钮
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    //判断加上输入的字符，是否超过界限
    NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];
    if (str.length > 110)
    {
        textView.text = [str substringToIndex:110];
        return NO;
    }
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"textView.text.length == %d",textView.text.length);
    
    //该判断用于联想输入
    if (textView.text.length > 110)
    {
        NSLog(@"超出了 140 字符的限制");
        textView.text = [textView.text substringToIndex:14];
    }
    
}

@end
