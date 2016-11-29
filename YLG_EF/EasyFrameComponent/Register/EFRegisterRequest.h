//
//  EFRegisterRequest.h
//  demo
//
//  Created by HqLee on 16/5/25.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "EFRequest.h"

@interface EFRegisterRequest : EFRequest
//验证码
@property (nonatomic, copy) NSString *codeNumber;
//手机号
@property (nonatomic, copy) NSString *phoneNumber;
//密码
@property (nonatomic, copy) NSString *password;
@end

/**
 *  发送账户注册验证码
 */
@interface RegistryCode : EFRequest
@property (nonatomic,copy) NSString *mobile;

@end
