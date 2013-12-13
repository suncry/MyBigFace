//
//  MyBigFaceCell.m
//  MyBigFace
//
//  Created by Suncry on 13-10-22.
//  Copyright (c) 2013年 ipointek. All rights reserved.
//

#import "MyBigFaceCell.h"

@implementation MyBigFaceCell
@synthesize faceBtn_0 = _faceBtn_0;
@synthesize faceBtn_1 = _faceBtn_1;
@synthesize faceBtn_2 = _faceBtn_2;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.faceBtn_0 = [[UIButton alloc]initWithFrame:CGRectMake(15,5, 90, 90)];
        [self.faceBtn_0.layer setMasksToBounds:YES];
        [self.faceBtn_0.layer setCornerRadius:45.0];//设置矩形四个圆角半径
        [self addSubview:self.faceBtn_0];
        
        self.faceBtn_1 = [[UIButton alloc]initWithFrame:CGRectMake(115,5, 90, 90)];
        [self.faceBtn_1.layer setMasksToBounds:YES];
        [self.faceBtn_1.layer setCornerRadius:45.0];//设置矩形四个圆角半径
        [self addSubview:self.faceBtn_1];
        
        self.faceBtn_2 = [[UIButton alloc]initWithFrame:CGRectMake(215,5, 90, 90)];
        [self.faceBtn_2.layer setMasksToBounds:YES];
        [self.faceBtn_2.layer setCornerRadius:45.0];//设置矩形四个圆角半径
        [self addSubview:self.faceBtn_2];

        self.backgroundColor = [UIColor colorWithRed:240/255.0f green:237/255.0f blue:228/255.0f alpha:1.0f];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
