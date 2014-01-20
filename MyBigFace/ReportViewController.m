//
//  ReportViewController.m
//  MyBigFace
//
//  Created by cy on 14-1-17.
//  Copyright (c) 2014年 ipointek. All rights reserved.
//

#import "ReportViewController.h"
#import "MyDB.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"

@interface ReportViewController ()

@end

@implementation ReportViewController

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
    if (IOS_VERSION_7_OR_ABOVE)
    {
//        NSLog(@"IOS_VERSION_7_OR_ABOVE");
    } else {
//        NSLog(@"NOT IOS_VERSION_7_OR_ABOVE");
        self.navigationController.navigationBar.hidden = NO;
    }

    //初始化 举报原因为1 垃圾广告
    info = @"1";
    btn1.selected = YES;
    //设置提交按钮圆角
    sendBtn.layer.masksToBounds = YES;
    sendBtn.layer.cornerRadius = 5.0;
    [self setupMenuButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupMenuButton
{
    //设置标题
    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    t.font = [UIFont systemFontOfSize:17];
    t.textColor = [UIColor whiteColor];
    t.backgroundColor = [UIColor clearColor];
    t.textAlignment = NSTextAlignmentCenter;
    t.text = @"举报";
    self.navigationItem.titleView = t;
    
    if (IOS_VERSION_7_OR_ABOVE) {
        NSLog(@"IOS_VERSION_7_OR_ABOVE");
        //左按钮
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        [backBtn setTintColor:[UIColor whiteColor]];
        self.navigationItem.leftBarButtonItem = backBtn;
        
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:251/255.0f green:209/255.0f blue:6/255.0f alpha:1.0f]];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        
    } else {
        NSLog(@"NOT IOS_VERSION_7_OR_ABOVE");
        self.navigationController.navigationBarHidden = YES;
        UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(110, 29, 100, 30)];
        t.font = [UIFont systemFontOfSize:17];
        t.textColor = [UIColor whiteColor];
        t.backgroundColor = [UIColor clearColor];
        t.textAlignment = NSTextAlignmentCenter;
        t.text = @"举报";
        [self.view addSubview:t];
        
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];

    }
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btn1Click:(id)sender//垃圾广告
{
    btn1.selected = YES;
    btn2.selected = NO;
    btn3.selected = NO;
    btn4.selected = NO;

    info =@"1";
//    NSLog(@"垃圾广告");
}
- (IBAction)btn2Click:(id)sender//淫秽色情
{
    btn1.selected = NO;
    btn2.selected = YES;
    btn3.selected = NO;
    btn4.selected = NO;

    info =@"2";
//    NSLog(@"淫秽色情");

}
- (IBAction)btn3Click:(id)sender//不实信息
{
    btn1.selected = NO;
    btn2.selected = NO;
    btn3.selected = YES;
    btn4.selected = NO;

    info =@"3";
//    NSLog(@"不实信息");

}
- (IBAction)btn4Click:(id)sender//敏感信息
{
    btn1.selected = NO;
    btn2.selected = NO;
    btn3.selected = NO;
    btn4.selected = YES;

    info =@"4";
//    NSLog(@"敏感信息");

}
- (IBAction)sendBtnClick:(id)sender//发送举报
{
    int faceClicked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"faceClicked"]intValue];
    MyDB *mydb = [[MyDB alloc]init];
    NSLog(@"faceView  faceClicked == %d",faceClicked);
    //myFace 设置的faceClicked 应该大于100000
    //大于 100000 说明是从 myFace页面跳转过来的 否侧是从主页面跳转的
    NSString *face_id = [[NSString alloc]init];
    if (faceClicked >= 100000)
    {
        face_id = [mydb myDate:@"id" num:faceClicked - 100000];
        //        NSLog(@"comment face_id in myDate == %@",face_id);
    }
    else
    {
        face_id = [mydb date:@"id" num:faceClicked];
        //        NSLog(@"comment face_id in date == %@",face_id);
    }
    NSLog(@"report 的时候face_id == %@",face_id);

    NSString *urlString = [NSString stringWithFormat:@"%@/report",MY_URL];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:url];
    [requestForm addRequestHeader:@"X-Token" value:[[NSUserDefaults standardUserDefaults]stringForKey:@"token"]];
    //要举报的 ID
    [requestForm setPostValue:face_id forKey:@"rid"];
    //举报原因
    [requestForm setPostValue:info forKey:@"info"];
    __block ASIFormDataRequest *requestFormBlock = requestForm;
    [requestForm setCompletionBlock :^{
        NSString *reprottString = [requestFormBlock responseString];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSMutableDictionary *dict = [jsonParser objectWithString:reprottString];
        NSLog(@"report dict == %@",dict);
    }];
    [requestForm setFailedBlock :^{
        // 请求响应失败，返回错误信息
        NSError *error = [requestFormBlock error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
    }];
    [requestForm startAsynchronous];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
