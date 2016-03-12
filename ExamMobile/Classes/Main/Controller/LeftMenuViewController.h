//
//  LeftMenuViewController.h
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LeftMenuViewControllerDelegate;
@interface LeftMenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) id<LeftMenuViewControllerDelegate> delegate;
@end

@protocol LeftMenuViewControllerDelegate <NSObject>

@optional
-(void)leftMenuChangeSelected:(int)index;
@end
