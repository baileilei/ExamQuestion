//
//  CourseListViewCell.h
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoursesVideoObject.h"
#define k_ListViewCell_Height 70.0f
@interface CourseListViewCell : UITableViewCell
@property(nonatomic,strong) CoursesVideoObject *courses;
@end
