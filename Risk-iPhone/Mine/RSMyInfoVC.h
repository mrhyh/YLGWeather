//
//  RSMyInfoVC.h
//  Risk
//
//  Created by Cherie Jeong on 16/7/15.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//  基本资料

#import "EFBaseViewController.h"

#if NS_BLOCKS_AVAILABLE
typedef void (^EditVCCallBack)(BOOL isSuccess);
#endif

@interface RSMyInfoVC : EFBaseViewController {
    EditVCCallBack callBack;
}

- (instancetype)initWithCallBack:(EditVCCallBack)_callBack;

@end
