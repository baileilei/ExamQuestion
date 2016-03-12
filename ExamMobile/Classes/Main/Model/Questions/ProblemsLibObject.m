//
//  ProblemsLibObject.m
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "ProblemsLibObject.h"

@implementation ProblemsLibObject
//需要修改
-(id)initWithJson:(NSDictionary *)json;
{
    self = [super init];
    if(self)
    {
        if(json != nil)
        {
            self.ProblemsLibID  = [json objectForKey:@"ProblemsLibID"];
            self.ProblemPaperID  = [json objectForKey:@"ProblemspaperID"];
            self.CourseID  = [json objectForKey:@"CourseID"];
            self.TypeID  = [json objectForKey:@"TypeID"];
            self.QuestionNumber  = [json objectForKey:@"QuestionNumber"];
            self.ProblemDes  = [json objectForKey:@"ProblemDes"];
            self.ProblemName = [json objectForKey:@"ProblemName"];
            self.PaperName = [json objectForKey:@"PaperName"];
            self.ProblemAnswer =[json objectForKey:@"ProblemAnswer"];
            //NSLog(@"---ProblemName---%@",self.ProblemName);
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
        ProblemsLibObject *postObj=[[ProblemsLibObject alloc] initWithJson:dic];
        [objArr addObject:postObj];
        //   NSLog(@"---ProblemName---%@",postObj.ProblemName);
        // NSLog(@"%@");
        postObj=nil;
    }
    NSArray *result=[NSArray arrayWithArray:objArr];
    //  NSLog(@"PostObject-initArrayWithJson-%@",result);
    return result;
}


@end
