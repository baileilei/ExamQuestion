//
//  CoursesVideoObject.h
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoursesVideoObject : NSObject
//视频编号
@property (nonatomic,strong) NSNumber *VideoID;
//课程类别（C语言程序设计等）
@property (nonatomic,strong) NSNumber *CourseID;
//名称
@property (nonatomic,strong) NSString *VideoName;
//视频路径
@property (nonatomic,strong) NSString *VideoPath;
//图片路径
@property (nonatomic,strong) NSString *VideoImage;
//长度
@property (nonatomic,strong) NSNumber *VideoLength;

@property(nonatomic) BOOL isReaded;
-(id)initWithJson:(NSDictionary *)json;
+(NSArray *)initArrayWithJson:(NSArray *)json;
@end
