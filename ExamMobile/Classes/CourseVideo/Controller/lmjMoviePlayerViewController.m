//
//  lmjMoviePlayerViewController.m
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "lmjMoviePlayerViewController.h"
#import "Config.h"
@interface lmjMoviePlayerViewController ()

@end

@implementation lmjMoviePlayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    MPMoviePlayerPlaybackDidFinishNotification
    // 移除程序进入后台的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    

}




#pragma mark - 实现这个方法来控制屏幕方向
/**
 *  控制当前控制器支持哪些方向
 *  返回值是UIInterfaceOrientationMask*
 */
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}


@end
