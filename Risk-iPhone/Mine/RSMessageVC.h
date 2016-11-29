//
//  RSMessageVC.h
//  Risk
//
//  Created by Cherie Jeong on 16/7/15.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//  消息通知

#import "EFBaseViewController.h"

#if NS_BLOCKS_AVAILABLE
typedef void (^MSGVCCallBack)(BOOL isSuccess);
#endif

@interface RSMessageVC : EFBaseViewController{
    MSGVCCallBack callBack;
}

- (instancetype)initWithCallBack:(MSGVCCallBack)_callBack;

@end
