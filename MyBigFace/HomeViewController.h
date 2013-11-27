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

@interface HomeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
{
    IBOutlet UITableView *_tableview;
    IBOutlet UISegmentedControl *_segmentControl;
    CLLocationManager *_locationManager;
    CLGeocoder *_geocoder;
    MyDB *_mydb;
}
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)UISegmentedControl *segmentControl;

@property (strong, nonatomic)CLLocationManager *locationManager;
@property (strong, nonatomic)CLGeocoder *geocoder;
@property(nonatomic,retain)MyDB *mydb;



- (IBAction)addFace;
- (IBAction)valueChanged:(id)sender;
@end
