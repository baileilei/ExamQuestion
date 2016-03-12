//
//  QuestionListViewCell.m
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "QuestionListViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "Common.h"
#import "ProblemPaperKindObject.h"
#import "ProblemPaperObject.h"
#import "Config.h"

@interface QuestionListViewCell()
{
    UIImageView *headerImageView;
    UITextField *title;
//    UILabel *note;
    UILabel *name;
    UILabel *problemNum;
//    UILabel *comment;
}
@end

@implementation QuestionListViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        headerImageView=[[UIImageView alloc] init];
        [headerImageView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:headerImageView];
        
        title=[[UITextField alloc] init];
        [title setTextColor:[Common translateHexStringToColor:@"#121212"]];
        [title setFont:[UIFont boldSystemFontOfSize:14]];
        [title setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [title setEnabled:NO];
        [title setBackgroundColor:[UIColor clearColor]];
        [self addSubview:title];
        
        
        name=[[UILabel alloc] init];
        [name setTextColor:[Common translateHexStringToColor:@"#888888"]];
        [name setFont:[UIFont systemFontOfSize:13]];
        [name setNumberOfLines:0];
        [name setBackgroundColor:[UIColor clearColor]];
        [self addSubview:name];
        
        problemNum=[[UILabel alloc] init];
        [problemNum setTextColor:[Common translateHexStringToColor:@"#888888"]];
        [problemNum setFont:[UIFont systemFontOfSize:13]];
        [problemNum setNumberOfLines:0];
        [problemNum setBackgroundColor:[UIColor clearColor]];
        [self addSubview:problemNum];
        
        //UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, k_ListViewCell_Height - 0.5, self.bounds.size.width, 1)];
        UIView *separator2 = [[UIView alloc] initWithFrame:CGRectMake(10, k_ListViewCell_Height - 1.0, self.bounds.size.width-20, 1)];
        //separator.backgroundColor = [UIColor darkGrayColor];
        separator2.backgroundColor =[Common translateHexStringToColor:@"#e1e1e1"];
        //[self addSubview:separator];
        [self addSubview:separator2];
    }
    return self;
}
-(void)setPost:(ProblemPaperObject *)post
{
    _post=post;
    if (_post.Header.length>0)
    {
        //   NSLog(@"initUrl3(_post.Header)---%@",initUrl3(_post.Header));
        [headerImageView setImageWithURL:[NSURL URLWithString:initUrlWeb(_post.Header)]];
        // NSLog(@"----header---%@",_post.header);
    }
    //标题
    
    title.text=_post.Name;
    if (_post.isReaded) {
        [title setTextColor:[Common translateHexStringToColor:@"#888888"]];
    }
    else{
        [title setTextColor:[Common translateHexStringToColor:@"#121212"]];
    }
    //self.note.text=_post.summary;
    //标题下备注
    //截取下标之前的字符串（去除），下标至最后的值
    if ([_post.Name length] > 16) {
        name.text=[_post.Name substringFromIndex:16];
    }
    else{
        name.text=_post.Name;
    }
    problemNum.text=[NSString stringWithFormat:@"%@道",_post.ProblemNum];
    
    [self setNeedsLayout];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    float titleMagin=0;
    if (self.post.Header.length>0)
    {
        [headerImageView setFrame:CGRectMake(10, 8, 54, 54)];
        titleMagin=75;
    }
    else
    {
        
        [headerImageView setFrame:CGRectZero];
        titleMagin=10;
    }
    
    [title setFrame:CGRectMake(titleMagin, 8, CGRectGetWidth(self.bounds)-titleMagin-10, 20)];
    //[self.note setFrame:CGRectMake(titleMagin, 30, CGRectGetWidth(self.bounds)-titleMagin-10, 30)];
    [name setFrame:CGRectMake(titleMagin, 30, 100, 30)];
    [problemNum setFrame:CGRectMake(CGRectGetWidth(self.bounds)-100, 30, 100, 30)];
//    [self->comment setFrame:CGRectMake(titleMagin+100+100+20, 30, 20, 30)];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
