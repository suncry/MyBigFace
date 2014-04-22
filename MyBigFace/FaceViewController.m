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
//#import "MMDrawerController.h"
#import "UIImageView+WebCache.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "FaceViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "CommentCell.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "ReportViewController.h"

#define FONT_SIZE 16.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 20.0f


@interface FaceViewController ()
{
}
//@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;
//@property (nonatomic, strong) AVSpeechUtterance *utterance;

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
@synthesize commentNumLable = _commentNumLable;
//@synthesize plusBtn = _plusBtn;
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
    self.blackBackground.frame = CGRectMake(0, 0, 320, [self.view bounds].size.height );
    self.blackBackground.alpha = 0;
    [self.view addSubview:self.blackBackground];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    __weak FaceViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreComment];
    }];

    // Do any additional setup after loading the view from its nib.
    [self loadFace];
    [self loadText];
    [self loadPlus];
    [self.tableView triggerInfiniteScrolling];
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
    //myFace 设置的faceClicked 应该大于100000
    //大于 100000 说明是从 myFace页面跳转过来的 否侧是从主页面跳转的
    if (faceClicked >= 100000)
    {
        NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@%@",MY_URL,[mydb myDate:@"url" num:faceClicked - 100000]]];
        NSLog(@"url == %@",url);
        //    NSLog(@"home 页面 的数据条数 == %d",[mydb getTableItemCount:@"face"]);
        [self.faceImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"DrawFaceView_logo.png"]];
    }
    else
    {
        NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@%@",MY_URL,[mydb date:@"url" num:faceClicked]]];
        NSLog(@"url == %@",url);
        //    NSLog(@"home 页面 的数据条数 == %d",[mydb getTableItemCount:@"face"]);
        [self.faceImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"DrawFaceView_logo.png"]];
    }
}
- (void)loadText
{
    int faceClicked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"faceClicked"]intValue];
    MyDB *mydb = [[MyDB alloc]init];
    //myFace 设置的faceClicked 应该大于100000
    //大于 100000 说明是从 myFace页面跳转过来的 否侧是从主页面跳转的
    if (faceClicked >= 100000)
    {
        [self.contentLable setText:[mydb myDate:@"content" num:faceClicked - 100000]];

    }
    else
    {
        [self.contentLable setText:[mydb date:@"content" num:faceClicked]];

    }
    //是否为iPhone5 不为5的话缩小字号 以显示完全
    if ([[UIScreen mainScreen] bounds].size.height < 568)
    {
        //默认为20号
        self.contentLable.font = [UIFont systemFontOfSize:16.0];
    }
}
- (void)loadPlus
{
    int faceClicked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"faceClicked"]intValue];
    MyDB *mydb = [[MyDB alloc]init];
    //myFace 设置的faceClicked 应该大于100000
    //大于 100000 说明是从 myFace页面跳转过来的 否侧是从主页面跳转的
    if (faceClicked >= 100000)
    {
        //最多显示9999+
        if ([[mydb myDate:@"plus" num:faceClicked - 100000] intValue] > 9999)
        {
            [self.plusLable setText:@"9999+"];
        }
        else
        {
            [self.plusLable setText:[mydb myDate:@"plus" num:faceClicked - 100000]];
        }

//        NSLog(@"plus num == %@",[mydb myDate:@"plus" num:faceClicked - 100000]);
    }
    else
    {
        [self.plusLable setText:[mydb date:@"plus" num:faceClicked]];
        //最多显示9999+
        if ([[mydb date:@"plus" num:faceClicked] intValue] > 9999)
        {
            [self.plusLable setText:@"9999+"];
        }
        else
        {
            [self.plusLable setText:[mydb date:@"plus" num:faceClicked]];
        }

//        NSLog(@"plus num == %@",[mydb myDate:@"plus" num:faceClicked - 100000]);
    }
}
- (void)loadCommentNum
{
    int faceClicked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"faceClicked"]intValue];
    MyDB *mydb = [[MyDB alloc]init];
    //myFace 设置的faceClicked 应该大于100000
    //大于 100000 说明是从 myFace页面跳转过来的 否侧是从主页面跳转的
    if (faceClicked >= 100000)
    {
        [self.commentNumLable setText:[mydb myDate:@"all_comment" num:faceClicked - 100000]];
//        NSLog(@"all_comment num == %@",[mydb myDate:@"all_comment" num:faceClicked - 100000]);
    }
    else
    {
        [self.commentNumLable setText:[mydb date:@"all_comment" num:faceClicked]];
//        NSLog(@"all_comment num == %@",[mydb myDate:@"all_comment" num:faceClicked - 100000]);
    }
}

