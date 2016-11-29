//
//  AppDelegate.h
//  Risk-iPhone
//
//  Created by Cherie Jeong on 16/8/23.
//  Copyright © 2016年 Cherie Jeong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) BOOL allowRotation; // 标记是否可以旋转

+ (AppDelegate *)shareInstance;

@end

