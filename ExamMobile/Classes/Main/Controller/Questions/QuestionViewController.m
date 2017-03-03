//
//  QuestionViewController.m
//  QuestionDemo
//
//  Created by lmj on 15-10-5.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "QuestionViewController.h"
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
@interface QuestionViewController ()
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
    NSMutableDictionary *_questionDics;
    int _questionCount;
    int _lastOrder;
    BOOL _isNextQuestion;
    
}

@property(nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong) NSMutableArray *listData;
@end

@implementation QuestionViewController

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
    //
    commentBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn addTarget:self action:@selector(showComment) forControlEvents:UIControlEventTouchUpInside];
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
   
    self.listData = [[NSMutableArray alloc] init];
//    [self vSlide];
    // NSLog(@"videDid--slide");
//    ProblemPaperObject *pro = [[ProblemPaperObject alloc] init];
//    [self setProObj:pro];
//    [self initAPPSetting];

}
-(void)goBack
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(questionViewControllerBack:)]) {
        [self.delegate questionViewControllerBack:self];
        
    }
}
-(void)showComment
{
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(questionViewControllerComment:)]) {
        [self.delegate questionViewControllerComment:self];
        
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
-(void)setComment
{
    
    NSString *comment=[NSString stringWithFormat:@"完成"];
    [commentBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    CGSize size=[comment sizeWithFont:[UIFont systemFontOfSize:12]];
    [commentBtn setFrame:CGRectMake(commentBtn.frame.origin.x, commentBtn.frame.origin.y, size.width+20, 44)];
    [commentBtn setTitle:comment forState:UIControlStateNormal];
    
    
}
-(void)setTabBarItems
{
    //是否已收藏 右1
    isFav=[[DBManager share] postIsInFavorites:[_currentQuestion.ProblemsLibID stringValue]];
    NSString *favBtnBg=isFav?@"icon_star_full.png":@"icon_star.png";
    favBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 44)];
    [favBtn setBackgroundImage:[UIImage imageNamed:favBtnBg] forState:UIControlStateNormal];
    [favBtn addTarget:self action:@selector(handleFav) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *favItem=[[UIBarButtonItem alloc] initWithCustomView:favBtn];
    
    
    //上一题
    UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setFrame:CGRectMake(0, 0, 54, 30)];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"btn_pre.png"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setTag:1];
    UIBarButtonItem *shareItem=[[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    //答案
    UIButton *topBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [topBtn setFrame:CGRectMake(0, 0, 54, 30)];
    [topBtn setBackgroundImage:[UIImage imageNamed:@"btn_answer.png"] forState:UIControlStateNormal];
    [topBtn addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [topBtn setTag:2];
    UIBarButtonItem *topItem=[[UIBarButtonItem alloc] initWithCustomView:topBtn];
    
    //下一题
    UIButton *bottomBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [bottomBtn setFrame:CGRectMake(0, 0, 54, 30)];
    [bottomBtn setBackgroundImage:[UIImage imageNamed:@"btn_next.png"] forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtn setTag:3];
    UIBarButtonItem *bottonItem=[[UIBarButtonItem alloc] initWithCustomView:bottomBtn];
    
    
    
    //blank
    UIBarButtonItem *blank=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:shareItem,blank,topItem,blank,bottonItem,favItem, nil]];
}
-(void)handleFav
{
    if (isFav) {
//         NSLog(@"handleFav--1");
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
  //      NSLog(@"handleFav--2");

        if ([[DBManager share] insertPostToFavorites:_currentQuestion]) {
           //  NSLog(@"handleFav--4");
            isFav=!isFav;
            [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
            NSString *favBtnBg=isFav?@"icon_star_full.png":@"icon_star.png";
            [favBtn setBackgroundImage:[UIImage imageNamed:favBtnBg] forState:UIControlStateNormal];
        }
    }
 //   NSLog(@"handleFav--3");
}
-(void)setProObj:(ProblemPaperObject *)ppoObj
{
    _lastOrder = 0;
    
    [self startLoading];
//    //完成按钮
//    [self setComment];
    
    NSString *url=@"http://www.ltydkb.com/Service.asmx/SelectProblemsLib?PPID={PPID}";
    url=[url stringByReplacingOccurrencesOfString:@"{PPID}" withString:[NSString stringWithFormat:@"%@",ppoObj.PpID]];
   
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0f];
    AFHTTPRequestOperation *operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.listData =[NSMutableArray arrayWithArray:[ProblemsLibObject initArrayWithJson:[responseObject JSONValue]]];
        //   NSLog(@"initAPPSetting---%@",[responseObject JSONValue]);
        ProblemsLibObject  *ppo = [self.listData objectAtIndex:_lastOrder];
        
        _questionCount = [self.listData count];
        
        [self displayQuestionView:ppo];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    [operation start];
    
    
}
// 显示问题视图
- (void)displayQuestionView:(ProblemsLibObject *)question {
    [self startLoading];
    _currentQuestion = question;
    _currentQuestion = question;
    int cuurrentNumber = [_currentQuestion.QuestionNumber intValue];
    NSString *currentName = [NSString stringWithFormat:@"%d:%@",cuurrentNumber,_currentQuestion.ProblemName];
//    NSLog(@"_currentQuestion---%@",_currentQuestion.ProblemsLibID);
    //图标
    [self setTabBarItems];
//    _currentQuestion.ProblemName =[NSString stringWithFormat:@"%d:%@",_lastOrder+1,_currentQuestion.ProblemName];
   // _currentQuestion.ProblemName =_currentQuestion.ProblemName;
  //  NSLog(@"ProblemName---%@",_currentQuestion.ProblemName);
    
    [self.webView loadHTMLString:currentName baseURL:nil];
    if (!isFirstLoad) {
        [self endLoading];
    }
}
// 显示上一问题
- (void)preQuestion {
    // [self commitAnswer];
    [self closeTip];
    if (_lastOrder < 0) {
        [self.view makeToast:@"前面没题目啦~~~"];
        _lastOrder = 0;
    } else {
        ProblemsLibObject *question = [self.listData objectAtIndex:_lastOrder];
        if (question) {
            [self displayQuestionView:question];
        } else {
            _isNextQuestion = NO;
            [_hudProgress show:YES];
            //       [_dataHelper getQuestionsAfterOrder:_lastOrder chapterId:_chapter.ID userId:_userId questionType:_questionTypeId pageSize:_pageSize isError:_isErrorShow];
        }
    }
}

