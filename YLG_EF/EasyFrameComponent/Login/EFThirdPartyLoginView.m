//
//  EFThirdPartyLoginView.m
//  demo
//
//  Created by HqLee on 16/5/20.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "EFThirdPartyLoginView.h"

//
//#import <TencentOpenAPI/TencentOAuth.h>
//
@interface EFThirdPartyLoginView()  {
//    TencentOAuth * tencentOAuth;
//    NSArray *permissions;
}
@property (weak, nonatomic) IBOutlet UIButton *weiboBtn;
@property (weak, nonatomic) IBOutlet UIButton *wexinBtn;
@property (weak, nonatomic) IBOutlet UIButton *QQBtn;
@end

@implementation EFThirdPartyLoginView
+ (instancetype)thirdPartyView{
    return [[[NSBundle mainBundle] loadNibNamed:@"EFThirdPartyLoginView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.thirdPartyLabel addGestureRecognizer:tap];
    [self.wexinBtn setTitleColor:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_TextColorLoginSecondary] forState:UIControlStateNormal];
    [self.wexinBtn setImage:[UIImage imageNamed:@"resource.bundle/ic_sigin_wechat.png"] forState:UIControlStateNormal];
    [self.weiboBtn setTitleColor:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_TextColorLoginSecondary] forState:UIControlStateNormal];
    [self.weiboBtn setImage:[UIImage imageNamed:@"resource.bundle/ic_sigin_weibo.png"] forState:UIControlStateNormal];
    [self.QQBtn setTitleColor:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_TextColorLoginSecondary] forState:UIControlStateNormal];
    [self.QQBtn setImage:[UIImage imageNamed:@"resource.bundle/ic_sigin_qq.png"] forState:UIControlStateNormal];
    
    //初始化
//    tencentOAuth = [[TencentOAuth alloc]initWithAppId:TENCENT_APPID andDelegate:self];
//    permissions = [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t", nil];

}

#pragma mark ---event response
- (void)tap{
    if ([self.delegate respondsToSelector:@selector(tapThirdPartyLabel)]) {
        [self.delegate tapThirdPartyLabel];
    }
}

//微信按钮点击
- (IBAction)weixinBtnClick {
    if ([self.delegate respondsToSelector:@selector(weixinBtnClick)]) {
        [self.delegate weixinBtnClick];
    }
}
//微博按钮点击
- (IBAction)weiboBtnClick {
    if ([self.delegate respondsToSelector:@selector(weiboBtnClick)]) {
        [self.delegate weiboBtnClick];
    }
}
//QQ按钮点击
- (IBAction)QQBtnClick {
    if ([self.delegate respondsToSelector:@selector(weiboBtnClick)]) {
        [self.delegate QQBtnClick];
    }
    NSLog(@"loginAct");
//    [tencentOAuth authorize:permissions inSafari:NO];
}
//
//#pragma mark -- TencentSessionDelegate
////登陆完成调用
//- (void)tencentDidLogin
//{
//    
//    if (tencentOAuth.accessToken && 0 != [tencentOAuth.accessToken length])
//    {
//        //  记录登录用户的OpenID、Token以及过期时间
//        NSLog(@"accessToken--%@",tencentOAuth.accessToken);
//        [tencentOAuth getUserInfo];
//        [UIUtil alert:@"登录成功"];
//    }
//    else
//    {
//        NSLog(@"登录不成功 没有获取accesstoken");
//    }
//}
//
////非网络错误导致登录失败：
//-(void)tencentDidNotLogin:(BOOL)cancelled
//{
//    NSLog(@"tencentDidNotLogin");
//    if (cancelled)
//    {
//        [UIUtil alert:@"用户取消登录"];
//    }else{
//        [UIUtil alert:@"登录失败"];
//    }
//}
//// 网络错误导致登录失败：
//-(void)tencentDidNotNetWork
//{
//    NSLog(@"tencentDidNotNetWork");
//    [UIUtil alert:@"无网络连接，请设置网络"];
//}
//
//-(void)getUserInfoResponse:(APIResponse *)response
//{
//    
//    NSLog(@"respons:%@",response.jsonResponse);
//}


//#pragma mark -- TencentSessionDelegate
////登陆完成调用
//- (void)tencentDidLogin
//{
//    
//    if (tencentOAuth.accessToken && 0 != [tencentOAuth.accessToken length])
//    {
//        //  记录登录用户的OpenID、Token以及过期时间
//        NSLog(@"accessToken--%@",tencentOAuth.accessToken);
//        [tencentOAuth getUserInfo];
//        [UIUtil alert:@"登录成功"];
//    }
//    else
//    {
//        NSLog(@"登录不成功 没有获取accesstoken");
//    }
//}
//
////非网络错误导致登录失败：
//-(void)tencentDidNotLogin:(BOOL)cancelled
//{
//    NSLog(@"tencentDidNotLogin");
//    if (cancelled)
//    {
//        [UIUtil alert:@"用户取消登录"];
//    }else{
//        [UIUtil alert:@"登录失败"];
//    }
//}
//// 网络错误导致登录失败：
//-(void)tencentDidNotNetWork
//{
//    NSLog(@"tencentDidNotNetWork");
//    [UIUtil alert:@"无网络连接，请设置网络"];
//}
//
//-(void)getUserInfoResponse:(APIResponse *)response
//{
//    
//    NSLog(@"respons:%@",response.jsonResponse);
//}

@end
