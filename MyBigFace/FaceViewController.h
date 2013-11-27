//
//  FaceViewController.h
//  MyBigFace
//
//  Created by Suncry on 13-10-16.
//  Copyright (c) 2013年 ipointek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDB.h"
#import "Animations.h"
#import <CoreLocation/CoreLocation.h>

@interface FaceViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UIImageView *_faceImageView;
    IBOutlet UILabel *_contentLable;
    IBOutlet UILabel *_plusLable;
    IBOutlet UIView *_commentView;
    IBOutlet UIView *_faceView;
    IBOutlet UITextView *_commentTextView;
    IBOutlet UITableView *_tableview;
    NSMutableArray *_commentArray;
//    CLLocationManager *_locationManager;
    CLGeocoder *_geocoder;


}
@property(nonatomic,retain)UIImageView *faceImageView;
@property(nonatomic,retain)UILabel *contentLable;
@property(nonatomic,retain)UILabel *plusLable;
@property(nonatomic,retain)UIView *commentView;
@property(nonatomic,retain)UIView *faceView;
@property(nonatomic,retain)UITextView *commentTextView;
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)NSMutableArray *commentArray;
//@property (strong, nonatomic)CLLocationManager *locationManager;
@property (strong, nonatomic)CLGeocoder *geocoder;



- (IBAction)plus:(id)sender;
- (IBAction)commentBtnClick:(id)sender;
- (IBAction)commentCancelBtnClick:(id)sender;
- (IBAction)commentSendBtnClick:(id)sender;
- (IBAction)shareBtnClick:(id)sender;


@end
