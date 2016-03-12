//
//  CoursesObject.m
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//
#import "CoursesObject.h"
#import "Common.h"
#import "Config.h"
@implementation CoursesObject
+(CoursesObject *)share
{
    static CoursesObject * _ProblemPaperKindObject_Share=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _ProblemPaperKindObject_Share=[[CoursesObject alloc] init];
    });
    return _ProblemPaperKindObject_Share;
}
-(void)videoWithDict2:(NSArray *)dict
{
    //分类中分类!
    
    
    NSMutableArray *categorysTemp=[[NSMutableArray alloc] init];
    for (NSDictionary *dic in dict) {
        CoursesObject *video = [[CoursesObject alloc] init];
        video.CourseID = [dic[@"CourseID"] intValue];
        video.ParentID = [dic[@"ParentID"] intValue];
        video.CourseName = dic[@"CourseName"];
        [categorysTemp addObject:video];
     //   NSLog(@"CourseID---%@",[dic objectForKey:@"CourseID"]);
    
    }
    self.categorys=[NSArray arrayWithArray:categorysTemp];
    //NSLog(@"CoursesObject--%@",self.categorys);

    //显示的分类
    NSArray *categoryShowArr=[[Common readLocalString:Course_k_categoryShowPath secondPath:Course_k_categoryShowPath2] JSONValue];
    //
   //  NSLog(@"categoryShowArr--%d",categoryShowArr.count);
    
    NSMutableArray *showTempArr=[[NSMutableArray alloc] init];
    for (int i=0; i<categoryShowArr.count; i++) {
        NSPredicate *filter=[NSPredicate predicateWithFormat:@"CourseID=%@",[categoryShowArr objectAtIndex:i]];
        [showTempArr addObjectsFromArray:[self.categorys filteredArrayUsingPredicate:filter]];
    }
    self.categorysShow=[NSArray arrayWithArray:showTempArr];
    //  NSLog(@"categorysShow--%@",self.categorysShow);
    NSPredicate *filter2=[NSPredicate predicateWithFormat:@" NOT (CourseID  in %@)",categoryShowArr];
    self.categoryHide=[self.categorys filteredArrayUsingPredicate:filter2];
  //   NSLog(@"indexsCategorys222---%@",self.indexsCategorys);
    
    //    [video setValuesForKeysWithDictionary:dict]; // KVC方法使用前提: 字典中的所有key 都能在 模型属性 中找到
    
}
@end
