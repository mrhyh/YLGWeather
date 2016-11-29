//
//  RSHuanXinVC.m
//  Risk
//
//  Created by ylgwhyh on 16/8/4.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSHuanXinVC.h"
#import "EMClient.h"
#import "RSRiskViewModel.h"


@interface RSHuanXinVC ()

@property (nonatomic, strong) EMGroup *chatGroup;
@property (nonatomic,strong) RSRiskViewModel * viewModel;

@end


@implementation RSHuanXinVC

+ (void  ) rs_asyncJoinPublicGroup {
    [[EMClient sharedClient].groupManager joinPublicGroup:HuanXin_Group_Id completion:^(EMGroup *aGroup, EMError *aError) {
        if ( [UIUtil isEmptyStr:aError.errorDescription] ) {
            NSLog(@"加入群组成功");
            [MFUserDefaults setBool:NO forKey:MFHuanXin_IsNotLoginSuccessUserdefaultKey];
            [MFUserDefaults synchronize];
        }else {
            NSLog(@"加入群组失败，原因:%@",aError.errorDescription);
            [MFUserDefaults setBool:YES forKey:MFHuanXin_IsNotLoginSuccessUserdefaultKey];
            [MFUserDefaults synchronize];
        }
    }];
}

+ (void) rs_loginEasemob {
    WS(weakSelf)
    NSLog(@"环信账号：%@ 环信密码：%@",[RS_UserModel ShareUserModel].easemobId, [RS_UserModel ShareUserModel].easemobPwd);
    
    [[EMClient sharedClient] loginWithUsername:[RS_UserModel ShareUserModel].easemobId password:[RS_UserModel ShareUserModel].easemobPwd  completion:^(NSString *aUsername, EMError *aError) {
        if ([UIUtil isEmptyStr:aError.errorDescription] ) {
            NSLog(@"环信登录成功");
            [[NSNotificationCenter defaultCenter] postNotificationName:MFRequestGetUserProfileByEasemobNotificationKey object:nil];
            [weakSelf rs_asyncJoinPublicGroup];
        }else {
            NSLog(@"环信登录失败，原因:%@",aError.errorDescription);
        }
    }];
    [self rs_asyncSetApnsNickname];
}

+ (void) rs_asyncSetApnsNickname {
    [[EMClient sharedClient] updatePushNotifiationDisplayName:[RS_UserModel ShareUserModel].nickname completion:^(NSString *aDisplayName, EMError *aError) {
        if ([UIUtil isEmptyStr:aError.errorDescription] ) {
            NSLog(@"设置推送昵称成功！");
        }else {
            NSLog(@"设置推送昵称失败！，原因:%@",aError.errorDescription);
        }
    }];
}

@end
