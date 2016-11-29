//
//  EFViewControllerManager.m
//  demo
//
//  Created by HqLee on 16/5/19.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "EFViewControllerManager.h"
#import "EFLoginViewController.h"
#import "EFLoginWithThirdViewController.h"
#import "EFBaseNavigationController.h"
#import "UserModel.h"
@interface EFViewControllerManager()
//当第一次进入app时，是否需要显示登录界面
@property (nonatomic, assign) BOOL isLoginWhenFirstLaunchApp;
//登录界面是否需要第三方
@property (nonatomic, assign) BOOL isNeedThirdPartyLogin;
//登录界面VC
@property (nonatomic, strong) NSString * loginVCName;
@end
@implementation EFViewControllerManager

static id shareInstance = nil;
//单例
+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
    
}

- (instancetype)init{
    if (self = [super init]) {
        NSString *plistPath = nil;
        plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame_" ofType:@"plist"];
        if (plistPath == nil) {
            plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame" ofType:@"plist"];
        }
        self.isLoginWhenFirstLaunchApp = [[[NSDictionary alloc] initWithContentsOfFile:plistPath][@"MainLayout"][@"isLoginWhenFirstLaunchApp"] boolValue];
        self.isNeedThirdPartyLogin = [[[NSDictionary alloc] initWithContentsOfFile:plistPath][@"MainLayout"][@"isNeedThirdPartyLogin"] boolValue];
        
        self.loginVCName = [[NSDictionary alloc] initWithContentsOfFile:plistPath][@"MainLayout"][@"LoginViewControllerName"];
    }
    return self;
}

//根控制器
- (UIViewController *)rootViewController{
    
    UIViewController *viewController = nil;
    if (![UserModel ShareUserModel].isLogin) {
        //app进入时是否需要先登录
        if(self.isLoginWhenFirstLaunchApp == YES){
            /**
             *  由单个项目继承决定是否需要第三方登录
             */
            const char *className = [self.loginVCName cStringUsingEncoding:NSUTF8StringEncoding];
            Class aClass = objc_getClass(className);
            viewController = [[aClass alloc]init];
            
        }else{
            viewController = [[EFAppManager shareInstance] getRootViewController];
        }
    }else{
        viewController = [[EFAppManager shareInstance] getRootViewController];
    }
    return viewController;
}

@end
