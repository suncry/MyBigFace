//
//  CommentCell.m
//  MyBigFace
//
//  Created by cy on 13-12-16.
//  Copyright (c) 2013年 ipointek. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.logoView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 44, 44)];
        [self.logoView setImage:[UIImage imageNamed:@"FaceView_comment.png"]];
        [self addSubview:self.logoView];
        
//        self.commentLable = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 250, 30)];
//        [self addSubview:self.commentLable];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