- (IBAction)plus:(id)sender
{
    int faceClicked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"faceClicked"]intValue];
//    NSLog(@"plus 的时候faceClicked == %d",faceClicked);
    MyDB *mydb = [[MyDB alloc]init];
    NSString *face_id = [[NSString alloc]init];
    if (faceClicked >= 100000)
    {
        face_id = [mydb myDate:@"id" num:faceClicked - 100000];
//        NSLog(@"plus face_id in myDate == %@",face_id);
    }
    else
    {
        face_id = [mydb date:@"id" num:faceClicked];
//        NSLog(@"plus face_id in date == %@",face_id);
    }
    NSLog(@"plus 的时候face_id == %@",face_id);

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
    
    [self.plusLable setText:[NSString stringWithFormat:@"%d",[self.plusLable.text intValue]+1]];
    _plusBtn.enabled = NO;
    [_isPlusLable setText:@"已赞"];
    
    //把赞的数目在本地db中同步
    //主页面 和 我的表情页面的db都要同步
    [mydb setPlus:[face_id intValue] plus:[[NSString stringWithFormat:@"%d",[self.plusLable.text intValue]]intValue]];
    [mydb setMyPlus:[face_id intValue] plus:[[NSString stringWithFormat:@"%d",[self.plusLable.text intValue]]intValue]];
    ///////////////////////////
    [self moveUpAndDown];
}
- (IBAction)commentBtnClick:(id)sender
{
    self.commentView.frame = CGRectMake(0, [self.view bounds].size.height, 320, 190);
    [self.view addSubview:_commentView];
    [self.commentTextView becomeFirstResponder];
    
    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^(){
        self.blackBackground.alpha = 1;
        
    } completion:^(BOOL finished)
     {
     }];

    //commentView上滑
    [Animations moveUp:self.commentView andAnimationDuration:0.3 andWait:YES andLength:[self.view bounds].size.height - 65];
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
    if (self.commentTextView.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<!" message:@"回复不能为空哦!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        // optional - add more buttons:
        //        [alert addButtonWithTitle:@"Yes"];
        [alert show];
        
    }
    else
    {
        int faceClicked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"faceClicked"]intValue];
        MyDB *mydb = [[MyDB alloc]init];
//        NSLog(@"faceView  faceClicked == %d",faceClicked);
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
        NSString *urlString = [NSString stringWithFormat:@"%@/comment",MY_URL];
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:url];
        [requestForm addRequestHeader:@"X-Token" value:[[NSUserDefaults standardUserDefaults]stringForKey:@"token"]];
        [requestForm setPostValue:face_id forKey:@"id"];
        [requestForm setPostValue:self.commentTextView.text forKey:@"content"];
        
        [requestForm setPostValue:[[NSUserDefaults standardUserDefaults]stringForKey:@"CommentAddress"] forKey:@"address"];
        
        
        
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
}
#pragma mark tableView-代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int cellCount = self.commentArray.count + 1;
    return cellCount;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
