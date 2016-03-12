//
//  QuestionListJsonHandler.m
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "QuestionListJsonHandler.h"
#import "AFNetworking.h"
#import "ProblemPaperKindObject.h"
#import "SVProgressHUD.h"

@implementation QuestionListJsonHandler
-(void)handlerCategoryObject:(ProblemPaperKindObject *)catObj currentPageIndex:(int)currentPageIndex pageSize:(int)pageSize;
{
    //NSString *url=catObj.Name;
    self.PRKID = catObj.PRKID;
    NSString *url = @"http://www.dota2ms.com/Service.asmx/ProblemPaperSelect?";
    NSString *k_initUrl3 =[url stringByAppendingFormat:@"PRKID=%d&CurrentPageIndex=%d&PageSize=%d",self.PRKID,currentPageIndex,pageSize];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:k_initUrl3] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0f];
    AFHTTPRequestOperation *operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        
        if (self.delegate) {
            [self.delegate QuestionListJsonhandler:self withResult:html];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self initFailure];
    }];
    [operation start];
}
- (void)searchListWithName:(int)prkID name:(NSString *)name searchPageIndex:(int)searchPageIndex pageSize:(int)pageSize{
    [SVProgressHUD showWithStatus:@"搜索数据..."];
    name=[name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url=@"http://www.dota2ms.com/Service.asmx/ProblemPaperSelect2?PRKID={PRKID}&Name={NAME}&CurrentPageIndex={PAGEINDEX}&PageSize={PAGESIZE}";
    url=[url stringByReplacingOccurrencesOfString:@"{PRKID}" withString:[NSString stringWithFormat:@"%d",prkID]];
    url=[url stringByReplacingOccurrencesOfString:@"{NAME}" withString:name];
    url=[url stringByReplacingOccurrencesOfString:@"{PAGEINDEX}" withString:[NSString stringWithFormat:@"%d",searchPageIndex]];
    url=[url stringByReplacingOccurrencesOfString:@"{PAGESIZE}" withString:[NSString stringWithFormat:@"%d",pageSize]];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //  NSLog(@"searchListWithKey---%@",[responseObject JSONValue]);
        if (self.delegate) {
            [self.delegate QuestionListJsonhandler:self withResult:responseObject];
            
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
