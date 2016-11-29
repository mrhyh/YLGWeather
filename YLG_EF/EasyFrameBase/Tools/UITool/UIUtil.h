//
//  UIUtil.h
//  QuickFlip
//
//  Created by 李传政 on 15-3-20.
//  Copyright (c) 2015年 李传政. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#if NS_BLOCKS_AVAILABLE
typedef void (^BarButtonItemTouchBlock)();
#endif


@interface UIUtil : NSObject

/**
 *  nav导航上button
 *
 *  @param view   添加方法的id
 *  @param title  名称
 *  @param image  图片
 *  @param action 方法
 *
 *  @return bar
 */

+ (UIBarButtonItem *) barButtonItem:(id)view WithTitle:(NSString *)title withImage:(UIImage *)image withBlock:(BarButtonItemTouchBlock)action isLeft:(BOOL)_isleft;


/**
 *  检测str是否为空或不空
 *
 *  @param str 需要检测的str
 *
 *  @return 是否为空
 */

+ (BOOL) isEmptyStr:(NSString *)str;
+ (BOOL) isNoEmptyStr:(NSString *)str;


/**
 *  类似安卓toast效果显现
 *
 *  @param message 显示信息
 *  @param image   显示图片
 */
+ (void) alert:(NSString*)message;
+ (void) alert:(NSString*)message image:(UIImage*)image;

/**
 *  获取一段字符串的长度
 *
 *  @param text 目标字符串
 *  @param font 字体大小
 *  @param linespacing 间距
 *  @param width 宽度
 *
 *  @return 长度
 */
+ (float)getWidthOfText:(NSString *)text font:(UIFont *)font;
+ (float)getWidthOfText:(NSString *)text font:(UIFont *)font lineSpacing:(float)linespacing width:(float)width;

+ (BOOL)isMobileNumber : (NSString *)_mobile;

/**
 *  获取一段md5
 *
 *  @param str 目标字符串
 *
 *  @return md5码
 */
+ (NSString *)md5:(NSString *)str;


/**
 *  获取一段md5
 *
 *  @param reference 目标日起
 *
 *  @return 日期之前
 */
+ (NSString *)prettyDateWithReference:(NSDate *)reference;

/**
 *  获取时间
 *
 *  @param reference reference 目标日起
 *
 *  @return 日期格式返回
 */
+ (NSString *)HJRprettyDateWithReference:(NSDate *)reference;


/**
 *  根据时间戳返回时间字符串
 *
 *  @param reference reference
 *
 *  @return 日期字符串 (2016-06-07 10:28)
 */
+ (NSString *)prettyDateNoChangeWithReference:(NSDate *)reference;

/**
 *  根据时间戳返回时间字符串
 *
 *  @param reference reference
 *  @param dateFormat 格式@"yyyy-MM-dd HH:mm"
 *
 *  @return 日期字符串
 */
/*
 用法：
 long long time = self.viewModel.orderDetailModel.createTime;
 NSDate * data = [NSDate dateWithTimeIntervalSince1970:time/1000.0];
 NSString *timeString = [UIUtil prettyDateNoChangeWithReference:data];
 */
+ (NSString *)prettyDateChangeWithReference:(NSDate *)reference setDateFormat:(NSString *)dateFormat;


/**
 *  获取时间
 *
 *  @param date 毫秒时间
 *
 *  @return 返回时间
 */
+ (NSString *)getDateFromMiao:(NSString *)date;

/**
 *  获取当前时间戳
 *
 *  @return 当前时间戳
 */
+ (NSString *)getNowDateMiao;

/**
 *  获取时间
 *
 *  @param date 毫秒时间
 *
 *  @return 返回毫秒
 */
+ (NSString *)getDateFromDate:(NSString *)date isHms:(BOOL)isHms;

@end