// 显示下一问题
- (void)nextQuestion {
    // [self commitAnswer];
    [self closeTip];
    if (_lastOrder > _questionCount - 1) {
        [self.view makeToast:@"这已经是最后一题啦！"];
        _lastOrder = _questionCount;
    } else {
        //        ProblemsLibObject  *ppo = [self.listData objectAtIndex:0];
        //        NSLog(@"ProblemsLibObject---%@",ppo.ProblemName);
        
        // [self.webview loadHTMLString:ppo.ProblemName baseURL:nil];
        ProblemsLibObject *question = [self.listData objectAtIndex:_lastOrder];
        // NSLog(@"nextQuestion---%@",question.ProblemName);
        if (question) {
            [self displayQuestionView:question];
        } else {
            _isNextQuestion = YES;
            [_hudProgress show:YES];
            //    [_dataHelper getQuestionsAfterOrder:_lastOrder chapterId:_chapter.ID userId:_userId questionType:_questionTypeId pageSize:_pageSize isError:_isErrorShow];
        }
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

- (void)fillDictionaryWithQuestions:(id)questions {
    if (!_questionDics) {
        _questionDics = [[NSMutableDictionary alloc] init];
    }
    if (questions == [NSNull null]) {
        return;
    }
    BOOL _hasLastOrder = NO;
    for (NSDictionary *questionDic in self.listData) {
        ProblemsLibObject *question = [[ProblemsLibObject alloc ] initWithJson:questionDic];
        [_questionDics setObject:question forKey:question.QuestionNumber];
        //NSLog(@"ProblemsLibObject2----%@",question.ProblemName);
        if (question.QuestionNumber == [NSNumber numberWithInt:_lastOrder]) {
            _hasLastOrder = YES;
        }
    }
    if (_hasLastOrder) {
        if (_isNextQuestion) {
            [self nextQuestion];
        } else {
            [self preQuestion];
        }
    }
}


- (void)onButtonClicked:(UIButton *)sender {
    
    switch (sender.tag) {
        case 1:
            _lastOrder--;
            [self preQuestion];
            break;
        case 2:
            //  NSLog(@"123123");
            [self showTip:sender problemsLib:[self.listData objectAtIndex:_lastOrder]];
            break;
        case 3:
            _lastOrder++;
            [self nextQuestion];
            break;
    }
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
