//
//  LoadingViewController.m
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "LoadingViewController.h"
#import "Config.h"

#import "SlideFrameViewController.h"





#import "CagtegorySortViewController.h"
#import "ProblemPaperKindObject.h"
#import "CoursesObject.h"
@interface LoadingViewController ()
{
    NSString *downURL;
    BOOL showAlert;
    NSDictionary *loadingDic;
    UIActivityIndicatorView *actView;
}
@end

@implementation LoadingViewController

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
   // NSLog(@"沙盒路径：%@",NSHomeDirectory());
    showAlert=NO;
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    UIImageView *bgImgView=[[UIImageView alloc] initWithFrame:self.view.bounds];
    [bgImgView setImage:[self loadingImage]];
    //启动图片设置内容形式
    [bgImgView setContentMode:UIViewContentModeScaleToFill];
    [self.view addSubview:bgImgView];
    actView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [actView setCenter:self.view.center];
    [self.view addSubview:actView];
    [actView startAnimating];
    
   // [self performSelector:@selector(initAPPSetting) withObject:self afterDelay:0.0];
    
    [self performSelector:@selector(BasicCourseinitAPPSetting) withObject:self afterDelay:0.0];
    [self performSelector:@selector(CategoryCourseinitAPPSetting) withObject:self afterDelay:0.0];
    [self performSelector:@selector(VideoinitAPPSetting) withObject:self afterDelay:0.0];
   

}

- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}
//读取启动图片信息
-(UIImage *)loadingImage
{
    UIImage *img=nil;
    
     if ([Common fileExists:k_LoadingjsonPath])
     {
         
        NSString *loadingStr=[Common readLocalString:k_LoadingjsonPath];
        loadingDic=[loadingStr JSONValue];
        if (loadingDic) {
            NSString *loadingImgName=[NSString stringWithFormat:@"%@.png",[loadingDic objectForKey:@"version"]];
            //NSString *loadingLink=[loadingDic objectForKey:@"link"];
            //NSString *loadingImgUrl=[loadingDic objectForKey:@"img"];
            if ([Common fileExists:[k_LoadingPath stringByAppendingFormat:@"/%@",loadingImgName]]) {
                img=[UIImage imageWithContentsOfFile:[k_LoadingPath stringByAppendingFormat:@"/%@",loadingImgName]];
                return img;
            }
        }
     }
//    NSLog(@"k_defaultLoadingImage--%@",k_defaultLoadingImage);
    img=[UIImage imageNamed:k_defaultLoadingImage];
    return img;
}
-(void)presentToIndex
{
    
    if (showAlert) {
        return;
    }
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {

    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
 
    SlideFrameViewController *frame=[[SlideFrameViewController alloc] init];
    [self presentViewController:frame];


}
- (void)presentViewController:(UIViewController *)aViewController
{
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.75];
    [animation setType: kCATransitionFade];
    [animation setSubtype:kCATransitionFromRight];//从上推入
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.view window].layer addAnimation:animation forKey:kCATransitionFade];
    [self presentViewController:aViewController animated:NO completion:nil];
    
    
}
-(void)initFailure
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                  message:@"初始化数据失败"
                                                 delegate:self
                                        cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
    [alert setTag:3];
    [alert show];
}


//基础题库从网络获取最新应用信息
-(void)BasicCourseinitAPPSetting
{
   
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:k_initUrlBasicCourse] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0f];
    AFHTTPRequestOperation *operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData *data= [html dataUsingEncoding:NSUTF8StringEncoding];
        [[ProblemPaperKindObject share] videoWithDict:[data JSONValue]];
        [self performSelector:@selector(presentToIndex) withObject:self afterDelay:0.0];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self initFailure];
    }];
    [operation start];
}

//分类题库网络获取最新应用信息
-(void)CategoryCourseinitAPPSetting
{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:k_initUrlCategoryCourse] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0f];
    AFHTTPRequestOperation *operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData *data= [html dataUsingEncoding:NSUTF8StringEncoding];              [[ProblemPaperKindObject share] videoWithDict2:[data JSONValue]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self initFailure];
    }];
    [operation start];
}

//视频从网络获取最新应用信息
-(void)VideoinitAPPSetting
{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:k_initUrlVideo] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0f];
    AFHTTPRequestOperation *operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData *data= [html dataUsingEncoding:NSUTF8StringEncoding];
        [[CoursesObject share] videoWithDict2:[data JSONValue]];
       // NSLog(@"testinitAPPSetting3---%@",[responseObject JSONValue]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self initFailure];
    }];
    [operation start];
}

//更新启动图片
-(void)updateLoadingInfo
{
}
//检查应用版本号1.1 大版本号不同强制更新 小版本号不同选择更新
-(void)checkAPPVersion
{
        
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -
#pragma alertView delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1) {
        if (buttonIndex==1) {
            exit(0);
        }
        if (buttonIndex==0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downURL]];
        }
    }
    if (alertView.tag==2)
    {
        if (buttonIndex==0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downURL]];
        }
        else
        {
            showAlert=NO;
            [self presentToIndex];
        }
    }
    if (alertView.tag==3) {
        if (buttonIndex==0) {
             exit(0);
        }
    }
    
}
#pragma sideMenu delegate
- (void)sideMenu:(RESideMenu *)sideMenu didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer
{
    
}
- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    
}
- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    
}
- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    
}
- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    
}
@end
