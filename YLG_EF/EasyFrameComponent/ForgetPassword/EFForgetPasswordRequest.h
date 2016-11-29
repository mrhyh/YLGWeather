//
//  EFForgetPasswordRequest.h
//  demo
//
//  Created by HqLee on 16/5/25.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "EFRequest.h"

@interface EFForgetPasswordRequest : EFRequest
/**
 *  验证码
 */
@property (nonatomic, copy) NSString *codeNumber;
/**
 *  手机号
 */
@property (nonatomic, copy) NSString *phoneNumber;
/**
 *  密码
 */
@property (nonatomic, copy) NSString *password;
@end


/**
 *  发送重置密码验证码
 */
@interface PasswordCode : EFRequest
@property (nonatomic,copy) NSString *mobile;

@end