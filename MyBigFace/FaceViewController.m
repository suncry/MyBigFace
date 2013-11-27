//
//  FaceViewController.m
//  MyBigFace
//
//  Created by Suncry on 13-10-16.
//  Copyright (c) 2013年 ipointek. All rights reserved.
//

#import "FaceViewController.h"
#import "HomeViewController.h"
#import "SettingViewController.h"
#import "NewsViewController.h"
#import "MMDrawerController.h"
#import "UIImageView+WebCache.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "MJRefresh.h"
#import "FaceViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "UMSocial.h"


@interface FaceViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *_footer;
//    MJRefreshHeaderView *_header;
}
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;

@end

@implementation FaceViewController
@synthesize faceImageView = _faceImageView;
@synthesize contentLable = _contentLable;
@synthesize plusLable = _plusLable;
@synthesize commentView = _commentView;
@synthesize commentTextView = _commentTextView;
@synthesize faceView = _faceView;
@synthesize tableView = _tableview;
@synthesize commentArray = _commentArray;
//@synthesize locationManager = _locationManager;
@synthesize geocoder = _geocoder;


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
    //初始化 评论信息数组
    self.commentArray = [[NSMutableArray alloc]initWithCapacity:50];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    //初始化上拉下拉刷新控件
    [self initRefreshBar];
    [self loadFace];
    [self loadText];
    [self loadPlus];
    [self loadMoreComment];
    [self loadLocationInfo];
//    [self speechComment];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(speechComment) userInfo:Nil repeats:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//使用前一页面画的笑脸
- (void)loadFace
{
    int faceClicked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"faceClicked"]intValue];
    MyDB *mydb = [[MyDB alloc]init];
    NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://112.124.15.6:8001%@",[mydb date:@"url" num:faceClicked]]];
//    NSLog(@"url == %@",url);
//    NSLog(@"home 页面 的数据条数 == %d",[mydb getTableItemCount:@"face"]);
    [self.faceImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"添加"]];
}
- (void)loadText
{
    int faceClicked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"faceClicked"]intValue];
    MyDB *mydb = [[MyDB alloc]init];
    //    NSLog(@"home 页面 的数据条数 == %d",[mydb getTableItemCount:@"face"]);
    
