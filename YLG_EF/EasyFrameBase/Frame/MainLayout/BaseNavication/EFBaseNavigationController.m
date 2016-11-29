//
//  EFBaseNavigationController.m
//  demo
//
//  Created by HqLee on 16/5/19.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "EFBaseNavigationController.h"

@interface EFBaseNavigationController ()

@end

@implementation EFBaseNavigationController
#pragma mark --- life cycle
- (void)viewDidLoad{
    [super viewDidLoad];
    
}

//push时，隐藏底部tabbar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        [viewController setHidesBottomBarWhenPushed:YES];
    }
    [super pushViewController:viewController animated:YES];
}

- (void)back{
    [self popViewControllerAnimated:YES];
}

//        UIButton *backItem = [UIButton buttonWithType:UIButtonTypeCustom];
//        [backItem setTitle:@"返回" forState:UIControlStateNormal];
//        [backItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
////        [backItem setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
////        [backItem setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
////        [backItem setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
//        backItem.size = backItem.currentImage.size;
//        backItem.width = 60;
//        backItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//控制类专用
//        backItem.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);//靠左边近点//暂时只有这个方法!
//        [backItem addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backItem];
@end
