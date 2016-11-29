//
//  WebUtil.h
//  EF_MallDemo
//
//  Created by MH on 16/6/14.
//  Copyright © 2016年 MH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebUtil : NSObject
/**
 *  HTML获取自适应的图片
 *
 *  @param date 文本
 *
 *  @return 正常的文本
 */
+ (NSString *)getNormalImage:(NSString *)date;
@end
