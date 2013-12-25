//
//  HomeViewController.m
//  MyBigFace
//
//  Created by Suncry on 13-10-16.
//  Copyright (c) 2013年 ipointek. All rights reserved.
//

#import "HomeViewController.h"
#import "DrawFaceViewController.h"
#import "FaceViewController.h"
//#import "UIViewController+MMDrawerController.h"
//#import "MMDrawerBarButtonItem.h"
#import "MyBigFaceCell.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "UIButton+WebCache.h"
#import "PPiFlatSegmentedControl.h"
#import "NSString+FontAwesome.h"
#import "NewsViewController.h"

#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"

@interface HomeViewController ()
{
}
@end

@implementation HomeViewController
@synthesize tableView = _tableview;
@synthesize locationManager = _locationManager;
@synthesize geocoder = _geocoder;
@synthesize mydb = _mydb;
@synthesize settingView = _settingView;
@synthesize feedBackView = _feedBackView;
@synthesize feedBackCommentLable = _feedBackCommentLable;
@synthesize feedBackEmailLable = _feedBackEmailLable;
@synthesize feedBackCommentTextView = _feedBackCommentTextView;
@synthesize feedBackEmailTextView = _feedBackEmailTextView;
@synthesize speechSwitch = _speechSwitch;

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
    self.blackBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SettingView_blackBackground.png"]];
    self.blackBackground.frame = CGRectMake(0, 0, 320, 568);
    self.blackBackground.alpha = 0;
    [self.view addSubview:self.blackBackground];

    //控制 switch 的开关
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"speech"]isEqualToString:@"no"])
    {
        self.speechSwitch.on = NO;
        //        NSLog(@"语音 关!");
    }
    else
    {
        self.speechSwitch.on = YES;
        //        NSLog(@"语音 开!");
        
    }
    
    
    //是否是第一次启动 如果是 加载启动界面
    if (![[[NSUserDefaults standardUserDefaults]valueForKey:@"isNotFirstStart"] isEqualToString:@"yes"])
    {
        [self startPage];
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"yes"] forKey:@"isNotFirstStart"];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //默认 获取 最新的face
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"0"] forKey:@"selectedSegmentIndex"];

    __weak HomeViewController *weakSelf = self;
    //setup pull-to-refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refreshData];
    }];
    
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreData];
    }];
    //登陆
    [self login];

    [self.tableView triggerPullToRefresh];

    
    //设置 navigation的左右item
    [self setupMenuButton];
    //初始化上拉下拉刷新控件
//    [self initRefreshBar];
    //获取地理信息
    [self findLocation];
    //获取广告识别符
    NSLog(@"identifierForVendor.UUIDString == %@",[UIDevice currentDevice].identifierForVendor.UUIDString);
    //进入程序 第一次 刷新数据
//    [_header beginRefreshing];
//    [NSTimer scheduledTimerWithTimeInterval:1 target:_header selector:@selector(beginRefreshing) userInfo:nil repeats:NO];
    //构建segmentedControl
    [self segmentedControlInit];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addFace
{
    DrawFaceViewController *drawFaceViewController = [[DrawFaceViewController alloc]init];
    [self.navigationController pushViewController:drawFaceViewController animated:YES];
}
-(void)setupMenuButton{
    //设置标题
    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    t.font = [UIFont systemFontOfSize:17];
    t.textColor = [UIColor whiteColor];
    t.backgroundColor = [UIColor clearColor];
    t.textAlignment = NSTextAlignmentCenter;
    t.text = @"微喷";
    self.navigationItem.titleView = t;
    //左按钮
    UIBarButtonItem *leftDrawerButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"MainView_ setting"] style:UIBarButtonItemStylePlain target:self action:@selector(leftDrawerButtonPress:)];
    [leftDrawerButton setTintColor:[UIColor whiteColor]];
    leftDrawerButton.imageInsets = UIEdgeInsetsMake(10, 0, 10, 20);
    self.navigationItem.leftBarButtonItem = leftDrawerButton;
    //右按钮
    UIBarButtonItem *rightDrawerButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"MainView_ self"] style:UIBarButtonItemStylePlain target:self action:@selector(rightDrawerButtonPress:)];
    [rightDrawerButton setTintColor:[UIColor whiteColor]];
    rightDrawerButton.imageInsets = UIEdgeInsetsMake(10, 20, 10, 0);
    self.navigationItem.rightBarButtonItem = rightDrawerButton;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:249/255.0f green:201/255.0f blue:12/255.0f alpha:1.0f]];

    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}
