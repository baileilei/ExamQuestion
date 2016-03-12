//
//  CourseListViewController.h
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "BaseViewController.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "CoursesListJsonHandler.h"
#import "RefreshFooterView.h"
#import "CoursesVideoObject.h"
#define k_ListViewCell_Height 70.0f
@protocol CourseListViewControllerDelegate;
@interface CourseListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate,CoursesListJsonHandlerDelegate,RefreshFooterViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
@property(nonatomic,weak) id<CourseListViewControllerDelegate> delegate;
-(id)initWithCagtegory:(CoursesObject *)catObj;
-(void)needRefresh;
@end

@protocol CourseListViewControllerDelegate <NSObject>
@optional
-(void)courseListViewController:(CourseListViewController *)listVCT selectedPostObject:(CoursesVideoObject *)postObj;

@end
