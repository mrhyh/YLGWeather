//
//  main.m
//  Risk-iPhone
//
//  Created by Cherie Jeong on 16/8/23.
//  Copyright © 2016年 Cherie Jeong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

CFAbsoluteTime StartTime;

int main(int argc, char * argv[]) {
    StartTime = CFAbsoluteTimeGetCurrent(); //记录App启动时间
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
