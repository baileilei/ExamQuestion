//
//  FavQuestionViewController.h
//  QuestionDemo3
//
//  Created by lmj on 15-10-8.
//  Copyright (c) 2015年 lmj. All rights reserved.
//
#define k_ToolBarHeight 44.0f
#import "BaseViewController.h"
#import "ProblemPaperObject.h"
#import "ProblemsLibObject.h"
@protocol FavQuestionViewControllerDelegate;

@interface FavQuestionViewController : BaseViewController<UIScrollViewDelegate,UIWebViewDelegate>
@property (nonatomic,strong) ProblemsLibObject *proObj;
@property (nonatomic,weak) id<FavQuestionViewControllerDelegate> delegate;
@property(nonatomic,assign) BOOL isFromAuthorHome;
-(void)startLoading;
-(void)endLoading;
-(void)reset;


@end
@protocol FavQuestionViewControllerDelegate <NSObject>

@optional
-(void)FavquestionViewControllerBack:(FavQuestionViewController *)quesVC;

@end