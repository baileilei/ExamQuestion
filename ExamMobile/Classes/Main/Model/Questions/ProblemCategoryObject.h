//
//  ProblemCategoryObject.h
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProblemCategoryObject : NSObject
/*!
 *  分类信息
 */
@property(nonatomic,strong) NSArray *categorys;
/*!
 *  显示的分类
 */
@property(nonatomic,strong) NSArray *categorysShow;
@property(nonatomic,strong) NSArray *categoryHide;

//类别编号
@property (assign,nonatomic) int PRKID;

//类别
@property (assign,nonatomic) int ParentID;

//视频长度
@property (copy,nonatomic) NSString *Name;

- (void)videoWithDict:(NSDictionary *)dict;
- (void)initWithJson:(NSDictionary *)dict;
//理解！
+(ProblemCategoryObject *)share;

@end
