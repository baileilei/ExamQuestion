//
//  ProblemPaperKindObject.m
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "ProblemPaperKindObject.h"
#import "Common.h"
#import "Config.h"
@implementation ProblemPaperKindObject
+(ProblemPaperKindObject *)share
{
    static ProblemPaperKindObject * _ProblemPaperKindObject_Share=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _ProblemPaperKindObject_Share=[[ProblemPaperKindObject alloc] init];
    });
    return _ProblemPaperKindObject_Share;
}
-(void)videoWithDict:(NSArray *)dict
{
    NSMutableArray *categorysTemp=[[NSMutableArray alloc] init];
     for (NSDictionary *dic in dict) {
      //   NSLog(@"videoWithDict---%@",dic[@"Name"]);
         ProblemPaperKindObject *video = [[ProblemPaperKindObject alloc] init];
         video.PRKID = [dic[@"PRKID"] intValue];
         video.ParentID = [dic[@"ParentID"] intValue];
         video.Name = dic[@"Name"];
         [categorysTemp addObject:video];
     }
   // NSLog(@"1234");
    self.indexsCategorys=[NSArray arrayWithArray:categorysTemp];
    
    //    [video setValuesForKeysWithDictionary:dict]; // KVC方法使用前提: 字典中的所有key 都能在 模型属性 中找到
    
}
-(void)videoWithDict2:(NSArray *)dict
{
    //分类中分类!
    
   // NSLog(@"NSArray--%@",dict);
    NSMutableArray *categorysTemp=[[NSMutableArray alloc] init];
    for (NSDictionary *dic in dict) {
        ProblemPaperKindObject *video = [[ProblemPaperKindObject alloc] init];
        video.PRKID = [dic[@"PRKID"] intValue];
        video.ParentID = [dic[@"ParentID"] intValue];
        video.Name = dic[@"Name"];
         [categorysTemp addObject:video];
    //    NSLog(@"Name---%@",dic[@"Name"]);
       //     NSLog(@"PRKID---%@",[dic objectForKey:@"PRKID"]);
    //
    }
    self.categorys=[NSArray arrayWithArray:categorysTemp];

    //显示的分类
    NSArray *categoryShowArr=[[Common readLocalString:k_categoryShowPath secondPath:k_categoryShowPath2] JSONValue];
    
    NSMutableArray *showTempArr=[[NSMutableArray alloc] init];
    
    for (int i=0; i<categoryShowArr.count; i++) {
        NSPredicate *filter=[NSPredicate predicateWithFormat:@"PRKID=%@",[categoryShowArr objectAtIndex:i]];
//        NSLog(@"[categoryShowArr objectAtIndex:i]----%@",[categoryShowArr objectAtIndex:i]);
//        NSLog(@"filter----%@",filter);
        //categorys：所有数据 showTempArr：展示的数据
//        NSLog(@"[self.categorys filteredArrayUsingPredicate:filter]--%@",[self.categorys filteredArrayUsingPredicate:filter]);
        [showTempArr addObjectsFromArray:[self.categorys filteredArrayUsingPredicate:filter]];
    }
//    for (ProblemPaperKindObject *pro in showTempArr) {
//        NSLog(@"pro.PRKID---%d",pro.PRKID);
//    }
    
    self.categorysShow=[NSArray arrayWithArray:showTempArr];
  //  NSLog(@"categorysShow--%@",self.categorysShow);
    NSPredicate *filter2=[NSPredicate predicateWithFormat:@" NOT (PRKID  in %@)",categoryShowArr];
    self.categoryHide=[self.categorys filteredArrayUsingPredicate:filter2];
    
    
    //    [video setValuesForKeysWithDictionary:dict]; // KVC方法使用前提: 字典中的所有key 都能在 模型属性 中找到
    
}



-(void)initWithJson:(NSDictionary *)dict
{
    [self videoWithDict:dict];
}
@end