#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender
{
    //弹出settingView
    self.settingView.frame = CGRectMake(-320, 0, 320, 568);
    [self.view addSubview:self.settingView];
    
    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^(){
        self.navigationController.navigationBar.alpha = 0;
        self.blackBackground.alpha = 1;

    } completion:^(BOOL finished)
     {
         self.navigationController.navigationBar.hidden = YES;

     }];

        //commentView左滑
    [Animations moveRight:self.settingView andAnimationDuration:0.5 andWait:YES andLength:320.0];
}
-(void)rightDrawerButtonPress:(id)sender
{
    NewsViewController *newsViewController = [[NewsViewController alloc]init];
    [self.navigationController pushViewController:newsViewController animated:YES];
}
//初始化 下拉和上拉刷新控件
//- (void)initRefreshBar
//{
//    // 下拉刷新
//    _header = [MJRefreshHeaderView header];
//    _header.delegate = self;
//    _header.scrollView = self.tableView;
//    
//    // 上拉加载更多
//    _footer = [MJRefreshFooterView footer];
//    _footer.delegate = self;
//    _footer.scrollView = self.tableView;
//
//}
#pragma mark 代理方法-进入刷新状态就会调用
//- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
//{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"HH : mm : ss.SSS";
//    if (_header == refreshView) {
//        [self refreshData];
//    } else {
//        [self loadMoreData];
//    }
//}
- (void)dealloc
{
    // 释放资源
//    [_footer free];
//    [_header free];
}
#pragma mark tableView-代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 结束刷新状态
//    [_header endRefreshing];
//    [_footer endRefreshing];
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
    MyBigFaceCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[MyBigFaceCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    int faceCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"faceCount"]intValue];
