//
//  ProblemCategoryObject.m
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "ProblemCategoryObject.h"
#import "Common.h"
#import "Config.h"
@implementation ProblemCategoryObject
+(ProblemCategoryObject *)share
{
    static ProblemCategoryObject * _ProblemPaperKindObject_Share=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _ProblemPaperKindObject_Share=[[ProblemCategoryObject alloc] init];
    });
    return _ProblemPaperKindObject_Share;
}
-(void)videoWithDict:(NSArray *)dict
{
    //分类中分类!
    
    
    NSMutableArray *categorysTemp=[[NSMutableArray alloc] init];
    for (NSDictionary *dic in dict) {
        ProblemCategoryObject *video = [[ProblemCategoryObject alloc] init];
        video.PRKID = [dic[@"PRKID"] intValue];
        video.ParentID = [dic[@"ParentID"] intValue];
        video.Name = dic[@"Name"];

        //    NSLog(@"%@",[dic objectForKey:@"categoryName"]);
        
    }
    self.categorys=[NSArray arrayWithArray:categorysTemp];
    //显示的分类
    NSArray *categoryShowArr=[[Common readLocalString:k_categoryShowPath secondPath:k_categoryShowPath2] JSONValue];
    //


    NSMutableArray *showTempArr=[[NSMutableArray alloc] init];
    for (int i=0; i<categoryShowArr.count; i++) {
        NSPredicate *filter=[NSPredicate predicateWithFormat:@"categoryID=%@",[categoryShowArr objectAtIndex:i]];
        [showTempArr addObjectsFromArray:[self.categorys filteredArrayUsingPredicate:filter]];
    }
    self.categorysShow=[NSArray arrayWithArray:showTempArr];
    NSPredicate *filter2=[NSPredicate predicateWithFormat:@" NOT (categoryID  in %@)",categoryShowArr];
    self.categoryHide=[self.categorys filteredArrayUsingPredicate:filter2];

    
    //    [video setValuesForKeysWithDictionary:dict]; // KVC方法使用前提: 字典中的所有key 都能在 模型属性 中找到
    
}
-(void)initWithJson:(NSDictionary *)dict
{
    [self videoWithDict:dict];
}
@end
