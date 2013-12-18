//
//  MyFaceCell.m
//  MyBigFace
//
//  Created by cy on 13-12-18.
//  Copyright (c) 2013年 ipointek. All rights reserved.
//

#import "MyFaceCell.h"

@implementation MyFaceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //背景色
        self.backgroundColor = [UIColor lightGrayColor];
        self.faceBackgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 162, 162)];
        self.faceBackgroundImageView.image = [UIImage imageNamed:@"MyFace_faceBackground.png"];
        [self addSubview:self.faceBackgroundImageView];
        self.faceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(32, 32, 140, 140)];
        [self addSubview:self.faceImageView];
        self.locationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(190, 10, 15, 15)];
        self.locationImageView.image = [UIImage imageNamed:@"MyFace_location.png"];

        [self addSubview:self.locationImageView];
        self.timeOfUploadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(190, 40, 15, 15)];
        self.timeOfUploadImageView.image = [UIImage imageNamed:@"MyFace_time.png"];

        [self addSubview:self.timeOfUploadImageView];
        self.plusImageView = [[UIImageView alloc]initWithFrame:CGRectMake(190, 70, 15, 15)];
        self.plusImageView.image = [UIImage imageNamed:@"MyFace_plus.png"];

        [self addSubview:self.plusImageView];
        self.commentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(190, 100, 15, 15)];
        self.commentImageView.image = [UIImage imageNamed:@"MyFace_comment.png"];

        [self addSubview:self.commentImageView];


        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
