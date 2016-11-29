//
//  NSMutableArray+WSMutableArray.h
//  Guwang
//
//  Created by MH on 16/7/29.
//  Copyright © 2016年 MH. All rights reserved.
//  防止数组越界程序崩溃

#import <Foundation/Foundation.h>

@interface NSMutableArray (WSMutableArray)

/**
 *   过滤掉相同的元素
 *
 *   @return 返回一个数组
 */
- (NSMutableArray*)filterTheSameElement;

@end
