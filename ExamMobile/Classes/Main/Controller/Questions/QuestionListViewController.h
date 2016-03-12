//
//  QuestionListViewController.h
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
#import "QuestionListJsonHandler.h"
#import "RefreshFooterView.h"
#import "ProblemPaperObject.h"
@protocol QuestionListViewControllerDelegate;
@interface QuestionListViewController :BaseViewController<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate,QuestionListJsonHandlerDelegate,RefreshFooterViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>


@property(nonatomic,weak) id<QuestionListViewControllerDelegate> delegate;
-(id)initWithCagtegory:(ProblemPaperKindObject *)catObj;
-(void)needRefresh;

@end


@protocol QuestionListViewControllerDelegate <NSObject>
@optional
-(void)QuestionlistViewContoller:(QuestionListViewController *)listVCT selectedPostObject:(ProblemPaperObject *)postObj;

@end