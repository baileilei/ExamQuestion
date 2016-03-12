//
//  JSON1.m
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//



#import "JSON.h"

@implementation NSString (JSON)
- (id) JSONValue {
    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    if (error)
        NSLog(@"%@", [error description]);
    return obj;
}
@end



@implementation NSData (JSON)
- (id) JSONValue {
    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:&error];
    if (error)
        NSLog(@"%@", [error description]);
    return obj;
}
@end

@implementation NSObject (JSON)
- (NSString *)JSONRepresentation
{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        NSData *data=[NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        if (error)
            NSLog(@"%@", [error description]);
        NSString *result=[[NSString alloc]initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
        return result;
    }
    return @"";
}
@end