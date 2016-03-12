//
//  JSON1.h
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (JSON)
- (id) JSONValue;
@end

@interface NSData (JSON)
- (id) JSONValue;
@end

@interface NSObject (JSON)
- (NSString *)JSONRepresentation;
@end