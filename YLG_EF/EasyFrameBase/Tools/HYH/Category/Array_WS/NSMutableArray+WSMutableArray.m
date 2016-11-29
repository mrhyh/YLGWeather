//
//  NSMutableArray+WSMutableArray.m
//  Guwang
//
//  Created by MH on 16/7/29.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "NSMutableArray+WSMutableArray.h"
#import "objc/runtime.h"
#import "UIUtil.h"


@implementation NSMutableArray (WSMutableArray)

+ (void)load {
    [super load];
    Method fromMethod = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndex:));
    Method toMethod = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(ws_objectAtIndex:));
    method_exchangeImplementations(fromMethod, toMethod);
}

- (id)ws_objectAtIndex:(NSUInteger)index {
    if (self.count-1 < index || self.count == 0) {
        // 这里做一下异常处理，不然都不知道出错了。
        @try {
            return [self ws_objectAtIndex:index];
        }
        @catch (NSException *exception) {
//            [UIUtil alert:@"数据出现异常"];
            NSLog(@"数据出现异常");
            // 在崩溃后会打印崩溃信息，方便我们调试。
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        }
        @finally {}
    } else {
        return [self ws_objectAtIndex:index];
    }
}

/**
 *   过滤掉相同的元素
 *
 *   @return 返回一个数组
 */
- (NSMutableArray*)filterTheSameElement
{
    NSMutableSet *set = [NSMutableSet set];
    for (NSObject *obj in self) {
        [set addObject:obj];
    }
    [self removeAllObjects];
    for (NSObject *obj in set) {
        [self addObject:obj];
    }
    return self;
}


@end
