//
//  ProblemPaperObject.h
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProblemPaperObject : NSObject
//编号

@property (nonatomic,strong) NSNumber *PpID;
//分类类别（计算机类，医护学院类等）
@property (nonatomic,strong) NSNumber *PrkID;
//等级类别（国家，省级等）
@property (nonatomic,strong) NSNumber *PtID;
//标题
@property (nonatomic,strong) NSString *Name;
//发布时间
@property (nonatomic,strong) NSString *UpdateTime;
//描述
@property (nonatomic,strong) NSString *PpDesc;
//题量
@property (nonatomic,strong) NSNumber *ProblemNum;
//URL
@property (nonatomic,strong) NSString *CategoryURL;
//图片路径
@property (nonatomic,strong) NSString *Header;
//试题
@property (nonatomic,strong) NSString *ProblemName;


@property(nonatomic) BOOL isReaded;
-(id)initWithJson:(NSDictionary *)json;
+(NSArray *)initArrayWithJson:(NSArray *)json;
@end
