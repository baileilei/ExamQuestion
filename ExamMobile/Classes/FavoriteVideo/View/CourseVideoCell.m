//
//  CourseVideoCell.m
//  ExamQuestions
//
//  Created by lmj on 15-10-6.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "CourseVideoCell.h"
#import "UIImageView+AFNetworking.h"
#import "Common.h"
#import "config.h"
@interface CourseVideoCell()
{
    UIImageView *headerImageView;
    UITextField *authorName;
    UILabel *note;
    UILabel *dateLabel;
    UILabel *lastedTitle;
    UIButton *cancelBtn;
    //    UIImageView *headerImageView;
    //    UITextField *title;
    //    UILabel *note;
    //    UILabel *author;
    //    UILabel *date;
    //    UILabel *comment;
    //    UIButton *cancelBtn;
    
}

@end
@implementation CourseVideoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *bgView = [[UIView alloc ] initWithFrame:CGRectMake(10, 10, self.bounds.size.width - 20, k_VideoListDetailCell_Height - 10)];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        [bgView.layer setCornerRadius:3];
        [bgView.layer setBorderWidth:1.0f];
        [bgView.layer setBorderColor:[UIColor colorWithWhite:0.0f alpha:0.1].CGColor];
        [self addSubview:bgView];
        
        headerImageView = [[UIImageView alloc] init];
        [headerImageView setContentMode:UIViewContentModeScaleAspectFit];
        [headerImageView setFrame:CGRectMake(10, 8, 54, 54)];
        [bgView addSubview:headerImageView];
        
        authorName = [[UITextField alloc] init];
        [authorName setTextColor:[Common translateHexStringToColor:@"#121212"]];
        [authorName setFont:[UIFont boldSystemFontOfSize:14]];
        [authorName setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [authorName setEnabled:NO];
        [authorName setBackgroundColor:[UIColor clearColor]];
        [authorName setFrame:CGRectMake(75, 8, CGRectGetWidth(bgView.bounds) - 10 - 75, 20)];
        [bgView addSubview:authorName];
        
        dateLabel = [[UILabel alloc] init];
        [dateLabel setTextColor:[Common translateHexStringToColor:@"#888888"]];
        [dateLabel setFont:[UIFont systemFontOfSize:13]];
        [dateLabel setTextAlignment:NSTextAlignmentRight];
        [dateLabel setFrame:CGRectMake(75, 75, CGRectGetWidth(bgView.bounds) - 75 - 10, 20)];
        [bgView addSubview:dateLabel];
        
        lastedTitle = [[UILabel alloc] init];
        [lastedTitle setTextColor:[Common translateHexStringToColor:@"#666666"]];
        [lastedTitle setFont:[UIFont boldSystemFontOfSize:13]];
        [lastedTitle setBackgroundColor:[UIColor clearColor]];
        [lastedTitle setFrame:CGRectMake(75, 30, bgView.bounds.size.width - 75 -10, 40)];
        [bgView addSubview:lastedTitle];
        
        cancelBtn = [[UIButton alloc] init];
        [cancelBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"cellBtn.png"] forState:UIControlStateNormal];
        [cancelBtn setFrame:CGRectMake(10, 70, 54, 24)];
        [cancelBtn addTarget:self action:@selector(cancelFocus) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:cancelBtn];
        
        //        headerImageView=[[UIImageView alloc] init];
        //        [headerImageView setContentMode:UIViewContentModeScaleAspectFit];
        //        [self addSubview:headerImageView];
        //
        //        title=[[UITextField alloc] init];
        //        [title setTextColor:[Common translateHexStringToColor:@"#121212"]];
        //        [title setFont:[UIFont boldSystemFontOfSize:14]];
        //        [title setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        //        [title setEnabled:NO];
        //        [title setBackgroundColor:[UIColor clearColor]];
        //        [self addSubview:title];
        //
        //
        //        author=[[UILabel alloc] init];
        //        [author setTextColor:[Common translateHexStringToColor:@"#888888"]];
        //        [author setFont:[UIFont systemFontOfSize:13]];
        //        [author setNumberOfLines:0];
        //        [author setBackgroundColor:[UIColor clearColor]];
        //        [self addSubview:author];
        //
        //        date=[[UILabel alloc] init];
        //        [date setTextColor:[Common translateHexStringToColor:@"#888888"]];
        //        [date setFont:[UIFont systemFontOfSize:13]];
        //        [date setNumberOfLines:0];
        //        [date setBackgroundColor:[UIColor clearColor]];
        //        [self addSubview:date];
        //
        //        //UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, k_ListViewCell_Height - 0.5, self.bounds.size.width, 1)];
        //        UIView *separator2 = [[UIView alloc] initWithFrame:CGRectMake(10, k_ListViewCell_Height - 1.0, self.bounds.size.width-20, 1)];
        //        //separator.backgroundColor = [UIColor darkGrayColor];
        //        separator2.backgroundColor =[Common translateHexStringToColor:@"#e1e1e1"];
        //        //[self addSubview:separator];
        //        [self addSubview:separator2];
        
        
    }
    return self;
}
-(void)setVideo:(CoursesVideoObject *)video
{
    _video=video;
    if (_video.VideoImage.length>0)
    {
        [headerImageView setImage:[UIImage imageNamed:@"userheader"]];
        //   [headerImageView setImageWithURL:[NSURL URLWithString:initUrl(_video.VideoImage)]];
        
        //  NSLog(@"----initUrl2---%@",[NSURL URLWithString:initUrl(_video.VideoImage)]);
    }
    else{
        [headerImageView setImage:[UIImage imageNamed:@"userheader"]];
    }
    //标题
    
    authorName.text=_video.VideoName;
    lastedTitle.text = _video.VideoName;
    if (_video.isReaded) {
        [authorName setTextColor:[Common translateHexStringToColor:@"#888888"]];
    }
    else{
        [authorName setTextColor:[Common translateHexStringToColor:@"#121212"]];
    }
    //self.note.text=_post.summary;
    //标题下备注
    //截取下标之前的字符串（去除），下标至最后的值
    if ([_video.VideoName length] > 16) {
        dateLabel.text=[_video.VideoName substringFromIndex:16];
    }
    else{
        dateLabel.text=_video.VideoName;
    }
    dateLabel.text=[NSString stringWithFormat:@"时间:%@分",_video.VideoLength];
    
    [self setNeedsLayout];
}
- (void)cancelFocus
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(courseListCancelFocus:)]) {
        [self.delegate courseListCancelFocus:self.tag];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    //    float titleMagin=0;
    //    if (self.video.VideoImage.length>0)
    //    {
    //        [headerImageView setFrame:CGRectMake(10, 8, 54, 54)];
    //        titleMagin=75;
    //    }
    //    else
    //    {
    //
    //        [headerImageView setFrame:CGRectZero];
    //        titleMagin=10;
    //    }
    //
    //    [title setFrame:CGRectMake(titleMagin, 8, CGRectGetWidth(self.bounds)-titleMagin-10, 20)];
    //    //[self.note setFrame:CGRectMake(titleMagin, 30, CGRectGetWidth(self.bounds)-titleMagin-10, 30)];
    //    [author setFrame:CGRectMake(titleMagin, 30, 100, 30)];
    //    [date setFrame:CGRectMake(CGRectGetWidth(self.bounds)-100, 30, 100, 30)];
    //    [self->comment setFrame:CGRectMake(titleMagin+100+100+20, 30, 20, 30)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
