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
#import "MJRefresh.h"
#import "UIButton+WebCache.h"

@interface NewsViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;

}
@end

@implementation NewsViewController
@synthesize tableView = _tableview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    //初始化 用于储存face信息的数组
    self.mydb = [[MyDB alloc]init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self loadNews];
    //初始化上拉下拉刷新控件
    [self initRefreshBar];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (IBAction)newsBtnClick:(id)sender
//{
//    NSString *urlString = [NSString stringWithFormat:@"http://112.124.15.6:8001/comment/my?skip=0&take=48"];
//    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//    [request addRequestHeader:@"X-Token" value:[[NSUserDefaults standardUserDefaults]stringForKey:@"token"]];
//    __block ASIHTTPRequest *requestBlock = request;
//    [request setCompletionBlock :^{
//        NSString *faceString = [requestBlock responseString];
//        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
//        NSMutableDictionary *dict = [jsonParser objectWithString:faceString];
//        NSLog(@"comment/my == %@",dict);
//    }];
//    [request setFailedBlock :^{
//        // 请求响应失败，返回错误信息
//        NSError *error = [requestBlock error ];
//        NSLog ( @"error:%@" ,[error userInfo ]);
//    }];
//    [request startAsynchronous];
//}
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
//初始化 下拉和上拉刷新控件
- (void)initRefreshBar
{
    // 下拉刷新
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = self.tableView;
    
    // 上拉加载更多
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = self.tableView;
    
}
#pragma mark 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH : mm : ss.SSS";
    if (_header == refreshView) {
        [self refreshData];
    } else {
        [self loadMoreData];
    }
    //    [NSTimer scheduledTimerWithTimeInterval:1 target:self.tableView selector:@selector(reloadData) userInfo:nil repeats:NO];
    //    [self.tableView reloadData];
}
- (void)dealloc
{
    // 释放资源
    [_footer free];
    [_header free];
}
#pragma mark tableView-代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 让刷新控件恢复默认的状态
    [_header endRefreshing];
    [_footer endRefreshing];
    int faceCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"faceCount"]intValue];
    int numberOfRows = faceCount/3;
    if (faceCount%3 != 0 )
    {
        numberOfRows ++;
    }
    return numberOfRows;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    FaceViewController *faceViewController = [[FaceViewController alloc]init];
    //    [self.navigationController pushViewController:faceViewController animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
//刷新table的填充数据
- (void)refreshData
{
    //    NSLog(@"refreshData  selectedSegmentIndex == %d",self.segmentControl.selectedSegmentIndex);
    NSString *str = @"newest";
    [self downloadData:str];
}
//加载更多table的填充数据
- (void)loadMoreData
{
    //    NSLog(@"loadMoreData  selectedSegmentIndex == %d",self.segmentControl.selectedSegmentIndex);
    NSString *str = @"my";
    [self loadMoreData:str];
    
}
- (void)downloadData:(NSString *)info
{
    NSString *urlString = [NSString stringWithFormat:@"http://112.124.15.6:8001/face/%@?skip=0&take=48",info];
    if ([info isEqualToString:@"round"])
    {
        urlString = [NSString stringWithFormat:@"http://112.124.15.6:8001/face/%@?skip=0&take=48&lng=%@&lat=%@",info,[[NSUserDefaults standardUserDefaults]valueForKey:@"lng"],[[NSUserDefaults standardUserDefaults]valueForKey:@"lat"]];
    }
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"X-Token" value:[[NSUserDefaults standardUserDefaults]stringForKey:@"token"]];
    //    [request startSynchronous];
    __block ASIHTTPRequest *requestBlock = request;
    [request setCompletionBlock :^{
        NSString *faceString = [requestBlock responseString];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSMutableDictionary *dict = [jsonParser objectWithString:faceString];
        //清空储存的face信息
        [self.mydb eraseTable:@"face"];
        int i = 0;
        for (NSDictionary *dataDic in [dict objectForKey:@"data"])
        {
            [self.mydb insertFace:i
                          face_id:[[dataDic valueForKey:@"id"]intValue]
                          content:[dataDic valueForKey:@"content"]
                       created_at:[dataDic valueForKey:@"created_at"]
                       updated_at:[dataDic valueForKey:@"updated_at"]
                              lat:[dataDic valueForKey:@"lat"]
                              lng:[dataDic valueForKey:@"lng"]
                             plus:[[dataDic valueForKey:@"plus"]intValue]
                              url:[dataDic valueForKey:@"url"]
                          user_id:[dataDic valueForKey:@"user_id"]];
            //            NSLog(@"url == %@",[_mydb date:@"url" num:i]);
            i++;
        }
        //储存 face 个数
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",i] forKey:@"faceCount"];
        //        NSLog(@"刷新时 face 个数 == %d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"faceCount"]intValue]);
        [self.tableView reloadData];
    }];
    [request setFailedBlock :^{
        // 请求响应失败，返回错误信息
        NSError *error = [requestBlock error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
    }];
    [request startAsynchronous];
}
- (void)loadMoreData:(NSString *)info
{
    int faceCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"faceCount"]intValue];
    NSString *urlString = [NSString stringWithFormat:@"http://112.124.15.6:8001/face/%@?skip=%d&take=48",info,faceCount];
    if ([info isEqualToString:@"round"])
    {
        urlString = [NSString stringWithFormat:@"http://112.124.15.6:8001/face/%@?skip=%d&take=48&lng=%@&lat=%@",info,faceCount,[[NSUserDefaults standardUserDefaults]valueForKey:@"lng"],[[NSUserDefaults standardUserDefaults]valueForKey:@"lat"]];
    }
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"X-Token" value:[[NSUserDefaults standardUserDefaults]stringForKey:@"token"]];
    __block ASIHTTPRequest *requestBlock = request;
    [request setCompletionBlock :^{
        NSString *faceString = [requestBlock responseString];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSMutableDictionary *dict = [jsonParser objectWithString:faceString];
        //        NSLog(@"dict == %@",dict);
        int i = faceCount;
        for (NSDictionary *dataDic in [dict objectForKey:@"data"])
        {
            //            [self.face addObject:dataDic];
            [self.mydb insertFace:i
                          face_id:[[dataDic valueForKey:@"id"]intValue]
                          content:[dataDic valueForKey:@"content"]
                       created_at:[dataDic valueForKey:@"created_at"]
                       updated_at:[dataDic valueForKey:@"updated_at"]
                              lat:[dataDic valueForKey:@"lat"]
                              lng:[dataDic valueForKey:@"lng"]
                             plus:[[dataDic valueForKey:@"plus"]intValue]
                              url:[dataDic valueForKey:@"url"]
                          user_id:[dataDic valueForKey:@"user_id"]];
            i++;
        }
        //储存 face 个数
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",i] forKey:@"faceCount"];
        NSLog(@"加载更多时 face 个数 == %d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"faceCount"]intValue]);
        [self.tableView reloadData];
    }];
    [request setFailedBlock :^{
        // 请求响应失败，返回错误信息
        NSError *error = [requestBlock error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
    }];
    [request startAsynchronous];
}

@end