//    NSLog(@"faceCount == %d",faceCount);
    if ((indexPath.row*3 + 0) < faceCount)
    {
        cell.faceBtn_0.enabled = YES;
        NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@%@",MY_URL,[self.mydb date:@"url" num:(indexPath.row*3 + 0)]]];
//        NSLog(@"加载face 时的 url == %@",url);
        [cell.faceBtn_0 setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"MainView_ defaultFace"]];
        [cell.faceBtn_0 addTarget:self action:@selector(faceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.faceBtn_0 setTag:1000 + indexPath.row*3 + 0];

    }
    else
    {
//        NSLog(@"第1个没有");
        [cell.faceBtn_0 setImage:nil forState:UIControlStateNormal];
        cell.faceBtn_0.enabled = NO;
    }

    if ((indexPath.row*3 + 1) < faceCount)
    {
        cell.faceBtn_1.enabled = YES;

        NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@%@",MY_URL,[self.mydb date:@"url" num:(indexPath.row*3 + 1)]]];

        [cell.faceBtn_1 setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"MainView_ defaultFace"]];
        [cell.faceBtn_1 addTarget:self action:@selector(faceBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        [cell.faceBtn_1 setTag:1000 + indexPath.row*3 + 1];
    }
    else
    {
//        NSLog(@"第2个没有");
        [cell.faceBtn_1 setImage:nil forState:UIControlStateNormal];
        cell.faceBtn_1.enabled = NO;
    }

    if ((indexPath.row*3 + 2) < faceCount)
    {
        cell.faceBtn_2.enabled = YES;

        NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@%@",MY_URL,[self.mydb date:@"url" num:(indexPath.row*3 + 2)]]];

        [cell.faceBtn_2 setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"MainView_ defaultFace"]];
        [cell.faceBtn_2 addTarget:self action:@selector(faceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.faceBtn_2 setTag:1000 + indexPath.row*3 + 2];

    }
    else
    {
//        NSLog(@"第3个没有");
        [cell.faceBtn_2 setImage:nil forState:UIControlStateNormal];

        cell.faceBtn_2.enabled = NO;

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (void)faceBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
//    NSLog(@"第几个 btn == %d",btn.tag - 1000);
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",btn.tag - 1000] forKey:@"faceClicked"];
//    int faceClicked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"faceClicked"]intValue];
//    NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://112.124.15.6:8001%@",[self.mydb date:@"url" num:faceClicked]]];
//    NSLog(@"url == %@",url);
//    NSLog(@"home页面 self.mydb date:@\"url\" num:faceClicked url == %@",[self.mydb date:@"url" num:faceClicked]);
//    NSLog(@"home 页面 的数据条数 == %d",[self.mydb getTableItemCount:@"face"]);
    FaceViewController *faceViewController = [[FaceViewController alloc]init];
    [self.navigationController pushViewController:faceViewController animated:YES];
}
//定位
- (void)findLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 1000.0f;
    [self.locationManager startUpdatingLocation];
}
//定位的委托方法
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"纬度 == %@",[NSString stringWithFormat:@"%3.5f",newLocation.coordinate.latitude]);
    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%3.5f",newLocation.coordinate.latitude] forKey:@"lat"];
    NSLog(@"经度 == %@",[NSString stringWithFormat:@"%3.5f",newLocation.coordinate.longitude]);
    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%3.5f",newLocation.coordinate.longitude] forKey:@"lng"];

    self.geocoder = [[CLGeocoder alloc]init];
    [self.geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error)
    {CLPlacemark *placemark = [placemarks objectAtIndex:0];
        //isoCountry.text = placemark.ISOcountryCode;
//        NSLog(@"placemark.ISOcountryCode == %@",placemark.ISOcountryCode);
        //country.text = plackmark.country;
//        NSLog(@"plackmark.country == %@",placemark.country);
        //adminArea.text = placemark.adminstrativeArea;
//        NSLog(@"placemark.adminstrativeArea == %@",placemark.administrativeArea);
        /**
         *  存储用户位置
         */
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@ %@",placemark.administrativeArea,placemark.subLocality] forKey:@"address"];
        NSLog(@"用户的位置 address ==  %@ ",[[NSUserDefaults standardUserDefaults]stringForKey:@"address"]);
        //locality.text = placemark.subLocality;
//        NSLog(@"placemark.subLocality == %@",placemark.subLocality);
    }];
    [self.locationManager stopUpdatingLocation];
}
- (void)login
{
    NSString *urlString = [NSString stringWithFormat:@"%@/device?device=%@",MY_URL,[UIDevice currentDevice].identifierForVendor.UUIDString];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:url];
    [requestForm setDelegate:self];
    [requestForm startSynchronous];
    NSError *error = [requestForm error];
    //输入返回的信息
    if (!error) {
        NSString *response = [requestForm responseString];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSMutableDictionary *dict = [jsonParser objectWithString:response];
        //获取 返回的 token 识别用户
        [[NSUserDefaults standardUserDefaults]setValue:[[dict objectForKey:@"data"] valueForKey:@"token"] forKey:@"token"];
        NSLog(@"login dict == %@",dict);
//
        NSLog(@"登陆时 token == %@",[[dict objectForKey:@"data"] valueForKey:@"token"]);
    }
}
//刷新table的填充数据
- (void)refreshData
{
    selectedSegmentIndex =[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSegmentIndex"]intValue];
//    NSLog(@"selectedSegmentIndex == %d",selectedSegmentIndex);
    NSString *str = @"newest";
    switch (selectedSegmentIndex) {
        case 0:
            str = @"newest";
            break;
        case 1:
            str = @"hot";
            break;
        case 2:
            str = @"round";
            break;
//        case 3:
//            str = @"my";
//            break;
        default:
            break;
    }
//    NSLog(@"str == %@",str);

    [self downloadData:str];
}
//加载更多table的填充数据
- (void)loadMoreData
{
    selectedSegmentIndex =[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSegmentIndex"]intValue];
    NSString *str = [[NSString alloc]init];
    switch (selectedSegmentIndex) {
        case 0:
            str = @"newest";
            break;
        case 1:
            str = @"hot";
            break;
        case 2:
            str = @"round";
            break;
//        case 3:
//            str = @"my";
//            break;
            
        default:
            break;
    }
    [self loadMoreData:str];

}
- (void)downloadData:(NSString *)info
{
    NSString *urlString = [NSString stringWithFormat:@"%@/face/%@?skip=0&take=48",MY_URL,info];
    if ([info isEqualToString:@"round"])
    {
        urlString = [NSString stringWithFormat:@"%@/face/%@?skip=0&take=48&lng=%@&lat=%@",MY_URL,info,[[NSUserDefaults standardUserDefaults]valueForKey:@"lng"],[[NSUserDefaults standardUserDefaults]valueForKey:@"lat"]];
    }
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"X-Token" value:[[NSUserDefaults standardUserDefaults]stringForKey:@"token"]];
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
                          user_id:[dataDic valueForKey:@"user_id"]
                          address:[dataDic valueForKey:@"address"]];
//            NSLog(@"downloadData address == %@",[self.mydb date:@"address" num:i]);
            i++;
        }
