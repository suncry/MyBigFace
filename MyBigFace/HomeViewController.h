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
    CLLocationManager *_locationManager;
    CLGeocoder *_geocoder;
    MyDB *_mydb;
    int selectedSegmentIndex;
}
@property(nonatomic,retain)UITableView *tableView;
@property (strong, nonatomic)CLLocationManager *locationManager;
@property (strong, nonatomic)CLGeocoder *geocoder;
@property(nonatomic,retain)MyDB *mydb;



- (IBAction)addFace;
@end
