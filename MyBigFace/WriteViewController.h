//
//  WriteViewController.h
//  MyBigFace
//
//  Created by Suncry on 13-10-16.
//  Copyright (c) 2013年 ipointek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteViewController : UIViewController<UITextViewDelegate>
{
    IBOutlet UITextView *mytextView;
}
//- (IBAction)back;
- (void)nextPage;
@end
