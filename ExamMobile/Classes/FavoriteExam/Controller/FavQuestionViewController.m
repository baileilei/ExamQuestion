//
//  FavQuestionViewController.m
//  QuestionDemo3
//
//  Created by lmj on 15-10-8.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "FavQuestionViewController.h"
#import "AFNetworking.h"

#import "SVProgressHUD.h"

#import "ProblemPaperObject.h"
#import "Config.h"
#import "DBManager.h"
#import "SinaShareObject.h"
#import "CMPopTipView.h"
#import "ProblemPaperObject.h"
#import "ProblemsLibObject.h"
#import "MBProgressHUD.h"
#import "Toast+UIView.h"
@interface FavQuestionViewController ()
{
    UIActivityIndicatorView *actView;
    UILabel *loadingLabel;
    
    //完成按钮
    UIButton *commentBtn;
    UIView *loadingView;
    UIToolbar *toolBar;
    UIButton *favBtn;
    BOOL isFav;
    BOOL isFirstLoad;//解决web黑色
    UISlider* Slide;
    
    //试题展示部分
    MBProgressHUD *_hudProgress;
    CMPopTipView *_popTipView;
    ProblemsLibObject *_currentQuestion;


    
}

@property(nonatomic,strong)UIWebView *webView;
@end


@implementation FavQuestionViewController

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
	isFirstLoad=YES;
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //
    //webview
    float webViewHeith= self.view.bounds.size.height-k_ToolBarHeight;
    float webViewY=0;
    if (![Common isIOS7]) {
        webViewHeith-=k_navigationBarHeigh;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_detail_bg.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    //这行代码挡住了Slide,slide控件放在它addsub出现之后即可
    self.webView=[[UIWebView alloc] initWithFrame:CGRectMake(0,webViewY,self.view.bounds.size.width,webViewHeith)];
    if ([Common isIOS7]) {
        self.webView.scrollView.contentInset=UIEdgeInsetsMake(20+k_navigationBarHeigh, 0, 0, 0);
        self.webView.scrollView.scrollIndicatorInsets=UIEdgeInsetsMake(20+k_navigationBarHeigh, 0, 0, 0);
    }
    else
    {
        // remove shadow view when drag web view
        for (UIView *subView in [self.webView subviews]) {
            if ([subView isKindOfClass:[UIScrollView class]]) {
                for (UIView *shadowView in [subView subviews]) {
                    if ([shadowView isKindOfClass:[UIImageView class]]) {
                        shadowView.hidden = YES;
                    }
                }
            }
        }
    }
    
    
    //    // 伸缩内容至适应屏幕尺寸
    //    self.webView.scalesPageToFit = YES;
    [self.webView setBackgroundColor:[Common translateHexStringToColor:@"#f5f5f5"]];
    self.webView.delegate=self;
    
    //navbar
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 54, 44)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back=[[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=back;
   
    UIImage *btnBg=[UIImage imageNamed:@"comment_icon.png"];
    btnBg=[btnBg stretchableImageWithLeftCapWidth:10 topCapHeight:5];
    [commentBtn setBackgroundImage:btnBg forState:UIControlStateNormal];
    UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithCustomView:commentBtn];
    self.navigationItem.rightBarButtonItem=right;
    
    //toolbar
    toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, webViewHeith, self.view.bounds.size.width, k_ToolBarHeight)];
    [toolBar setBackgroundImage:[UIImage imageNamed:@"toolbar_bg.png"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [toolBar setTintColor:[UIColor darkGrayColor]];
    [self.view addSubview:toolBar];
    
    
    
    
    //加载显示
    loadingView=[[UIView alloc] initWithFrame:self.webView.frame];
    [loadingView setBackgroundColor:[Common translateHexStringToColor:@"#f5f5f5"]];
    actView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    actView.center=self.webView.center;
    loadingLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.webView.bounds.size.width, 30)];
    loadingLabel.center=CGPointMake(self.webView.center.x, self.webView.center.y+30);
    [loadingLabel setTextColor:[UIColor lightGrayColor]];
    [loadingLabel setFont:[UIFont systemFontOfSize:12]];
    [loadingLabel setTextAlignment:NSTextAlignmentCenter];
    [loadingLabel setBackgroundColor:[UIColor clearColor]];
    [loadingView addSubview:actView];
    [loadingView addSubview:loadingLabel];
    //加载试题
    self.title = _currentQuestion.PaperName;
     //    [self vSlide];
    // NSLog(@"videDid--slide");
