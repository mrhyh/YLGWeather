//
//  EFPayAlertView.h
//  EF_MallDemo
//
//  Created by HqLee on 16/6/16.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFPopupViewManager.h"

typedef void(^CompleteBlock)(NSString * Type) ;

@interface EFPayAlertView : EFPopupView
- (instancetype)initWithType:(NSString*)type andIsShowWalletPay:(BOOL)isShow CallBack:(CompleteBlock)callBack;
@end