//    NSLog(@"content == %@",[mydb date:@"content" num:faceClicked]);
    
    [self.contentLable setText:[mydb date:@"content" num:faceClicked]];
}
- (void)loadPlus
{
    int faceClicked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"faceClicked"]intValue];
    MyDB *mydb = [[MyDB alloc]init];
    [self.plusLable setText:[mydb date:@"plus" num:faceClicked]];
}
- (IBAction)plus:(id)sender
{
    int faceClicked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"faceClicked"]intValue];
    MyDB *mydb = [[MyDB alloc]init];
    NSString *face_id = [mydb date:@"id" num:faceClicked];
    NSString *urlString = [NSString stringWithFormat:@"http://112.124.15.6:8001/face/plus"];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:url];
    [requestForm addRequestHeader:@"X-Token" value:[[NSUserDefaults standardUserDefaults]stringForKey:@"token"]];
    [requestForm setRequestMethod:@"POST"];
    [requestForm setPostValue:face_id forKey:@"id"];
    //因为没有返回的信息。。所以其实并没有写回调函数
    __block ASIHTTPRequest *requestBlock = requestForm;
    [requestForm setCompletionBlock :^{
//        NSString *plusString = [requestBlock responseString];
//        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
//        NSMutableDictionary *dict = [jsonParser objectWithString:plusString];
//        NSLog(@"plusString dict == %@",dict);
    }];
    [requestForm setFailedBlock :^{
        // 请求响应失败，返回错误信息
        NSError *error = [requestBlock error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
    }];
    [requestForm startAsynchronous];
    
    [self.plusLable setText:[NSString stringWithFormat:@"%d",[[mydb date:@"plus" num:faceClicked]intValue]+1]];
    UIButton *plusBtn = (UIButton *)sender;
    plusBtn.enabled = NO;
    //把赞的数目在本地db中同步
    [mydb setPlus:[face_id intValue] plus:[[NSString stringWithFormat:@"%d",[[mydb date:@"plus" num:faceClicked]intValue]+1]intValue]];
    
    ///////////////////////////
    //动画测试
    //往上弹跳动画
    [Animations shadowOnView:self.faceImageView andShadowType:@"NoShadow"];
    [Animations moveUp:self.faceImageView andAnimationDuration:0.2 andWait:YES andLength:50.0];
    [Animations moveDown:self.faceImageView andAnimationDuration:0.2 andWait:YES andLength:10.0];
    [Animations moveUp:self.faceImageView andAnimationDuration:0.1 andWait:YES andLength:5.0];
    [Animations moveDown:self.faceImageView andAnimationDuration:0.1 andWait:YES andLength:10.0];
    [Animations moveUp:self.faceImageView andAnimationDuration:0.1 andWait:YES andLength:12.0];
    
    //向下弹跳
    [Animations shadowOnView:self.faceImageView andShadowType:@"NoShadow"];
    [Animations moveDown:self.faceImageView andAnimationDuration:0.2 andWait:YES andLength:50.0];
    [Animations moveUp:self.faceImageView andAnimationDuration:0.2 andWait:YES andLength:20.0];
    [Animations moveDown:self.faceImageView andAnimationDuration:0.1 andWait:YES andLength:20.0];
    [Animations moveUp:self.faceImageView andAnimationDuration:0.1 andWait:YES andLength:12.0];
    [Animations moveDown:self.faceImageView andAnimationDuration:0.1 andWait:YES andLength:12.0];
    
    
    
    

 
}
- (IBAction)commentBtnClick:(id)sender
{
    self.commentView.frame = CGRectMake(320, 80, 320, 560);
    [self.view addSubview:_commentView];
    [self.commentTextView becomeFirstResponder];

    //commentView左滑
    [Animations moveLeft:self.commentView andAnimationDuration:1.0 andWait:YES andLength:320.0];
}
- (IBAction)commentCancelBtnClick:(id)sender
{
    [self.commentTextView resignFirstResponder];

    //commentView右滑
    [Animations moveRight:self.commentView andAnimationDuration:1.0 andWait:YES andLength:320.0];
}
- (IBAction)commentSendBtnClick:(id)sender
{
    int faceClicked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"faceClicked"]intValue];
    MyDB *mydb = [[MyDB alloc]init];
    NSString *face_id = [mydb date:@"id" num:faceClicked];
    NSString *urlString = [NSString stringWithFormat:@"http://112.124.15.6:8001/comment"];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:url];
    [requestForm addRequestHeader:@"X-Token" value:[[NSUserDefaults standardUserDefaults]stringForKey:@"token"]];
    [requestForm setPostValue:face_id forKey:@"id"];
    [requestForm setPostValue:self.commentTextView.text forKey:@"content"];
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
    
    [self.commentTextView resignFirstResponder];
    
    //commentView右滑
    [Animations moveRight:self.commentView andAnimationDuration:1.0 andWait:YES andLength:320.0];

    self.commentTextView.text = @"";
}
//初始化 下拉和上拉刷新控件
- (void)initRefreshBar
{
//    // 下拉刷新
//    _header = [[MJRefreshHeaderView alloc] init];
//    _header.delegate = self;
//    _header.scrollView = self.tableView;
    
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
//    if (_header == refreshView) {
//        [self refreshComment];
//    } else {
//        [self loadMoreComment];
//    }
    [self loadMoreComment];

}

- (void)dealloc
{
    // 释放资源
    [_footer free];
//    [_header free];
}

