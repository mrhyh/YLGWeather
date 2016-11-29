//
//  AppDelegate.m
//  Risk-iPhone
//
//  Created by Cherie Jeong on 16/8/23.
//  Copyright © 2016年 Cherie Jeong. All rights reserved.
//

#import "UMMobClick/MobClick.h"
#import "EFViewControllerManager.h"
#import "AppDelegate.h"
#import "EFViewControllerManager.h"
#import "RSRiskKindVC.h"
#import "EMSDK.h"
#import "EMClient.h"
#import "EaseSDKHelper.h"
#import "RSHuanXinVC.h"
#import "LoginVC.h"
#import "QFPushManager.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

#if DEBUG
#import "FLEXManager.h"
#endif

#define MEASURE_LAUNCH_TIME 1

extern CFAbsoluteTime StartTime;

@interface AppDelegate () <JPUSHRegisterDelegate>

@end

@implementation AppDelegate

+ (AppDelegate *)shareInstance{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
#warning 请勿删除,若不用，注释这句即可
    //[[FLEXManager sharedManager] showExplorer];
    
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:HuanXin_AppKey];
    options.apnsCertName = HuanXin_Risk_aps;
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    if (YES == [RS_UserModel ShareUserModel].isLogin ) {
        [RSHuanXinVC rs_loginEasemob];  //如果已经登录了账号，启动时自动登录环信并加入群组
    }
    
    [MFUserDefaults setBool:NO forKey:MFIsLogoutUserdefaultKey];
    [MFUserDefaults synchronize];
    
    //设置状态栏字体颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent; //状态栏颜色
    self.window.rootViewController = [[EFViewControllerManager shareInstance] rootViewController];
    
    
    //umeng，数据分析
    UMConfigInstance.appKey = UMENG_APPKEY;;
    UMConfigInstance.channelId = @"APP Store";
    UMConfigInstance.ePolicy = BATCH;
    [MobClick startWithConfigure:UMConfigInstance];
    
#if MEASURE_LAUNCH_TIME
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"App启动时间-Launched in %f sec", CFAbsoluteTimeGetCurrent() - StartTime);
    });
#endif
    
    //推送
    //添加初始化APNs代码
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //添加初始化JPush代码
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    //apsForProduction:0 (默认值)表示采用的是开发证书，1 表示采用生产证书发布应用。
    
    BOOL apsForProduction = YES;
#if DEBUG
    apsForProduction = NO;
#endif
    
    
    [JPUSHService setupWithOption:launchOptions appKey:MKJPushAppKey
                          channel:MFJPushNotAppStory
                 apsForProduction:apsForProduction
            advertisingIdentifier:advertisingId];
    
    return YES;
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    //应用在前台收到通知
    NSLog(@"========%@", notification);
    
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    //点击通知进入应用
    NSLog(@"response:%@", response);
}


- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)nowWindow {
    //    是非支持横竖屏
    
    if (_allowRotation) {
        
        return UIInterfaceOrientationMaskAll;
        
    } else{
        
        return UIInterfaceOrientationMaskPortrait;
        
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [QFPushManager handlerPushNotification:userInfo];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        [JPUSHService resetBadge];
        [JPUSHService handleRemoteNotification:userInfo];
    }
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

#pragma mark 接收到远程推送的消息时调用此方法（后台和前台时可用）
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [QFPushManager handlerPushNotification:userInfo];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];
    [JPUSHService handleRemoteNotification:userInfo];
}


#pragma mark 接收到远程推送的消息时调用此方法（前、后、退出都可用，iOS7以后可用）
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    
    NSLog(@"userInfo = %@", userInfo);
    
    [QFPushManager handlerPushNotification:userInfo];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [QFPushManager handlerPushNotification:userInfo];
        [self setApplicationIconBadgeNumber];
        [JPUSHService resetBadge];
        [JPUSHService handleRemoteNotification:userInfo];

    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)setApplicationIconBadgeNumber {
     [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] postNotificationName:MF_UpdateApp object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//iOS8 推送
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

#pragma mark - application notification
// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[EMClient sharedClient] bindDeviceToken:deviceToken];
    NSLog(@"deviceToken---%@",deviceToken);
    
    /// JPush Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    NSLog(@"deviceToken---%@",deviceToken);
}

//deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"deviceToken失败-- %@",error);
}

- (void)handleSixFingerQuadrupleTap:(UITapGestureRecognizer *)tapRecognizer {
    // 请勿删除
#if DEBUG
    if (tapRecognizer.state == UIGestureRecognizerStateRecognized) {
        [[FLEXManager sharedManager] showExplorer];
    }
#endif
}


@end