//    ProblemsLibObject *pro = [[ProblemsLibObject alloc] init];
//    [self setProObj:pro];
    //    [self initAPPSetting];
    
}
-(void)goBack
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(FavquestionViewControllerBack:)]) {
        [self.delegate FavquestionViewControllerBack:self];
        
    }
}

-(void)reset
{
    self.isFromAuthorHome=NO;
    [self.webView loadHTMLString:@"" baseURL:nil];
    [self.webView removeFromSuperview];
    
}
-(void)startLoading
{
    
    [self.view addSubview:self.webView];
    [self.view addSubview:loadingView];
    [actView startAnimating];
    [loadingLabel setText:@"正在加载..."];
    [self.view bringSubviewToFront:toolBar];
    
}
-(void)endLoading
{
    
    [actView stopAnimating];
    [loadingView removeFromSuperview];
    
    
}
-(void)setTabBarItems
{
    //是否已收藏 右1
    isFav=[[DBManager share] postIsInFavorites:[_currentQuestion.ProblemsLibID stringValue]];
//    NSLog(@"setTabBarItems---isFav--%hhd",isFav);
//     NSLog(@"[_currentQuestion.ProblemsLibID stringValue]--%@",[_currentQuestion.ProblemsLibID stringValue]);
    NSString *favBtnBg=isFav?@"icon_star_full.png":@"icon_star.png";
    favBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 44)];
    [favBtn setBackgroundImage:[UIImage imageNamed:favBtnBg] forState:UIControlStateNormal];
    [favBtn addTarget:self action:@selector(handleFav) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *favItem=[[UIBarButtonItem alloc] initWithCustomView:favBtn];
    
    
    
    //答案
    UIButton *topBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [topBtn setFrame:CGRectMake(0, 0, 54, 30)];
    [topBtn setBackgroundImage:[UIImage imageNamed:@"btn_answer.png"] forState:UIControlStateNormal];
    [topBtn addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *topItem=[[UIBarButtonItem alloc] initWithCustomView:topBtn];
    
    //blank
    UIBarButtonItem *blank=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:topItem,blank,blank,blank,favItem, nil]];
}

