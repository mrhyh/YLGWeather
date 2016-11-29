//
//  EFForgetPasswordViewModel.h
//  demo
//
//  Created by HqLee on 16/5/25.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "EFBaseViewModel.h"
typedef NS_ENUM(EFViewControllerCallBackAction,PasswordViewModelCallBackAction){
    PasswordCallBackActionResetPassword = 1<<0,
    PasswordCallBackActionPasswordCode = 1<<1,
};
@interface EFForgetPasswordViewModel : EFBaseViewModel
/**
 *  忘记密码
 *
 *  @param phoneNumber 手机号
 *  @param codeNumber  验证码
 *  @param passWord    密码
 */
- (void)resetPasswordWithPhoneNumber:(NSString *)phoneNumber codeNumber:(NSString *)codeNumber newPassWord:(NSString *)passWord;

/**
 *  验证码
 *
 *  @param _mobile 手机号
 */
- (void)getPasswordCodeWithMobile : (NSString *)_mobile;
@end
