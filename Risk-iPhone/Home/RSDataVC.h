//
//  RSDataVC.h
//  Risk
//
//  Created by ylgwhyh on 16/7/3.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "EFBaseViewController.h"


#if NS_BLOCKS_AVAILABLE
typedef void (^SuccessActionCallBack)(BOOL isSuccess);
#endif

typedef void(^RSDataVCRefreshBlock)(BOOL isRefresh);

@interface RSDataVC : EFBaseViewController

@property (nonatomic,assign) int objectId;

@property(nonatomic, copy) RSDataVCRefreshBlock rsDataVCRefreshBlock;

- (instancetype)initWithCallBack:(SuccessActionCallBack)_callBack;

@end
