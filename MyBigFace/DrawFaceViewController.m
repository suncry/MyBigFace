//
//  DrawFaceViewController.m
//  MyBigFace
//
//  Created by Suncry on 13-10-16.
//  Copyright (c) 2013年 ipointek. All rights reserved.
//

#import "DrawFaceViewController.h"
#import "WriteViewController.h"
@interface DrawFaceViewController ()
@end
@implementation DrawFaceViewController
@synthesize drawView = _drawView;
//@synthesize faceBackgroundImageView = _faceBackgroundImageView;
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
    //初始化画笔  颜色默认为黑色   粗细为中
    self.drawView.Segment = 1;
    self.drawView.SegmentWidth = 6;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //设置 navigationBar
    [self setupMenuButton];
    
    
    self.drawView = [[Palette alloc]initWithFrame:CGRectMake(30, 100, 260, 260)];
    //默认是黄色开心的脸
    self.drawView.backgroundColor = [UIColor colorWithRed:254/255.0f green:214/255.0f blue:10/255.0f alpha:1.0f];
    _happyFaceBtn.selected = YES;
    //默认画笔为中
    _penLine_mid.selected = YES;
    //默认画笔颜色为黑色
    _pencolor_black.selected = YES;
    self.drawView.layer.masksToBounds=YES; //设置为yes，就可以使用圆角
    self.drawView.layer.cornerRadius= 130; //设置它的圆角大小 半径
    self.drawView.layer.borderWidth=0; //视图的边框宽度
//    self.drawView.layer.borderdg= [[UIdggray  dg].CGdg]; //视图的边框颜色
//    [self.faceBackgroundImageView addSubview:self.drawView];
    [self.view addSubview:self.drawView];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)nextPage
{
    //先保存 画的笑脸
    //保存瞬间把view上的所有按钮的Alpha值改为０
//	[[self.view subviews] makeObjectsPerformSelector:@selector (setAlpha:)];
    
	UIGraphicsBeginImageContext(self.view.bounds.size);
	[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
	
	UIImage* image=UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
    
    CGRect rect = CGRectMake(30, 100, 260, 260);//创建要剪切的矩形框 这里你可以自己修改
    UIImage *res = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage], rect)];
    NSData *imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation([self circleImage:res withParam:0], 0.5)];
    [[NSUserDefaults standardUserDefaults]setObject:imageData forKey:@"myFace"];
    //将图片存入相册
//	UIImageWriteToSavedPhotosAlbum(res, self, nil, nil);
	//遍历view全部按钮在把他们改为１
