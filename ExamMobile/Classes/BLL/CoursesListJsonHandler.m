//
//  CoursesListJsonHandler.m
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "CoursesListJsonHandler.h"
#import "AFNetworking.h"
#import "CoursesObject.h"
#import "SVProgressHUD.h"
@implementation CoursesListJsonHandler
-(void)handlerCategoryObject:(CoursesObject *)catObj currentPageIndex:(int)currentPageIndex pageSize:(int)pageSize;
{
    NSString *url=@"http://www.dota2ms.com/Service.asmx/CourseVideoSelect?CourseID={COURSEID}&CurrentPageIndex={PAGEINDEX}&PageSize={PAGESIZE}";
    url=[url stringByReplacingOccurrencesOfString:@"{COURSEID}" withString:[NSString stringWithFormat:@"%d",catObj.CourseID]];
    url=[url stringByReplacingOccurrencesOfString:@"{PAGEINDEX}" withString:[NSString stringWithFormat:@"%d",currentPageIndex]];
    url=[url stringByReplacingOccurrencesOfString:@"{PAGESIZE}" withString:[NSString stringWithFormat:@"%d",pageSize]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0f];
    AFHTTPRequestOperation *operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
    // NSLog(@"CoursesListJsonHandler--PostListJsonhandler---");
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
       
        if (self.delegate) {
            [self.delegate PostListJsonhandler:self withResult:html];
           
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self initFailure];
    }];
    [operation start];
}
-(void)searchListWithVideoName:(int)courseID videoName:(NSString *)videoName searchPageIndex:(int)searchPageIndex pageSize:(int)pageSize
{
    [SVProgressHUD showWithStatus:@"搜索数据..."];
    videoName=[videoName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url=@"http://www.dota2ms.com/Service.asmx/ConditionCourseVideoSelect?CourseID={COURSEID}&VideoName={VIDEONAME}&CurrentPageIndex={PAGEINDEX}&PageSize={PAGESIZE}";
    url=[url stringByReplacingOccurrencesOfString:@"{COURSEID}" withString:[NSString stringWithFormat:@"%d",courseID]];
    url=[url stringByReplacingOccurrencesOfString:@"{VIDEONAME}" withString:videoName];
    url=[url stringByReplacingOccurrencesOfString:@"{PAGEINDEX}" withString:[NSString stringWithFormat:@"%d",searchPageIndex]];
    url=[url stringByReplacingOccurrencesOfString:@"{PAGESIZE}" withString:[NSString stringWithFormat:@"%d",pageSize]];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //  NSLog(@"searchListWithKey---%@",[responseObject JSONValue]);
        if (self.delegate) {
            [self.delegate PostListJsonhandler:self withResult:responseObject];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[loadingLabel setText:@"加载失败"];
        [SVProgressHUD showErrorWithStatus:@"搜索失败"];
    }];
    [operation start];
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
@end
