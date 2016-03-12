//
//  FavExamListCell.m
//  ExamQuestions
//
//  Created by lmj on 15-10-8.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "FavExamListCell.h"
#import "Common.h"
@interface FavExamListCell()
{
    UITextField *title;
    UILabel *note;
    UILabel *questionNumber;
    UILabel *date;
    UILabel *comment;
}
@end
@implementation FavExamListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        title=[[UITextField alloc] init];
        [title setTextColor:[Common translateHexStringToColor:@"#121212"]];
        [title setFont:[UIFont boldSystemFontOfSize:14]];
        [title setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [title setEnabled:NO];
        [title setBackgroundColor:[UIColor clearColor]];
        [self addSubview:title];
        
        
        questionNumber=[[UILabel alloc] init];
        [questionNumber setTextColor:[Common translateHexStringToColor:@"#888888"]];
        [questionNumber setFont:[UIFont systemFontOfSize:13]];
        [questionNumber setNumberOfLines:0];
        [questionNumber setBackgroundColor:[UIColor clearColor]];
        [self addSubview:questionNumber];
        
        date=[[UILabel alloc] init];
        [date setTextColor:[Common translateHexStringToColor:@"#888888"]];
        [date setFont:[UIFont systemFontOfSize:11]];
        [date setNumberOfLines:0];
        [date setBackgroundColor:[UIColor clearColor]];
        [self addSubview:date];
        
        UIView *separator2 = [[UIView alloc] initWithFrame:CGRectMake(10, k_ListViewCell_Height - 1.0, self.bounds.size.width-20, 1)];
        
        separator2.backgroundColor =[Common translateHexStringToColor:@"#e1e1e1"];
        
        [self addSubview:separator2];
    }
    return self;
}
-(void)setProblems:(ProblemsLibObject *)post
{
    _problems=post;
   // NSLog(@"_problems.PaperName---%@",_problems.PaperName);
    title.text=_problems.PaperName;
    
    [title setTextColor:[Common translateHexStringToColor:@"#121212"]];
    
    //self.note.text=_post.summary;
    questionNumber.text=[NSString stringWithFormat:@"编号:%@",_problems.QuestionNumber];
    date.text= post.ProblemsLibData;
    
    [self setNeedsLayout];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    float titleMagin=10;
    [title setFrame:CGRectMake(titleMagin, 8, CGRectGetWidth(self.bounds)-titleMagin-10, 20)];
    //[self.note setFrame:CGRectMake(titleMagin, 30, CGRectGetWidth(self.bounds)-titleMagin-10, 30)];
    [questionNumber setFrame:CGRectMake(titleMagin, 30, 100, 30)];
    [date setFrame:CGRectMake(CGRectGetWidth(self.bounds)-100, 30, 100, 30)];
    //[self.comment setFrame:CGRectMake(titleMagin+100+100+20, 30, 20, 30)];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
