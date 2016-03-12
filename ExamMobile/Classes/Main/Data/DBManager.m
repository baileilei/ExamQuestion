//
//  DBManager.m
//  NewsBrowser
//
//  Created by Ethan on 13-12-17.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "DBManager.h"
#import "SQLiteDBOperationObject.h"
#import "Config.h"


#import "CoursesVideoObject.h"
#import "ProblemsLibObject.h"
@interface DBManager()
{
    SQLiteDBOperationObject *dbOperation;
}
@end
@implementation DBManager
-(id)init
{
    if (self=[super init]) {
        BOOL exist=NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:k_sqliteDBPath]) {
            exist=YES;
        }
        dbOperation=[[SQLiteDBOperationObject alloc] init];
        dbOperation.dataBasePath=k_sqliteDBPath;
        [dbOperation open]; //只打开一次
        if (!exist) {
            [self create];
        }
        NSLog(@"沙盒路径：%@",NSHomeDirectory());
    }
    return self;
}
+(DBManager *)share
{
    static DBManager *_share=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _share=[[DBManager alloc] init];
    });
    return _share;
}
//创建表
-(void)create
{

//    NSString *sqlStr=@"Create Table if not exists \
//    FavoritesExam \
//    (               \
//        PpID          nvarchar(50) PRIMARY KEY NOT NULL,\
//        PrkID       nvarchar(100), \
//        PtID      nvarchar(50),\
//        Name         nvarchar(100),\
//        UpdateTime     date,\
//        PpDesc      nvarchar(200),\
//        ProblemNum        nvarchar(10),\
//        CategoryURL    nvarchar(50),\
//        Header     nvarchar(300)\
//    );\
//    Create Table if not exists \
//    FavoritesVideo \
//    (               \
//         VideoID          nvarchar(50) PRIMARY KEY NOT NULL,\
//         CourseID       nvarchar(50), \
//         VideoName        nvarchar(100),\
//         VideoPath      nvarchar(100),\
//         VideoImage       nvarchar(50),\
//         VideoLength     nvarchar(10)\
//    );";
    NSString *sqlStr=@"Create Table if not exists \
    FavoritesExam \
    (               \
    ProblemsLibID          nvarchar(5000) PRIMARY KEY NOT NULL,\
    ProblemPaperID       nvarchar(5000), \
    CourseID      nvarchar(5000),\
    TypeID         nvarchar(5000),\
    QuestionNumber     nvarchar(5000),\
    ProblemDes      nvarchar(5000),\
    ProblemName    nvarchar(8000),\
    PaperName    nvarchar(5000),\
    ProblemsLibData    nvarchar(5000),\
    ProblemAnswer     nvarchar(5000)\
    );\
    Create Table if not exists \
    FavoritesVideo \
    (               \
    VideoID          nvarchar(50) PRIMARY KEY NOT NULL,\
    CourseID       nvarchar(50), \
    VideoName        nvarchar(100),\
    VideoPath      nvarchar(100),\
    VideoImage       nvarchar(50),\
    VideoLength     nvarchar(10)\
    );";

    if (dbOperation) {
        [dbOperation executeWithSQLString:sqlStr];
    }
}
#pragma -
#pragma 收藏表操作  先查找是否有重复的在添加
-(NSArray *)selectPostFavs
{
    NSString *sqlstr=@"select * from FavoritesExam";
    NSArray *result=[dbOperation selectWithSQLString:sqlstr];
    NSMutableArray *array=[[NSMutableArray alloc] init];
    for (NSDictionary *dic in result) {
        ProblemsLibObject *obj=[[ProblemsLibObject alloc] init];
        obj.ProblemsLibID=[NSNumber numberWithInt:[[dic objectForKey:@"ProblemsLibID"] intValue]];
        obj.ProblemPaperID=[NSNumber numberWithInt:[[dic objectForKey:@"ProblemPaperID"] intValue]];
        obj.CourseID=[NSNumber numberWithInt:[[dic objectForKey:@"CourseID"] intValue]];
        obj.TypeID=[NSNumber numberWithInt:[[dic objectForKey:@"TypeID"] intValue]];
        obj.QuestionNumber=[NSNumber numberWithInt:[[dic objectForKey:@"QuestionNumber"] intValue]];
        obj.ProblemDes=[dic objectForKey:@"ProblemDes"];
        obj.ProblemsLibData=[dic objectForKey:@"ProblemsLibData"];
//        NSString *asciiString = [[NSString alloc] initWithData:[dic objectForKey:@"ProblemDes"] encoding:NSUTF16BigEndianStringEncoding];
//         NSLog(@"asciiString--%@",asciiString);
        
//        NSLog(@"initWithData--%@",[[NSString alloc] initWithData:[dic objectForKey:@"ProblemDes"] encoding:NSUTF16BigEndianStringEncoding]);
   //      NSLog(@"initWithData--%@",[dic objectForKey:@"ProblemDes"]);
       
        obj.ProblemName= [dic objectForKey:@"ProblemName"];
        obj.PaperName=[dic objectForKey:@"PaperName"];
        obj.ProblemAnswer=[dic objectForKey:@"ProblemAnswer"];
        [array addObject:obj];
    }
    NSArray *returnArr=[NSArray arrayWithArray:array];
    return returnArr;
}
-(BOOL)insertPostToFavorites:(ProblemsLibObject *)postObj
{
//    NSData *ProblemDesData = [postObj.ProblemDes dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *ProblemNameData = [postObj.ProblemName dataUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"ProblemDes-----%@",postObj.ProblemDes);
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    //设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyy年MM月dd日\nHH小时mm分ss秒"];
     postObj.ProblemsLibData = [df stringFromDate:currentDate];
    
    postObj.ProblemDes = [postObj.ProblemDes stringByReplacingOccurrencesOfString:@"'" withString:@"@"];
     postObj.ProblemName = [postObj.ProblemName stringByReplacingOccurrencesOfString:@"'" withString:@"@"];
//    NSLog(@"ProblemDes-----%@",postObj.ProblemDes);
   
  //  NSString *asciiString = [[NSString alloc] initWithData:ProblemDesData encoding:NSUTF16BigEndianStringEncoding];
   
  NSString  *sqlstr=[NSString stringWithFormat:@"insert into FavoritesExam\
            (ProblemsLibID,ProblemPaperID,CourseID,TypeID,QuestionNumber,ProblemDes,ProblemName,PaperName,ProblemsLibData,ProblemAnswer)\
    values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",
            postObj.ProblemsLibID,
            postObj.ProblemPaperID,
            postObj.CourseID,
            postObj.TypeID,
            postObj.QuestionNumber,
            postObj.ProblemDes,
            postObj.ProblemName,
            postObj.PaperName,
            postObj.ProblemsLibData,
            postObj.ProblemAnswer];
//    NSLog(@"postObj.ProblemsLibID---%@",postObj.ProblemsLibID);
//    NSLog(@"postObj.ProblemPaperID---%@",postObj.ProblemPaperID);
//    NSLog(@"postObj.ProblemName---%@",postObj.ProblemName);
//    NSLog(@"postObj.ProblemAnswer---%@",postObj.ProblemAnswer);
//    NSLog(@"postObj.ProblemDes---%@",postObj.ProblemDes);
//    NSLog(@"postObj.CourseID---%@",postObj.CourseID);
//    NSLog(@"postObj.TypeID---%@",postObj.TypeID);
//    NSLog(@"postObj.PaperName---%@",postObj.PaperName);
//    NSLog(@"postObj.QuestionNumber---%@",postObj.QuestionNumber);
    return [dbOperation executeWithSQLString:sqlstr];
    return YES;
}