//        NSLog(@"home page dict == %@",dict);
        //储存 face 个数
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",i] forKey:@"faceCount"];
//        NSLog(@"刷新时 face 个数 == %d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"faceCount"]intValue]);
        __weak HomeViewController *weakSelf = self;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.pullToRefreshView stopAnimating];

//        // 结束刷新状态
//        [_header endRefreshing];
//        [_footer endRefreshing];

    }];
    [request setFailedBlock :^{
        // 请求响应失败，返回错误信息
        NSError *error = [requestBlock error ];
        NSLog ( @"home page error:%@" ,[error userInfo ]);
    }];
    [request startAsynchronous];
}
- (void)loadMoreData:(NSString *)info
{
    int faceCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"faceCount"]intValue];
    NSString *urlString = [NSString stringWithFormat:@"%@/face/%@?skip=%d&take=48",MY_URL,info,faceCount];
    if ([info isEqualToString:@"round"])
    {
        urlString = [NSString stringWithFormat:@"%@/face/%@?skip=%d&take=48&lng=%@&lat=%@",MY_URL,info,faceCount,[[NSUserDefaults standardUserDefaults]valueForKey:@"lng"],[[NSUserDefaults standardUserDefaults]valueForKey:@"lat"]];
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
                          user_id:[dataDic valueForKey:@"user_id"]
                          address:[dataDic valueForKey:@"address"]];
            i++;
        }
        //储存 face 个数
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",i] forKey:@"faceCount"];
//        NSLog(@"加载更多时 face 个数 == %d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"faceCount"]intValue]);
        __weak HomeViewController *weakSelf = self;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
