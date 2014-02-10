//
//  NickNameViewController.h
//  MyBigFace
//
//  Created by cy on 14-2-10.
//  Copyright (c) 2014年 ipointek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NickNameViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UIButton *cancelBtn;
    IBOutlet UIButton *okBtn;
    IBOutlet UITextField *nickNameField;
}
-(IBAction)cancelBtnClick:(id)sender;
-(IBAction)okBtnClick:(id)sender;

@end
