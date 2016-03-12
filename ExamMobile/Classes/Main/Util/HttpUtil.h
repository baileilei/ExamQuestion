//
//  HttpUtil.h
//  LoginDemo
//  HTTP远程访问的工具类
//  Created by lmj on 15-9-25.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Result.h"
@interface HttpUtil : NSObject

+ (void)doPostWithBaseUrl:(NSString *)baseUrl params:(NSDictionary *)params callback:(void (^)(BOOL isSuccessed,Result *result))callback;

@end
