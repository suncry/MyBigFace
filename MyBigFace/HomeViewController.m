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
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "MJRefresh.h"
#import "MyBigFaceCell.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "UIButton+WebCache.h"
#import "PPiFlatSegmentedControl.h"
#import "NSString+FontAwesome.h"

@interface HomeViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
}
@end

@implementation HomeViewController
@synthesize tableView = _tableview;
@synthesize locationManager = _locationManager;
@synthesize geocoder = _geocoder;
@synthesize mydb = _mydb;
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
    selectedSegmentIndex = 0;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //设置 navigation的左右item
    [self setupMenuButton];
    //初始化上拉下拉刷新控件
    [self initRefreshBar];
    //获取地理信息
    [self findLocation];
    //获取广告识别符
    NSLog(@"identifierForVendor.UUIDString == %@",[UIDevice currentDevice].identifierForVendor.UUIDString);
    //登陆
    [self login];
    //进入程序 第一次 刷新数据
//    [_header beginRefreshing];
    [NSTimer scheduledTimerWithTimeInterval:1 target:_header selector:@selector(beginRefreshing) userInfo:nil repeats:NO];
    
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
    self.navigationItem.title = @"大饼";
    //左按钮
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"MainView_ setting"] style:UIBarButtonItemStylePlain target:self action:@selector(leftDrawerButtonPress:)];
    [leftDrawerButton setTintColor:[UIColor whiteColor]];
    leftDrawerButton.imageInsets = UIEdgeInsetsMake(10, 0, 10, 20);
    self.navigationItem.leftBarButtonItem = leftDrawerButton;
    //右按钮
    MMDrawerBarButtonItem *rightDrawerButton = [[MMDrawerBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"MainView_ self"] style:UIBarButtonItemStylePlain target:self action:@selector(rightDrawerButtonPress:)];
    [rightDrawerButton setTintColor:[UIColor whiteColor]];
    rightDrawerButton.imageInsets = UIEdgeInsetsMake(10, 20, 10, 0);

    self.navigationItem.rightBarButtonItem = rightDrawerButton;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:249/255.0f green:201/255.0f blue:12/255.0f alpha:1.0f]];
}
#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
-(void)rightDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
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

        NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://112.124.15.6:8001%@",[self.mydb date:@"url" num:(indexPath.row*3 + 0)]]];
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

        NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://112.124.15.6:8001%@",[self.mydb date:@"url" num:(indexPath.row*3 + 1)]]];

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

        NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://112.124.15.6:8001%@",[self.mydb date:@"url" num:(indexPath.row*3 + 2)]]];

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
//- (IBAction)valueChanged:(id)sender
//{
//    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
//    NSLog(@"sender.value == %d",segmentedControl.selectedSegmentIndex);
//    [_header beginRefreshing];
//}
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
        NSLog(@"placemark.adminstrativeArea == %@",placemark.administrativeArea);
        //locality.text = placemark.subLocality;
//        NSLog(@"placemark.subLocality == %@",placemark.subLocality);
    }];
    [self.locationManager stopUpdatingLocation];
}

- (void)login
{
    NSString *urlString = [NSString stringWithFormat:@"http://112.124.15.6:8001/device?device=%@",[UIDevice currentDevice].identifierForVendor.UUIDString];
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
        NSLog(@"登陆时 token == %@",[[dict objectForKey:@"data"] valueForKey:@"token"]);
    }
}

//刷新table的填充数据
- (void)refreshData
{
//    NSLog(@"refreshData  selectedSegmentIndex == %d",self.segmentControl.selectedSegmentIndex);
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
        case 3:
            str = @"my";
            break;
        default:
            break;
    }
    [self downloadData:str];
}
//加载更多table的填充数据
- (void)loadMoreData
{
//    NSLog(@"loadMoreData  selectedSegmentIndex == %d",self.segmentControl.selectedSegmentIndex);
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
        case 3:
            str = @"my";
            break;
            
        default:
            break;
    }
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

- (void)segmentedControlInit
{
    PPiFlatSegmentedControl *segmented=[[PPiFlatSegmentedControl alloc] initWithFrame:CGRectMake(40, 73, 246, 29) items:@[               @{@"text":@"最新"},@{@"text":@"最热"},@{@"text":@"附近"}]
                                                                         iconPosition:IconPositionRight andSelectionBlock:^(NSUInteger segmentIndex) {
                                                                             NSLog(@"segmentIndex  == %d",segmentIndex);
                                                                             selectedSegmentIndex = segmentIndex;
                                                                             [_header beginRefreshing];
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
@end
