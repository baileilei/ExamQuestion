//
//  CoursesVideoViewController.h
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "BaseViewController.h"
#import "SlideSwitchView.h"
@protocol CourseVideoViewControllerDelegate;
@interface CoursesVideoViewController : BaseViewController<SlideSwitchViewDelegate>
@property(nonatomic,assign) id<CourseVideoViewControllerDelegate> delegate;
-(id)initWithIsIndex:(BOOL)isIndex;
-(void)reset;
@end

@protocol CourseVideoViewControllerDelegate <NSObject>

@optional
-(void)CourseVideoViewShowCategorySort2;
@end
