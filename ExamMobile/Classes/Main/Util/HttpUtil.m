//
//  HttpUtil.m
//  LoginDemo
//
//  Created by lmj on 15-9-25.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "HttpUtil.h"

@implementation HttpUtil

+(void)doPostWithBaseUrl:(NSString *)baseUrl params:(NSDictionary *)params callback:(void (^)(BOOL, Result *))callback{
    
//    NSArray *actions =[NSArray arrayWithObjects:@"login",@"regist", nil];
    //查找对应的方法
    NSString *actionPath = [params objectForKey:@"action_path"];
    
    //真是网络数据请求
    NSURL *url = [NSURL URLWithString:baseUrl];
    
    AFHTTPClient *httpClient =[[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient postPath:actionPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Result *result;
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLog(@"responseStr---%@",responseStr);
        if (responseStr) {
            NSDictionary *map = [responseStr objectFromJSONString];
            result = [[Result alloc] init];
            result.content = [map objectForKey:@"content"];
            result.stateCode = [[map objectForKey:@"stateCode"] intValue];
            result.message = [map objectForKey:@"message"];
            callback(YES,result);
            
        }
        else{
            callback(NO,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(NO,nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }];
    
}

@end
