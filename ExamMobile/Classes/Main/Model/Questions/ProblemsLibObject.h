//
//  ProblemsLibObject.h
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProblemsLibObject : NSObject
//编号
@property (nonatomic,strong) NSNumber *ProblemsLibID;
//章节编号
@property (nonatomic,strong) NSNumber *ProblemPaperID;
//题型
@property (nonatomic,strong) NSNumber *TypeID;
//课程类别
@property (nonatomic,strong) NSNumber *CourseID;
//试题
@property (nonatomic,strong) NSString *ProblemName;
//答案
@property (nonatomic,strong) NSString *ProblemAnswer;
//解析
@property (nonatomic,strong) NSString *ProblemDes;
//题号
@property (nonatomic,strong) NSNumber *QuestionNumber;
//试卷名称
@property (nonatomic,strong) NSString *PaperName;
//收藏时间
@property (nonatomic,strong) NSString *ProblemsLibData;



-(id)initWithJson:(NSDictionary *)json;
+(NSArray *)initArrayWithJson:(NSArray *)json;
@end
