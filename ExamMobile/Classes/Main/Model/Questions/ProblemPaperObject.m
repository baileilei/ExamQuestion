//
//  ProblemPaperObject.m
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "ProblemPaperObject.h"

@implementation ProblemPaperObject
//需要修改
-(id)initWithJson:(NSDictionary *)json;
{
    self = [super init];
    if(self)
    {
        if(json != nil)
        {
            self.PpID  = [json objectForKey:@"PpID"];
            self.PrkID  = [json objectForKey:@"PrkID"];
            self.PtID  = [json objectForKey:@"PtID"];
            self.Name  = [json objectForKey:@"Name"];
            self.UpdateTime  = [json objectForKey:@"UpdateTime"];
            self.PpDesc  = [json objectForKey:@"PpDesc"];
            self.ProblemNum  = [json objectForKey:@"ProblemNum"];
            self.CategoryURL  = [json objectForKey:@"CategoryURL"];
            self.Header  = [json objectForKey:@"Header"];
            self.ProblemName = [json objectForKey:@"ProblemName"];
         
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
        ProblemPaperObject *postObj=[[ProblemPaperObject alloc] initWithJson:dic];
        [objArr addObject:postObj];
        // NSLog(@"%@");
        postObj=nil;
    }
    NSArray *result=[NSArray arrayWithArray:objArr];
    //  NSLog(@"PostObject-initArrayWithJson-%@",result);
    return result;
}
@end