//    static NSString *CommentCellIdentifier = @"CommentCell";
    if (indexPath.row == 0)
    {
        //第一排显示face信息时
        FaceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[FaceViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (IOS_VERSION_7_OR_ABOVE) {
//            NSLog(@"IOS_VERSION_7_OR_ABOVE");
            self.faceView.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height - 65);

        } else {
//            NSLog(@"NOT IOS_VERSION_7_OR_ABOVE");
            self.faceView.frame = CGRectMake(0, 65, 320, [[UIScreen mainScreen] bounds].size.height - 65);

        }


        [cell.faceInfoView addSubview:self.faceView];
//        [cell addSubview:self.faceView];
//        cell.faceInfoView.backgroundColor = [UIColor colorWithRed:215/255.0f green:215/255.0f blue:215/255.0f alpha:1.0f];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
//        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentCellIdentifier];
        CommentCell *cell = [[CommentCell alloc]init];

        UILabel *label = nil;
        UILabel *timeLabel = nil;

        UIView *backgroundViewLeft = nil;
        UIView *backgroundViewRight = nil;
        UILabel *bottonLable = nil;
            cell.frame = CGRectZero;
            
            label = [[UILabel alloc] initWithFrame:CGRectZero];
            [label setLineBreakMode:NSLineBreakByWordWrapping];
            //        [label setMinimumFontSize:FONT_SIZE]; 已废除
            //取代 setMinimumFontSize:FONT_SIZE
            [label setMinimumScaleFactor:FONT_SIZE];
            [label setNumberOfLines:0];
            [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
            [label setTag:1];
            label.backgroundColor = [UIColor clearColor];
//            [[label layer] setBorderWidth:2.0f];
        
            [[cell contentView] addSubview:label];
            
            
            timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [timeLabel setLineBreakMode:NSLineBreakByWordWrapping];
            //        [label setMinimumFontSize:FONT_SIZE]; 已废除
            //取代 setMinimumFontSize:FONT_SIZE
            [timeLabel setMinimumScaleFactor:12.0f];
            [timeLabel setNumberOfLines:0];
            [timeLabel setTag:5];
            timeLabel.textColor = [UIColor lightGrayColor];
            timeLabel.font = [UIFont systemFontOfSize:12.0f];
            timeLabel.backgroundColor = [UIColor clearColor];

//            [[timeLabel layer] setBorderWidth:2.0f];
            
            [[cell contentView] addSubview:timeLabel];

            bottonLable = [[UILabel alloc] initWithFrame:CGRectZero];
            bottonLable.backgroundColor = [UIColor lightGrayColor];
            [backgroundViewRight setTag:4];
            [[cell contentView] addSubview:bottonLable];

            
            backgroundViewLeft = [[UIView alloc] initWithFrame:CGRectZero];
            backgroundViewLeft.backgroundColor = [UIColor colorWithRed:215/255.0f green:215/255.0f blue:215/255.0f alpha:1.0f];
            [backgroundViewLeft setTag:2];

            backgroundViewRight = [[UIView alloc] initWithFrame:CGRectZero];
            backgroundViewRight.backgroundColor = [UIColor colorWithRed:215/255.0f green:215/255.0f blue:215/255.0f alpha:1.0f];
            [backgroundViewRight setTag:3];

            [[cell contentView] addSubview:backgroundViewLeft];
            [[cell contentView] addSubview:backgroundViewRight];

//        }
        NSString *text = [self.commentArray[indexPath.row - 1] valueForKey:@"content"];
        NSString *timeText = [self.commentArray[indexPath.row - 1] valueForKey:@"created_at"];

        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        CGFloat height = MAX(size.height, 35.0f);

        if (!label)
            label = (UILabel*)[cell viewWithTag:1];
        
        [label setText:text];
//        [label setFrame:CGRectMake(CELL_CONTENT_MARGIN+60, CELL_CONTENT_MARGIN+10, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2) - 60, MAX(size.height, 15.0f))];
        [label setFrame:CGRectMake(70, CELL_CONTENT_MARGIN+10, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2) - 60 - 10, MAX(size.height, 15.0f)+40)];

        if (!timeLabel)
            timeLabel = (UILabel*)[cell viewWithTag:5];
        
        [timeLabel setText:timeText];
        [timeLabel setFrame:CGRectMake(200, MAX((height + (CELL_CONTENT_MARGIN + 15))+10, 55.0f) - 16 + 30, 120.0f, 15.0f)];
        if (!backgroundViewLeft)
            backgroundViewLeft = (UIView*)[cell viewWithTag:2];
        [backgroundViewLeft setFrame:CGRectMake(0, 0, 10, MAX((height + (CELL_CONTENT_MARGIN + 15) + 30), 55.0f) + 10)];
        if (!backgroundViewRight)
            backgroundViewRight = (UIView*)[cell viewWithTag:3];
        [backgroundViewRight setFrame:CGRectMake(310, 0, 10, MAX((height + (CELL_CONTENT_MARGIN + 15) + 30), 55.0f) + 10)];
        if (!bottonLable)
            bottonLable = (UILabel*)[cell viewWithTag:4];
        [bottonLable setFrame:CGRectMake(20, (MAX((height + (CELL_CONTENT_MARGIN + 15)), 55.0f) - 1) + 10 + 30, 280, 1)];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
//        cell.nameLable.text = [NSString stringWithFormat:@"%@喷友:",[self.commentArray[indexPath.row - 1] valueForKey:@"address"]];
        NSString *nickName_addressString = [NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"%@",[self.commentArray[indexPath.row - 1] valueForKey:@"nickname"]],[NSString stringWithFormat:@"(%@):",[self.commentArray[indexPath.row - 1] valueForKey:@"address"]]]
        ;
        cell.nameLable.text = nickName_addressString;

        return cell;

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        int h = [[UIScreen mainScreen] bounds].size.height - 65;
        //第一排 显示face信息时
        NSLog(@"faceView 第一排的高度为 == %d",h);
        if (IOS_VERSION_7_OR_ABOVE) {
//            NSLog(@"IOS_VERSION_7_OR_ABOVE");
            return [[UIScreen mainScreen] bounds].size.height - 65;
        } else {
//            NSLog(@"NOT IOS_VERSION_7_OR_ABOVE");
            return [[UIScreen mainScreen] bounds].size.height;
        }
    }
    else
    {
        //显示评论内容时
//        return 55;
        NSString *text = [self.commentArray[indexPath.row - 1] valueForKey:@"content"];
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        CGFloat height = MAX(size.height, 35.0f);
//        NSLog(@"height == %f",height);
        return height + (CELL_CONTENT_MARGIN + 15) + 10 + 30;//加10 是因为 用户名的加入 使得 高度增加了10

    }
    //错误时
    return 10;
    

}
- (void)loadMoreComment
{
    int faceClicked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"faceClicked"]intValue];
    MyDB *mydb = [[MyDB alloc]init];
    //myFace 设置的faceClicked 应该大于100000
    //大于 100000 说明是从 myFace页面跳转过来的 否侧是从主页面跳转的
    NSString *face_id = [[NSString alloc]init];
    if (faceClicked >= 100000)
    {
        face_id = [mydb myDate:@"id" num:faceClicked - 100000];
        
    }
    else
    {
        face_id = [mydb date:@"id" num:faceClicked];
        
    }
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
//        NSLog(@"self.commentArray  dict == %@ ",dict);
        __weak FaceViewController *weakSelf = self;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        
