//
//  DetailVideoViewController.m
//  ExamMobile
//
//  Created by lmj on 16/4/12.
//  Copyright © 2016年 lmj. All rights reserved.
//

#import "DetailVideoViewController.h"
#import "LMVideoPlayerOperationView.h"
@interface DetailVideoViewController ()
{
    LMVideoPlayerOperationView *lmPlayer;
    CGRect playerFrame;
}
@end

@implementation DetailVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self changeNavBarTitleColor];
    
    [self setupNavigationItem];
    
}

-(void)changeNavBarTitleColor
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.navigationController.navigationBar setBarTintColor:[Common translateHexStringToColor:k_NavBarBGColor]];
    UIColor *cc = [UIColor whiteColor];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:cc forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)setupPlayer {
    self.view.backgroundColor = [UIColor whiteColor];
    playerFrame = CGRectMake(0, 64, self.view.frame.size.width, (self.view.frame.size.width)*3/4);
    lmPlayer =  [[LMVideoPlayerOperationView alloc] initWithFrame:playerFrame videoURLString:self.URLString];
    [self.view addSubview:lmPlayer];
    [lmPlayer play];
}


- (void)setupNavigationItem {
    //navbar
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 54, 44)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"icon_back_w.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back=[[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    self.navigationItem.leftBarButtonItem=back;
}

-(void)goBack
{
    [lmPlayer dismiss];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(detailVideoVideoControllerGoBack:)]) {
        [self.delegate detailVideoVideoControllerGoBack:self];
        
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"player deallco");
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
