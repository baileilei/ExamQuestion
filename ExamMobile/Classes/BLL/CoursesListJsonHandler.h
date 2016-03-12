//
//  CoursesListJsonHandler.h
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoursesObject.h"
@protocol CoursesListJsonHandlerDelegate;

@interface CoursesListJsonHandler : NSObject
@property(nonatomic,weak) id <CoursesListJsonHandlerDelegate> delegate;
-(void)handlerCategoryObject:(CoursesObject *)catObj currentPageIndex:(int)currentPageIndex pageSize:(int)pageSize;
//查询数据
-(void)searchListWithVideoName:(int)courseID videoName:(NSString *)videoName searchPageIndex:(int)searchPageIndex pageSize:(int)pageSize;
//判断刷新上拉下拉
@property(nonatomic,strong) NSString *ID;
//类别编号
@property (assign,nonatomic) int CourseID;
@end

@protocol CoursesListJsonHandlerDelegate <NSObject>

-(void)PostListJsonhandler:(CoursesListJsonHandler *)handler withResult:(NSString *)result;
@end