//        NSLog(@"self.commentArray == %@",self.commentArray);
//        NSLog(@"self.commentArray.count == %d",self.commentArray.count);
        /**
         *  设置评论的数量显示
         */
        if (self.commentArray.count != 0)
        {
            NSLog(@" face view   self.commentArray[0] == %@",self.commentArray[0]);
            
            //最多显示9999+
            if ([[NSString stringWithFormat:@"%@",[self.commentArray[0] valueForKey:@"all_comment"]] intValue] > 9999)
            {
                [self.commentNumLable setText:@"9999+"];
            }
            else
            {
                [self.commentNumLable setText:[NSString stringWithFormat:@"%@",[self.commentArray[0] valueForKey:@"all_comment"]]];

            }
        }
        else
        {
            //        NSLog(@"self.tableView setContentOffset == %f",self.tableView.contentOffset.y);
            
            //评论为0 返回顶部
            //tableView 返回顶部
            if (IOS_VERSION_7_OR_ABOVE) {
//                NSLog(@"IOS_VERSION_7_OR_ABOVE");
                [self.tableView setContentOffset:CGPointMake(0, -64) animated:YES];

            } else {
//                NSLog(@"NOT IOS_VERSION_7_OR_ABOVE");
//                [self.tableView setContentOffset:CGPointMake(0, -64) animated:YES];

            }


        }
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
    //myFace 设置的faceClicked 应该大于100000
    //大于 100000 说明是从 myFace页面跳转过来的 否侧是从主页面跳转的
    CLLocationDegrees lat;
    CLLocationDegrees lng;
    if (faceClicked >= 100000)
    {
        lat = [[mydb myDate:@"lat" num:faceClicked - 100000]floatValue];
        lng = [[mydb myDate:@"lng" num:faceClicked - 100000]floatValue];
        NSString *address =[mydb myDate:@"address" num:faceClicked - 100000];
        //设置标题
        UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        t.font = [UIFont systemFontOfSize:17];
        t.textColor = [UIColor whiteColor];
        t.backgroundColor = [UIColor clearColor];
        t.textAlignment = NSTextAlignmentCenter;
        //         t.text = [NSString stringWithFormat:@"%@ %@",placemark.administrativeArea,placemark.subLocality];
        t.text = address;
        if (IOS_VERSION_7_OR_ABOVE) {
//            NSLog(@"IOS_VERSION_7_OR_ABOVE");
        }
        else
        {
//            NSLog(@"NOT IOS_VERSION_7_OR_ABOVE");
            [_localLable setText:address];
        }

        NSLog(@"myDate  faceView address == %@",address);
        self.navigationItem.titleView = t;
    }
    else
    {
        lat = [[mydb date:@"lat" num:faceClicked]floatValue];
        lng = [[mydb date:@"lng" num:faceClicked]floatValue];
        NSString *address =[mydb date:@"address" num:faceClicked];
        //设置标题
        UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        t.font = [UIFont systemFontOfSize:17];
        t.textColor = [UIColor whiteColor];
        t.backgroundColor = [UIColor clearColor];
        t.textAlignment = NSTextAlignmentCenter;
        //         t.text = [NSString stringWithFormat:@"%@ %@",placemark.administrativeArea,placemark.subLocality];
        t.text = address;
        if (IOS_VERSION_7_OR_ABOVE) {
            //            NSLog(@"IOS_VERSION_7_OR_ABOVE");
        }
        else
        {
            //            NSLog(@"NOT IOS_VERSION_7_OR_ABOVE");
            [_localLable setText:address];
        }

        NSLog(@"date  faceView address == %@",address);
        self.navigationItem.titleView = t;
    }
