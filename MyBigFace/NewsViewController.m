//
//  NewsViewController.m
//  MyBigFace
//
//  Created by Suncry on 13-10-16.
//  Copyright (c) 2013年 ipointek. All rights reserved.
//

#import "NewsViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
@interface NewsViewController ()

@end

@implementation NewsViewController

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
//    [self loadNews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)newsBtnClick:(id)sender
{
    NSString *urlString = [NSString stringWithFormat:@"http://112.124.15.6:8001/comment/my?skip=0&take=48"];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"X-Token" value:[[NSUserDefaults standardUserDefaults]stringForKey:@"token"]];
    __block ASIHTTPRequest *requestBlock = request;
    [request setCompletionBlock :^{
        NSString *faceString = [requestBlock responseString];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSMutableDictionary *dict = [jsonParser objectWithString:faceString];
        NSLog(@"comment/my == %@",dict);
    }];
    [request setFailedBlock :^{
        // 请求响应失败，返回错误信息
        NSError *error = [requestBlock error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
    }];
    [request startAsynchronous];
}
- (void)loadNews
{
    NSString *urlString = [NSString stringWithFormat:@"http://112.124.15.6:8001/comment/my?skip=0&take=48"];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"X-Token" value:[[NSUserDefaults standardUserDefaults]stringForKey:@"token"]];
    __block ASIHTTPRequest *requestBlock = request;
    [request setCompletionBlock :^{
        NSString *faceString = [requestBlock responseString];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSMutableDictionary *dict = [jsonParser objectWithString:faceString];
        NSLog(@"comment/my == %@",dict);
    }];
    [request setFailedBlock :^{
        // 请求响应失败，返回错误信息
        NSError *error = [requestBlock error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
    }];
    [request startAsynchronous];

}
@end
