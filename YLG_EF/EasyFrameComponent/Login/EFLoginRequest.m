//
//  EFLoginRequest.m
//  demo
//
//  Created by HqLee on 16/5/25.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "EFLoginRequest.h"
#import "UserModel.h"
static NSString *const defaultUrlPath = @"rest/user/login";

@implementation EFLoginRequest
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.urlPath = @"/rest/user/login";
    self.params = @{@"loginname":self.phoneNumber,@"password":self.password};
    self.httpHeaderFields = @{@"version":@"1.0"};
    [super startCallBack:_callBack];
}

@end


#pragma mark 获取我的个人资料
@implementation GetMyProfile

- (void)startCallBack:(RequestCallBackBlock)_callBack {
    self.urlPath = @"/rest/user/myProfile";
    self.httpHeaderFields = @{@"version":@"1.0",@"token":self.token};
    [super startCallBack:_callBack];
}

@end


#pragma mark 上传临时文件
@implementation Upload

- (void)startCallBack:(RequestCallBackBlock)_callBack {
    self.urlPath = @"/rest/attachment/upload/";
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"version":@"1.0",@"token":token};
    self.requestFiles_Upload = @{@"file":self.file};
    self.requestImages =  self.file;
    [super startCallBack:_callBack];
}


@end


#pragma mark 保存我的个人资料
@implementation SaveMyProfile

- (void)startCallBack:(RequestCallBackBlock)_callBack {
    self.urlPath = @"/rest/user/saveMyProfile";
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"version":@"1.0",@"token":token};
    self.params = @{@"nickname":self.nickname,@"sex":self.sex,@"birthDate":self.birthDate,@"sign":self.sign,@"headKey":self.headKey};
    
    
    [super startCallBack:_callBack];
}

@end

#pragma mark 登出
@implementation UserLogout

- (void)startCallBack:(RequestCallBackBlock)_callBack {
    self.urlPath = @"/rest/user/logout";
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"version":@"1.0",@"token":token};
    [super startCallBack:_callBack];
}

@end

#pragma mark 第三方登录
@implementation ThirdPartyLogin

- (void)startCallBack:(RequestCallBackBlock)_callBack {
    self.urlPath = @"/rest/user/thirdPartyLogin";
    self.params = @{@"userName":self.userName,@"nickName":self.nickName,@"sex":self.sex,@"sign":self.sign,@"headImage":self.headImage};
//    NSString * token = @"";
//    if ([UserModel ShareUserModel].token) {
//        token = [UserModel ShareUserModel].token;
//    }
//    self.httpHeaderFields = @{@"version":@"1.0",@"token":token};
    self.httpHeaderFields = @{@"version":@"1.0"};
    [super startCallBack:_callBack];
}

@end


@implementation modifyPassword

- (void)startCallBack:(RequestCallBackBlock)_callBack {
    self.urlPath = @"/rest/user/modifyPassword";
    self.params = @{@"oldPassword":self.oldPassword,@"newPassword":self.kNewPassword};
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"version":@"1.0",@"token":token};
    [super startCallBack:_callBack];
}

@end

