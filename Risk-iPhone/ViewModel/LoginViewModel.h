//
//  LoginViewModel.h
//  Risk
//
//  Created by Cherie Jeong on 16/7/27.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "EFBaseViewModel.h"

typedef NS_ENUM(EFViewControllerCallBackAction,LoginViewModelCallBackAction){
    LoginCallBackActionLogin = 1<<0,
    LoginCallBackActionGetMyProfile = 1<<2,
};

@interface LoginViewModel : EFBaseViewModel

/**
 *  通过手机号登录
 *
 *  @param phoneNumber 手机号
 *  @param password    密码
 *  @param md5Code     UDID
 *  @param type        设备类型  0 -- andorid  1 -- ipad  2 -- iphone
 */
- (void)loginWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password md5Code:(NSString *)md5Code  type:(int)_type;

/**
 *  获取个人信息
 *
 *  @param _token token
 */
- (void)GetMyProfile:(NSString *)_token;

@end
