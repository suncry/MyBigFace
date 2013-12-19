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
        self.backgroundColor = [UIColor colorWithRed:215/255.0f green:215/255.0f blue:215/255.0f alpha:1.0f];
        self.faceBackgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 162, 162)];
        self.faceBackgroundImageView.image = [UIImage imageNamed:@"MyFace_faceBackground.png"];
        [self addSubview:self.faceBackgroundImageView];
        self.faceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(21, 21, 140, 140)];
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

        self.locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(205, 10, 150, 15)];
        self.locationLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:self.locationLabel];
        self.timeOfUploadLabel = [[UILabel alloc]initWithFrame:CGRectMake(205, 40, 150, 15)];
        self.timeOfUploadLabel.textColor = [UIColor lightGrayColor];
        self.timeOfUploadLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.timeOfUploadLabel];
        self.plusLabel = [[UILabel alloc]initWithFrame:CGRectMake(205, 70, 150, 15)];
        self.plusLabel.textColor = [UIColor lightGrayColor];
        self.plusLabel.font = [UIFont systemFontOfSize:13.0f];

        [self addSubview:self.plusLabel];
        self.commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(205, 100, 150, 15)];
        self.commentLabel.textColor = [UIColor lightGrayColor];
        self.commentLabel.font = [UIFont systemFontOfSize:12.0f];

        [self addSubview:self.commentLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
