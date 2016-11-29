//
//  EFViewControllerManager.h
//  demo
//
//  Created by HqLee on 16/5/19.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EFViewControllerManager : NSObject
//单例
+ (instancetype)shareInstance;
//根控制器
- (UIViewController *)rootViewController;
@end
