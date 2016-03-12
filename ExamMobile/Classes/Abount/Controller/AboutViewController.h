//
//  AboutViewController.h
//  ExamMobile
//
//  Created by lmj on 15-10-31.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "BaseViewController.h"
#import <StoreKit/StoreKit.h>
@interface AboutViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,SKProductsRequestDelegate,UIActionSheetDelegate,SKPaymentTransactionObserver>

@end
