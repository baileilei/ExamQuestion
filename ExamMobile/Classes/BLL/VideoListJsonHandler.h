//
//  VideoListJsonHandler.h
//  UISearchBarDemo
//
//  Created by lmj on 15-9-27.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoursesVideoObject.h"
@protocol VideoListJsonHandlerDelegate;
@interface VideoListJsonHandler : NSObject
@property (nonatomic,weak) id <VideoListJsonHandlerDelegate> delegate;
//刷新数据
- (void)handlerVideoObject:(CoursesVideoObject *)cvObj currentPageIndex:(int)CurrentPageIndex pageSize:(int)pageSize;
//查询数据
-(void)searchListWithVideoName:(NSString *)VideoName searchPageIndex:(int)searchPageIndex pageSize:(int)pageSize;
//判断刷新是否加载更多
@property (nonatomic,strong) NSString *ID;

@end
@protocol VideoListJsonHandlerDelegate <NSObject>

- (void)VideoListJsonhandler:(VideoListJsonHandler *)handler withResult:(NSString *)result;


@end