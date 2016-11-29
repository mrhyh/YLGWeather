//
//  RSHEDetailVC.h
//  Risk
//
//  Created by ylgwhyh on 16/7/14.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "EFBaseViewController.h"

#if NS_BLOCKS_AVAILABLE
typedef void (^SuccessActionCallBack)(BOOL isSuccess);
#endif


@interface RSHEDetailVC : EFBaseViewController

@property (nonatomic,assign) int objectId;

- (instancetype)initWithCallBack:(SuccessActionCallBack)_callBack;

@end
