//
//  CoursesObject.h
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoursesObject : NSObject
/*!
 *  分类信息
 */
@property(nonatomic,strong) NSArray *categorys;
/*!
 *  显示的分类
 */
@property(nonatomic,strong) NSArray *categorysShow;
@property(nonatomic,strong) NSArray *categoryHide;


@property(nonatomic,strong) NSArray *indexsCategorys;
//类别编号
@property (assign,nonatomic) int CourseID;

//
@property (assign,nonatomic) int ParentID;

//
@property (copy,nonatomic) NSString *CourseName;
- (void)videoWithDict2:(NSDictionary *)dict;
//理解！
+(CoursesObject *)share;

@end
