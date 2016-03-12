//
//  QuestionViewController.h
//  QuestionDemo
//
//  Created by lmj on 15-10-5.
//  Copyright (c) 2015年 lmj. All rights reserved.
//
#define k_ToolBarHeight 44.0f
#import "BaseViewController.h"

#import "ProblemPaperObject.h"
#import "ProblemsLibObject.h"
@protocol QuestionViewControllerDelegate;

@interface QuestionViewController : BaseViewController<UIScrollViewDelegate,UIWebViewDelegate>
@property (nonatomic,strong) ProblemPaperObject *proObj;
@property (nonatomic,weak) id<QuestionViewControllerDelegate> delegate;
@property(nonatomic,assign) BOOL isFromAuthorHome;
-(void)startLoading;
-(void)endLoading;
-(void)reset;


@end
@protocol QuestionViewControllerDelegate <NSObject>

@optional
-(void)questionViewControllerBack:(QuestionViewController *)quesVC;
-(void)questionViewControllerComment:(QuestionViewController *)quesVC;

@end