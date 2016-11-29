//
//  EFHomeSideAndTabViewController.m
//  EasyFrame
//
//  Created by MH on 16/4/19.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFHomeSideAndTabViewController.h"


@interface EFHomeSideAndTabViewController () <UITabBarControllerDelegate> {
    NSArray *naviPages;
}


@property (nonatomic,assign) BOOL isShow;

@end

//static EFHomeSideAndTabViewController *mainTab;

@implementation EFHomeSideAndTabViewController

+ (EFHomeSideAndTabViewController*)shareInstance{
    static EFHomeSideAndTabViewController *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[EFHomeSideAndTabViewController alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"EFSideHomeMenuConfig" ofType:@"plist"];
        NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        
        naviPages = [dictionary objectForKey:@"naviPages"];
        
//        [self setUp];
        
        EFHomeTabBarController * tabbarViewController = [[EFHomeTabBarController alloc]init];
        EFBaseNavigationController * rootViewController = [[EFBaseNavigationController alloc] initWithRootViewController:[[EFHomeTabBarController alloc] init]];
        
        self.rootViewController = rootViewController;
        self.tabbarViewController = tabbarViewController;
        
        [self.view addSubview:self.rootViewController.view];
        [self addChildViewController:self.rootViewController];
        [self addChildViewController:self.tabbarViewController];
        
        
        self.rootViewController.navigationBar.hidden = YES;
        
        EFSideTabViewController * leftViewController = [[EFSideTabViewController alloc] init];
        EFBaseNavigationController * leftNavVC = [[EFBaseNavigationController alloc] initWithRootViewController:[[EFSideTabViewController alloc] init]];
        
        self.leftViewController = leftViewController;
        
        [self.view insertSubview:self.leftViewController.view atIndex:0];
        [self addChildViewController:leftNavVC];
        
        self.leftViewController.view.exclusiveTouch = YES;
        
        UIPanGestureRecognizer *hiddenLeftViewPan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenLeftViewByPan:)];
        
        [self.leftViewController.view addGestureRecognizer:hiddenLeftViewPan];
        
    }
    
//     mainTab = self;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.delegate = self;
}

//- (void)setUp{
//    self.tabBar.translucent= NO;
//    NSString *plistPath = nil;
//    plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame_" ofType:@"plist"];
//    //如果没有创建EasyFrame_.plist文件，那么直接加载框架内部自带的
//    if (plistPath == nil) {
//        plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame" ofType:@"plist"];
//    }
//    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath][@"MainLayout"];
//    //加载底部Tabbar框架的配置
//    dictionary = [dictionary objectForKey:@"TabHome"];
//    NSArray * tabnaviPages = [dictionary objectForKey:@"VCClassName"];
//    NSArray * TitleArray = [dictionary objectForKey:@"TitleArray"];
//    NSArray * NormalImageArray = [dictionary objectForKey:@"NormalImageArray"];
//    NSArray * SelectedImageArray = [dictionary objectForKey:@"SelectedImageArray"];
//    NSMutableArray * viewControllers = [NSMutableArray array];
//    for (int i = 0; i < tabnaviPages.count; i++) {
//        const char *className = [[tabnaviPages objectAtIndex:i] cStringUsingEncoding:NSUTF8StringEncoding];
//        Class aClass = objc_getClass(className);
//        UIViewController *vc = [[aClass alloc]init];
//        vc.title = TitleArray[i];
//        EFBaseNavigationController *nav = [[EFBaseNavigationController alloc] initWithRootViewController:vc];
//        //        选择之前的图片
//        [nav.tabBarItem setImage:[Img(NormalImageArray[i]) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//        //选择之后的图片
//        [nav.tabBarItem setSelectedImage:[Img(SelectedImageArray[i]) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//        ////        选择后字体的颜色
//        [nav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_TextColorTabberSelected] forKey:NSForegroundColorAttributeName] forState:UIControlStateHighlighted];
//        //选择前字体的颜色
//        [nav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_TextColorTabberNormal] forKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
//        
//        [viewControllers addObject:nav];
//    }
//    self.viewControllers = viewControllers;
//}


- (void)showLeftView {
    
    if (!_isShow) {
        _isShow = YES;
        [UIView animateWithDuration:0.25 animations:^{
            
            UIView *mainView = self.rootViewController.view;
            
            CGAffineTransform translateForm = CGAffineTransformTranslate(mainView.transform, SCREEN_WIDTH/2, 0);
            mainView.transform = translateForm;
            
        }];
    }else {
        [self hiddenLeftView];
    }
    
}


- (void)hiddenLeftView {
    [UIView animateWithDuration:0.25 animations:^{
        self.rootViewController.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        _isShow = NO;
    }];
}

- (void)hiddenLeftViewByPan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translatedPoint = [recognizer translationInView:self.leftViewController.view];
    if (translatedPoint.x < 0) {
        [self hiddenLeftView];
    }
    
}


- (void)navigateToViewControllerWithIndex : (int)_pageIndex{
    
    [self hiddenLeftView];
    
    const char *className = [[naviPages objectAtIndex:_pageIndex] cStringUsingEncoding:NSUTF8StringEncoding];
    Class aClass = objc_getClass(className);
    
    UIViewController *vc = [[aClass alloc]init];
    [self.rootViewController pushViewController:vc animated:YES];
    
    
}

@end
