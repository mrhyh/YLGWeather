//
//  UserModel.h
//  EasyFrame_iOS2.0
//
//  Created by MH on 16/5/25.
//  Copyright © 2016年 MH. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LoginNotificationFromLogin @"LoginNotificationFromLogin"
#define LogoutNotificationFromLogout @"LogoutNotificationFromLogout"

#define EFUserModel @"EFUserModel"

@class Head,Objectid,Objectid;

@interface UserModel : NSObject
@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, assign) long long birthDate;

@property (nonatomic, assign) long long birthDateLong;

@property (nonatomic, strong) Head *head;

@property (nonatomic, assign) NSInteger objectId;

@property (nonatomic, copy) NSString *sign;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic,strong)NSString *token;

@property (nonatomic,assign)BOOL isLogin;

@property (nonatomic,assign)BOOL isDurgUpdate;

+ (UserModel *)ShareUserModel;
+ (void)Logout;
+ (void)LoginWithModel:(NSDictionary *)_dic andToken:(NSString *)token;
+ (void)SaveUserModel;
- (NSDictionary *)getUserModel;
@end

@interface Head : NSObject <NSCoding>

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) int objectId;

@end
