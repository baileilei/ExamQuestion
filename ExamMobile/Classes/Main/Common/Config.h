//
//  Config.h
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "Common.h"
#import "JSON.h"
#ifndef NewsBrowser_Config_h
#define NewsBrowser_Config_h

#define k_VideoListDetailCell_Height 110.0f


//应用初始化启动图片
#define k_defaultLoadingImage @"Default-568h@2x.png"
//应用初始化网址ddd
#define initUrl2(x)    [NSString stringWithFormat:@"http://www.ltydkb.com/%@",(x)]

#define initUrlWeb(x)    [NSString stringWithFormat:@"http://qxw1098930026.my3w.com/%@",(x)]

//应用初始化网址2
#define k_initUrlBasicCourse @"http://www.ltydkb.com/Service.asmx/RootNodeSelect"



//应用初始化网址4
#define k_initUrlCategoryCourse @"http://www.ltydkb.com/Service.asmx/ProblemResourceKindSelect"

//应用初始化网址5
#define k_initUrlVideo @"http://www.ltydkb.com/Service.asmx/CourseAllSelectSelect"



//loaing信息本地路径
#define k_LoadingPath [k_DocumentsPath stringByAppendingString:@"/loading"]
#define k_LoadingjsonPath [k_DocumentsPath stringByAppendingString:@"/loading/loading.txt"]

//分类显示排序存放
#define k_categoryShowPath [k_DocumentsPath stringByAppendingString:@"/categoryShowOrder.json"]
#define k_categoryShowPath2 [[NSBundle mainBundle] pathForResource:@"categoryShowOrder" ofType:@"txt"]
//课程分类显示排序存放
#define Course_k_categoryShowPath [k_DocumentsPath stringByAppendingString:@"/CoursescategoryShowOrder.json"]
#define Course_k_categoryShowPath2 [[NSBundle mainBundle] pathForResource:@"CoursescategoryShowOrder" ofType:@"txt"]


//本地数据库存放位置
#define k_sqliteDBPath [k_DocumentsPath stringByAppendingString:@"/exam.db"]

#define k_NavBarBGColor @"#2887c2"
#endif