//    NSLog(@"faceLocation lng == %f",lng);
//    NSLog(@"faceLocation lat == %f",lat);
    CLLocation *faceLocation = [[CLLocation alloc]initWithLatitude:lat longitude:lng];
    //计算距离
    CLLocation *userLocation=[[CLLocation alloc] initWithLatitude:[[NSUserDefaults standardUserDefaults]doubleForKey:@"lat"] longitude:[[NSUserDefaults standardUserDefaults]doubleForKey:@"lng"]];
    CLLocationDistance locationDistance=[faceLocation distanceFromLocation:userLocation];
    //loadDistance
    if (locationDistance > 10000)
    {
        [self.distanceLable setText:[NSString stringWithFormat:@"%.0fkm",locationDistance/1000]];
    }
    else
    {
        [self.distanceLable setText:[NSString stringWithFormat:@"%.0fm",locationDistance]];
        if (locationDistance < 100)
        {
            [self.distanceLable setText:[NSString stringWithFormat:@"<100m"]];
        }
    }
//    NSLog(@"locationDistance == %f m",locationDistance);
}
- (void)speechComment
{
    if (![[[NSUserDefaults standardUserDefaults]objectForKey:@"closeSpeech"]isEqualToString:@"yes"])
    {
        //语音
        self.synthesizer = [[AVSpeechSynthesizer alloc] init];
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:self.contentLable.text];
        [self.synthesizer speakUtterance:utterance];
    }
}
- (void)shareBtnClick
{
    UIImage  *myImage = [UIImage imageNamed:@"ShareImg.png"];
    UIImage *shareImg = [self addImage:myImage rect1:CGRectMake(0, 0, 320, 568)];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"528c287f56240be0d93b99ad"
                                      shareText:@"分享了一条来自@Whisper微喷 的消息。——微喷，喷出你的秘密吧！"
                                     shareImage:shareImg
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQQ,UMShareToQzone,UMShareToRenren,UMShareToWechatSession,UMShareToWechatTimeline,nil]
                                       delegate:self];

