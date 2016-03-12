//
//  CourseVideoSortViewController.h
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "BaseViewController.h"
@protocol CourseVideoSortViewControllerDelegate;
@interface CourseVideoSortViewController : BaseViewController<UIScrollViewDelegate>
@property(nonatomic,assign) id<CourseVideoSortViewControllerDelegate> delegate;
@end

@protocol CourseVideoSortViewControllerDelegate <NSObject>

@optional
-(void)courseVideocategorySortGoBack:(BOOL)changed;



@end
