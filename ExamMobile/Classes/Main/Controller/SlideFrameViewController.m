//
//  SlideFrameViewController.m
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "SlideFrameViewController.h"

#import "ProblemPaperObject.h"
#import "CourseListViewController.h"

#import "lmjMoviePlayerViewController.h"
#import "QuestionViewController.h"
#import "FavQuestionViewController.h"
#import "AboutViewController.h"

#import "DetailVideoViewController.h"
@interface SlideFrameViewController ()
{
    //-------------------------
    //框架数据
    UIViewController *currentVC;
    int currentIndex;
    UIViewController *_willShowCTR;
    float showTime;
    float autoShowDistance;
    //-------------------------
    //业务数据
    RESideMenu *sideMenuVC;
//    PostShowViewController *postVC;
    QuestionViewController *quesVC;
    UINavigationController *postNavVC;
    
//    lmjMoviePlayerViewController *playerVC;
//    UINavigationController *playerNavVC;
    
    
    UINavigationController *commNavVC;
    UINavigationController *containerNavVC;
    IndexSlideViewController *indexListVC;
    IndexSlideViewController *categoryListVC;

    UIButton *showmenuBtn;

    FavVideoViewController *favVideoVC;

    CagtegorySortViewController *categorySortVC;
    CourseVideoSortViewController *courseVideogorySortVC;
    
    
    UINavigationController *categorySortNavVC;
    UINavigationController *coursevideogorySortNavVC;

    CoursesVideoViewController *coursesVideoVc;
    
    FavQuestionViewController *favQuesVC;
    UINavigationController *favQuesNavVC;
    
    FavExamViewController *favExamVC;
    UINavigationController *favExamNavVC;
    
    AboutViewController *aboutVC;
    
    DetailVideoViewController *detailVideoVC;
    UINavigationController *detailVideoNavVC;
    
}
@end

@implementation SlideFrameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    showTime=0.5;
    autoShowDistance=80;
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizedBase:)];
    //添加分类图标
    //videoVC = [[VideoViewController alloc] init];
    coursesVideoVc = [[CoursesVideoViewController alloc] initWithIsIndex:NO];
    coursesVideoVc.delegate=self;
    
   // NSLog(@"SlideFrameViewController");
    
    
    //首页
	indexListVC=[[IndexSlideViewController alloc] initWithIsIndex:YES];
    containerNavVC=[[UINavigationController alloc] initWithRootViewController:indexListVC];
  //  containerNavVC = [[UINavigationController alloc] initWithRootViewController:videoVC];
    LeftMenuViewController *leftMenuVC=[[LeftMenuViewController alloc] init];
    leftMenuVC.delegate=self;
    sideMenuVC=[[RESideMenu alloc] initWithContentViewController:containerNavVC
                                                          menuViewController:leftMenuVC];
    sideMenuVC.backgroundImage = [UIImage imageNamed:@"menubg.png"];
    sideMenuVC.delegate=self;
    
    //[sideMenuVC.view setBackgroundColor:[UIColor redColor]];
    sideMenuVC.parallaxEnabled=NO;
    //菜单缩放
    sideMenuVC.menuViewScaleValue=1.0f;
    sideMenuVC.menuViewAlphaChangeable=NO;
    //菜单背景缩放
    sideMenuVC.scaleBackgroundImageView=NO;
    if ([Common IOSVersion]<7.0) {
        sideMenuVC.scaleContentView=NO;
    }
    [self addChildViewController:sideMenuVC];
    [self.view addSubview:sideMenuVC.view];
    [self changeCurrentVC:sideMenuVC fromVC:nil];
    
    //分类列表
    categoryListVC=[[IndexSlideViewController alloc] initWithIsIndex:NO];
    categoryListVC.delegate=self;
   
//    //详细页
//    postVC=[[PostShowViewController alloc] init];
//    postVC.delegate=self;
//    postNavVC=[[UINavigationController alloc] initWithRootViewController:postVC];
//   [self addChildViewController:postNavVC];
    
    //详细页
    quesVC=[[QuestionViewController alloc] init];
    quesVC.delegate=self;
    postNavVC=[[UINavigationController alloc] initWithRootViewController:quesVC];
    [self addChildViewController:postNavVC];

    
   
