//
//  RS_UserModel.m
//  Risk
//
//  Created by Cherie Jeong on 16/7/28.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RS_UserModel.h"
#import <YYModel/YYModel.h>

#define RSUserModel @"RSUserModel"

static RS_UserModel *rs_userModel = nil;
@implementation RS_UserModel


+ (RS_UserModel *)ShareHJRUserModel {
    return [RS_UserModel ShareUserModel];
}


+ (void)SaveHJRUserModel:(NSDictionary *)_dic {
    [RS_UserModel SaveUserModel];
}

+ (void)LogoutHJR{
    [RS_UserModel Logout];
}



+(void)LoginWithModel:(NSDictionary *)_dic {
    
    RS_UserModel *user = [RS_UserModel yy_modelWithJSON:_dic];
    user.isLogin = YES;
    rs_userModel = user;
    [RS_UserModel SaveUserModel];
}


+ (RS_UserModel *)ShareUserModel {
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:RSUserModel];
    if (dic && [dic count]>0) {
        
        RS_UserModel *user = [RS_UserModel yy_modelWithDictionary:dic];
        if (user.token && user.token.length > 0) {
            user.isLogin = YES;
        }
        rs_userModel = user;
    }else {
        rs_userModel = [[RS_UserModel alloc]init];
    }
    return rs_userModel;
}

+ (void)SaveUserModel{
    NSDictionary *dic = [rs_userModel getUserModel];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:RSUserModel];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:RSUserModel];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)Logout{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:RSUserModel];
    [[NSUserDefaults standardUserDefaults] synchronize];
    rs_userModel = nil;
}

@end
