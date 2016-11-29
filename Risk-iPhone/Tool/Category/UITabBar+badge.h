//
//  UITabBar+badge.h
//  Risk-iPhone
//
//  Created by Cherie Jeong on 16/9/12.
//  Copyright © 2016年 Cherie Jeong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar(badge)

- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end
