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
#import "CommentCell.h"

@interface FaceViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *_footer;
//    MJRefreshHeaderView *_header;
}
//@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;

@end

@implementation FaceViewController
@synthesize faceImageView = _faceImageView;
@synthesize contentLable = _contentLable;
@synthesize plusLable = _plusLable;
@synthesize distanceLable = _distanceLable;
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
    
    self.faceImageView.layer.masksToBounds=YES; //设置为yes，就可以使用圆角
    self.faceImageView.layer.cornerRadius= 80; //设置它的圆角大小 半径
    
    self.blackBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SettingView_blackBackground.png"]];
    self.blackBackground.frame = CGRectMake(0, 0, 320, 568);
    self.blackBackground.alpha = 0;
    [self.view addSubview:self.blackBackground];


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
    [self setupMenuButton];
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
    NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@%@",MY_URL,[mydb date:@"url" num:faceClicked]]];
//    NSLog(@"url == %@",url);
//    NSLog(@"home 页面 的数据条数 == %d",[mydb getTableItemCount:@"face"]);
    [self.faceImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"DrawFaceView_logo.png"]];
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
    NSString *urlString = [NSString stringWithFormat:@"%@/face/plus",MY_URL];
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
    self.faceImageView.layer.masksToBounds=YES; //设置为yes，就可以使用圆角
    self.faceImageView.layer.cornerRadius= 80; //设置它的圆角大小 半径

    [Animations moveUp:self.faceImageView andAnimationDuration:0.2 andWait:YES andLength:50.0];
    [Animations moveDown:self.faceImageView andAnimationDuration:0.2 andWait:YES andLength:10.0];
    [Animations moveUp:self.faceImageView andAnimationDuration:0.1 andWait:YES andLength:5.0];
    [Animations moveDown:self.faceImageView andAnimationDuration:0.1 andWait:YES andLength:10.0];
    [Animations moveUp:self.faceImageView andAnimationDuration:0.1 andWait:YES andLength:12.0];
    
    //向下弹跳
    [Animations shadowOnView:self.faceImageView andShadowType:@"NoShadow"];
    self.faceImageView.layer.masksToBounds=YES; //设置为yes，就可以使用圆角
    self.faceImageView.layer.cornerRadius= 80; //设置它的圆角大小 半径

    [Animations moveDown:self.faceImageView andAnimationDuration:0.2 andWait:YES andLength:50.0];
    [Animations moveUp:self.faceImageView andAnimationDuration:0.2 andWait:YES andLength:20.0];
    [Animations moveDown:self.faceImageView andAnimationDuration:0.1 andWait:YES andLength:20.0];
    [Animations moveUp:self.faceImageView andAnimationDuration:0.1 andWait:YES andLength:12.0];
    [Animations moveDown:self.faceImageView andAnimationDuration:0.1 andWait:YES andLength:12.0];
    
    
    
    

 
}
- (IBAction)commentBtnClick:(id)sender
{
    self.commentView.frame = CGRectMake(0, 500, 320, 560);
    [self.view addSubview:_commentView];
    [self.commentTextView becomeFirstResponder];
    
    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^(){
        self.blackBackground.alpha = 1;
        
    } completion:^(BOOL finished)
     {
     }];

    //commentView左滑
    [Animations moveUp:self.commentView andAnimationDuration:0.3 andWait:YES andLength:320.0];
}
- (IBAction)commentCancelBtnClick:(id)sender
{
    [self.commentTextView resignFirstResponder];

    //commentView右滑
    [Animations moveDown:self.commentView andAnimationDuration:0.3 andWait:YES andLength:500];
    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^(){
        self.blackBackground.alpha = 0;
        
    } completion:^(BOOL finished)
     {
     }];

}
- (IBAction)commentSendBtnClick:(id)sender
{
    int faceClicked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"faceClicked"]intValue];
    MyDB *mydb = [[MyDB alloc]init];
    NSString *face_id = [mydb date:@"id" num:faceClicked];
    NSString *urlString = [NSString stringWithFormat:@"%@/comment",MY_URL];
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
    [Animations moveDown:self.commentView andAnimationDuration:0.3 andWait:YES andLength:500];
    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^(){
        self.blackBackground.alpha = 0;
        
    } completion:^(BOOL finished)
     {
     }];

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
        self.faceView.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height - 65);
        [cell.faceInfoView addSubview:self.faceView];
        cell.faceInfoView.backgroundColor = [UIColor redColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    //显示评论内容时
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//    }
//    cell.textLabel.text = [self.commentArray[self.commentArray.count - indexPath.row ] valueForKey:@"content"];
//    cell.detailTextLabel.text = [self.commentArray[self.commentArray.count - indexPath.row ] valueForKey:@"created_at"];
//    return cell;
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.commentLable.text = [self.commentArray[self.commentArray.count - indexPath.row ] valueForKey:@"content"];
    cell.timeLable.text = [self.commentArray[self.commentArray.count - indexPath.row ] valueForKey:@"created_at"];
    return cell;

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        //第一排 显示face信息时
        return [[UIScreen mainScreen] bounds].size.height - 65;
    }
    else
    {
        //显示评论内容时
        return 55;
    }
    //错误时
    return 10;
}
- (void)loadMoreComment
{
    int faceClicked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"faceClicked"]intValue];
    MyDB *mydb = [[MyDB alloc]init];
    NSString *face_id = [mydb date:@"id" num:faceClicked];
    NSString *urlString = [NSString stringWithFormat:@"%@/comment?id=%@skip=0&take=%d",MY_URL,face_id,self.commentArray.count+48];
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
        NSLog(@"self.commentArray  dict == %@ ",dict);
        NSLog(@"self.commentArray == %@",self.commentArray);
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
//    NSLog(@"faceLocation lng == %f",lng);
//    NSLog(@"faceLocation lat == %f",lat);
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
    //计算距离
    CLLocation *userLocation=[[CLLocation alloc] initWithLatitude:[[NSUserDefaults standardUserDefaults]doubleForKey:@"lat"] longitude:[[NSUserDefaults standardUserDefaults]doubleForKey:@"lng"]];
    CLLocationDistance locationDistance=[faceLocation distanceFromLocation:userLocation];
    //loadDistance
    if (locationDistance > 10000)
    {
        [self.distanceLable setText:[NSString stringWithFormat:@"%.0fKM",locationDistance/1000]];

    }
    else
    {
        [self.distanceLable setText:[NSString stringWithFormat:@"%.0fM",locationDistance]];

    }
//    NSLog(@"locationDistance == %f m",locationDistance);
}
- (void)speechComment
{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"speech"]isEqualToString:@"yes"])
    {
        //语音
        self.synthesizer = [[AVSpeechSynthesizer alloc] init];
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:self.contentLable.text];
        [self.synthesizer speakUtterance:utterance];
    }
}
- (void)shareBtnClick
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
-(void)setupMenuButton{
    //右按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"MainView_ self"]style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnClick)];
    rightButton.imageInsets = UIEdgeInsetsMake(10, 20, 10, 0);
    self.navigationItem.rightBarButtonItem = rightButton;

}

@end
