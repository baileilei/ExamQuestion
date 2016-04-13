//
//  DetailVideoViewController.h
//  ExamMobile
//
//  Created by lmj on 16/4/12.
//  Copyright © 2016年 lmj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@protocol DetailVideoViewControllerDelegate;
@interface DetailVideoViewController : BaseViewController

@property (nonatomic, retain)NSString * URLString;

@property (nonatomic, weak) id<DetailVideoViewControllerDelegate> delegate;


- (void)setupPlayer;

@end


@protocol DetailVideoViewControllerDelegate <NSObject>

@optional
-(void)detailVideoVideoControllerGoBack:(BOOL)changed;

@end