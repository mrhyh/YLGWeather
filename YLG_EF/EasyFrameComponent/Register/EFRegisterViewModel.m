//
//  EFRegisterViewModel.m
//  demo
//
//  Created by HqLee on 16/5/25.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "EFRegisterViewModel.h"
#import "EFRegisterRequest.h"

@implementation EFRegisterViewModel
/**
 *  注册
 *
 *  @param phoneNumber 手机号
 *  @param codeNumber  验证码
 *  @param passWord    密码
 */
- (void)registerWithPhoneNumber:(NSString *)phoneNumber codeNumber:(NSString *)codeNumber passWord:(NSString *)passWord{
    EFRegisterRequest *request = [EFRegisterRequest requestWithPOST];
    request.phoneNumber = phoneNumber;
    request.codeNumber = codeNumber;
    request.password = passWord;
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        if (callBackStatus == CallBackStatusRequestFailure ) {//说明请求失败，可能是服务器出错
            [UIUtil alert:@"服务器出错"];
            [self.viewController callBackAction:RegistryCallBackActionRegister Result:result];
        }else if (callBackStatus == CallBackStatusRequestError){//说明请求成功，但可能输入有误等原因，无法正确获得请求结果，原因可由result的status、message和inputError进行相应的逻辑处理
            [self.viewController callBackAction:RegistryCallBackActionRegister Result:result];
            
        }else if (callBackStatus == CallBackStatusSuccess){//说明请求成功，正确获得请求结果
            
            [self.viewController callBackAction:RegistryCallBackActionRegister Result:result];
        }
        [self delRequestWithTag:RegistryCallBackActionRegister];
    } Request:request WithTag:RegistryCallBackActionRegister];
}

/**
 *  验证码
 *
 *  @param _mobile 手机号
 */
- (void)RegistryCodeWithMobile : (NSString *)_mobile{
    RegistryCode * code = [RegistryCode requestWithGET];
    code.mobile = _mobile;
    [self startCallBack:^(CallBackStatus callBackStatus,NetworkModel * result) {
        [self delRequestWithTag:RegistryCallBackActionRegistryCode];
        if (callBackStatus == CallBackStatusRequestFailure) {
            [self.viewController callBackAction:RegistryCallBackActionRegistryCode Result:result];
            [UIUtil alert:@"服务器出错"];
        }else if (callBackStatus == CallBackStatusRequestError){
            [self.viewController callBackAction:RegistryCallBackActionRegistryCode Result:result];
        }else if (callBackStatus == CallBackStatusSuccess){
            [self.viewController callBackAction:RegistryCallBackActionRegistryCode Result:result];
        }
    } Request:code WithTag:RegistryCallBackActionRegistryCode];
}
@end
