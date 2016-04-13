//
//  CourseListViewController.m
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "CourseListViewController.h"
#import "CourseListViewCell.h"
#import "SlideSwitchView.h"
#import "lmjMoviePlayerViewController.h"
#import "CoursesObject.h"
#import "Config.h"
#import "DBManager.h"
#import "SVProgressHUD.h"

@interface CourseListViewController ()
{
    //查找
    UISearchDisplayController *searchDisplay;
    UISearchBar *searchBar;

    
    MJRefreshHeaderView *_header;
    RefreshFooterView *_footer;
    CoursesObject *currentCategory;
    CoursesListJsonHandler *listHandler;
    BOOL noMore;
    BOOL isFav;
    NSMutableArray *readPostIDArr;
    int currentPageIndex;
    int currentPageSize;
    //查找
    int searchPageIndex;
    int searchPageSize;
    BOOL last;
}
@property(nonatomic) int index;
@property(nonatomic,strong) UITableView *listTableView;
@property(nonatomic,strong) NSMutableArray *listData;
@property (nonatomic,strong) NSMutableArray *searchListData;
@property (nonatomic,strong) NSString   *searchText;

@end

@implementation CourseListViewController

-(id)initWithCagtegory:(CoursesObject *)catObj
{
    if (self=[super init]) {
        
        _listData=[[NSMutableArray alloc] init];
        self.searchListData = [[NSMutableArray alloc] init];
        currentCategory=catObj;
        //刷新
        currentPageIndex=1;
        currentPageSize=20;
        //查找
        searchPageIndex = 1;
        searchPageSize = 100;
        
        listHandler=[[CoursesListJsonHandler alloc] init];
        readPostIDArr=[[NSMutableArray alloc] init];
        listHandler.delegate=self;
        noMore=NO;
        last = NO;
        //  NSLog(@"currentCategory---!%d",currentCategory.categoryID);
    }
    return  self;
}



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
    
	[self.view setBackgroundColor:[Common translateHexStringToColor:@"#f0f0f0"]];
    CGRect rect;
    if ([Common isIOS7])
    {
        rect=self.view.bounds;
    }
    else
    {
        rect=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-k_navigationBarHeigh-kHeightOfTopScrollView);
    }
    //读取历史
    NSString *path=[k_DocumentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/Course_cach_%d.txt",currentCategory.CourseID]];
    NSString *history=[Common readLocalString:path];
    if (history.length>0) {
        self.listData=[NSMutableArray arrayWithArray:[CoursesVideoObject initArrayWithJson:[history JSONValue]]];
        //获得所有分类数据
        //   NSLog(@"listData---%@",self.listData);
    }
    
    
    self.listTableView=[[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    [self.listTableView setBackgroundColor:[UIColor clearColor]];
    self.listTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.listTableView.delegate=self;
    self.listTableView.dataSource=self;
    
    [self.view addSubview:self.listTableView];
    if ([Common isIOS7])
    {
        self.listTableView.contentInset=UIEdgeInsetsMake(20+k_navigationBarHeigh+kHeightOfTopScrollView, 0, 0, 0);
        self.listTableView.scrollIndicatorInsets=UIEdgeInsetsMake(20+k_navigationBarHeigh+kHeightOfTopScrollView, 0, 0, 0);
    }
    // 集成下拉刷新控件
    _header = [MJRefreshHeaderView header];
    _header.refreshID=[NSString stringWithFormat:@"list_header_%d",currentCategory.CourseID];
    _header.headerAddToBack=YES; //添加到表格后面
    if ([Common isIOS7])
    {
        _header.scrollViewInsetTop=20+k_navigationBarHeigh+kHeightOfTopScrollView;
    }
    else
    {
        _header.scrollViewInsetTop=0;
    }
    
    _header.scrollView =self.listTableView;
    _header.delegate = self;
    
    
    //集成上拉加载更多控件
    _footer=[RefreshFooterView footerWithWidth:self.listTableView.bounds.size.width];
    _footer.delegate=self;
    //第一次进入刷新
    if (self.listData.count<1) {
        //[_header beginRefreshing];
    }
    searchBar = [[UISearchBar alloc] init];
    [searchBar sizeToFit];
    searchBar.placeholder=@"搜索其他视频";
    //[searchBar setBackgroundImage:[[UIImage alloc] init]];
    [searchBar setTranslucent:YES];
    searchBar.delegate = self;
   // searchBar = [[UISearchBar alloc] initWithFrame: CGRectMake(0, 0, 320, 50)];
    
//    self.listTableView.contentInset = UIEdgeInsetsMake(120, 0, 0, 0);
//    self.listTableView.scrollIndicatorInsets = UIEdgeInsetsMake(120, 0, 0, 0);
    
    self.listTableView.tableHeaderView=searchBar;
    
    searchDisplay = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplay.delegate = self;
    searchDisplay.searchResultsDataSource = self;
    searchDisplay.searchResultsDelegate = self;
   // [self setAutomaticallyAdjustsScrollViewInsets:YES];
   
}
-(void)needRefresh
{
    //如果超过1个小时没刷新，自动刷新
    if (_header.lastUpdateTime) {
        NSDate *date = [NSDate date];
        NSTimeInterval sec = [date timeIntervalSinceNow];
        NSDate *currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
        NSTimeInterval time=[currentDate timeIntervalSinceDate:_header.lastUpdateTime];
        if (time>60*60) {
            [_header beginRefreshing];
        }
    }
    else
    {
        [_header beginRefreshing];
    }
}

- (void)showMenu
{
    [self.sideMenuViewController presentMenuViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -
#pragma private method

#pragma mark - 刷新的代理方法---进入下拉刷新\上拉加载更多都有可能调用这个方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    
    
    //这个方便处理有点难办
    if (refreshView == _header) {
        // 下拉刷新
        listHandler.ID=@"refresh";
        [listHandler handlerCategoryObject:currentCategory currentPageIndex:1 pageSize:currentPageSize];
        
    }
    
    
}
-(void)refreshFooterBegin:(RefreshFooterView *)view
{
    //这个方便处理有点难办
    //加载更多
    listHandler.ID=@"more";
    [listHandler handlerCategoryObject:currentCategory currentPageIndex:currentPageIndex+1 pageSize:currentPageSize];
    
}

- (void)reloadTableView
{
    [self.listTableView reloadData];
    // 结束刷新状态
    [_header endRefreshing];
    _footer.status=FooterRefreshStateNormal;
    
}

-(void)successLoadList
{
    [SVProgressHUD showSuccessWithStatus:@"加载成功"];
    _footer.status=FooterRefreshStateNormal;
    
}

#pragma 获取数据代理
-(void)PostListJsonhandler:(CoursesListJsonHandler *)handler withResult:(NSString *)result
{
    
    NSArray *resultArr=[result JSONValue];
    
    // NSLog(@"resultArr--%@",resultArr);
    if (!resultArr) {
        return;
    }
    if ([handler.ID isEqualToString:@"refresh"]) {
        NSString *path=[k_DocumentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/Course_cach_%d.txt",currentCategory.CourseID]];
        [Common writeString:result toPath:path];
        self.listData=[NSMutableArray arrayWithArray:[CoursesVideoObject initArrayWithJson:resultArr]];
        currentPageIndex=1;
        [self reloadTableView];
        
    }
    if ([handler.ID isEqualToString:@"more"]) {
        NSArray *arr=[CoursesVideoObject initArrayWithJson:resultArr];
        if (arr.count==0) {
            noMore=YES;
        }
        [self.listData addObjectsFromArray:arr];
        currentPageIndex++;
        [self reloadTableView];
        
    }
    if ([handler.ID isEqualToString:@"search"]) {
       //  NSLog(@"search");
        NSArray *arr=[CoursesVideoObject initArrayWithJson:resultArr];
        
        if (arr.count==0) {
            noMore=YES;
        }
       
        [self.searchListData removeAllObjects];
        [self.searchListData addObjectsFromArray:arr];
        // searchPageIndex++;
        // NSLog(@"searchPageIndex---%d",searchPageIndex);
        [self successLoadList];
        [searchDisplay.searchResultsTableView reloadData];
        
    }
    
}
#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row]==self.listData.count) {
        return k_RefreshFooterViewHeight;
    }
    return k_ListViewCell_Height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (tableView==self.listTableView)
        return self.listData.count+1;
    else{
     //    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 50)];
        return self.searchListData.count;
    }
//    if (_footer&&self.listData.count>0) {
//        return self.listData.count+1;
//    }
//    //  NSLog(@"self---%d",self.listData.count);
//    return self.listData.count;
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row]==self.listData.count)
    {
        FooterRefreshState status;
        status=self.listData.count>100?FooterRefreshStateNormal:FooterRefreshStateRefreshing;
        if (noMore) {
            status=FooterRefreshStateDiseable;
        }
        _footer.status=status;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row]==self.listData.count) {
        //底部刷新
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"footer"];
        [_footer setBackgroundColor:[Common translateHexStringToColor:@"#f0f0f0"]];
        [cell.contentView addSubview:_footer];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    static NSString *cellIdentifier = @"Cell";
    CourseListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[CourseListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UIView *bg = [[UIView alloc] initWithFrame:cell.frame];
        bg.backgroundColor = [Common translateHexStringToColor:@"#f0f0f0"];
        cell.backgroundView = bg;
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        
    }
    
