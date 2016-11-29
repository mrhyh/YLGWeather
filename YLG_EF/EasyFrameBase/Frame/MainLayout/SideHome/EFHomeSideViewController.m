//
//  EFHomeSideViewController.m
//  Symiles
//
//  Created by Jack on 3/4/16.
//  Copyright © 2016 KingYon LTD. All rights reserved.
//

#import "EFHomeSideViewController.h"
#import "HomeViewController.h"
#import "EFBaseNavigationController.h"


@interface EFHomeSideViewController () {
    NSArray *naviPages;
}

@end

@implementation EFHomeSideViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"EFSideHomeMenuConfig" ofType:@"plist"];
        NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        
        naviPages = [dictionary objectForKey:@"naviPages"];
        
        self.rootViewController = [[EFBaseNavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
        self.leftViewController = [[EFSideMenuViewController alloc] init];

        self.leftViewShowWidth = SCREEN_WIDTH/5*4;
        self.needSwipeShowMenu = NO;//默认开启的可滑动展示
        //动画效果可以被自己自定义，具体请看api
        [self setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        
        [self setRootViewMoveBlock:^(UIView *rootView, CGRect orginFrame, CGFloat xoffset) {
            //使用简单的平移动画
            rootView.frame=CGRectMake(xoffset, orginFrame.origin.y, orginFrame.size.width, orginFrame.size.height);
        }];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigateToViewControllerWithIndex : (int)_pageIndex{
    
    const char *className = [[naviPages objectAtIndex:_pageIndex] cStringUsingEncoding:NSUTF8StringEncoding];
    Class aClass = objc_getClass(className);
    
    UIViewController *vc = [[aClass alloc]init];
    [((UINavigationController*)self.rootViewController) pushViewController:vc animated:YES];
    
    [self hideSideViewController:YES];
    

}

@end
