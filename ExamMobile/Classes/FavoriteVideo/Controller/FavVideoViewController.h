//
//  FavPostViewController.h
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "BaseViewController.h"
#import "CoursesVideoObject.h"
#import "CourseVideoCell.h"
@protocol FavVideoViewControllerDelegate;
@interface FavVideoViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,CourseVideoCellDelegate>
@property(nonatomic,assign) id<FavVideoViewControllerDelegate> delegate;
@end


@protocol FavVideoViewControllerDelegate <NSObject>

@optional
-(void)favPostView:(FavVideoViewController *)favPVC selectedPostObject:(CoursesVideoObject *)postObj;
@end