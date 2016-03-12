//
//  RefreshFooterView.h
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <UIKit/UIKit.h>
#define k_RefreshFooterViewHeight 60.0f
#define k_RefreshFooterNormalStr @"加载更多"
#define k_RefreshFooterRefreshingStr @"正在加载..."
#define k_RefreshFooterNoMoreStr @"没有更多数据了"
typedef enum {
	FooterRefreshStateNormal = 1,
	FooterRefreshStateRefreshing = 2,
    FooterRefreshStateDiseable=3  //没有更多
} FooterRefreshState;

@protocol RefreshFooterViewDelegate;

@interface RefreshFooterView : UIView
@property(nonatomic) FooterRefreshState status;
@property(nonatomic,weak) id<RefreshFooterViewDelegate> delegate;
+(RefreshFooterView *)footerWithWidth:(float)width;

@end

@protocol RefreshFooterViewDelegate <NSObject>

@optional
-(void)refreshFooterBegin:(RefreshFooterView *)view;

@end