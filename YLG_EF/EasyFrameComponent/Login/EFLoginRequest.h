//
//  EFLoginRequest.h
//  demo
//
//  Created by HqLee on 16/5/25.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "EFRequest.h"

@interface EFLoginRequest : EFRequest
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *password;
@end


/**
 *  获取我的个人资料
 */
@interface GetMyProfile : EFRequest
@property (nonatomic,copy) NSString *token;
@end

/**
 *  上传临时文件
 */
@interface Upload : EFRequest
@property (nonatomic,strong) NSArray *file;
@end

/**
 *  保存我的个人资料
 */
@interface SaveMyProfile : EFRequest
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *sex;
@property (nonatomic,copy) NSString *birthDate;
@property (nonatomic,copy) NSString *sign;
@property (nonatomic,copy) NSString *headKey;
@end


/**
 *  登出
 */
@interface UserLogout : EFRequest
@end

/**
 *  第三方登录
 */
@interface ThirdPartyLogin : EFRequest

@property (nonatomic ,copy) NSString * userName;
@property (nonatomic, copy) NSString * nickName;
@property (nonatomic, copy) NSString * sex;
@property (nonatomic, copy) NSString * sign;
@property (nonatomic, copy) NSString * headImage;

@end


/**
 *  修改密码
 */
@interface modifyPassword : EFRequest

@property (nonatomic, copy) NSString * oldPassword;
@property (nonatomic, copy) NSString * kNewPassword;

@end

