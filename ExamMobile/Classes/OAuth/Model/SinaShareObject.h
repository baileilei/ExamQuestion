//
//  SinaShareObject.h
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SinaLogin.h"
#import "SinaAPI_update.h"
@interface SinaShareObject : NSObject<OAuthLoginDelegate,SinaAPIRequestDelegate,UIActionSheetDelegate>
{
    SinaLogin *sina;
    SinaAPI_update *updateAPI;
    UIViewController *parentVC;
}
@property(nonatomic,strong) NSString *content;
//已经登录过的所有新浪用户信息
@property(nonatomic,strong) NSArray *userInfoArray;
+(SinaShareObject *)share;
-(void)shareWithContent:(NSString *)conent pVC:(UIViewController *)pvc;
@end
