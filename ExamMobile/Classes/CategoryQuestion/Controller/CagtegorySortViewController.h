//
//  CagtegorySortViewController.h
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "BaseViewController.h"
@protocol CagtegorySortViewControllerDelegate;
@interface CagtegorySortViewController : BaseViewController <UIScrollViewDelegate>
@property(nonatomic,assign) id<CagtegorySortViewControllerDelegate> delegate;
@end

@protocol CagtegorySortViewControllerDelegate <NSObject>

@optional
-(void)categorySortGoBack:(BOOL)changed;

@end