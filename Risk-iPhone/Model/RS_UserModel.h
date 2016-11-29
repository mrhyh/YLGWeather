//
//  RS_UserModel.h
//  Risk
//
//  Created by Cherie Jeong on 16/7/28.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "UserModel.h"

@interface RS_UserModel : UserModel

@property (nonatomic,assign) long long  beginDate;

@property (nonatomic,copy) NSString * easemobId;

@property (nonatomic,copy) NSString * easemobPwd;

@property (nonatomic,assign) long long endDate;

@property (nonatomic,copy) NSString * versionNumber;

@property (nonatomic,copy) NSString * username;

@property (nonatomic,assign) BOOL isDrugUpdate;

+ (void)SaveHJRUserModel:(NSDictionary *)_dic;
+ (RS_UserModel *)ShareHJRUserModel;
+ (void)LogoutHJR;



+ (RS_UserModel *)ShareUserModel;
+ (void)Logout;
+ (void)LoginWithModel:(NSDictionary *)_dic;
+ (void)SaveUserModel;

@end