-(BOOL)postIsInFavorites:(NSString *)postID
{
    NSString *sqlstr=[NSString stringWithFormat:@"select ProblemsLibID from FavoritesExam where ProblemsLibID='%@'",postID];
    NSArray *result=[dbOperation selectWithSQLString:sqlstr];
    if (result.count==0) {
        return NO;
    }
    return YES;
}

-(BOOL)delPostFromFavorites:(NSString *)postID
{
    NSString *sqlstr=[NSString stringWithFormat:@"delete from FavoritesExam where ProblemsLibID='%@'",postID];
    
    return [dbOperation executeWithSQLString:sqlstr];
}
//25.还没重写
#pragma 播放记录操作
-(BOOL)videoIsInFavorites:(NSString *)videoID
{
    NSString *sqlstr=[NSString stringWithFormat:@"select VideoID from FavoritesVideo where VideoID='%@'",videoID];
    NSArray *result=[dbOperation selectWithSQLString:sqlstr];
    if (result.count==0) {
        return NO;
    }
    return YES;
}
-(NSArray *)selectVideo
{
    NSString *sqlstr=@"select * from FavoritesVideo";
    NSArray *result=[dbOperation selectWithSQLString:sqlstr];
    NSMutableArray *array=[[NSMutableArray alloc] init];
    for (NSDictionary *dic in result) {
        CoursesVideoObject *obj=[[CoursesVideoObject alloc] init];
        obj.VideoID=[dic objectForKey:@"VideoID"];
        obj.CourseID=[dic objectForKey:@"CourseID"];
        obj.VideoName=[dic objectForKey:@"VideoName"];
        obj.VideoPath=[dic objectForKey:@"VideoPath"];
        obj.VideoImage=[dic objectForKey:@"VideoImage"];
        obj.VideoLength=[dic objectForKey:@"VideoLength"];
        [array addObject:obj];
    }
    NSArray *returnArr=[NSArray arrayWithArray:array];
    return returnArr;
}
-(BOOL)insertVideo:(CoursesVideoObject *)videoObj
{
    NSString  *sqlstr=[NSString stringWithFormat:@"insert into FavoritesVideo\
                       (VideoID,CourseID,VideoName,VideoPath,VideoImage,VideoLength)\
                       values('%@','%@','%@','%@','%@','%@');",
                       videoObj.VideoID,
                       videoObj.CourseID,
                       videoObj.VideoName,
                       videoObj.VideoPath,
                       videoObj.VideoImage,
                       videoObj.VideoLength];
    return [dbOperation executeWithSQLString:sqlstr];
}
-(BOOL)delVideo:(NSString *)videoID
{
    NSString *sqlstr=[NSString stringWithFormat:@"delete from FavoritesVideo where VideoID='%@'",videoID];
    return [dbOperation executeWithSQLString:sqlstr];

}
@end
