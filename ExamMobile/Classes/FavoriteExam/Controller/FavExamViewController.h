//
//  FavExamViewController.h
//  QuestionDemo3
//
//  Created by lmj on 15-10-8.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "BaseViewController.h"
#import "ProblemsLibObject.h"
@protocol FavExamViewControllerDelegate;
@interface FavExamViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) id<FavExamViewControllerDelegate> delegate;

@end
@protocol FavExamViewControllerDelegate <NSObject>

@optional

- (void)favExamView:(FavExamViewController *)favExamVC selectedExamObject:(ProblemsLibObject *)examObj;

@end