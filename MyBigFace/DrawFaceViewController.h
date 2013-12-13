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
//	CGPoint MyBeganpoint;
//	CGPoint MyMovepoint;
	UIImageView* pickImage;
    Palette *_drawView;
    IBOutlet UIButton *_happyFaceBtn;
    IBOutlet UIButton *_sadFaceBtn;
    IBOutlet UIButton *_angryFaceBtn;


}
@property(nonatomic,retain)Palette *drawView;
//@property(nonatomic,retain)UIImageView *faceBackgroundImageView;


- (void)nextPage;
- (IBAction)LineFinallyRemove;
- (IBAction)allLineClear;
//笑脸背景色的变换
- (IBAction)happyFace:(id)sender;
- (IBAction)sadFace:(id)sender;
- (IBAction)angryFace:(id)sender;
- (IBAction)color1:(id)sender;
- (IBAction)color2:(id)sender;
- (IBAction)color3:(id)sender;
- (IBAction)width1:(id)sender;
- (IBAction)width2:(id)sender;
- (IBAction)width3:(id)sender;



@end
