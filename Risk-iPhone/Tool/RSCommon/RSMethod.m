//
//  RSMethod.m
//  Risk
//
//  Created by ylgwhyh on 16/7/25.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSMethod.h"
#import "SVProgressHUD.h"

@implementation RSMethod

+ (NSInteger )returnCurrentYear {
    
    NSString *dateString = [UIUtil prettyDateChangeWithReference:[NSDate date] setDateFormat:@"yyyy"];
    NSInteger yellowInteger = [dateString integerValue];
    return yellowInteger;
}


+ (CGFloat)cellContentViewWith {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    
    return width;
}

+ (NSString *)returnDateStringWithTimestamp:(NSString * )timeStr {
    
    
    long long time = [timeStr longLongValue];
    
    if ( time <= 0 ) {
        return @"";
    }
    
    NSDate * data = [NSDate dateWithTimeIntervalSince1970:time/1000.0];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSString *destDateString = [dateFormatter stringFromDate:data];
    
    return destDateString;
}

+ (long long)ylg_returnTimeStampWithDateString:(NSString *)dataString {
    
    NSString* timeStr = dataString;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY.MM.dd"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/BeiJing"];
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:timeStr]; //------------将字符串按formatter转成nsdate
    
    long long time = [date timeIntervalSince1970] * 1000;
    //时间戳字符串
    //NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    //NSLog(@"timeSp:%@",timeSp); //时间戳的值
    //long long型时间戳
    return time;
}



+ (UIAlertController *)ylg_presentAlertControllerWithTitle:(NSString *)title message:(NSString *)message {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancel];
    
    return alertController;
}


+ (NSString *) ylg_returnPraisedCountString:(CGFloat ) praisedCount {
    
    if (praisedCount <= 0) {
        praisedCount = 0;
        return [NSString stringWithFormat:@"%ld",(long)praisedCount];
    }else if (praisedCount > 1000) {
        praisedCount = praisedCount/1000;
        return [NSString stringWithFormat:@"%.2f",praisedCount];
    }else {
        return [NSString stringWithFormat:@"%ld",(long)praisedCount];
    }
}

+ (void) ylg_showSuccessWithStatus:(NSString *)status {
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD showSuccessWithStatus:status];
        [SVProgressHUD dismissWithDelay:2.0];
    });
}

+ (void)ylg_showErrorWithStatus:(NSString *)status {
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD showErrorWithStatus:status];
        [SVProgressHUD dismissWithDelay:2.0];
    });
}


+ (void)ylg_SVProgressHUD_showWithSVProgressHUDMaskType:(SVProgressHUDMaskType )SVProgressHUDMaskType {
    
    if (SVProgressHUDMaskType <= 0 ) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    }else {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskType];
    }
    [SVProgressHUD show];
}

+ (void)ylg_SVProgressHUD_showWithSVProgressHUDMaskTypeNone {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
}


+ (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
}

+ (NSDate *)ylg_returnDateWithTime:(NSString *)timeString {
    
    NSString* timeStr = timeString;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY.MM.dd"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/BeiJing"];
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:timeStr];
    return date;
}


/********************小红点**********************/
+ (void)rs_refreshTrackPoint:(NSInteger)number {
//    UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
//    UITabBarController *tabController = (UITabBarController*)rootController;
//    UIViewController *requiredViewController = [tabController.viewControllers objectAtIndex:2];
//    UITabBarItem *item = requiredViewController.tabBarItem;
//    
//    if (number > 0) {
//        [item showBadge];
//        [item setBadgeCenterOffset:CGPointMake(-25, 10)];
//    }else {
//        [item clearBadge];
//    }
    
}

/********************阅读人数**********************/
+ (NSString *)readCount:(NSInteger )readCount {
    NSString *string = [[NSString alloc] init];
    if ( readCount <= 0) {
        string = @"0人阅读";
    }else if (readCount >0 && readCount < 1000) {
        string = [NSString stringWithFormat:@"%d人阅读",(int)readCount];
    }else if (readCount >=1000 && readCount < 10000) {
        string = [NSString stringWithFormat:@"%.1f千人阅读",(float)readCount/1000.0];
    }else if (readCount >=10000) {
        string = [NSString stringWithFormat:@"%.1f万人阅读",(float)readCount/10000.0];
    }
    return string;
}

/********************文件大小**********************/
+ (NSString *)fileSize:(NSInteger)fileSize {
    NSString *string = [[NSString alloc] init];
    if (fileSize <= 0) {
        string = @"";
        return string;
    }else {
        string = [NSString stringWithFormat:@"%.1f Mb",(float)fileSize/(1024.0*1024.0)];
    }
    return [NSString stringWithFormat:@"大小:%@",string];
}

+ (NSString *)fileSizeString:(NSString *)fileSizeString {
    NSInteger fileSize = [fileSizeString integerValue];
    NSString *string = [[NSString alloc] init];
    if (fileSize <= 0) {
        string = @"";
        return string;
    }else {
        string = [NSString stringWithFormat:@"%.1f Mb",(float)fileSize/(1024.0*1024.0)];
    }
    return [NSString stringWithFormat:@"大小:%@",string];
}
@end