-(void)handleFav
{
    if (isFav) {
       // NSLog(@"ProblemsLibID%@");
        if([[DBManager share] delPostFromFavorites:[_currentQuestion.ProblemsLibID stringValue]])
        {
            isFav=!isFav;
            [SVProgressHUD showSuccessWithStatus:@"取消收藏"];
            NSString *favBtnBg=isFav?@"icon_star_full.png":@"icon_star.png";
            [favBtn setBackgroundImage:[UIImage imageNamed:favBtnBg] forState:UIControlStateNormal];
        }
    }
    else
    {
        if ([[DBManager share] insertPostToFavorites:_currentQuestion]) {
            isFav=!isFav;
            [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
            NSString *favBtnBg=isFav?@"icon_star_full.png":@"icon_star.png";
            [favBtn setBackgroundImage:[UIImage imageNamed:favBtnBg] forState:UIControlStateNormal];
        }
    }
    [SVProgressHUD showSuccessWithStatus:@"收藏成功"];

}
-(void)setProObj:(ProblemsLibObject *)ppoObj
{
    
    [self startLoading];
   // NSData *ProblemDesData = [ppoObj.ProblemDes dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *str = [[NSString alloc] initWithFormat:ppoObj.ProblemDes];
//   // NSString *asciiString = [[NSString alloc] initWithData:ppoObj.ProblemDes encoding:NSUTF16BigEndianStringEncoding];
//    NSLog(@"str---%@",str);
    [self displayQuestionView:ppoObj];
    
    [self setTabBarItems];
    
    
    
}
// 显示问题视图
- (void)displayQuestionView:(ProblemsLibObject *)question {
//    question.ProblemName = [[NSString alloc] initWithData:(NSData *)question.ProblemName encoding:NSUTF16BigEndianStringEncoding];
//     question.ProblemDes = [[NSString alloc] initWithData:(NSData *)question.ProblemDes encoding:NSUTF16BigEndianStringEncoding];
    
    _currentQuestion = question;
  //  _currentQuestion.ProblemName=[question.ProblemName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    _currentQuestion.ProblemName =[NSString stringWithFormat:@"%d:%@",_lastOrder+1,_currentQuestion.ProblemName];
    //_currentQuestion.ProblemName =question.ProblemName;
//    NSData *ProblemNameData = (NSData *)_currentQuestion.ProblemName;

//    NSString *asciiProblemName = [[NSString alloc] initWithData:ProblemNameData encoding:NSUTF16BigEndianStringEncoding];
//    NSLog(@"asciiProblemName----%@",asciiProblemName);
   [self.webView loadHTMLString:_currentQuestion.ProblemName baseURL:nil];
    if (!isFirstLoad) {
        [self endLoading];
    }
}
// 答案解析，弹出气泡提示
- (void)showTip:(UIView *)view  problemsLib:(ProblemsLibObject *)problemLib{
    _currentQuestion =problemLib;
    //    if (_popTipView) {
    //        [_popTipView presentPointingAtView:view inView:self.view animated:YES];
    //        NSLog(@"_popTipView");
    //        return;
    //    }
    //_currentQuestion =problemLib;
    UIView *vTip = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 55)];
    UIImageView *ivClose = [[UIImageView alloc] initWithFrame:CGRectMake(262, 0, 18, 18)];
    UILabel *lblAnswer = [[UILabel alloc] initWithFrame:CGRectMake(10, 22, 260, 20)];
    UIImageView *ivLine = [[UIImageView alloc] initWithFrame:CGRectMake(5, 48, 270, 1)];
    UIWebView *tvTip = [[UIWebView alloc] initWithFrame:CGRectMake(5, 55, 270, 80)];
    vTip.backgroundColor = [UIColor clearColor];
    lblAnswer.backgroundColor = [UIColor clearColor];
    tvTip.backgroundColor = [UIColor clearColor];
    ivClose.image = [UIImage imageNamed:@"ic_close"];
    ivLine.image = [UIImage imageNamed:@"line1"];
    //   tvTip.editable = NO;
    
    [vTip addSubview:ivClose];
    [vTip addSubview:lblAnswer];
    [vTip addSubview:ivLine];
    [vTip addSubview:tvTip];
    
    lblAnswer.text = [NSString stringWithFormat:@"正确答案：%@", _currentQuestion.ProblemAnswer];
    [tvTip loadHTMLString:_currentQuestion.ProblemDes baseURL:nil];
    // tvTip.text = _currentQuestion.ProblemDes;
    // NSLog(@"_currentQuestion---%@",_currentQuestion.ProblemDes);
    
    CGSize tipContent = [tvTip sizeThatFits:CGSizeZero];
    tvTip.frame = CGRectMake(tvTip.frame.origin.x, tvTip.frame.origin.y, tvTip.frame.size.width, tipContent.height);
    vTip.frame = CGRectMake(vTip.frame.origin.x, vTip.frame.origin.y, vTip.frame.size.width, vTip.frame.size.height + tipContent.height);
    _popTipView = [[CMPopTipView alloc] initWithCustomView:vTip];
    _popTipView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [_popTipView presentPointingAtView:view inView:self.view animated:YES];
}


// 关闭答案解析
- (void)closeTip {
    if (!_popTipView.hidden) {
        [_popTipView dismissAnimated:YES];
        _popTipView = nil;
    }
}

- (void)onButtonClicked:(UIButton *)sender {
    
    
    [self showTip:sender problemsLib:_currentQuestion];


}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -
#pragma scrollview delegate
//这个方法控制Url是否有Http://前缀如果有的话不能显示这个url
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //    if ([[request.URL absoluteString] hasPrefix:@"http://"]) {
    //        return NO;
    //    }
    return YES;}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    if (isFirstLoad) {
        [self endLoading];
        isFirstLoad=NO;
    }
    //    //获得当前网页的标题
    //    
    //    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
}
@end
