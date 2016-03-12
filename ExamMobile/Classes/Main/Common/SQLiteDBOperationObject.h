//
//  SQLiteDBOperationObject.h
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
@interface SQLiteDBOperationObject : NSObject
{
    sqlite3 *hSqlite3DB;
    NSString *dataBasePath;
}
@property(nonatomic,strong) NSString *dataBasePath;
-(BOOL)open;//打开数据库
-(BOOL)close;//关闭数据库
-(BOOL)executeWithSQLString:(NSString *)sqlstr;
-(BOOL)executeWithSQLArray:(NSArray *)sqlArr;
-(NSArray *)selectWithSQLString:(NSString *)sqlstr;
@end