//    //根据indexPath.row分类数据变化
//    //   NSLog(@"某分类？%@",[self.listData objectAtIndex:indexPath.row]);
//    CoursesVideoObject *postObj=[self.listData objectAtIndex:indexPath.row];
//    //  NSLog(@"某分类categoryID子？%@",postObj.author);
//    if(currentCategory.CourseID==1&&postObj.VideoImage.length==0)
//    {
//        postObj.VideoImage=[[[NSBundle mainBundle] URLForResource:@"userheader@2x" withExtension:@"png"] absoluteString];
//    }
//    if ([readPostIDArr containsObject:postObj.CourseID]) {
//        postObj.isReaded=YES;
//    }
//    else
//    {
//        postObj.isReaded=NO;
//    }
    CoursesVideoObject *obj=nil;
    if (tableView==self.listTableView)
    {
        obj=[self.listData objectAtIndex:indexPath.row];
    }
    else
    {
        if (last != true) {
            //NSLog(@"123");
            last = YES;
            tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 80)];
        }
        
        obj=[self.searchListData objectAtIndex:indexPath.row];
    }
    if(currentCategory.CourseID==1&&obj.VideoImage.length==0)
    {
        obj.VideoImage=[[[NSBundle mainBundle] URLForResource:@"userheader@2x" withExtension:@"png"] absoluteString];
    }
    if ([readPostIDArr containsObject:obj.CourseID]) {
        obj.isReaded=YES;
    }
    else
    {
        obj.isReaded=NO;
    }
    
    cell.courses=obj;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int index=indexPath.row;
    
    
    if ([indexPath row]==self.listData.count)
    {
        return;
        
    }
    //从普通也到内容页面
    CoursesVideoObject *courseObj = nil;
    if (tableView==self.listTableView) {
        courseObj=[self.listData objectAtIndex:index];
    }
    else
    {
        courseObj=[self.searchListData objectAtIndex:index];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(courseListViewController:selectedPostObject:)]) {
        [self.delegate courseListViewController:self  selectedPostObject:courseObj];
    }
    [readPostIDArr addObject:courseObj.VideoID];
     [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    isFav=[[DBManager share] videoIsInFavorites:[courseObj.VideoID stringValue]];
    //找不到则添加
    if (!isFav) {
        [[DBManager share] insertVideo:courseObj];
    }

    
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    //  NSLog(@"indexPath--%d",indexPath.row);
}
#pragma search bar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar_
{
   // NSLog(@"searchBarSearchButtonClicked");
    listHandler.ID=@"search";
    //    _searchText = [NSString stringWithFormat:searchBar_.text];
    //    NSLog(@"_searchText---%@",_searchText);
    //    NSLog(@"searchBar_----%@",searchBar_.text);
    
    [listHandler searchListWithVideoName:currentCategory.CourseID videoName:searchBar_.text searchPageIndex:searchPageIndex pageSize:searchPageSize];
    
    //    [self searchListWithKey:searchBar_.text];
  //  NSLog(@"currentCategory.CourseID---%d",currentCategory.CourseID);
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self.searchListData removeAllObjects];
}


@end
