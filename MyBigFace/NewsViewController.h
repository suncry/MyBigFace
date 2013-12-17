//
//  NewsViewController.h
//  MyBigFace
//
//  Created by Suncry on 13-10-16.
//  Copyright (c) 2013年 ipointek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDB.h"

@interface NewsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *_tableview;

}
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)MyDB *mydb;

@end
