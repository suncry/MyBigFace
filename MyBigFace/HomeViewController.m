//
//  HomeViewController.m
//  MyBigFace
//
//  Created by Suncry on 13-10-16.
//  Copyright (c) 2013年 ipointek. All rights reserved.
//

#import "HomeViewController.h"
#import "DrawFaceViewController.h"
#import "FaceViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "MJRefresh.h"

@interface HomeViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    
    NSMutableArray *_data;
}
@end

@implementation HomeViewController
@synthesize tableView = _tableview;
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
    //设置 navigation的左右item
    [self setupLeftMenuButton];
    [self setupRightMenuButton];
    //初始化上拉下拉刷新控件
    [self initRefreshBar];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addFace
{
    DrawFaceViewController *drawFaceViewController = [[DrawFaceViewController alloc]init];
    [self.navigationController pushViewController:drawFaceViewController animated:YES];
}
- (IBAction)toFaceView:(id)sender
{
    FaceViewController *faceViewController = [[FaceViewController alloc]init];
    [self presentViewController:faceViewController animated:YES completion:Nil];
}
-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [myNavigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}
-(void)setupRightMenuButton{
//    MMDrawerBarButtonItem * rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(rightDrawerButtonPress:)];
    //换一个方法 自定义图片
    MMDrawerBarButtonItem * rightDrawerButton = [[MMDrawerBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"item"] style:UIBarButtonItemStylePlain target:self action:@selector(rightDrawerButtonPress:)];
    [myNavigationItem setRightBarButtonItem:rightDrawerButton animated:YES];
}
#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
-(void)rightDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}
//初始化 下拉和上拉刷新控件
- (void)initRefreshBar
{
    // 下拉刷新
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = self.tableView;
    
    // 上拉加载更多
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = self.tableView;
    
    // 假数据
    _data = [NSMutableArray array];

}
#pragma mark 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH : mm : ss.SSS";
    if (_header == refreshView) {
        for (int i = 0; i<5; i++) {
            [_data insertObject:[formatter stringFromDate:[NSDate date]] atIndex:0];
        }
        
    } else {
        for (int i = 0; i<5; i++) {
            [_data addObject:[formatter stringFromDate:[NSDate date]]];
        }
    }
    [NSTimer scheduledTimerWithTimeInterval:1 target:self.tableView selector:@selector(reloadData) userInfo:nil repeats:NO];
}

- (void)dealloc
{
    // 释放资源
    [_footer free];
    [_header free];
}

#pragma mark tableView-代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 让刷新控件恢复默认的状态
    [_header endRefreshing];
    [_footer endRefreshing];
    
    return _data.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"dian ji!");
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"笑脸"];
    cell.textLabel.text = _data[indexPath.row];
    cell.detailTextLabel.text = @"上面的是刷新时间";
    
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
@end
