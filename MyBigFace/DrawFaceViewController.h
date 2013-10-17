//
//  DrawFaceViewController.h
//  MyBigFace
//
//  Created by Suncry on 13-10-16.
//  Copyright (c) 2013年 ipointek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Palette.h"
#import <QuartzCore/QuartzCore.h>

@interface DrawFaceViewController : UIViewController
{
	CGPoint MyBeganpoint;
	CGPoint MyMovepoint;
	int Segment;
	int SegmentWidth;
	//----------------
	UIImageView* pickImage;
}
@property int Segment;

- (IBAction)back;
- (IBAction)next;
- (IBAction)LineFinallyRemove;
//笑脸背景色的变换
- (IBAction)happyFace:(id)sender;
- (IBAction)sadFace:(id)sender;
- (IBAction)angryFace:(id)sender;

@end
