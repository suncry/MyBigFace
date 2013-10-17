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
@synthesize Segment;


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
    //默认为笑脸 黄色
    self.view.backgroundColor = [UIColor yellowColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back
{
//    [(Palette*)self.view myalllineclear];

    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)next
{
    //先保存 画的笑脸
    //保存瞬间把view上的所有按钮的Alpha值改为０
//	[[self.view subviews] makeObjectsPerformSelector:@selector (setAlpha:)];
    
	UIGraphicsBeginImageContext(self.view.bounds.size);

	
	[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
	
	UIImage* image=UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
    
    CGRect rect = CGRectMake(0,90, 320, 320);//创建要剪切的矩形框 这里你可以自己修改
    UIImage *res = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage], rect)];
    
    NSData *imageData;
    imageData = [NSKeyedArchiver archivedDataWithRootObject:res];

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
	[(Palette*)self.view myLineFinallyRemove];
}
#pragma mark -
//手指开始触屏开始
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch=[touches anyObject];
	MyBeganpoint=[touch locationInView:self.view ];
	[(Palette*)self.view Introductionpoint1];
	[(Palette*)self.view Introductionpoint3:MyBeganpoint];
}
//手指移动时候发出
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSArray* MovePointArray=[touches allObjects];
	MyMovepoint=[[MovePointArray objectAtIndex:0] locationInView:self.view];
	[(Palette*)self.view Introductionpoint3:MyMovepoint];
	[self.view setNeedsDisplay];
}
//当手指离开屏幕时候
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[(Palette*)self.view Introductionpoint2];
	[self.view setNeedsDisplay];
}
//电话呼入等事件取消时候发出
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	//NSLog(@"touches Canelled");
}
//笑脸背景色
- (IBAction)happyFace:(id)sender
{
    self.view.backgroundColor = [UIColor yellowColor];
}
- (IBAction)sadFace:(id)sender
{
    self.view.backgroundColor = [UIColor blueColor];

}
- (IBAction)angryFace:(id)sender
{
    self.view.backgroundColor = [UIColor redColor];

}

@end