//    //视频播放页
//    playerVC=[[lmjMoviePlayerViewController alloc] init];
////    playerVC=self;
//    playerNavVC=[[UINavigationController alloc] initWithRootViewController:playerVC];
//    [self addChildViewController:playerNavVC];
    
    //题库记录页
    favQuesVC = [[FavQuestionViewController alloc] init];
    favQuesVC.delegate = self;
    favQuesNavVC = [[UINavigationController  alloc] initWithRootViewController:favQuesVC];
    [self addChildViewController:favQuesNavVC];
    
    favExamVC = [[FavExamViewController alloc] init];
    favExamVC.delegate = self;
    favExamNavVC = [[UINavigationController alloc] initWithRootViewController:favExamVC];
    
    
    showmenuBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 44)];
    [showmenuBtn setBackgroundImage:[UIImage imageNamed:@"top_navigation_menuicon.png"] forState:UIControlStateNormal];
    [showmenuBtn addTarget:self action:@selector(showLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    containerNavVC.topViewController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:showmenuBtn];
  
    
    // 播放视频内容页
    
    
    //播放记录
    favVideoVC=[[FavVideoViewController alloc] init];
    favVideoVC.delegate=self;
    //关于
    aboutVC=[[AboutViewController alloc] init];
    //分类排序
    categorySortVC=[[CagtegorySortViewController alloc] init];
    categorySortVC.delegate=self;
    categorySortNavVC=[[UINavigationController alloc] initWithRootViewController:categorySortVC];
    [self addChildViewController:categorySortNavVC];
    
    //课程排序courseVideogorySortVC
    courseVideogorySortVC=[[CourseVideoSortViewController alloc] init];
    courseVideogorySortVC.delegate=self;
    coursevideogorySortNavVC=[[UINavigationController alloc] initWithRootViewController:courseVideogorySortVC];
    [self addChildViewController:coursevideogorySortNavVC];
   
    //题库记录页
    detailVideoVC = [[DetailVideoViewController alloc] init];
    detailVideoVC.delegate = self;
    detailVideoNavVC = [[UINavigationController  alloc] initWithRootViewController:detailVideoVC];
    [self addChildViewController:detailVideoNavVC];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showLeftMenu
{
    [sideMenuVC presentMenuViewController];
}

#pragma -
#pragma leftmenu selected deleage
-(void)leftMenuChangeSelected:(int)index
{
    
    switch (index) {
        case 0:
            containerNavVC.viewControllers=[NSArray arrayWithObjects:indexListVC, nil];
            break;
        case 1:
            containerNavVC.viewControllers=[NSArray arrayWithObjects:categoryListVC, nil];
            break;
        case 2:
            containerNavVC.viewControllers = [NSArray arrayWithObjects:coursesVideoVc, nil];
          //  containerNavVC.viewControllers = [NSArray arrayWithObjects:videoVC, nil];
           // containerNavVC.viewControllers=[NSArray arrayWithObjects:favAuthorVC, nil];
            break;
        case 3:
//            containerNavVC.viewControllers=[NSArray arrayWithObjects:favPostVC, nil];favQuesVC
            containerNavVC.viewControllers=[NSArray arrayWithObjects:favExamVC, nil];
            break;
        case 4:
            containerNavVC.viewControllers=[NSArray arrayWithObjects:favVideoVC,nil];
            break;
        case 5:
            containerNavVC.viewControllers=[NSArray arrayWithObjects:aboutVC, nil];
            break;
        case 6:
            break;
            
        default:
            break;
    }
    containerNavVC.topViewController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:showmenuBtn];    
}
#pragma category index delegate
//显示分类排序
-(void)indexSliderViewShowCategorySort
{
    
    [self switchShowViewContrller:categorySortNavVC
               fromViewController:currentVC
                         duration:showTime
                        showRight:YES];
   

}
//分类返回
-(void)categorySortGoBack:(BOOL)changed
{

    [self switchShowViewContrller:sideMenuVC
               fromViewController:currentVC
                         duration:showTime
                        showRight:NO];
 
    if (changed) {
        [categoryListVC reset];
    }

}
//显示课程分类排序 courseVideoSliderViewShowCategorySort
-(void)CourseVideoViewShowCategorySort2
{
    //NSLog(@"123131");
    [self switchShowViewContrller:coursevideogorySortNavVC
               fromViewController:currentVC
                         duration:showTime
                        showRight:YES];
    
    
}

