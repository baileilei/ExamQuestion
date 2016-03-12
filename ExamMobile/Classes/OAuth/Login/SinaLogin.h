//
//  SinaLogin.h
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "OAuthLogin.h"
#import "UserInfoAPI.h"
@interface SinaLogin : OAuthLogin<SinaAPIRequestDelegate>
{
    UserInfoAPI *api;
}
@end
