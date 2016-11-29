//
//  RSVideoVC.h
//  Risk-iPhone
//
//  Created by Cherie Jeong on 16/8/29.
//  Copyright © 2016年 Cherie Jeong. All rights reserved.
//

#import "EFBaseViewController.h"
@class FilesitemsModel;

#if NS_BLOCKS_AVAILABLE
typedef void (^SuccessActionCallBack)(BOOL isSuccess);
#endif

typedef void(^RSVideoVCRefreshBlock)(BOOL isRefresh);

@interface RSVideoVC : EFBaseViewController

@property (nonatomic, assign) NSInteger objectId; //资料Id

@property(nonatomic, copy) RSVideoVCRefreshBlock rsVideoVCRefreshBlock;

- (instancetype)initWithCallBack:(SuccessActionCallBack)_callBack;

@end
