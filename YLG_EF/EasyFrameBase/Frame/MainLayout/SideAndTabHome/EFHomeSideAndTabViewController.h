//
//  EFHomeSideAndTabViewController.h
//  EasyFrame
//
//  Created by MH on 16/4/19.
//  Copyright © 2016年 MH. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "EFBaseViewController.h"
#import "EFBaseNavigationController.h"
#import "EFHomeTabBarController.h"
#import "EFSideTabViewController.h"
#import "EFBaseViewController.h"

@interface EFHomeSideAndTabViewController : EFBaseViewController

+ (EFHomeSideAndTabViewController*)shareInstance;

//外部调用可用
@property (nonatomic,strong) EFBaseNavigationController * rootViewController;
@property (nonatomic,strong) EFHomeTabBarController * tabbarViewController;
@property (nonatomic,strong) EFSideTabViewController * leftViewController;

- (void)navigateToViewControllerWithIndex : (int)_pageIndex;

- (void)showLeftView;

- (void)hiddenLeftView;

@end
