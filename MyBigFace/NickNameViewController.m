//
//  NickNameViewController.m
//  MyBigFace
//
//  Created by cy on 14-2-10.
//  Copyright (c) 2014年 ipointek. All rights reserved.
//

#import "NickNameViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"

@interface NickNameViewController ()

@end

@implementation NickNameViewController

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
    //设置按钮圆角
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.cornerRadius = 5.0;
    okBtn.layer.masksToBounds = YES;
    okBtn.layer.cornerRadius = 5.0;

    [nickNameField becomeFirstResponder];
//    [[NSUserDefaults standardUserDefaults]setValue:[[dict objectForKey:@"data"] valueForKey:@"nickname"] forKey:@"nickname"];

    nickNameField.placeholder = [[NSUserDefaults standardUserDefaults]stringForKey:@"nickname"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)cancelBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)okBtnClick:(id)sender
{
    NSString *urlString = [NSString stringWithFormat:@"%@/user/updatenickname",MY_URL];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:url];
    [requestForm setRequestMethod:@"POST"];
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm addRequestHeader:@"X-Token" value:[[NSUserDefaults standardUserDefaults]stringForKey:@"token"]];
    [requestForm setPostValue:nickNameField.text forKey:@"nickname"];
    [requestForm setPostValue:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] forKey:@"uid"];

    
    
    __block ASIHTTPRequest *requestFormBlock = requestForm;
    [requestForm setCompletionBlock :^{
        NSString *faceString = [requestFormBlock responseString];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSMutableDictionary *dict = [jsonParser objectWithString:faceString];
        NSLog(@"修改nickName 返回的dict == %@",dict);
        [[NSUserDefaults standardUserDefaults]setValue:nickNameField.text forKey:@"nickname"];

    }];
    [requestForm setFailedBlock :^{
        // 请求响应失败，返回错误信息
        NSError *error = [requestFormBlock error ];
        NSLog ( @"修改nickName error:%@" ,[error userInfo ]);
        
    }];
    [requestForm startAsynchronous];

    
    
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)textFieldDidEndEditing:(UITextField *)textField             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
{
    NSLog(@"textField.text.length == %d",textField.text.length);
    
    //该判断用于联想输入
    if (textField.text.length > 10)
    {
        NSLog(@"超出了 10 字符的限制");
        textField.text = [textField.text substringToIndex:10];
    }

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string   // return NO to not change text
{
//    //禁止换行...实现 done 按钮
//    if ([text isEqualToString:@"\n"])
//    {
//        [textView resignFirstResponder];
//        return NO;
//    }
    //判断加上输入的字符，是否超过界限
    NSString *str = [NSString stringWithFormat:@"%@%@", textField.text, string];
    if (str.length > 10)
    {
        textField.text = [str substringToIndex:10];
        return NO;
    }
    return YES;
}
@end