//    //去掉了 分享到QQ
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:@"528c287f56240be0d93b99ad"
//                                      shareText:@"分享了一条来自@Whisper微喷 的消息。——微喷，喷出你的秘密吧！"
//                                     shareImage:shareImg
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToRenren,UMShareToWechatSession,UMShareToWechatTimeline,nil]
//                                       delegate:self];
}
-(void)setupMenuButton{
    if (IOS_VERSION_7_OR_ABOVE) {
//        NSLog(@"IOS_VERSION_7_OR_ABOVE");
        //右按钮
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"More"] style:UIBarButtonItemStylePlain target:self action:@selector(moreBtnClick)];

        self.navigationItem.rightBarButtonItem = rightButton;

        //自定义 返回按钮
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        self.navigationItem.leftBarButtonItem = backButton;

    } else {
//        NSLog(@"NOT IOS_VERSION_7_OR_ABOVE");
        self.navigationController.navigationBarHidden = YES;
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        [_shareBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];

    }


}
- (void)moveUpAndDown
{
    //往上弹跳动画
    [Animations shadowOnView:self.faceImageView andShadowType:@"NoShadow"];
    self.faceImageView.layer.masksToBounds=YES; //设置为yes，就可以使用圆角
    self.faceImageView.layer.cornerRadius= 80; //设置它的圆角大小 半径
    
    [Animations moveUp:self.faceImageView andAnimationDuration:0.2 andWait:YES andLength:50.0];
    [Animations moveDown:self.faceImageView andAnimationDuration:0.2 andWait:YES andLength:10.0];
    [Animations moveUp:self.faceImageView andAnimationDuration:0.1 andWait:YES andLength:50.0];
    [Animations moveDown:self.faceImageView andAnimationDuration:0.1 andWait:YES andLength:10.0];
    [Animations moveUp:self.faceImageView andAnimationDuration:0.1 andWait:YES andLength:12.0];
    
    //向下弹跳
    [Animations shadowOnView:self.faceImageView andShadowType:@"NoShadow"];
    self.faceImageView.layer.masksToBounds=YES; //设置为yes，就可以使用圆角
    self.faceImageView.layer.cornerRadius= 80; //设置它的圆角大小 半径
    
//    [Animations moveDown:self.faceImageView andAnimationDuration:0.2 andWait:YES andLength:50.0];
//    [Animations moveUp:self.faceImageView andAnimationDuration:0.2 andWait:YES andLength:20.0];
//    [Animations moveDown:self.faceImageView andAnimationDuration:0.1 andWait:YES andLength:20.0];
//    [Animations moveUp:self.faceImageView andAnimationDuration:0.1 andWait:YES andLength:12.0];
//    [Animations moveDown:self.faceImageView andAnimationDuration:0.1 andWait:YES andLength:12.0];
    
    [Animations moveDown:self.faceImageView andAnimationDuration:0.2 andWait:YES andLength:50.0];
    [Animations moveUp:self.faceImageView andAnimationDuration:0.2 andWait:YES andLength:10.0];
    [Animations moveDown:self.faceImageView andAnimationDuration:0.1 andWait:YES andLength:50.0];
    [Animations moveUp:self.faceImageView andAnimationDuration:0.1 andWait:YES andLength:10.0];
    [Animations moveDown:self.faceImageView andAnimationDuration:0.1 andWait:YES andLength:12.0];


}
//如果输入超过规定的字数14，就不再让输入
- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
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
        NSLog(@"超出了 110 字符的限制");
        textView.text = [textView.text substringToIndex:110];
    }

}
/**
 *  合成图片
 *
 *  @param image1 <#image1 description#>
 *  @param image2 <#image2 description#>
 *  @param rect1  <#rect1 description#>
 *  @param rect2  <#rect2 description#>
 *
 *  @return <#return value description#>
 */
//- (UIImage *)addImage:(UIImage *)image1 withImage:(UIImage *)image2 rect1:(CGRect)rect1 rect2:(CGRect)rect2 {
//    CGSize size = CGSizeMake(rect1.size.width+rect2.size.width, rect1.size.height);
//    
//    UIGraphicsBeginImageContext(size);
//    
//    [image1 drawInRect:rect1];
//    [image2 drawInRect:rect2];
//    NSString *qwe = @"123123123123123123123123123123123123123123123123123123测试测试123测试测试123测试测试123测试测试123测试测试123测试测试123测试测试";
//    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:22], NSStrokeColorAttributeName:[UIColor redColor]};
//    [qwe drawInRect:CGRectMake(50, 50, 220, 210) withAttributes:attributes];
//    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    return resultingImage;
//}
- (UIImage *)addImage:(UIImage *)image1 rect1:(CGRect)rect1
{
    CGSize size = CGSizeMake(rect1.size.width, rect1.size.height);
    
    UIGraphicsBeginImageContext(size);
    
    int faceClicked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"faceClicked"]intValue];
    MyDB *mydb = [[MyDB alloc]init];
    
    NSString *contentString = @"如果显示了这句话,说明分享的时候没有获取到你的内容哟!";

    //myFace 设置的faceClicked 应该大于100000
    //大于 100000 说明是从 myFace页面跳转过来的 否侧是从主页面跳转的
    if (faceClicked >= 100000)
    {
        contentString = [mydb myDate:@"content" num:faceClicked - 100000];
    }
    else
    {
        contentString = [mydb date:@"content" num:faceClicked];
        
    }

    
    [image1 drawInRect:rect1];
    [self.faceImageView.image drawInRect:CGRectMake(28, 235, 264, 264)];
