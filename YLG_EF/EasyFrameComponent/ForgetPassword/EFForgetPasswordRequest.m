//
//  EFForgetPasswordRequest.m
//  demo
//
//  Created by HqLee on 16/5/25.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "EFForgetPasswordRequest.h"

@implementation EFForgetPasswordRequest
- (void)startCallBack:(RequestCallBackBlock)_callBack {
    self.urlPath = @"/rest/user/resetPassword";
    self.params = @{@"password":self.password,@"securityCode":self.codeNumber,@"mobile":self.phoneNumber};
    self.httpHeaderFields = @{@"version":@"1.0"};
    [super startCallBack:_callBack];
}
@end



#pragma mark 发送重置密码验证码
@implementation PasswordCode

- (void)startCallBack:(RequestCallBackBlock)_callBack {
    self.urlPath = @"/rest/user/sendRestPasswordSecurityCodeToMobile";
    self.params = @{@"mobile":self.mobile};
    self.httpHeaderFields = @{@"version":@"1.0"};
    [super startCallBack:_callBack];
}

@end