//
//  FavExamListCell.h
//  ExamQuestions
//
//  Created by lmj on 15-10-8.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProblemsLibObject.h"
#define k_ListViewCell_Height 70.0f
@interface FavExamListCell : UITableViewCell
@property (nonatomic,strong) ProblemsLibObject *problems;
@end
