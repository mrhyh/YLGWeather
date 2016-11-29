//
//  AppDelegate+EaseMob.m
//  Risk
//
//  Created by ylgwhyh on 16/7/14.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "AppDelegate+EaseMob.h"
#import "EMOptions.h"
#import "EMClient.h"

@implementation AppDelegate (EaseMob)

- (void)initEaseMob{
    
    EMOptions *options = [EMOptions optionsWithAppkey:HuanXin_AppKey];
    options.apnsCertName = HuanXin_Risk_aps;
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    [self registerRemoteNotification];

}

// 注册推送
- (void)registerRemoteNotification{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    else{
        
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
}

@end