//课程分类返回
-(void)courseVideocategorySortGoBack:(BOOL)changed
{
    
    [self switchShowViewContrller:sideMenuVC
               fromViewController:currentVC
                         duration:showTime
                        showRight:NO];
    
    if (changed) {
        [coursesVideoVc reset];
    }
    
}

#pragma listView Delegate
//从普通列表页到内容页
-(void)QuestionlistViewContoller:(QuestionListViewController *)listVCT selectedPostObject:(ProblemPaperObject *)postObj
{
    
    [quesVC setProObj:postObj];
    //[commVC setPostObj:postObj];
    [postNavVC.view setFrame:CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self switchShowViewContrller:postNavVC
              fromViewController:currentVC
                        duration:showTime
                       showRight:YES];

}
#pragma courseListView Delegate
//从普通列表页到内容页
- (void)courseListViewController:(CourseListViewController *)listVCT selectedPostObject:(CoursesVideoObject *)postObj
{
   // NSLog(@"-----%@",postObj.VideoPath);
    
    
    detailVideoVC.URLString  = postObj.VideoPath;
    [detailVideoVC setupPlayer];
    detailVideoVC.title = @"视频";
    [detailVideoNavVC.view setFrame:CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self switchShowViewContrller:detailVideoNavVC
               fromViewController:currentVC
                         duration:showTime
                        showRight:NO];
    //    detailVC.URLString = model.mp4_url;
//    [self.navigationController pushViewController:detailVC animated:YES];
    
//    lmjMoviePlayerViewController *playerVc = [[lmjMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:postObj.VideoPath]];
////    playerVc.moviePlayer.controlStyle = MPMovieControlStyle.None;
//    [self presentMoviePlayerViewControllerAnimated:playerVc] ;   //全拼播放
    
}
#pragma postview delegate
//从内容页返回
-(void)questionViewControllerBack:(QuestionViewController *)_postVC
{
    
    [self switchShowViewContrller:_postVC.leftVC
               fromViewController:currentVC
                         duration:showTime
                        showRight:NO];
    if (_postVC.leftVC==sideMenuVC) {
        _postVC.leftVC=nil;
    }
    
}



//从从容页到评论页
-(void)questionViewControllerComment:(QuestionViewController *)postVC
{
    [self switchShowViewContrller:commNavVC
               fromViewController:currentVC
                         duration:showTime
                        showRight:YES];
}

#pragma favexamview delegate
//收藏题库页到内容页
- (void)favExamView:(FavExamViewController *)favExamVC selectedExamObject:(ProblemsLibObject *)examObj{
    [favQuesVC setProObj:examObj];
    [self switchShowViewContrller:favQuesNavVC
               fromViewController:currentVC
                         duration:showTime
                        showRight:YES];
}
#pragma favquestionview delegate
//从内容页返回
- (void)FavquestionViewControllerBack:(FavQuestionViewController *)_quesVC
{
    
    [self switchShowViewContrller:_quesVC.leftVC
               fromViewController:currentVC
                         duration:showTime
                        showRight:NO];
    if (_quesVC.leftVC==sideMenuVC) {
        _quesVC.leftVC=nil;
    }
    
}

//播放记录页到内容页
-(void)favVideoView:(FavVideoViewController *)favPVC selectedPostObject:(CoursesVideoObject *)postObj
{
    
}

#pragma detailVideoViewController delegate
//从视频播放页返回
- (void)detailVideoVideoControllerGoBack:(BOOL)changed
{
    
    [self switchShowViewContrller:sideMenuVC
               fromViewController:currentVC
                         duration:showTime
                        showRight:NO];
    
}

