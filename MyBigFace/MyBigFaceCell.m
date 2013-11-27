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
//@synthesize faceBtn_3 = _faceBtn_3;
//@synthesize faceBtn_4 = _faceBtn_4;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.faceBtn_0 = [[UIButton alloc]initWithFrame:CGRectMake(5,0, 100, 100)];
        [self addSubview:self.faceBtn_0];
        self.faceBtn_1 = [[UIButton alloc]initWithFrame:CGRectMake(110,0, 100, 100)];
        [self addSubview:self.faceBtn_1];
        self.faceBtn_2 = [[UIButton alloc]initWithFrame:CGRectMake(215,0, 100, 100)];
        [self addSubview:self.faceBtn_2];
//        self.faceBtn_3 = [[UIButton alloc]initWithFrame:CGRectMake(64*3,0, 64, 64)];
//        [self addSubview:self.faceBtn_3];
//        self.faceBtn_4 = [[UIButton alloc]initWithFrame:CGRectMake(64*4,0, 64, 64)];
//        [self addSubview:self.faceBtn_4];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
