//
//  CourseVideoSortViewController.m
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "CourseVideoSortViewController.h"
#import "DropSortMenuView.h"
#import "CoursesObject.h"
#import "JSON.h"
@interface CourseVideoSortViewController ()
{

    UILabel *lable;
    NSArray *oldShowCategorys;
    BOOL showCategorysChanged;
    UIScrollView *_scrollView;
}

@property(nonatomic,strong)DropSortMenuView *sortMenuView;
@property(nonatomic,strong)DropSortMenuView *hideMenuView;
@end
@implementation CourseVideoSortViewController

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
    if([Common isIOS7])
    {
        self.automaticallyAdjustsScrollViewInsets=NO;
        [self.navigationController.navigationBar setBarTintColor:[Common translateHexStringToColor:k_NavBarBGColor]];
    }
    else
    {
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    //navbar
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 54, 44)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"icon_back_w.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back=[[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=back;
    
    
    self.title=@"编辑分类";
    [self changeNavBarTitleColor];
    [self.view setBackgroundColor:[Common translateHexStringToColor:@"#f5f5f5"]];
    
    //显示分类编辑
    self.sortMenuView=[[DropSortMenuView alloc] initWithFrame:CGRectMake(0, self.viewBounds.origin.y+20, self.view.bounds.size.width, 200)];
    [self.sortMenuView setBackgroundColor:[UIColor clearColor]];
    self.sortMenuView.itemBtnBgColor=[UIColor whiteColor];
    self.sortMenuView.itemBtnDisEnableBgColor=[UIColor lightGrayColor];
    self.sortMenuView.itemBtnTitleColor=[UIColor darkGrayColor];
    NSMutableArray *menus=[[NSMutableArray alloc] init];
    for (CoursesObject *cateObj in [CoursesObject share].categorysShow) {
        DropItemObjcet *item=[[DropItemObjcet alloc] init];
        
        item.title=[NSString stringWithFormat:@"%@",cateObj.CourseName];
        item.index=cateObj.CourseID;
        [menus addObject:item];
    }
    self.sortMenuView.itemArray=menus;
    
    [self.sortMenuView initItemsWithCanSort:YES];
    
    [self.view addSubview:self.sortMenuView];
    
    
    //说明文字
    lable=[[UILabel alloc] initWithFrame:CGRectMake(0, self.sortMenuView.frame.origin.y+self.sortMenuView.frame.size.height+20, self.view.bounds.size.width, 40)];
    [lable setText:@"点击添加，拖动排序"];
    [lable setTextAlignment:NSTextAlignmentCenter];
    [lable setFont:[UIFont systemFontOfSize:13]];
    [lable setTextColor:[UIColor darkGrayColor]];
    [lable setBackgroundColor:[Common translateHexStringToColor:@"#f0f0f0"]];
    [self.view addSubview:lable];
    
    // 1.创建UIScrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, lable.frame.origin.y+lable.frame.size.height+20, self.view.bounds.size.width, self.view.bounds.size.height);
    // frame中的size指UIScrollView的可视范围
    //    scrollView.backgroundColor = [UIColor redColor];
    scrollView.contentSize =CGSizeMake(self.view.bounds.size.width, 20000);
    // scrollView.contentInset = UIEdgeInsetsMake(0, 500, 200, 200);
    _scrollView = scrollView;
    [self.view addSubview:_scrollView];
    //隐藏的分类
    
    self.hideMenuView=[[DropSortMenuView alloc] initWithFrame:CGRectMake(0,lable.frame.size.height+20, self.view.bounds.size.width, 200)];
    [self.hideMenuView setBackgroundColor:[UIColor clearColor]];
    self.hideMenuView.itemBtnBgColor=[UIColor whiteColor];
    self.hideMenuView.itemBtnDisEnableBgColor=[UIColor lightGrayColor];
    self.hideMenuView.itemBtnTitleColor=[UIColor darkGrayColor];
    self.hideMenuView.allowEmpty=YES;
    
    NSMutableArray *menus2=[[NSMutableArray alloc] init];
    for (CoursesObject *cateObj in [CoursesObject share].categoryHide) {
        DropItemObjcet *item=[[DropItemObjcet alloc] init];
        item.title=[NSString stringWithFormat:@"%@",cateObj.CourseName];
        item.index=cateObj.CourseID;
        [menus2 addObject:item];
    }
    self.hideMenuView.itemArray=menus2;
    
    [self.hideMenuView initItemsWithCanSort:NO];
    [self.view addSubview:self.hideMenuView];
    
    __weak CourseVideoSortViewController *weakself=self;
    
    self.sortMenuView.itemClick=^(DropItemObjcet *item){
        [weakself.hideMenuView addItem:item];
        [weakself layout];
        [weakself updateCategory];
    };
    self.sortMenuView.itemSorted=^(){
        [weakself updateCategory];
    };
    self.hideMenuView.itemClick=^(DropItemObjcet *item){
        [weakself.sortMenuView addItem:item];
        [weakself layout];
        [weakself updateCategory];
    };

    // [_scrollView addSubview:_sortMenuView];
    [_scrollView addSubview:_hideMenuView];
    
    
    
    
    
}
//uiscroll
//告诉scrollview要缩放的是哪个子控件
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
   // NSLog(@"scroll1--");
    return _hideMenuView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
   // NSLog(@"scroll2--");
    
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
//    NSLog(@"scroll3--");
}