#pragma mark FavVideoViewController delegate
- (void)favPostView:(FavVideoViewController *)favPVC selectedPostObject:(CoursesVideoObject *)postObj {
    detailVideoVC.URLString  = postObj.VideoPath;
    [detailVideoVC setupPlayer];
    detailVideoVC.title = @"视频";
    [detailVideoNavVC.view setFrame:CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self switchShowViewContrller:detailVideoNavVC
               fromViewController:currentVC
                         duration:showTime
                        showRight:NO];
}

#pragma -
#pragma 框架方法

-(void)addPanGesture
{

    [self.view addGestureRecognizer:self.panGestureRecognizer];
}
-(void)removePanGesture
{
    [self.view removeGestureRecognizer:self.panGestureRecognizer];
}
-(void)changeCurrentVC:(UIViewController *)vc fromVC:(UIViewController *)fr
{
    
    [self.view bringSubviewToFront:fr.view];
    if ([vc respondsToSelector:@selector(leftVC)]||[vc respondsToSelector:@selector(rightVC)])
    {
        [self addPanGesture];
        
    }
    else
    {
        [self removePanGesture];
    }
    if ([vc isKindOfClass:[UINavigationController class]])
    {
        UIViewController *child=[(UINavigationController *)vc topViewController];
        if ([child respondsToSelector:@selector(leftVC)]||[child respondsToSelector:@selector(rightVC)])
        {
            [self addPanGesture];
        }
        else
        {
            [self removePanGesture];
        }
    }
    currentVC=vc;
    currentIndex=[self.childViewControllers indexOfObject:currentVC];
    
    
    //切换页面的逻辑处理
    
    
}


-(void)switchShowViewContrller:(UIViewController *)toVC
            fromViewController:(UIViewController *)fromVC
                      duration:(NSTimeInterval)duration
                     showRight:(BOOL)showRight//显示右边的VC
{
    toVC.view.layer.shadowColor=[UIColor blackColor].CGColor;
    toVC.view.layer.shadowOpacity = 0.7;
    // The Width and the Height of the shadow rect
    CGFloat rectWidth = 5.0;
    CGFloat rectHeight =  toVC.view.frame.size.height;
    // Creat the path of the shadow
    CGMutablePathRef shadowPath = CGPathCreateMutable();
    // Move to the (0, 0) point
    CGPathMoveToPoint(shadowPath, NULL, 0.0, 0.0);
    // Add the Left and right rect
    CGPathAddRect(shadowPath, NULL, CGRectMake(0.0-rectWidth, 0.0, rectWidth, rectHeight));
    CGPathAddRect(shadowPath, NULL, CGRectMake( toVC.view.frame.size.width, 0.0, rectWidth, rectHeight));
    toVC.view.layer.shadowPath = shadowPath;
    CGPathRelease(shadowPath);
    if (duration==showTime) {
        //根据动画时间确定是否非手势
        toVC.view.center=CGPointMake(self.view.frame.size.width*(showRight?1.5:-1), fromVC.view.center.y);
    }

    [self transitionFromViewController:fromVC
                      toViewController:toVC
                              duration:duration
                               options:UIViewAnimationOptionCurveEaseInOut
                            animations:^{
                                fromVC.view.center=CGPointMake(self.view.center.x*(showRight?-1:1.5), fromVC.view.center.y);
                                toVC.view.center=CGPointMake(self.view.center.x, toVC.view.center.y);
                                
                            } completion:^(BOOL finished) {
                                toVC.view.layer.shadowColor=[UIColor clearColor].CGColor;
                                toVC.view.layer.shadowOpacity = 0.0;
                                toVC.view.layer.shadowPath=NULL;
                                [self changeCurrentVC:toVC fromVC:fromVC];
                            }];
    if (showRight)
    {
        BaseViewController *currentBaseVC=nil;
        if ([toVC isKindOfClass:[UINavigationController class]])
        {
            currentBaseVC=(BaseViewController *)[(UINavigationController *)toVC topViewController];
        }
       else
        {
            currentBaseVC=(BaseViewController *)toVC;
        }
        currentBaseVC.leftVC=fromVC;
             
    }
    
    
}

