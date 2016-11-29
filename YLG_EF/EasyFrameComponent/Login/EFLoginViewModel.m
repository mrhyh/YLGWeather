//
//  EFLoginViewModel.m
//  demo
//
//  Created by HqLee on 16/5/25.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "EFLoginViewModel.h"
#import "EFLoginRequest.h"

@implementation EFLoginViewModel
- (void)loginWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password{
    EFLoginRequest *request = [EFLoginRequest requestWithPOST];
    request.phoneNumber = phoneNumber;
    request.password = password;
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        if (callBackStatus == CallBackStatusRequestFailure ) {//说明请求失败，可能是服务器出错
            [self.viewController callBackAction:LoginCallBackActionGetMyProfile Result:result];
           
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
    GetMyProfile * profile = [GetMyProfile requestWithGET];
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


- (void)Upload:(NSArray *)_file{
    Upload * images = [Upload requestWithPOST];
    images.file = _file;
    [self startCallBack:^(CallBackStatus callBackStatus,NetworkModel * result) {
        if (callBackStatus == CallBackStatusRequestFailure) {
            [self.viewController callBackAction:LoginCallBackActionGetMyProfile Result:result];
            
        }else if (callBackStatus == CallBackStatusRequestError){
            [self.viewController callBackAction:LoginCallBackActionUpload Result:result];
        }else if (callBackStatus == CallBackStatusSuccess){
            [self.viewController callBackAction:LoginCallBackActionUpload Result:result];
        }
        [self delRequestWithTag:LoginCallBackActionUpload];
    } Request:images WithTag:LoginCallBackActionUpload];
}


- (void)SaveMyProfileWithName : (NSString *)_Name Sex:(NSString *)_sex BirthDate:(NSString *)_birthDate Sign:(NSString *)_sign HeadKey:(NSString *)_headKey{
    SaveMyProfile * profile = [SaveMyProfile requestWithPOST];
    profile.nickname = _Name;
    profile.sex = _sex;
    profile.birthDate = _birthDate;
    profile.sign = _sign;
    profile.headKey = _headKey;
    [self startCallBack:^(CallBackStatus callBackStatus,NetworkModel * result) {
        [self delRequestWithTag:LoginCallBackActionSaveMyProfile];
        if (callBackStatus == CallBackStatusRequestFailure) {
            [self.viewController callBackAction:LoginCallBackActionGetMyProfile Result:result];
            
        }else if (callBackStatus == CallBackStatusRequestError){
            [self.viewController callBackAction:LoginCallBackActionSaveMyProfile Result:result];
        }else if (callBackStatus == CallBackStatusSuccess){
            [self.viewController callBackAction:LoginCallBackActionSaveMyProfile Result:result];
        }
        
    } Request:profile WithTag:LoginCallBackActionSaveMyProfile];
}


- (void)UserLogout{
    UserLogout * request = [UserLogout requestWithPOST];
    [self startCallBack:^(CallBackStatus callBackStatus,NetworkModel * result) {
        if (callBackStatus == CallBackStatusRequestFailure) {
            [self.viewController callBackAction:LoginCallBackActionGetMyProfile Result:result];
           
        }else if (callBackStatus == CallBackStatusRequestError){
            [self.viewController callBackAction:LoginCallBackActionUserLogout Result:result];
        }else if (callBackStatus == CallBackStatusSuccess){
            [self.viewController callBackAction:LoginCallBackActionUserLogout Result:result];
        }
        [self delRequestWithTag:LoginCallBackActionUserLogout];
    } Request:request WithTag:LoginCallBackActionUserLogout];
}

- (void)ThirdPartyLoginWithUserName:(NSString *)_userName NickName:(NSString *)_nickName Sex:(NSString *)_sex Sign:(NSString *)_sign HeadImage:(NSString *)_headImage {
    ThirdPartyLogin * request = [ThirdPartyLogin requestWithPOST];
    request.userName = _userName;
    request.nickName = _nickName;
    request.sex = _sex;
    request.sign = _sign;
    request.headImage = _headImage;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:LoginCallBackActionThirdPartyLogin];
        if (callBackStatus == CallBackStatusRequestFailure) {
            [self.viewController callBackAction:LoginCallBackActionThirdPartyLogin Result:result];
            
        }else if (callBackStatus == CallBackStatusRequestError){
            [self.viewController callBackAction:LoginCallBackActionThirdPartyLogin Result:result];
        }else if (callBackStatus == CallBackStatusSuccess){
            [self.viewController callBackAction:LoginCallBackActionThirdPartyLogin Result:result];
        }
    } Request:request WithTag:LoginCallBackActionThirdPartyLogin];
    
}

- (void)modifyPassWordWithOldPassWotd:(NSString *)_oldPassword NewPassWord:(NSString *)_newPassword {
    modifyPassword * request = [modifyPassword requestWithPOST];
    request.oldPassword = _oldPassword;
    request.kNewPassword = _newPassword;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:LoginCallBackActionModifyPassWord];
        
        if (callBackStatus == CallBackStatusRequestFailure) {
            [self.viewController callBackAction:LoginCallBackActionModifyPassWord Result:result];
            
        }else if (callBackStatus == CallBackStatusRequestError){
            [self.viewController callBackAction:LoginCallBackActionModifyPassWord Result:result];
        }else if (callBackStatus == CallBackStatusSuccess){
            [self.viewController callBackAction:LoginCallBackActionModifyPassWord Result:result];
        }
        
    } Request:request WithTag:LoginCallBackActionModifyPassWord];
    
}

@end
