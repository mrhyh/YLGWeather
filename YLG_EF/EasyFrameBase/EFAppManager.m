//
//  EFAppManager.m
//  EasyFrame
//
//  Created by Jack on 3/3/16.
//  Copyright © 2016 KingYon LTD. All rights reserved.
//

#import "EFAppManager.h"
typedef NS_ENUM(NSInteger,EFMainLayoutType){
    EFSingleViewType = 0,
    EFSideViewType = 1,
    EFTabBarViewType = 2,
    EFSideAndTabBarViewType = 3
};

@interface EFAppManager()
/**
 *  与plist文件中的key对应
 */
@property (nonatomic,strong)NSNumber * Style;
/**
 *  当前根控制器
 */
@property (nonatomic,strong)UIViewController *home;

@end
@implementation EFAppManager

static EFAppManager *appManager;

+ (EFAppManager *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appManager = [[self alloc] init];
    });
    return appManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *plistPath = nil;
        plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame_" ofType:@"plist"];
        //如果没有创建EasyFrame_.plist文件，那么直接加载框架内部自带的
        if (plistPath == nil) {
            plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame" ofType:@"plist"];
        }
        NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath][@"MainLayout"];
        self.Style = [dictionary objectForKey:@"Style"];
        [self mianLayoutStyle:self.Style];
    }
    return self;
}

- (void)mianLayoutStyle:(NSNumber*)_style{
    switch ([_style intValue])
    {
        case EFSingleViewType:
        {
            EFHomeTabBarController *home = [[EFHomeTabBarController alloc] init];
            self.home = home;
        }
            break;
            
        case EFSideViewType:
        {
            EFHomeSideViewController *home = [[EFHomeSideViewController alloc] init];
            self.sideHome = home;
            self.home = home;
        }
            break;
        case EFTabBarViewType:
        {
            EFHomeTabBarController *home = [EFHomeTabBarController shareInstance];
            self.home = home;
            self.tabHome = home;
        }
            break;
        case EFSideAndTabBarViewType:
        {
            EFHomeSideAndTabViewController *home = [[EFHomeSideAndTabViewController alloc] init];
            self.sideAndTabHome = home;
            self.home = home;
        }
            break;
    
        default:
            break;
    }
}

- (UIViewController *)getRootViewController{
    return self.home;
}


+ (void)pushViewController : (UIViewController *)viewController Animated:(BOOL)animated{
    UINavigationController *nav = (UINavigationController *)[EFAppManager shareInstance].sideHome.rootViewController;
    [nav pushViewController:viewController animated:animated];
}
@end
