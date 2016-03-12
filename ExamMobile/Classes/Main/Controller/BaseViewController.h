//
//  BaseViewController.h
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//
#define k_navigationBarHeigh 44.0f



#import <UIKit/UIKit.h>
#import "Config.h"

@class SlideFrameViewController;
@interface BaseViewController : UIViewController
@property(nonatomic) CGRect viewBounds;
@property(nonatomic,strong) UIViewController *leftVC;
@property(nonatomic,strong) UIViewController *rightVC;
@property (strong,nonatomic) SlideFrameViewController *sliderFrameVC;
//改版navbar的颜色
-(void)changeNavBarTitleColor;
@end

