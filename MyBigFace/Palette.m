//
//  Palette.m
//  MyPalette
//
//  Created by xiaozhu on 11-6-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Palette.h"


@implementation Palette
@synthesize x;
@synthesize y;
@synthesize Segment;
@synthesize SegmentWidth;
- (id)initWithFrame:(CGRect)frame {
    
//	NSLog(@"initwithframe");
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
	
}
-(void)IntsegmentColor
{
	switch (Intsegmentcolor)
	{
		case 0:
			segmentColor=[[UIColor whiteColor] CGColor];
			break;
		case 1:
			segmentColor=[[UIColor blackColor] CGColor];
			break;
		case 2:
			segmentColor=[[UIColor redColor] CGColor];
			break;
        case 3:
			segmentColor=[[UIColor orangeColor] CGColor];
			break;
        case 4:
			segmentColor=[[UIColor yellowColor] CGColor];
			break;
        case 5:
			segmentColor=[[UIColor greenColor] CGColor];
			break;
        case 6:
			segmentColor=[[UIColor blueColor] CGColor];
			break;
		default:
			break;
	}
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
	//NSLog(@"Thes is drawRect ");
	//获取上下文
	CGContextRef context=UIGraphicsGetCurrentContext();
	//设置笔冒
	CGContextSetLineCap(context, kCGLineCapRound);
	//设置画线的连接处　拐点圆滑
	CGContextSetLineJoin(context, kCGLineJoinRound);
	//第一次时候个myallline开辟空间
//	static BOOL allline=NO;
//	if (allline==NO)
//	{
//		myallline=[[NSMutableArray alloc] initWithCapacity:10];
//		myallColor=[[NSMutableArray alloc] initWithCapacity:10];
//		myallwidth=[[NSMutableArray alloc] initWithCapacity:10];
//		allline=YES;
//	}
    //没有初始化过 才初始化
    if (![myallline count]>0)
    {
        myallline=[[NSMutableArray alloc] initWithCapacity:10];
    }
    if (![myallColor count]>0)
    {
        myallColor=[[NSMutableArray alloc] initWithCapacity:10];
    }
    if (![myallwidth count]>0)
    {
		myallwidth=[[NSMutableArray alloc] initWithCapacity:10];
    }
	//画之前线
	if ([myallline count]>0)
	{
		for (int i=0; i<[myallline count]; i++)
		{
			NSArray* tempArray=[NSArray arrayWithArray:[myallline objectAtIndex:i]];
            //----------------------------------------------------------------
			if ([myallColor count]>0)
			{
				Intsegmentcolor=[[myallColor objectAtIndex:i] intValue];
				Intsegmentwidth=[[myallwidth objectAtIndex:i]floatValue]+1;
			}
			//-----------------------------------------------------------------
			if ([tempArray count]>1)
			{
				CGContextBeginPath(context);
				CGPoint myStartPoint=[[tempArray objectAtIndex:0] CGPointValue];
				CGContextMoveToPoint(context, myStartPoint.x, myStartPoint.y);
				
				for (int j=0; j<[tempArray count]-1; j++)
				{
					CGPoint myEndPoint=[[tempArray objectAtIndex:j+1] CGPointValue];
					//--------------------------------------------------------
					CGContextAddLineToPoint(context, myEndPoint.x,myEndPoint.y);	
				}
				[self IntsegmentColor];
				CGContextSetStrokeColorWithColor(context, segmentColor);
				//-------------------------------------------------------
				CGContextSetLineWidth(context, Intsegmentwidth);
				CGContextStrokePath(context);
			}
		}
	}
	//画当前的线
	if ([myallpoint count]>1)
	{
		CGContextBeginPath(context);
		//-------------------------
		//起点
		//------------------------
		CGPoint myStartPoint=[[myallpoint objectAtIndex:0]   CGPointValue];
		CGContextMoveToPoint(context,    myStartPoint.x, myStartPoint.y);
		//把move的点全部加入　数组
		for (int i=0; i<[myallpoint count]-1; i++)
		{
			CGPoint myEndPoint=  [[myallpoint objectAtIndex:i+1] CGPointValue];
			CGContextAddLineToPoint(context, myEndPoint.x,   myEndPoint.y);
		}
		//在颜色和画笔大小数组里面取不相应的值
        Intsegmentcolor=[[myallColor lastObject] intValue];
		Intsegmentwidth=[[myallwidth lastObject]floatValue]+1;

		//-------------------------------------------
		//绘制画笔颜色
		[self IntsegmentColor];
		CGContextSetStrokeColorWithColor(context, segmentColor);
		CGContextSetFillColorWithColor (context,  segmentColor);
		//-------------------------------------------
		//绘制画笔宽度
		CGContextSetLineWidth(context, Intsegmentwidth);
		//把数组里面的点全部画出来
		CGContextStrokePath(context);
	}
}
//===========================================================
//初始化
//===========================================================
-(void)Introductionpoint1
{
//	NSLog(@"in init allPoint");
	myallpoint=[[NSMutableArray alloc] initWithCapacity:10];
}
//===========================================================
//把画过的当前线放入　存放线的数组
//===========================================================
-(void)Introductionpoint2
{
	[myallline addObject:myallpoint];
}
-(void)Introductionpoint3:(CGPoint)sender
{
	NSValue* pointvalue=[NSValue valueWithCGPoint:sender];
	[myallpoint addObject:[pointvalue retain]];
	[pointvalue release];
}
//===========================================================
//接收颜色segement反过来的值
////===========================================================
-(void)Introductionpoint4:(int)sender
{
//	NSLog(@"Palette sender:%i", sender);
	NSNumber* Numbersender= [NSNumber numberWithInt:sender];
	[myallColor addObject:Numbersender];
}
//===========================================================
//接收线条宽度按钮反回来的值
//===========================================================
-(void)Introductionpoint5:(int)sender
{
//	NSLog(@"Palette sender:%i", sender);
	NSNumber* Numbersender= [NSNumber numberWithInt:sender];
	[myallwidth addObject:Numbersender];
}
//===========================================================
//清屏按钮
//===========================================================
-(void)myalllineclear
{
	if ([myallline count]>0)
	{
		[myallline removeAllObjects];
        [myallColor removeAllObjects];
        [myallwidth removeAllObjects];
		[myallpoint removeAllObjects];
		myallline=[[NSMutableArray alloc] initWithCapacity:10];
        myallColor=[[NSMutableArray alloc] initWithCapacity:10];
        myallwidth=[[NSMutableArray alloc] initWithCapacity:10];

		[self setNeedsDisplay];
	}
}
//===========================================================
//撤销
//===========================================================
-(void)myLineFinallyRemove
{
	if ([myallline count]>0)
	{
		[myallline  removeLastObject];
        [myallColor removeLastObject];
        [myallwidth removeLastObject];
		[myallpoint removeAllObjects];
	}
	[self setNeedsDisplay];
}
//===========================================================
//橡皮擦　segmentColor=[[UIColor whiteColor]CGColor];
//===========================================================
//-(void)myrubberseraser
//{
//	segmentColor=[[UIColor whiteColor]CGColor];
//}
-(void)button
{
//	NSLog(@"button");
	
	//[self setNeedsDisplay];
}
- (void)dealloc 
{
    [super dealloc];
}
//////////////////////////////////
//触摸事件
#pragma mark -
//手指开始触屏开始
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch=[touches anyObject];
	MyBeganpoint=[touch locationInView:self];
    [self Introductionpoint4:self.Segment];
	[self Introductionpoint5:self.SegmentWidth];
	[self Introductionpoint1];
	[self Introductionpoint3:MyBeganpoint];
    //	NSLog(@"======================================");
    //	NSLog(@"MyPalette Segment=%i",Segment);
    //    NSLog(@"MyPalette SegmentWidth=%i",SegmentWidth);
}
//手指移动时候发出
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSArray* MovePointArray=[touches allObjects];
	MyMovepoint=[[MovePointArray objectAtIndex:0] locationInView:self];
	[self Introductionpoint3:MyMovepoint];
	[self setNeedsDisplay];
}
//当手指离开屏幕时候
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self Introductionpoint2];
	[self setNeedsDisplay];
}
//电话呼入等事件取消时候发出
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	//NSLog(@"touches Canelled");
}


@end
