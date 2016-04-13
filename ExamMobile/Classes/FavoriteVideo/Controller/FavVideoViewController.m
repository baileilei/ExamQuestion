//
//  FavPostViewController.m
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "FavVideoViewController.h"
#import "CourseListViewController.h"
#import "DBManager.h"
#import "lmjMoviePlayerViewController.h"
#import "CourseVideoCell.h"
@interface FavVideoViewController ()
{
    UILabel *messageLable;
    BOOL isFav;
     NSMutableArray *readPostIDArr;
}
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *listData;
@end

@implementation FavVideoViewController

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
    readPostIDArr = [[NSMutableArray alloc] init];
    float tableViewHeith=self.view.bounds.size.height;
    if([Common isIOS7])
    {
        self.automaticallyAdjustsScrollViewInsets=YES;
        [self.navigationController.navigationBar setBarTintColor:[Common translateHexStringToColor:k_NavBarBGColor]];
    }
    else
    {
        tableViewHeith-=k_navigationBarHeigh;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title=@"播放记录";
    [self changeNavBarTitleColor];
      
    self.tableView=({
        UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,tableViewHeith) style:UITableViewStylePlain];
        tableView.delegate=self;
        tableView.dataSource=self;
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [tableView setBackgroundColor:[Common translateHexStringToColor:@"#f0f0f0"]];
        tableView.allowsSelectionDuringEditing = YES;
        [self.view addSubview:tableView];
        tableView;
    });
}

-(void)selectFavPosts
{
    //改
    self.listData=[NSMutableArray arrayWithArray:[[DBManager share] selectVideo]];
    if (self.listData.count==0 && messageLable==nil) {
        [self initMessageLable];
    }
    else
    {
        if (messageLable) {
            [messageLable removeFromSuperview];
        }
    }
    [self.tableView reloadData];
}
-(void)initMessageLable;
{
    messageLable=[[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 100)];
    messageLable.center=CGPointMake(self.view.center.x, messageLable.center.y);
    [messageLable setTextAlignment:NSTextAlignmentCenter];
    [messageLable setText:@"没有播放视频"];
    [messageLable setBackgroundColor:[UIColor clearColor]];
    [messageLable setFont:[UIFont systemFontOfSize:13]];
    [messageLable setTextColor:[UIColor darkGrayColor]];
    [self.view addSubview:messageLable];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self selectFavPosts];
    
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return k_VideoListDetailCell_Height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    
    return self.listData.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    CourseVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[CourseVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UIView *bg = [[UIView alloc] initWithFrame:cell.frame];
        bg.backgroundColor = [Common translateHexStringToColor:@"#f0f0f0"];
        cell.backgroundView = bg;
        cell.delegate=self;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

        
        
        
    }
    
    CoursesVideoObject *postObj=nil;
    cell.tag =indexPath.row;
    postObj = [self.listData objectAtIndex:indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.video=postObj;
    
    return cell;

}
-(void)courseListCancelFocus:(int)index
{
    CoursesVideoObject *obj=[self.listData objectAtIndex:index];
   
    [[DBManager share] delVideo:[NSString stringWithFormat:@"%@",obj.VideoID]];
    [self.listData removeObjectAtIndex:index];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:index inSection:0], nil] withRowAnimation:UITableViewRowAnimationLeft];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([indexPath row]==self.listData.count)
    {
        return;
        
    }
    //从普通页面到内容页面-------25号完善
    CoursesVideoObject *courseObj=[self.listData objectAtIndex:indexPath.row];
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(courseListViewController:selectedPostObject:)]) {
        
        [self.delegate favPostView:self  selectedPostObject:courseObj];
    }
    
   
}

@end