-(void)viewDidAppear:(BOOL)animated
{
    oldShowCategorys=[NSArray arrayWithArray:[CoursesObject share].categorysShow];
    [super viewDidAppear:animated];
}
-(void)goBack
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(courseVideocategorySortGoBack:)]) {
        [self.delegate courseVideocategorySortGoBack:showCategorysChanged];
    }
}
//更新显示和隐藏的分类
-(void)updateCategory
{
    NSMutableArray *showCategoryTmp=[[NSMutableArray alloc] init];
    NSMutableArray *IDArr=[[NSMutableArray alloc] init];
    showCategorysChanged=NO;
    int i=0;
    int count=oldShowCategorys.count;
    for (DropItemObjcet *item in self.sortMenuView.itemArray) {
        NSPredicate *filter=[NSPredicate predicateWithFormat:@"CourseID=%d",item.index];
        [showCategoryTmp addObjectsFromArray:[[CoursesObject share].categorys filteredArrayUsingPredicate:filter]];
        [IDArr addObject:[NSNumber numberWithInt:item.index]];
        if (!showCategorysChanged) {
            
            if (count<(i+1)) {
                showCategorysChanged=YES;
            }
            else
            {
                CoursesObject *obj=[oldShowCategorys objectAtIndex:i];
                if (obj.CourseID!=item.index) {
                    showCategorysChanged=YES;
                }
            }
        }
        
        i++;
    }
    if (count>i) {
        showCategorysChanged=YES;
    }
    
    [CoursesObject share].categorysShow=[NSArray arrayWithArray:showCategoryTmp];
    [Common writeString:[IDArr JSONRepresentation] toPath:Course_k_categoryShowPath];
    
}
-(void)layout
{
    lable.frame=CGRectMake(0, self.sortMenuView.frame.origin.y+self.sortMenuView.frame.size.height+20, self.view.bounds.size.width, 40);
    _scrollView.frame = CGRectMake(0, lable.frame.origin.y+lable.frame.size.height+20, self.view.bounds.size.width, self.view.bounds.size.height);
    self.hideMenuView.frame=CGRectMake(0, _scrollView.frame.origin.y-lable.frame.origin.y-lable.frame.size.height-20, self.view.bounds.size.width, self.hideMenuView.frame.size.height);
    // scrollView.frame.origin.y-lable.frame.origin.y-lable.frame.size.height-20
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
