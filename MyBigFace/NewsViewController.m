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
//#import "UIButton+WebCache.h"
#import "MyFaceCell.h"
#import "UIImageView+WebCache.h"
#import "FaceViewController.h"

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
    [self setupMenuButton];
    //初始化上拉下拉刷新控件
    [self initRefreshBar];
    
//进入 默认刷新一次
    [_header beginRefreshing];
//    [NSTimer scheduledTimerWithTimeInterval:1 target:_header selector:@selector(beginRefreshing) userInfo:nil repeats:NO];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadNews
{
    NSString *urlString = [NSString stringWithFormat:@"%@/face/my?skip=0&take=48",MY_URL];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"X-Token" value:[[NSUserDefaults standardUserDefaults]stringForKey:@"token"]];
    __block ASIHTTPRequest *requestBlock = request;
    [request setCompletionBlock :^{
        NSString *faceString = [requestBlock responseString];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSMutableDictionary *dict = [jsonParser objectWithString:faceString];
//        NSLog(@"face/my dict == %@",dict);
//        NSLog(@"face/my dataArray == %@",[dict objectForKey:@"data"]);

        //清空储存的face信息
        [self.mydb eraseTable:@"myFace"];
        int i = 0;
        /**
         *  将获取到得face信息写入本地数据库
         *
         *  @param num                myFace 在数据库中得排序
         *  @param face_id            face 在后台的ID
         *  @param content            face 的内容
         *  @param created_at         face 的创建时间
         *  @param updated_at         face 的更新时间
         *  @param lat                face 经度
         *  @param lng                face 纬度
         *  @param plus               face 赞的个数
         *  @param latest_plus_num    face 新的赞的个数
         *  @param url                face 图片的地址
         *  @param user_id            发表face的用户的ID
         *  @param all_comment_num    face 总的评论数量
         *  @param latest_comment_num face 新的评论的数量
         */

        for (NSDictionary *dataDic in [dict objectForKey:@"data"])
        {
            [self.mydb insertMyFace:i
                          face_id:[[dataDic valueForKey:@"id"]intValue]
                          content:[dataDic valueForKey:@"content"]
                       created_at:[dataDic valueForKey:@"created_at"]
                       updated_at:[dataDic valueForKey:@"updated_at"]
                              lat:[dataDic valueForKey:@"lat"]
                              lng:[dataDic valueForKey:@"lng"]
                             plus:[[dataDic valueForKey:@"plus"]intValue]
                      latest_plus:[[dataDic valueForKey:@"latest_plus"]intValue]
                              url:[dataDic valueForKey:@"url"]
                          user_id:[dataDic valueForKey:@"user_id"]
                      all_comment:[[dataDic valueForKey:@"all_comment"]intValue]
                       latest_num:[[dataDic valueForKey:@"latest_num"]intValue]
                            address:[dataDic valueForKey:@"address"]];
            i++;
//            NSLog(@"dataDic address == %@",[dataDic valueForKey:@"address"]);

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
    /**
     *
     *  改变图片文字的颜色 和去掉 新增动态的数量 标示 动态已经阅读
     *
     */
    ((MyFaceCell *)[tableView cellForRowAtIndexPath:indexPath]).plusImageView.image = [UIImage imageNamed:@"MyFace_plus.png"];
    ((MyFaceCell *)[tableView cellForRowAtIndexPath:indexPath]).commentImageView.image = [UIImage imageNamed:@"MyFace_comment.png"];
    ((MyFaceCell *)[tableView cellForRowAtIndexPath:indexPath]).plusLabel.textColor = [UIColor lightGrayColor];
    [((MyFaceCell *)[tableView cellForRowAtIndexPath:indexPath]).plusLabel setText:[NSString stringWithFormat:@"%@",[self.mydb myDate:@"plus" num:indexPath.row]]];
    ((MyFaceCell *)[tableView cellForRowAtIndexPath:indexPath]).commentLabel.textColor = [UIColor lightGrayColor];
    [((MyFaceCell *)[tableView cellForRowAtIndexPath:indexPath]).commentLabel setText:[NSString stringWithFormat:@"%@",[self.mydb myDate:@"all_comment" num:indexPath.row]]];
    /**
     *  返回face_id 标示动态已经读取
     */
    NSString *urlString = [NSString stringWithFormat:@"%@/comment/my?id=%@",MY_URL,[self.mydb myDate:@"id" num:(indexPath.row)]];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"X-Token" value:[[NSUserDefaults standardUserDefaults]stringForKey:@"token"]];
    __block ASIHTTPRequest *requestBlock = request;
    [request setCompletionBlock :^{
        NSString *faceString = [requestBlock responseString];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSMutableDictionary *dict = [jsonParser objectWithString:faceString];
        NSLog(@"comment/my dict == %@",dict);
    }];
    [request setFailedBlock :^{
        // 请求响应失败，返回错误信息
        NSError *error = [requestBlock error ];
        NSLog ( @"comment/my error:%@" ,[error userInfo ]);
    }];
    [request startAsynchronous];
    /**
     *  跳转至对应页面
     */
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",indexPath.row + 100000] forKey:@"faceClicked"];
//    NSLog(@"myFace 设置 faceClicked == %d ",indexPath.row + 100000);
    FaceViewController *faceViewController = [[FaceViewController alloc]init];
    [self.navigationController pushViewController:faceViewController animated:YES];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    MyFaceCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[MyFaceCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    /**
     *
     *  face图片
     *
     */
    NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@%@",MY_URL,[self.mydb myDate:@"url" num:(indexPath.row)]]];
//        NSLog(@"加载face 时的 url == %@",url);
    [cell.faceImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"MainView_ defaultFace"]];
    /**
     *
     *  face地理位置
     *
     */
    [cell.locationLabel setText:[self.mydb myDate:@"address" num:(indexPath.row)]];
//        NSLog(@"加载face 时的 address == %@",[self.mydb myDate:@"address" num:(indexPath.row)]);
    /**
     *
     *  face时间
     *
     */
    NSString *timeString= [[self.mydb myDate:@"created_at" num:indexPath.row] substringWithRange:NSMakeRange(0,10)];
    [cell.timeOfUploadLabel setText:[NSString stringWithFormat:@"%@",timeString]];

    /**
     *
     *  face赞
     *
     */
    if ([[self.mydb myDate:@"latest_plus" num:indexPath.row] integerValue] == 0)
    {
        [cell.plusLabel setText:[NSString stringWithFormat:@"%@",[self.mydb myDate:@"plus" num:indexPath.row]]];
    }
    else
    {
        cell.plusImageView.image = [UIImage imageNamed:@"MyFace_new_plus.png"];
        cell.plusLabel.textColor = [UIColor redColor];
        [cell.plusLabel setText:[NSString stringWithFormat:@"%@  +%@",[self.mydb myDate:@"plus" num:indexPath.row],[self.mydb myDate:@"latest_plus" num:indexPath.row]]];
    }
    /**
     *
     *  face评论
     *
     */

    if ([[self.mydb myDate:@"latest_num" num:indexPath.row] integerValue] == 0)
    {
        [cell.commentLabel setText:[NSString stringWithFormat:@"%@",[self.mydb myDate:@"all_comment" num:indexPath.row]]];
    }
    else
    {
        cell.commentImageView.image = [UIImage imageNamed:@"MyFace_new_comment"];
        cell.commentLabel.textColor = [UIColor redColor];
        [cell.commentLabel setText:[NSString stringWithFormat:@"%@  +%@",[self.mydb myDate:@"all_comment" num:indexPath.row],[self.mydb myDate:@"latest_num" num:indexPath.row]]];
    }
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 182;
}
//刷新table的填充数据
- (void)refreshData
{
    [self loadNews];
}
//加载更多table的填充数据
- (void)loadMoreData
{
    int faceCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"faceCount"]intValue];
    NSString *urlString = [NSString stringWithFormat:@"%@/face/my?skip=%d&take=48",MY_URL,faceCount];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"X-Token" value:[[NSUserDefaults standardUserDefaults]stringForKey:@"token"]];
    __block ASIHTTPRequest *requestBlock = request;
    [request setCompletionBlock :^{
        NSString *faceString = [requestBlock responseString];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSMutableDictionary *dict = [jsonParser objectWithString:faceString];
        NSLog(@"加载更多时 face/my dict == %@",dict);
        //清空储存的face信息
//        [self.mydb eraseTable:@"myFace"];
        int i = faceCount;
        /**
         *  将获取到得face信息写入本地数据库
         *
         *  @param num                myFace 在数据库中得排序
         *  @param face_id            face 在后台的ID
         *  @param content            face 的内容
         *  @param created_at         face 的创建时间
         *  @param updated_at         face 的更新时间
         *  @param lat                face 经度
         *  @param lng                face 纬度
         *  @param plus               face 赞的个数
         *  @param latest_plus_num    face 新的赞的个数
         *  @param url                face 图片的地址
         *  @param user_id            发表face的用户的ID
         *  @param all_comment_num    face 总的评论数量
         *  @param latest_comment_num face 新的评论的数量
         */
        
        for (NSDictionary *dataDic in [dict objectForKey:@"data"])
        {
            [self.mydb insertMyFace:i
                            face_id:[[dataDic valueForKey:@"id"]intValue]
                            content:[dataDic valueForKey:@"content"]
                         created_at:[dataDic valueForKey:@"created_at"]
                         updated_at:[dataDic valueForKey:@"updated_at"]
                                lat:[dataDic valueForKey:@"lat"]
                                lng:[dataDic valueForKey:@"lng"]
                               plus:[[dataDic valueForKey:@"plus"]intValue]
                        latest_plus:[[dataDic valueForKey:@"latest_plus"]intValue]
                                url:[dataDic valueForKey:@"url"]
                            user_id:[dataDic valueForKey:@"user_id"]
                        all_comment:[[dataDic valueForKey:@"all_comment"]intValue]
                         latest_num:[[dataDic valueForKey:@"latest_num"]intValue]
                            address:[dataDic valueForKey:@"address"]];

            i++;
            //            NSLog(@"url == %@",[_mydb date:@"url" num:i]);
            
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
-(void)setupMenuButton{
    //设置标题
    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    t.font = [UIFont systemFontOfSize:24];
    t.textColor = [UIColor whiteColor];
    t.backgroundColor = [UIColor clearColor];
    t.textAlignment = NSTextAlignmentCenter;
    t.text = @"我的表情";
    self.navigationItem.titleView = t;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:249/255.0f green:201/255.0f blue:12/255.0f alpha:1.0f]];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}
@end
