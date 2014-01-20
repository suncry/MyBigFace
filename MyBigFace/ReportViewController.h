//
//  ReportViewController.h
//  MyBigFace
//
//  Created by cy on 14-1-17.
//  Copyright (c) 2014年 ipointek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportViewController : UIViewController
{
    IBOutlet UIButton *btn1;//垃圾广告
    IBOutlet UIButton *btn2;//淫秽色情
    IBOutlet UIButton *btn3;//不实信息
    IBOutlet UIButton *btn4;//敏感信息
    IBOutlet UIButton *sendBtn;//提交按钮

    //ios6 back
    IBOutlet UIButton *_backBtn;
    NSString *info;
}
- (IBAction)btn1Click:(id)sender;//垃圾广告
- (IBAction)btn2Click:(id)sender;//淫秽色情
- (IBAction)btn3Click:(id)sender;//不实信息
- (IBAction)btn4Click:(id)sender;//敏感信息
- (IBAction)sendBtnClick:(id)sender;//发送举报

@end