//    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20], NSStrokeColorAttributeName:[UIColor redColor]};

//    if (IOS_VERSION_7_OR_ABOVE) {
//        NSLog(@"IOS_VERSION_7_OR_ABOVE");
////        [qwe drawInRect:CGRectMake(45, 30, 230, 160) withAttributes:attributes];
//        [qwe drawInRect:CGRectMake(45, 30, 235, 160) withFont:[UIFont systemFontOfSize:17] lineBreakMode:NSLineBreakByTruncatingTail];
//        
//
//    } else {
//        NSLog(@"NOT IOS_VERSION_7_OR_ABOVE");
//        [qwe drawInRect:CGRectMake(45, 30, 235, 160) withFont:[UIFont systemFontOfSize:17] lineBreakMode:NSLineBreakByWordWrapping];
//    }

    UILabel *textLable = [[UILabel alloc]initWithFrame:CGRectMake(40, 30, 235, 160)];
    textLable.text = contentString;
    textLable.textAlignment = NSTextAlignmentCenter;
    textLable.lineBreakMode = NSLineBreakByCharWrapping;
    textLable.numberOfLines = 7;
    [textLable drawTextInRect:CGRectMake(40, 30, 235, 160)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

/**
 *  在图片上写字
 *
 *  @param img   <#img description#>
 *  @param text1 <#text1 description#>
 *
 *  @return <#return value description#>
 */
//-(UIImage *)addText:(UIImage *)img text:(NSString *)text1
//{
//    //get image width and height
//    int w = img.size.width;
//    NSLog(@"width:%d",w);
//    int h = img.size.height;
//    NSLog(@"height:%d",h);
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    //create a graphic context with CGBitmapContextCreate
//    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
//
//    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
//    CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 1);
//    char* text = (char *)[text1 cStringUsingEncoding:NSASCIIStringEncoding];
//    //字体大小
//    CGContextSelectFont(context, "Georgia", 30, kCGEncodingMacRoman);
//    CGContextSetTextDrawingMode(context, kCGTextFill);
//    //颜色
//    CGContextSetRGBFillColor(context, 255, 0, 0, 1);
//    //旋转
////    CGContextSetTextMatrix(context, CGAffineTransformMakeRotation( -M_PI/4 ));
//    
//    NSString *qwe = @"123123123";
//    [qwe drawInRect:CGRectMake(0, 0, 320, 400) withAttributes:nil];
//    
//    
//    
//    
//    CGContextShowTextAtPoint(context, 360, 200, text, strlen(text));
//    //Create image ref from the context
//    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//    return [UIImage imageWithCGImage:imageMasked];
//    
//}
- (void)back
{
//    NSLog(@"back!!!");
    [self.synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    UIImage  *myImage = [UIImage imageNamed:@"ShareImg.png"];
    UIImage *shareImg = [self addImage:myImage rect1:CGRectMake(0, 0, 320, 568)];

    if ([platformName isEqualToString:UMShareToTencent]) {
        socialData.shareText = @"分享了一条来自@Whisperweipen 的消息。——微喷，喷出你的秘密吧！";
        socialData.shareImage = shareImg;
    }
}
- (void)moreBtnClick
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<!" message:@"还是说点什么吧!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    // optional - add more buttons:
//    //        [alert addButtonWithTitle:@"Yes"];
//    [alert show];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"分享",@"举报",nil];
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self shareBtnClick];
    }
    if (buttonIndex == 1)
    {
        NSLog(@"举报");
        ReportViewController *reportViewController = [[ReportViewController alloc]init];
        [self.navigationController pushViewController:reportViewController animated:YES];
    }
}
//- (void)reportBtnClick
//{
//    ReportViewController *reportViewController = [[ReportViewController alloc]init];
//    [self.navigationController pushViewController:reportViewController animated:YES];
//}
@end
