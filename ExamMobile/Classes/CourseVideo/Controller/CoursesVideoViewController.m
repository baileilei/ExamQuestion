//
//  CoursesVideoViewController.m
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "CoursesVideoViewController.h"
#import "CourseListViewController.h"
#import "RESideMenu.h"
#import "CoursesObject.h"
#import "SlideFrameViewController.h"
@interface CoursesVideoViewController ()
@property(nonatomic,strong) SlideSwitchView *SSView;
@property(nonatomic,assign) BOOL isIndex;
@property(nonatomic,strong) NSArray *showCategorysArray;
@end

@implementation CoursesVideoViewController
-(id)initWithIsIndex:(BOOL)isIndex
{
    if (self=[super init]) {
        self.isIndex=isIndex;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([Common isIOS7])
    {
        self.automaticallyAdjustsScrollViewInsets=NO;
        [self.navigationController.navigationBar setBarTintColor:[Common translateHexStringToColor:k_NavBarBGColor]];
    }
    else
    {
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    //self.sideMenuViewController.navigationController.navigationBarHidden=YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self changeNavBarTitleColor];
    
    [self initSSView:YES];
    
}
-(void)reset
{
    [self.SSView removeFromSuperview];
    self.SSView=nil;
    [self initSSView:NO];
}
-(void)initSSView:(BOOL)first
{
    
    //这里修改侧滑
    self.title=@"视频";
    self.showCategorysArray=[CoursesObject share].categorysShow;
    //NSLog(@"视频---%d",self.showCategorysArray.count);
    
   
    //NSLog(@"CoursesVideoViewController");
   
    //初始化切换菜单
    CGRect frame=self.view.bounds;
    if (!first) {
        frame=self.parentViewController.view.bounds;
    }
    self.SSView=[[SlideSwitchView alloc] initWithFrame:frame];
    
    [self.view addSubview:self.SSView];
    
    self.SSView.slideSwitchViewDelegate=self;
    self.SSView.tabItemNormalColor = [Common translateHexStringToColor:@"#000000"];
    self.SSView.tabItemSelectedColor = [Common translateHexStringToColor:@"#333333"];
    self.SSView.shadowImage = [[UIImage imageNamed:@"red_line_and_shadow.png"]
                               stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    if (!self.isIndex) {
        UIButton *rightSideButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightSideButton setImage:[UIImage imageNamed:@"icon_rightadd.png"] forState:UIControlStateNormal];
        [rightSideButton addTarget:self action:@selector(sortCategory) forControlEvents:UIControlEventTouchUpInside];
        rightSideButton.frame = CGRectMake(0, 0, 43.0f, 33.0f);
        self.SSView.rigthSideButton = rightSideButton;
        self.SSView.alignCenter=NO;
    }
    else
    {
        self.SSView.alignCenter=YES;
    }
    [self.SSView buildUI];
    
}
-(void)sortCategory
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(CourseVideoViewShowCategorySort2)]) {
        //要改
       // NSLog(@"CourseVideoViewShowCategorySort");
        [self.delegate CourseVideoViewShowCategorySort2];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma slidswitchdelegate
#pragma mark - 滑动tab视图代理方法

- (NSUInteger)numberOfTab:(SlideSwitchView *)view
{
   // NSLog(@"showCategorysArray---%d",self.showCategorysArray.count);
    return self.showCategorysArray.count;
}

- (UIViewController *)slideSwitchView:(SlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    CourseListViewController *listVC=[[CourseListViewController alloc] initWithCagtegory:[self.showCategorysArray objectAtIndex:number]];
    listVC.title=((CoursesObject *)[self.showCategorysArray objectAtIndex:number]).CourseName;
    SlideFrameViewController *frameVCT=(SlideFrameViewController *)[self.sideMenuViewController parentViewController];
    listVC.delegate=frameVCT;
    return listVC;
}

- (void)slideSwitchView:(SlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam
{
    [self.sideMenuViewController panGestureRecognized:panParam];
}

- (void)slideSwitchView:(SlideSwitchView *)view didselectTab:(NSUInteger)number
{
    // NSLog(@"---ListViewController--didselectTab----%d",((CategoryObject *)[self.showCategorysArray objectAtIndex:number]).categoryID);
    
    [(CourseListViewController *)[view.viewArray objectAtIndex:number] needRefresh];
}
@end
