//
//  HTConfig.h
//  Haitangshequ
//
//  Created by zhaoxiaoyun on 14-3-13.
//  Copyright (c) 2014年 zxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#define UserDefaults_FontSize  @"UserDefaults_FontSize"
#define UserDefaults_DayOrNight @"UserDefaults_DayOrNight"

#define Notification_DayOrNight @"Notification_DayOrNight"


#define BACKGROUND_Day      [UIColor colorWithWhite:230.f/255 alpha:1]
#define BACKGROUND_Night    [UIColor colorWithWhite:39.f/255 alpha:1]

#define BACKGROUND      [HTConfig isDay] ? BACKGROUND_Day : BACKGROUND_Night
#define ISDAY           [HTConfig isDay]

@interface HTConfig : NSObject

+ (BOOL)isDay;

+ (int)getFontSize;
+ (void)setFontSizeWithNum:(int)_num;
+ (float)getFontPercentage;
+ (UIFont *)systemFontOfSize:(int)_size;
+ (UIFont *)boldSystemFontOfSize:(int)_size;
@end
