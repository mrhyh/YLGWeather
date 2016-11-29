//
//  EFLoginViewModel.h
//  demo
//
//  Created by HqLee on 16/5/25.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "EFBaseViewModel.h"
typedef NS_ENUM(EFViewControllerCallBackAction,LoginViewModelCallBackAction){
    LoginCallBackActionLogin = 1<<0,
    LoginCallBackActionGetMyProfile = 1<<2,
    LoginCallBackActionUserLogout = 1<<3,
    LoginCallBackActionSaveMyProfile = 1<<4,
    LoginCallBackActionUpload = 1<<5,
    LoginCallBackActionThirdPartyLogin = 1<<6,
    LoginCallBackActionModifyPassWord = 1<<7,
    
};
@interface EFLoginViewModel : EFBaseViewModel
/**
 *  通过手机号注册
 *
 *  @param phoneNumber 手机号
 *  @param password    密码
 */
- (void)loginWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password;

/**
 *  获取个人信息
 *
 *  @param _token token
 */
- (void)GetMyProfile:(NSString *)_token;

/**
 *  上传图片
 *
 *  @param _file 图片
 */
- (void)Upload:(NSArray *)_file;

/**
 *  修改个人信息
 *
 *  @param _Name      昵称
 *  @param _sex       性别
 *  @param _birthDate 生日
 *  @param _sign      签名
 *  @param _headKey   图片key
 */
- (void)SaveMyProfileWithName : (NSString *)_Name Sex:(NSString *)_sex BirthDate:(NSString *)_birthDate Sign:(NSString *)_sign HeadKey:(NSString *)_headKey;

/**
 *  退出登录
 */
- (void)UserLogout;


/**
 *  三方登录
 *
 *  @param _userName  第三方账号
 *  @param _nickName  第三方昵称
 *  @param _sex       性别
 *  @param _sign      个性签名
 *  @param _headImage 头像
 */
- (void)ThirdPartyLoginWithUserName:(NSString *)_userName NickName:(NSString *)_nickName Sex:(NSString *)_sex Sign:(NSString *)_sign HeadImage:(NSString *)_headImage;

/**
 *  修改密码
 *
 *  @param _oldPassword 旧密码
 *  @param _newPassword 新密码
 */
- (void)modifyPassWordWithOldPassWotd:(NSString * )_oldPassword NewPassWord:(NSString *)_newPassword;


@end
