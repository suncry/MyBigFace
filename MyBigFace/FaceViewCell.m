//
//  FaceViewCell.m
//  MyBigFace
//
//  Created by cy on 13-11-7.
//  Copyright (c) 2013年 ipointek. All rights reserved.
//

#import "FaceViewCell.h"

@implementation FaceViewCell
@synthesize faceInfoView = _faceInfoView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        self.faceInfoView = [[UIView alloc]initWithFrame:CGRectMake(0,0, 320, [self bounds].size.height)];
        self.faceInfoView = [[UIView alloc]initWithFrame:CGRectMake(0,0, 320, 568)];

        [self addSubview:self.faceInfoView];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
