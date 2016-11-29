//
//  RSMethod.h
//  Risk
//
//  Created by ylgwhyh on 16/7/25.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//  只有此项目用的公共方法都放于此类

#import <Foundation/Foundation.h>

@interface RSMethod : NSObject


/**
 *  返回当前的年
 *
 *  @return 整型
 */
+ (NSInteger )returnCurrentYear;

/**
 *  SD_Layout返回cell的宽度
 *
 *  @return cell宽度
 */
+ (CGFloat)cellContentViewWith;

/**
 *  根据时间戳返回时间字符串
 *
 *  @param reference reference
 *
 *  @return 日期字符串 (2016-06-07 10:28)
 */
+ (NSString *)returnDateStringWithTimestamp:(NSString *)timeStr;

/**
 *  返回时间戳
 *
 *  @param dataString 例如"2015.4.5"
 *
 *  @return 时间戳
 */
+ (long long)ylg_returnTimeStampWithDateString:(NSString *)dataString;


/**
 *  提示框
 *
 *  @param title
 *  @param message 样例@"默认样式\r这个是第二行\r这个是第三行"，这个是三行
 */
+ (UIAlertController *)ylg_presentAlertControllerWithTitle:(NSString *)title message:(NSString *)message;


/**
 *  返回点赞次数字符串
 *
 *  @param praisedCount (例如：1000返回1k（字符串）)
 */
+ (NSString *) ylg_returnPraisedCountString:(CGFloat ) praisedCount;

#pragma mark SVProgressHUD 简单封装(根据Risk项目需求)

/**
 *  显示提示信息
 *
 *  @param status 显示其实内容
 */
+ (void)ylg_showSuccessWithStatus:(NSString *)status;

+ (void)ylg_showErrorWithStatus:(NSString *)status;

+ (void)ylg_SVProgressHUD_showWithSVProgressHUDMaskType:(SVProgressHUDMaskType )SVProgressHUDMaskType;

+ (void)ylg_SVProgressHUD_showWithSVProgressHUDMaskTypeNone;

/********************时间日期**********************/
/**
 * 对比两个NSData先后
 */
+ (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;

+ (NSDate *)ylg_returnDateWithTime:(NSString *)timeString;

/********************小红点**********************/
+ (void)rs_refreshTrackPoint:(NSInteger)number;

/********************阅读人数**********************/
+ (NSString *)readCount:(NSInteger )readCount;

/********************文件大小**********************/
+ (NSString *)fileSize:(NSInteger)fileSize;
+ (NSString *)fileSizeString:(NSString *)fileSizeString;
@end
