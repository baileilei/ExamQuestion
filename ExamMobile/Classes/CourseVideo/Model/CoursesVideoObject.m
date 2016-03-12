//
//  CoursesVideoObject.m
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "CoursesVideoObject.h"

@implementation CoursesVideoObject
//需要修改
-(id)initWithJson:(NSDictionary *)json;
{
    self = [super init];
    if(self)
    {
        if(json != nil)
        {
            self.VideoID  = [json objectForKey:@"VideoID"];
            self.CourseID  = [json objectForKey:@"CourseID"];
            self.VideoName  = [json objectForKey:@"VideoName"];
            self.VideoPath  = [json objectForKey:@"VideoPath"];
            self.VideoImage  = [json objectForKey:@"VideoImage"];
            self.VideoLength  = [json objectForKey:@"VideoLength"];
            
        }
    }
    return self;
}
//需要修改
+(NSArray *)initArrayWithJson:(NSArray *)json
{
    //ListViewCell数据
    NSMutableArray *objArr=[[NSMutableArray alloc] init];
    for (NSDictionary *dic in json) {
        CoursesVideoObject *postObj=[[CoursesVideoObject alloc] initWithJson:dic];
        [objArr addObject:postObj];
        // NSLog(@"%@");
        postObj=nil;
    }
    NSArray *result=[NSArray arrayWithArray:objArr];
    //  NSLog(@"PostObject-initArrayWithJson-%@",result);
    return result;
}
@end
