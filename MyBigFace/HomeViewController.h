//
//  HomeViewController.h
//  MyBigFace
//
//  Created by Suncry on 13-10-16.
//  Copyright (c) 2013年 ipointek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MyDB.h"
#import "Animations.h"

@interface HomeViewController : UIViewController<UITableViewDelegate,
UITableViewDataSource,CLLocationManagerDelegate,UITextViewDelegate>
{
    IBOutlet UITableView *_tableview;
    IBOutlet UIView *_settingView;
    IBOutlet UIView *_feedBackView;
    IBOutlet UILabel *_feedBackCommentLable;
    IBOutlet UILabel *_feedBackEmailLable;
    IBOutlet UITextView *_feedBackCommentTextView;
    IBOutlet UITextView *_feedBackEmailTextView;
    IBOutlet UISwitch *_speechSwitch;

    CLLocationManager *_locationManager;
    CLGeocoder *_geocoder;
    MyDB *_mydb;
    int selectedSegmentIndex;
}
@property (nonatomic,retain)  UITableView       *tableView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder        *geocoder;
@property (nonatomic,retain)  MyDB              *mydb;
@property (strong, nonatomic) UIView            *settingView;
@property (nonatomic,retain)  UIImageView       *blackBackground;
@property (strong, nonatomic) UIView            *feedBackView;
@property (strong, nonatomic) UILabel            *feedBackCommentLable;
@property (strong, nonatomic) UILabel            *feedBackEmailLable;
@property (strong, nonatomic) UITextView            *feedBackCommentTextView;
@property (strong, nonatomic) UITextView            *feedBackEmailTextView;
@property (strong, nonatomic) UISwitch            *speechSwitch;



- (IBAction)settingBtnClick:(id)sender;
- (IBAction)rateMe:(id)sender;
- (IBAction)feedBack:(id)sender;
- (IBAction)speechSwitch:(id)sender;
- (IBAction)addFace;
- (IBAction)feedBackCancle:(id)sender;
- (IBAction)feedBackSend:(id)sender;

@end