//	for (UIView* temp in [self.view subviews])
//	{
//		[temp setAlpha:1.0];
//	}
    //再跳转页面
    WriteViewController *writeViewController = [[WriteViewController alloc]init];
    [self.navigationController pushViewController:writeViewController animated:YES];
}
-(IBAction)LineFinallyRemove
{
	[self.drawView myLineFinallyRemove];
}
- (IBAction)allLineClear
{
    [self.drawView myalllineclear];
}
//笑脸背景色
- (IBAction)happyFace:(id)sender
{
    _happyFaceBtn.selected = YES;
    _sadFaceBtn.selected = NO;
    _angryFaceBtn.selected = NO;
    
    self.drawView.backgroundColor = [UIColor colorWithRed:254/255.0f green:214/255.0f blue:10/255.0f alpha:1.0f];

}
- (IBAction)sadFace:(id)sender
{
    _happyFaceBtn.selected = NO;
    _sadFaceBtn.selected = YES;
    _angryFaceBtn.selected = NO;

    self.drawView.backgroundColor = [UIColor colorWithRed:53/255.0f green:152/255.0f blue:219/255.0f alpha:1.0f];

}
- (IBAction)angryFace:(id)sender
{
    _happyFaceBtn.selected = NO;
    _sadFaceBtn.selected = NO;
    _angryFaceBtn.selected = YES;

    self.drawView.backgroundColor = [UIColor colorWithRed:232/255.0f green:76/255.0f blue:61/255.0f alpha:1.0f];
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
        t.text = @"画心情";
        self.navigationItem.titleView = t;
        
        //    self.navigationItem.title = @"画心情";
        //左按钮
        UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(nextPage)];
        
        self.navigationItem.rightBarButtonItem = rightButton;
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
        t.text = @"画心情";
        [self.view addSubview:t];

        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [_nextBtn addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];

    }

    
    
}
- (IBAction)color1:(id)sender
{
    _pencolor_white.selected  = YES;
    _pencolor_black.selected  = NO;
    _pencolor_red.selected    = NO;
    _pencolor_orange.selected = NO;
    _pencolor_yellow.selected = NO;
    _pencolor_grenn.selected  = NO;
    _pencolor_blue.selected   = NO;

    self.drawView.Segment = 0;
}
- (IBAction)color2:(id)sender
{
    _pencolor_white.selected  = NO;
    _pencolor_black.selected  = YES;
    _pencolor_red.selected    = NO;
    _pencolor_orange.selected = NO;
    _pencolor_yellow.selected = NO;
    _pencolor_grenn.selected  = NO;
    _pencolor_blue.selected   = NO;

    self.drawView.Segment = 1;
}
- (IBAction)color3:(id)sender
{
    _pencolor_white.selected  = NO;
    _pencolor_black.selected  = NO;
    _pencolor_red.selected    = YES;
    _pencolor_orange.selected = NO;
    _pencolor_yellow.selected = NO;
    _pencolor_grenn.selected  = NO;
    _pencolor_blue.selected   = NO;

    self.drawView.Segment = 2;
}
- (IBAction)color4:(id)sender
{
    _pencolor_white.selected  = NO;
    _pencolor_black.selected  = NO;
    _pencolor_red.selected    = NO;
    _pencolor_orange.selected = YES;
    _pencolor_yellow.selected = NO;
    _pencolor_grenn.selected  = NO;
    _pencolor_blue.selected   = NO;

    self.drawView.Segment = 3;

}
- (IBAction)color5:(id)sender
{
    _pencolor_white.selected  = NO;
    _pencolor_black.selected  = NO;
    _pencolor_red.selected    = NO;
    _pencolor_orange.selected = NO;
    _pencolor_yellow.selected = YES;
    _pencolor_grenn.selected  = NO;
    _pencolor_blue.selected   = NO;

    self.drawView.Segment = 4;

}
- (IBAction)color6:(id)sender
{
    _pencolor_white.selected  = NO;
    _pencolor_black.selected  = NO;
    _pencolor_red.selected    = NO;
    _pencolor_orange.selected = NO;
    _pencolor_yellow.selected = NO;
    _pencolor_grenn.selected  = YES;
    _pencolor_blue.selected   = NO;

    self.drawView.Segment = 5;

}
- (IBAction)color7:(id)sender
{
    _pencolor_white.selected  = NO;
    _pencolor_black.selected  = NO;
    _pencolor_red.selected    = NO;
    _pencolor_orange.selected = NO;
    _pencolor_yellow.selected = NO;
    _pencolor_grenn.selected  = NO;
    _pencolor_blue.selected   = YES;

    self.drawView.Segment = 6;

}

- (IBAction)width1:(id)sender
{
    _penLine_max.selected = NO;
    _penLine_mid.selected = NO;
    _penLine_min.selected = YES;

    self.drawView.SegmentWidth = 2;
}
- (IBAction)width2:(id)sender
{
    _penLine_max.selected = NO;
    _penLine_mid.selected = YES;
    _penLine_min.selected = NO;

    self.drawView.SegmentWidth = 6;
}
- (IBAction)width3:(id)sender
{
    _penLine_max.selected = YES;
    _penLine_mid.selected = NO;
    _penLine_min.selected = NO;
    self.drawView.SegmentWidth = 12;
}

//将截图裁剪为圆形的方法
//inset 为进一步缩小裁剪范围参数
-(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置画线的连接处　拐点圆滑
	CGContextSetLineJoin(context, kCGLineJoinRound);

    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    //添加 椭圆边框，正方形rect中就为圆形
    CGContextAddEllipseInRect(context, rect);

    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}
//缩放图片
//+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
//
//{
//    // Create a graphics image context
//    UIGraphicsBeginImageContext(newSize);
//    // Tell the old image to draw in this new context, with the desired
//    // new size
//    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
//    // Get the new image from the context
//    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//    // End the context
//    UIGraphicsEndImageContext();
//    // Return the new image.
//    return newImage;
//}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
