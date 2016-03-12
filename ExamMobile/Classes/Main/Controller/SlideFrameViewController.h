//
//  SlideFrameViewController.h
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "RESideMenu.h"
#import "LeftMenuViewController.h"
#import "IndexSlideViewController.h"
#import "QuestionListViewController.h"

#import "CagtegorySortViewController.h"

#import "CourseVideoSortViewController.h"
#import "CoursesVideoViewController.h"
#import "FavVideoViewController.h"
#import "CourseListViewController.h"
#import "QuestionViewController.h"
#import "FavExamViewController.h"
#import "FavQuestionViewController.h"
@interface SlideFrameViewController : UIViewController< QuestionListViewControllerDelegate,
                                                        QuestionViewControllerDelegate,
                                                        RESideMenuDelegate,
                                                        LeftMenuViewControllerDelegate,
                                                    
                                                        FavVideoViewControllerDelegate,
                                                        IndexSlideViewControllerDelegate,
                                                        CagtegorySortViewControllerDelegate,
                                                        CourseVideoSortViewControllerDelegate,
                                                        CourseListViewControllerDelegate,
                                                        CourseVideoViewControllerDelegate,
                                                        FavQuestionViewControllerDelegate,
                                                        FavExamViewControllerDelegate>
@property(nonatomic,strong) UIPanGestureRecognizer *panGestureRecognizer;

@end
