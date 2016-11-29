//
//  HTConfig.m
//  Haitangshequ
//
//  Created by zhaoxiaoyun on 14-3-13.
//  Copyright (c) 2014年 zxy. All rights reserved.
//

#import "HTConfig.h"

@implementation HTConfig


#pragma mark-夜间模式切换
+ (BOOL)isDay{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UserDefaults_DayOrNight]) {
        BOOL isDay = [[[NSUserDefaults standardUserDefaults] objectForKey:UserDefaults_DayOrNight] boolValue];
        return isDay;
    }
    return YES;
}

#pragma mark-正文字体
+ (UIFont *)systemFontOfSize:(int)_size{
    UIFont *font = [UIFont systemFontOfSize:[HTConfig handleFontSize:_size]];
    return font;
}


+ (UIFont *)boldSystemFontOfSize:(int)_size{
    UIFont *font = [UIFont boldSystemFontOfSize:[HTConfig handleFontSize:_size]];
    return font;
}


+ (int)handleFontSize:(int)_size{
    switch ([HTConfig getFontSize]) {
        case 0:_size += 2;break;
        case 2:_size -= 2;break;
        default:break;
    }
    return _size;
}

+ (float)getFontPercentage{
    switch ([HTConfig getFontSize]) {
        case 0:return 1.2;
        case 2:return 0.8;
        default:break;
    }
    return 1.0;
}



+ (int)getFontSize{
    id userDefaults = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaults_FontSize];
    if (userDefaults && [userDefaults isKindOfClass:[NSNumber class]]) {
        userDefaults = (NSNumber *)userDefaults;
//        if ([userDefaults isEqualToString:@"大"]) {
//            return 0;
//        }
//        if ([userDefaults isEqualToString:@"小"]) {
//            return 2;
//        }
        return [userDefaults intValue];
    }
    return 1;
}

+ (void)setFontSizeWithNum:(int)_num
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:_num] forKey:UserDefaults_FontSize];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



@end
