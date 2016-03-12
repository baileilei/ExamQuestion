//
//  Public.h
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#ifndef ExamMobile_Public_h
#define ExamMobile_Public_h
#define URL_SERVER (@"http://www.dota2ms.com/Service.asmx/")

#define STATE_FAIL 0
#define STATE_SUCCESS 1
#define STATE_OFFLINE 2


#define DATA_REGIST 0
#define DATA_LOGIN 1
#define DATA_GET_ORDERITEMS 2
#define DATA_GET_BOOKINFO 3
#define DATA_GET_CHAPTERS 4
#define DATA_GET_LAST_QUESTION_ORDER 5
#define DATA_GET_LAST_QUESTIONS 6
#define DATA_GET_QUESTIONS_BETWEEN_ORDER 7
#define DATA_GET_QUESTIONS_AFTER_ORDER 8
#define DATA_GET_QUESTIONS_BEFORE_ORDER 9
#define DATA_COMMIT_ANSWER 10
#define DATA_GET_ERROR_QUESTIONS 11

#define INFO_USERID @"INFO_USERID"
#define INFO_USERNAME @"INFO_USERNAME"
#define INFO_PASSWORD @"INFO_PASSWORD"
#define INFO_REALNAME @"INFO_REALNAME"
#define INFO_EMAIL @"INFO_EMAIL"
#define INFO_MOBILE @"INFO_MOBILE"
#define INFO_LOGIN_DATE @"INFO_LOGIN_DATE"
#define INFO_LOGIN_CITY @"INFO_LOGIN_CITY"
#define INFO_AUTO_LOGIN @"INFO_AUTO_LOGIN"

// 定义问题类型枚举，有单选／多选／判断
typedef NS_ENUM(NSInteger, EnumQuestionType) {
    QuestionTypeAll = 0,
    QuestionTypeJudge = 4,
    QuestionTypeRadio = 1,
    QuestionTypeMulti = 2
};




#endif