#pragma mark tableView-代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 让刷新控件恢复默认的状态
//    [_header endRefreshing];
    [_footer endRefreshing];
    int cellCount = self.commentArray.count + 1;
    return cellCount;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    if (indexPath.row == 0)
    {
        //第一排显示face信息时
        FaceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[FaceViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        self.faceView.frame = CGRectMake(0, 0, 320, 568);
        [cell.faceInfoView addSubview:self.faceView];
        cell.faceInfoView.backgroundColor = [UIColor redColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    //显示评论内容时
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [self.commentArray[self.commentArray.count - indexPath.row ] valueForKey:@"content"];
    cell.detailTextLabel.text = [self.commentArray[self.commentArray.count - indexPath.row ] valueForKey:@"created_at"];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        //第一排 显示face信息时
        return 400;
    }
    else
    {
        //显示评论内容时
        return 44;
    }
    //错误时
    return 10;
}
- (void)loadMoreComment
{
    int faceClicked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"faceClicked"]intValue];
    MyDB *mydb = [[MyDB alloc]init];
    NSString *face_id = [mydb date:@"id" num:faceClicked];
    NSString *urlString = [NSString stringWithFormat:@"http://112.124.15.6:8001/comment?id=%@skip=0&take=%d",face_id,self.commentArray.count+48];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"X-Token" value:[[NSUserDefaults standardUserDefaults]stringForKey:@"token"]];
    
    __block ASIHTTPRequest *requestBlock = request;
    [request setCompletionBlock :^{
        NSString *commentString = [requestBlock responseString];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSMutableDictionary *dict = [jsonParser objectWithString:commentString];
//        NSLog(@"commentString dict == %@",dict);
        self.commentArray = [dict valueForKey:@"data"];
//        NSLog(@"self.commentArray == %@",self.commentArray);
        [self.tableView reloadData];
    }];
    [request setFailedBlock :^{
        // 请求响应失败，返回错误信息
        NSError *error = [requestBlock error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
    }];
    [request startAsynchronous];
}
- (void)loadLocationInfo
{
    MyDB *mydb = [[MyDB alloc]init];
    int faceClicked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"faceClicked"]intValue];
    CLLocationDegrees lat = [[mydb date:@"lat" num:faceClicked]doubleValue];
    CLLocationDegrees lng = [[mydb date:@"lng" num:faceClicked]doubleValue];
//    NSLog(@"lng == %f",lng);
//    NSLog(@"lat == %f",lat);
    CLLocation *faceLocation = [[CLLocation alloc]initWithLatitude:lat longitude:lng];
    self.geocoder = [[CLGeocoder alloc]init];
    [self.geocoder reverseGeocodeLocation:faceLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {CLPlacemark *placemark = [placemarks objectAtIndex:0];
         //isoCountry.text = placemark.ISOcountryCode;
//        NSLog(@"placemark.ISOcountryCode == %@",placemark.ISOcountryCode);
         //country.text = plackmark.country;
//        NSLog(@"plackmark.country == %@",placemark.country);
         //adminArea.text = placemark.adminstrativeArea;
//         NSLog(@"placemark.adminstrativeArea == %@",placemark.administrativeArea);
         //locality.text = placemark.subLocality;
//        NSLog(@"placemark.subLocality == %@",placemark.subLocality);
         //设置标题
//         self.navigationItem.title = placemark.subLocality;
         self.navigationItem.title = [NSString stringWithFormat:@"%@ %@",placemark.administrativeArea,placemark.subLocality];


     }];
}
- (void)speechComment
{
    //语音
    self.synthesizer = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:self.contentLable.text];
    [self.synthesizer speakUtterance:utterance];
}
- (IBAction)shareBtnClick:(id)sender
{
    //截图用来分享
    UIGraphicsBeginImageContext(self.view.bounds.size);
	[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
	
	UIImage* image=UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
    
    CGRect rect = CGRectMake(20, 100, 280, 280);//创建要剪切的矩形框 这里你可以自己修改
    UIImage *res = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage], rect)];
//    NSData *imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation(res, 0.1)];
//    [[NSUserDefaults standardUserDefaults]setObject:imageData forKey:@"myFace"];

    
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"528c287f56240be0d93b99ad"
                                      shareText:@"这是来自大饼的分享"
                                     shareImage:res
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToWechatSession,UMShareToWechatTimeline,nil]
                                       delegate:nil];

    
}

@end
