//
//  QuestionListViewCell.h
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProblemPaperObject.h"
#define k_ListViewCell_Height 70.0f

@interface QuestionListViewCell : UITableViewCell

@property(nonatomic,strong) ProblemPaperObject *post;

@end
