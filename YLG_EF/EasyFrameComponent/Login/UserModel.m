//
//  UserModel.m
//  EasyFrame_iOS2.0
//
//  Created by MH on 16/5/25.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "UserModel.h"
#import <YYModel/YYModel.h>


@implementation UserModel
static UserModel *userModel = nil;

+(void)LoginWithModel:(NSDictionary *)_dic andToken:(NSString *)token {
    
    UserModel *user = [UserModel yy_modelWithJSON:_dic];
    user.token = token;
    user.isLogin = YES;
    userModel = user;
    [self SaveUserModel];
}


+ (UserModel *)ShareUserModel {
    if (!userModel) {
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:EFUserModel];
        if (dic && [dic count]>0) {
            
            UserModel *user = [UserModel yy_modelWithJSON:dic];
            if (user.token && user.token.length > 0) {
                user.isLogin = YES;
            }
            userModel = user;
        }else {
            userModel = [[UserModel alloc]init];
        }
    }
    return userModel;
}

+ (void)SaveUserModel{
    NSDictionary *dic = [userModel getUserModel];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:EFUserModel];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:EFUserModel];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)Logout{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:EFUserModel];
    [[NSUserDefaults standardUserDefaults] synchronize];
    userModel = nil;
}



- (NSDictionary *)getUserModel {
    return [self yy_modelToJSONObject];
}


+ (NSDictionary *)modelCustomPropertyMapper {
    return nil;
}

@end

@implementation Head

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeInteger:self.objectId forKey:@"objectId"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if(self){
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.objectId = [aDecoder decodeIntegerForKey:@"objectId"];
        
    }
    return self;
}



@end
