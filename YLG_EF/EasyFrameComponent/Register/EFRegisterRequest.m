//
//  EFRegisterRequest.m
//  demo
//
//  Created by HqLee on 16/5/25.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "EFRegisterRequest.h"

@implementation EFRegisterRequest
#pragma mark 注册
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.params = @{@"mobile":self.phoneNumber,@"securityCode":self.codeNumber,@"password":self.password};
    self.urlPath = @"/rest/user/registry";
    self.httpHeaderFields = @{@"version":@"1.0"};
    [super startCallBack:_callBack];
}
@end

#pragma mark 发送账户注册验证码
@implementation RegistryCode

- (void)startCallBack:(RequestCallBackBlock)_callBack {
    self.urlPath = @"/rest/user/sendRegistrySecurityCodeToMobile";
    self.params = @{@"mobile":self.mobile};
    self.httpHeaderFields = @{@"version":@"1.0"};
    [super startCallBack:_callBack];
}

@end