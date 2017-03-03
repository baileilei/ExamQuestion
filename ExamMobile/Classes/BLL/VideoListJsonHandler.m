//
//  VideoListJsonHandler.m
//  UISearchBarDemo
//
//  Created by lmj on 15-9-27.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "VideoListJsonHandler.h"
#import "AFNetworking.h"
#import "CoursesVideoObject.h"
#import "SVProgressHUD.h"
@implementation VideoListJsonHandler
- (void)handlerVideoObject:(CoursesVideoObject *)cvObj currentPageIndex:(int)currentPageIndex pageSize:(int)pageSize
{
    //NSLog(@"handlerVideoObject--");
    NSString *url=@"http://www.ltydkb.com/Service.asmx/AllCourseVideoSelect?CurrentPageIndex={PAGEINDEX}&PageSize={PAGESIZE}";
    url=[url stringByReplacingOccurrencesOfString:@"{PAGEINDEX}" withString:[NSString stringWithFormat:@"%d",currentPageIndex]];
    url=[url stringByReplacingOccurrencesOfString:@"{PAGESIZE}" withString:[NSString stringWithFormat:@"%d",pageSize]];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"responseObject---%@",[responseObject JSONValue]);
        if (self.delegate) {
            [self.delegate VideoListJsonhandler:self withResult:responseObject];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[loadingLabel setText:@"加载失败"];
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
    [operation start];
}
-(void)searchListWithVideoName:(NSString *)VideoName searchPageIndex:(int)searchPageIndex pageSize:(int)pageSize
{
    [SVProgressHUD showWithStatus:@"搜索数据..."];
    VideoName=[VideoName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url=@"http://www.ltydkb.com/Service.asmx/ConditionCourseVideoSelect?VideoName={VIDEONAME}&CurrentPageIndex={PAGEINDEX}&PageSize={PAGESIZE}";
    url=[url stringByReplacingOccurrencesOfString:@"{VIDEONAME}" withString:VideoName];
    url=[url stringByReplacingOccurrencesOfString:@"{PAGEINDEX}" withString:[NSString stringWithFormat:@"%d",searchPageIndex]];
    url=[url stringByReplacingOccurrencesOfString:@"{PAGESIZE}" withString:[NSString stringWithFormat:@"%d",pageSize]];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
      //  NSLog(@"searchListWithKey---%@",[responseObject JSONValue]);
        if (self.delegate) {
            [self.delegate VideoListJsonhandler:self withResult:responseObject];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[loadingLabel setText:@"加载失败"];
        [SVProgressHUD showErrorWithStatus:@"搜索失败"];
    }];
    [operation start];
}
@end
