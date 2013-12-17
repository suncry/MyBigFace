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
        self.backgroundColor = [UIColor grayColor];
        UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, 55)];
        backgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backgroundView];
        self.logoView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 44, 44)];
        [self.logoView setImage:[UIImage imageNamed:@"FaceView_comment.png"]];
        [self addSubview:self.logoView];
        
        self.commentLable = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 250, 30)];
        [self addSubview:self.commentLable];
        self.timeLable = [[UILabel alloc] initWithFrame:CGRectMake(190, 35, 120, 15)];
        self.timeLable.textColor = [UIColor lightGrayColor];
        self.timeLable.font = [UIFont systemFontOfSize:12.0f];;
;
        [self addSubview:self.timeLable];

        UILabel *bottonLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 54, 280, 1)];
        bottonLable.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:bottonLable];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
