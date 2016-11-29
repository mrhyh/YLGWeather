//
//  EFForgetPasswordViewModel.m
//  demo
//
//  Created by HqLee on 16/5/25.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "EFForgetPasswordViewModel.h"
#import "EFForgetPasswordRequest.h"

@implementation EFForgetPasswordViewModel
/**
 *  重置密码
 *
 *  @param phoneNumber 手机号
 *  @param codeNumber  验证码
 *  @param passWord    密码
 */
- (void)resetPasswordWithPhoneNumber:(NSString *)phoneNumber codeNumber:(NSString *)codeNumber newPassWord:(NSString *)passWord{
    EFForgetPasswordRequest *request = [EFForgetPasswordRequest requestWithPOST];
    request.phoneNumber = phoneNumber;
    request.codeNumber = codeNumber;
    request.password = passWord;
    [self startCallBack:^(CallBackStatus callBackStatus,NetworkModel * result) {
        [self delRequestWithTag:PasswordCallBackActionResetPassword];
        
        [self.viewController callBackAction:PasswordCallBackActionResetPassword Result:result];
    } Request:request WithTag:PasswordCallBackActionResetPassword];
}
/**
 *  发送验证码
 *
 *  @param _mobile 手机号
 */
- (void)getPasswordCodeWithMobile : (NSString *)_mobile{
    PasswordCode * code = [PasswordCode requestWithGET];
    code.mobile = _mobile;
    [self startCallBack:^(CallBackStatus callBackStatus,NetworkModel * result) {
        [self delRequestWithTag:PasswordCallBackActionPasswordCode];
        if (callBackStatus == CallBackStatusRequestFailure) {
            [self.viewController callBackAction:PasswordCallBackActionPasswordCode Result:result];
            [UIUtil alert:@"服务器出错"];
        }else if (callBackStatus == CallBackStatusRequestError){
            [self.viewController callBackAction:PasswordCallBackActionPasswordCode Result:result];
        }else if (callBackStatus == CallBackStatusSuccess){
            [self.viewController callBackAction:PasswordCallBackActionPasswordCode Result:result];
        }
    } Request:code WithTag:PasswordCallBackActionPasswordCode];
}
@end
