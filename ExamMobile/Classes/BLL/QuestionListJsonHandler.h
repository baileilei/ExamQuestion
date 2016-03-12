//
//  QuestionListJsonHandler.h
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProblemPaperKindObject.h"
@protocol QuestionListJsonHandlerDelegate;
@interface QuestionListJsonHandler : NSObject
@property(nonatomic,weak) id <QuestionListJsonHandlerDelegate> delegate;
-(void)handlerCategoryObject:(ProblemPaperKindObject *)catObj currentPageIndex:(int)currentPageIndex pageSize:(int)pageSize;
//查询数据
-(void)searchListWithName:(int)prkID name:(NSString *)name searchPageIndex:(int)searchPageIndex pageSize:(int)pageSize;

//判断刷新上拉下拉
@property(nonatomic,strong) NSString *ID;
//类别编号
@property (assign,nonatomic) int PRKID;
@end

@protocol QuestionListJsonHandlerDelegate <NSObject>

-(void)QuestionListJsonhandler:(QuestionListJsonHandler *)handler withResult:(NSString *)result;
@end
