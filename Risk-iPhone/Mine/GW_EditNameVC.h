//
//  GW_EditNameVC.h
//  Guwang
//
//  Created by MH on 16/5/12.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFBaseViewController.h"
#if NS_BLOCKS_AVAILABLE
typedef void (^GW_EditNameVCCallBack)(NSString * name);
#endif
@interface GW_EditNameVC : EFBaseViewController
@property (strong, nonatomic)GW_EditNameVCCallBack  callBack;

@property (nonatomic,strong) NSString * nameStr;

- (instancetype)initWithCallBack:(GW_EditNameVCCallBack)callBack;
@end
