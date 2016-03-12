//
//  DBManager.h
//  NewsBrowser
//
//  Created by Ethan on 13-12-17.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CoursesVideoObject;
@class PostObject;
@class AuthorObject;
@class ProblemsLibObject;
@interface DBManager : NSObject
+(DBManager *)share;
/*!
 *  收藏一条文章
 *
 *  @param postObj <#postObj description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)insertPostToFavorites:(ProblemsLibObject *)postObj;
/*!
 *  收藏一条试题
 *
 *  @param postObj <#postObj description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)insertPostToFavorites2:(ProblemsLibObject *)postObj;

/*!
 *  是否收藏过
 *
 *  @param postID <#postID description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)postIsInFavorites:(NSString *)postID;
/*!
 *  删除一条收藏
 *
 *  @param postID <#postID description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)delPostFromFavorites:(NSString *)postID;
-(NSArray *)selectPostFavs;
/*!
 *  获得所有订阅
 *
 *  @return <#return value description#>
 */

-(NSArray *)selectVideo;

-(BOOL)insertVideo:(CoursesVideoObject *)videoObj;
-(BOOL)delVideo:(NSString *)videoID;
-(BOOL)videoIsInFavorites:(NSString *)videoID;
@end
