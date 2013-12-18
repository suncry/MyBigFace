//
//  MyFaceCell.h
//  MyBigFace
//
//  Created by cy on 13-12-18.
//  Copyright (c) 2013年 ipointek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFaceCell : UITableViewCell
@property(nonatomic,retain)UIImageView *faceImageView;
@property(nonatomic,retain)UIImageView *faceBackgroundImageView;
@property(nonatomic,retain)UIImageView *locationImageView;
@property(nonatomic,retain)UIImageView *timeOfUploadImageView;
@property(nonatomic,retain)UIImageView *plusImageView;
@property(nonatomic,retain)UIImageView *commentImageView;
@property(nonatomic,retain)UILabel *faceLabel;
@property(nonatomic,retain)UILabel *locationLabel;
@property(nonatomic,retain)UILabel *timeOfUploadLabel;
@property(nonatomic,retain)UILabel *plusLabel;
@property(nonatomic,retain)UILabel *commentLabel;

@end
