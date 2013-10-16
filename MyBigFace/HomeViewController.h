//
//  HomeViewController.h
//  MyBigFace
//
//  Created by Suncry on 13-10-16.
//  Copyright (c) 2013年 ipointek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UIBarButtonItem *leftBarBtnItem;
    IBOutlet UINavigationItem *myNavigationItem;
    IBOutlet UITableView *_tableview;
}
@property(nonatomic,retain)UITableView *tableView;


- (IBAction)addFace;
- (IBAction)toFaceView:(id)sender;
@end