#pragma mark Gesture recognizer
-(void)panGestureRecognizedBase:(UIPanGestureRecognizer *)recognizer
{
    
    BOOL showRight=NO;
    BaseViewController *currentBaseVC=(BaseViewController *)currentVC;
    if ([currentVC isKindOfClass:[UINavigationController class]]) {
        currentBaseVC=(BaseViewController *)[(UINavigationController *)currentVC topViewController];
    }
    CGPoint point=[recognizer velocityInView:self.view];
    if (recognizer.state==UIGestureRecognizerStateBegan)
    {
       
        
    }
    if (recognizer.state==UIGestureRecognizerStateChanged)
    {
        if (self.view.center.x+point.x*0.01>self.view.bounds.size.width*0.5)
        {
            //向右滑动准备显示左边VC
            if (_willShowCTR) {
                if (_willShowCTR!=currentBaseVC.leftVC&&currentVC.view.frame.origin.x>0) {
                    [_willShowCTR.view removeFromSuperview];
                    _willShowCTR=nil;
                }
            }
            else
            {
                _willShowCTR=currentBaseVC.leftVC;
               
            }
            if (_willShowCTR.view.superview!=self.view) {
                [_willShowCTR.view setFrame:CGRectMake(-self.view.frame.size.width*0.5, 0, self.view.frame.size.width,self.view.frame.size.height)];
                [self.view addSubview:_willShowCTR.view];
                [self.view sendSubviewToBack:_willShowCTR.view];
                currentVC.view.layer.shadowColor=[UIColor blackColor].CGColor;
                currentVC.view.layer.shadowRadius=5.0;
                currentVC.view.layer.shadowOpacity = 0.7;
            }

            
        }
        if (self.view.center.x+point.x*0.01<self.view.bounds.size.width*0.5)
        {
           
            //向左滑动准备显示右边VC
            if (_willShowCTR) {
                if (_willShowCTR!=currentBaseVC.rightVC&&currentVC.view.frame.origin.x<0) {
                    [_willShowCTR.view removeFromSuperview];
                    _willShowCTR=nil;
                }
            }
            else
            {
                _willShowCTR=currentBaseVC.rightVC;
                
            }
            if (_willShowCTR.view.superview!=self.view) {
                [_willShowCTR.view setFrame:CGRectMake(self.view.frame.size.width*0.5, 0, self.view.frame.size.width,self.view.frame.size.height)];
                [self.view addSubview:_willShowCTR.view];
                [self.view sendSubviewToBack:_willShowCTR.view];
                currentVC.view.layer.shadowColor=[UIColor blackColor].CGColor;
                currentVC.view.layer.shadowRadius=5.0;
                currentVC.view.layer.shadowOpacity = 0.7;

            }

            
        }
        if (_willShowCTR)
        {
            [_willShowCTR.view setFrame:CGRectMake(_willShowCTR.view.frame.origin.x+point.x*0.01, 0, self.view.frame.size.width,self.view.frame.size.height)];
            [currentVC.view setFrame:CGRectMake(currentVC.view.frame.origin.x+point.x*0.01*2, 0, self.view.frame.size.width,self.view.frame.size.height)];

        }
  
        
    }
    if (recognizer.state==UIGestureRecognizerStateEnded) {
       
       
        if (_willShowCTR) {
            float distance=currentVC.view.center.x-currentVC.view.bounds.size.width*0.5;
           
            NSTimeInterval time=showTime*fabsf(distance)/self.view.bounds.size.width;
           
            if(fabsf(distance)>autoShowDistance)
            {
                showRight=distance>0?NO:YES;
                [self switchShowViewContrller:_willShowCTR
                           fromViewController:currentVC
                                     duration:time
                                    showRight:showRight];
               
              
            }
            else
            {
                showRight=distance>0?YES:NO;
                [self switchShowViewContrller:currentVC
                           fromViewController:_willShowCTR
                                     duration:time
                                    showRight:showRight];
            }
             _willShowCTR=nil;
        }
        
        
    }
    
    
}
@end
