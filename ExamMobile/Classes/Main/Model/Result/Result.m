//
//  Result.m
//  LoginDemo
//
//  Created by lmj on 15-9-25.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "Result.h"

@implementation Result
- (id)initWithStateCode:(int)stateCode content:(id)content message:(NSString *)message{
    _stateCode = stateCode;
    _message = message;
    _content = content;
    return self;
    
    
}
@end
