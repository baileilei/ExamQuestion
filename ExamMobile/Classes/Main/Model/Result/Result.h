//
//  Result.h
//  LoginDemo
//
//  Created by lmj on 15-9-25.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Result : NSObject

@property int stateCode; //状态码
@property (nonatomic,strong) id content; //数据内容
@property (nonatomic,strong) NSString *message; //消息

- (id)initWithStateCode:(int)stateCode content:(id)content message:(NSString *)message;



@end
