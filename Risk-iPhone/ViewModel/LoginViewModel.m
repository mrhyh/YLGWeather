//
//  LoginViewModel.m
//  Risk
//
//  Created by Cherie Jeong on 16/7/27.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "LoginViewModel.h"
#import "RSRiskRequest.h"

@implementation LoginViewModel

- (void)loginWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password md5Code:(NSString *)md5Code type:(int)_type{
    RSLoginRequest *request = [RSLoginRequest requestWithPOST];
    request.phoneNumber = phoneNumber;
    request.password = password;
    request.md5Code = md5Code;
    request.type = _type;
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        if (callBackStatus == CallBackStatusRequestFailure ) {//说明请求失败，可能是服务器出错
            [self.viewController callBackAction:LoginCallBackActionLogin Result:result];
            
        }else if (callBackStatus == CallBackStatusRequestError){//说明请求成功，但可能输入有误等原因，无法正确获得请求结果，原因可由result的status、message和inputError进行相应的逻辑处理
            [self.viewController callBackAction:LoginCallBackActionLogin Result:result];
            
        }else if (callBackStatus == CallBackStatusSuccess){//说明请求成功，正确获得请求结果
            
            [self.viewController callBackAction:LoginCallBackActionLogin Result:result];
        }
        
        
        //根据相应的tag删除请求，避免重复请求
        [self delRequestWithTag:LoginCallBackActionLogin];
        
    } Request:request WithTag:LoginCallBackActionLogin];
    
}


- (void)GetMyProfile:(NSString *)_token{
    RSGetMyProfile * profile = [RSGetMyProfile requestWithGET];
    profile.token = _token;
    [self startCallBack:^(CallBackStatus callBackStatus,NetworkModel * result) {
        
        if (callBackStatus == CallBackStatusRequestFailure) {
            [self.viewController callBackAction:LoginCallBackActionGetMyProfile Result:result];
            
        }else if (callBackStatus == CallBackStatusRequestError){
            [self.viewController callBackAction:LoginCallBackActionGetMyProfile Result:result];
        }else if (callBackStatus == CallBackStatusSuccess){
            [self.viewController callBackAction:LoginCallBackActionGetMyProfile Result:result];
        }
        [self delRequestWithTag:LoginCallBackActionGetMyProfile];
    } Request:profile WithTag:LoginCallBackActionGetMyProfile];
}

@end
