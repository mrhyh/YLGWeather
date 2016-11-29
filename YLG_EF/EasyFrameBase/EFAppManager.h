//
//  EFAppManager.h
//  EasyFrame
//
//  Created by Jack on 3/3/16.
//  Copyright © 2016 KingYon LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EFHomeSideViewController.h"
#import "EFHomeSingleViewController.h"
#import "EFHomeTabBarController.h"
#import "EFHomeSideAndTabViewController.h"


@interface EFAppManager : NSObject
/**
 *  创建EFAppManager单例对象
 *
 *  @return EFAppManager单例对象
 */
+ (EFAppManager *)shareInstance;
/**
 *  可能会根据实际需要拿到当前根控制器进行操作
 */
@property (nonatomic,strong)EFHomeSideViewController *sideHome;
@property (nonatomic,strong)EFHomeSingleViewController *singleHome;
@property (nonatomic,strong)EFHomeTabBarController *tabHome;
@property (nonatomic,strong)EFHomeSideAndTabViewController *sideAndTabHome;

/**
 *  获取项目的根控制器
 *
 *  @return 根控制器
 */
- (UIViewController *)getRootViewController;
/**
 *  进行push操作，直接获取根控制器进行操作，使用时需注意当前控制器是否为根控制器
 *
 *  @param viewController 需要push的下一个界面的控制器
 *  @param animated       是否需要动画
 */
+ (void)pushViewController : (UIViewController *)viewController Animated:(BOOL)animated;

@end