//        // 结束刷新状态
//        [_header endRefreshing];
//        [_footer endRefreshing];

    }];
    [request setFailedBlock :^{
        // 请求响应失败，返回错误信息
        NSError *error = [requestBlock error ];
        NSLog ( @"加载更多时 error:%@" ,[error userInfo ]);
    }];
    [request startAsynchronous];
}
- (void)segmentedControlInit
{
    PPiFlatSegmentedControl *segmented=[[PPiFlatSegmentedControl alloc] initWithFrame:CGRectMake(40, 73, 246, 29) items:@[               @{@"text":@"最新"},@{@"text":@"最热"},@{@"text":@"附近"}]
                                                                         iconPosition:IconPositionRight andSelectionBlock:^(NSUInteger segmentIndex) {
//                                                                             selectedSegmentIndex = segmentIndex;
                                                                             [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",segmentIndex] forKey:@"selectedSegmentIndex"];

                                                                             [self.tableView triggerPullToRefresh];
//                                                                             [_header beginRefreshing];
                                                                         }];
    //    segmented.color=[UIColor colorWithRed:88.0f/255.0 green:88.0f/255.0 blue:88.0f/255.0 alpha:1];
    segmented.color=[UIColor whiteColor];
    segmented.borderWidth=0;
    segmented.borderColor=[UIColor whiteColor];
    //    segmented.selectedColor=[UIColor colorWithRed:0.0f/255.0 green:141.0f/255.0 blue:147.0f/255.0 alpha:1];
    segmented.selectedColor=[UIColor colorWithRed:249/255.0f green:201/255.0f blue:12/255.0f alpha:1.0f];
    
    segmented.textAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:13],
                               NSForegroundColorAttributeName:[UIColor colorWithRed:249/255.0f green:201/255.0f blue:12/255.0f alpha:1.0f]};
    segmented.selectedTextAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:13],
                                       NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.view addSubview:segmented];

}
- (IBAction)settingBtnClick:(id)sender;
{
    //收起settingView
    self.settingView.frame = CGRectMake(0, 0, 320, 568);
    [self.view addSubview:self.settingView];
    
    //commentView左滑
    [Animations moveLeft:self.settingView andAnimationDuration:0.5 andWait:YES andLength:320.0];
    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^(){
        self.navigationController.navigationBar.hidden = NO;
        self.navigationController.navigationBar.alpha = 1;
        self.blackBackground.alpha = 0;
    } completion:^(BOOL finished)
     {
     }];
}
//给我评分
- (IBAction)rateMe:(id)sender
{
    NSString *str = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", @"346703830"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
//意见反馈
- (IBAction)feedBack:(id)sender
{
    //弹出意见反馈
    self.feedBackView.frame = CGRectMake(0, 568, 320, 568);
    [self.view addSubview:self.feedBackView];
    //feedBackView上滑
    [Animations moveUp:self.feedBackView andAnimationDuration:0.5 andWait:YES andLength:568];
    
    [self.feedBackCommentTextView becomeFirstResponder];

}
- (IBAction)feedBackCancle:(id)sender
{
    //收起意见反馈
    self.feedBackView.frame = CGRectMake(0, 0, 320, 568);
    [self.view addSubview:self.feedBackView];
    //feedBackView上滑
    [Animations moveDown:self.feedBackView andAnimationDuration:0.5 andWait:YES andLength:568];
    [self.feedBackCommentTextView resignFirstResponder];
    [self.feedBackEmailTextView resignFirstResponder];

}
- (IBAction)feedBackSend:(id)sender
{
    //发送 反馈信息
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.ipointek.com/feedback/api/feedback"]];
    //@"http://www.ipointek.com/feedback/api/feedback
    //    post 方式
    //    appid = 1012
    //    content = 内容
    //    os_version = 系统版本
    //    client_version = 客户端版本
    //    email = 邮箱
    NSString *osVersion =[[ UIDevice currentDevice]systemVersion];
    NSString *osModel = [[ UIDevice currentDevice]model];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *clientVersion =  [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *bundleNum = [infoDictionary objectForKey:(NSString *)kCFBundleVersionKey];
    
    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:url];
    [requestForm setPostValue:@"1012" forKey:@"appid"];
    [requestForm setPostValue:self.feedBackEmailTextView.text forKey:@"email"];
    [requestForm setPostValue:self.feedBackCommentTextView.text forKey:@"content"];
    [requestForm setPostValue:[NSString stringWithFormat:@"iOS %@ Model:%@",osVersion,osModel] forKey:@"os_version"];
    [requestForm setPostValue:[NSString stringWithFormat:@"Client v%@ Build:%@",clientVersion,bundleNum] forKey:@"client_version"];
    __block ASIFormDataRequest *requestFormBlock = requestForm;
    [requestForm setCompletionBlock :^{
        NSString *commentString = [requestFormBlock responseString];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSMutableDictionary *dict = [jsonParser objectWithString:commentString];
        NSLog(@"commentSend dict == %@",dict);
    }];
    [requestForm setFailedBlock :^{
        // 请求响应失败，返回错误信息
        NSError *error = [requestFormBlock error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
    }];
    [requestForm startAsynchronous];

    //收起意见反馈
    self.feedBackView.frame = CGRectMake(0, 0, 320, 568);
    [self.view addSubview:self.feedBackView];
    //feedBackView上滑
    [Animations moveDown:self.feedBackView andAnimationDuration:0.5 andWait:YES andLength:568];
    self.feedBackCommentTextView.text = @"";
    self.feedBackEmailTextView.text = @"";
    self.feedBackCommentLable.text = @"请填写你的意见,我们将因您而不断改进.";
    self.feedBackEmailLable.text = @"请填写你的邮箱,以便我们给您回复.";
    [self.feedBackCommentTextView resignFirstResponder];
    [self.feedBackEmailTextView resignFirstResponder];

}

- (IBAction)speechSwitch:(id)sender
{
    if ([sender isOn])
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"speech"];
//        NSLog(@"语音 开!");
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"no" forKey:@"speech"];
//        NSLog(@"语音 关!");

    }
    
}
/**
 *  uitextView的代理方法 实现palceholder
 *
 *  @param textView
 */

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0)
    {
        if (textView.tag == 1001)
        {
            self.feedBackCommentLable.text = @"请填写你的意见,我们将因您而不断改进.";
        }
        if (textView.tag == 1002)
        {
            self.feedBackEmailLable.text = @"请填写你的邮箱,以便我们给您回复.";
        }
    }
    else
    {
        if (textView.tag == 1001)
        {
            self.feedBackCommentLable.text = @"";
        }
        if (textView.tag == 1002)
        {
            self.feedBackEmailLable.text = @"";
        }
    }
}
- (void)startPage
{
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.alpha = 0;
    
    self.startView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, [self.view bounds].size.height)];
    self.startView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [self.startView addGestureRecognizer:tap];

    [self.view addSubview:self.startView];
    
    UIImageView *helpImg= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, [self.view bounds].size.height)];
    helpImg.image = [UIImage imageNamed:@"helpPage_01.png"];
    [self.startView addSubview:helpImg];
    
    
    UIScrollView *startScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, [self.view bounds].size.height)];
    startScrollView.contentSize = CGSizeMake(320*3, [self.view bounds].size.height);
    startScrollView.delegate = self;
    startScrollView.pagingEnabled = YES;
    [self.startView addSubview:startScrollView];
    
    UIImageView *startPageImg_1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, [self.view bounds].size.height)];
    [startPageImg_1 setImage:[UIImage imageNamed:@"StartPage_01.png"]];
    [startScrollView addSubview:startPageImg_1];
    
    UIImageView *startPageImg_2 = [[UIImageView alloc]initWithFrame:CGRectMake(320, 0, 320, [self.view bounds].size.height)];
    [startPageImg_2 setImage:[UIImage imageNamed:@"StartPage_02.png"]];
    [startScrollView addSubview:startPageImg_2];

    UIImageView *startPageImg_3 = [[UIImageView alloc]initWithFrame:CGRectMake(320*2, 0, 320, [self.view bounds].size.height)];
    [startPageImg_3 setImage:[UIImage imageNamed:@"StartPage_03.png"]];
    [startScrollView addSubview:startPageImg_3];
    
    
    self.startDot1 = [[UIImageView alloc]initWithFrame:CGRectMake(110, 40, 14, 14)];
    self.startDot1.center = CGPointMake(140, 40);
    self.startDot1.image = [UIImage imageNamed:@"StartPage_dot.png"];
    [self.startView addSubview:self.startDot1];

    self.startDot2 = [[UIImageView alloc]initWithFrame:CGRectMake(150, 40, 14, 14)];
    self.startDot2.center = CGPointMake(160, 40);

    self.startDot2.image = [UIImage imageNamed:@"StartPage_ring.png"];
    [self.startView addSubview:self.startDot2];

    self.startDot3 = [[UIImageView alloc]initWithFrame:CGRectMake(180, 40, 14, 14)];
    self.startDot3.center = CGPointMake(180, 40);

    self.startDot3.image = [UIImage imageNamed:@"StartPage_ring.png"];
    [self.startView addSubview:self.startDot3];

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"contentOffset.x   == %f",scrollView.contentOffset.x);
    if (scrollView.contentOffset.x > 730)
    {
        self.startDot1.hidden = YES;
        self.startDot2.hidden = YES;
        self.startDot3.hidden = YES;

        [UIView animateWithDuration:1 delay:0 options:0 animations:^(){
            self.navigationController.navigationBar.alpha = 1;
            scrollView.frame = CGRectMake(-320, 0, 320, [self.view bounds].size.height);
        } completion:^(BOOL finished)
         {
         }];

    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.x > 320)
    {
        self.startDot1.image = [UIImage imageNamed:@"StartPage_ring.png"];
        self.startDot2.image = [UIImage imageNamed:@"StartPage_ring.png"];
        self.startDot3.image = [UIImage imageNamed:@"StartPage_dot.png"];

    }
    else
    {
        if (scrollView.contentOffset.x > 0)
        {
            self.startDot1.image = [UIImage imageNamed:@"StartPage_ring.png"];
            self.startDot2.image = [UIImage imageNamed:@"StartPage_dot.png"];
            self.startDot3.image = [UIImage imageNamed:@"StartPage_ring.png"];
        }
        else
        {
            self.startDot1.image = [UIImage imageNamed:@"StartPage_dot.png"];
            self.startDot2.image = [UIImage imageNamed:@"StartPage_ring.png"];
            self.startDot3.image = [UIImage imageNamed:@"StartPage_ring.png"];

        }
    
    }


}
- (void)tapGesture:(id)sender
{
    NSLog(@"tap!!!!!!!");
    
//    UIView *view = (UIView *)sender;

    [UIView animateWithDuration:1 delay:0 options:0 animations:^(){
        self.startView.alpha = 0;
    } completion:^(BOOL finished)
     {
         self.navigationController.navigationBar.alpha = 1;
         self.navigationController.navigationBar.hidden = NO;

         self.startView.hidden = YES;
     }];

}
@end
