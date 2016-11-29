//
//  EFRegisterViewModel.h
//  demo
//
//  Created by HqLee on 16/5/25.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "EFBaseViewModel.h"
typedef NS_ENUM(EFViewControllerCallBackAction,RegisterViewModelCallBackAction){
    RegistryCallBackActionRegister = 1<<0,
    RegistryCallBackActionRegistryCode = 1<<1,
};
@interface EFRegisterViewModel : EFBaseViewModel
/**
 *  注册
 *
 *  @param phoneNumber 手机号
 *  @param codeNumber  验证码
 *  @param passWord    密码
 */
- (void)registerWithPhoneNumber:(NSString *)phoneNumber codeNumber:(NSString *)codeNumber passWord:(NSString *)passWord;

/**
 *  验证码
 *
 *  @param _mobile 手机号
 */
- (void)RegistryCodeWithMobile : (NSString *)_mobile;
@end
