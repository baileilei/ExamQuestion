//
//  CourseVideoCell.h
//  ExamQuestions
//
//  Created by lmj on 15-10-6.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoursesVideoObject.h"
@protocol CourseVideoCellDelegate;
@interface CourseVideoCell : UITableViewCell
@property (nonatomic,strong) CoursesVideoObject *video;
@property (nonatomic,assign) id<CourseVideoCellDelegate> delegate;
@end

@protocol CourseVideoCellDelegate <NSObject>

@optional
- (void)courseListCancelFocus:(int)index;

@end