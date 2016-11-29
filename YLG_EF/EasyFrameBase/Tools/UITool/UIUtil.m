//
//  UIUtil.m
//  QuickFlip
//
//  Created by 李传政 on 15-3-20.
//  Copyright (c) 2015年 李传政. All rights reserved.
//

#import "UIUtil.h"
#import "TKAlertCenter.h"
#import "BlockButton.h"
#import <CommonCrypto/CommonDigest.h>
#import "XYAttributedString.h"

@implementation UIUtil

+ (UIBarButtonItem *) barButtonItem:(id)view WithTitle:(NSString *)title withImage:(UIImage *)image withBlock:(BarButtonItemTouchBlock)action isLeft:(BOOL)_isleft{
    BlockButton *btn= [[BlockButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    
    UIColor * color = EF_TextColor_TextColorNavigation;
    UIColor * color1 = EF_MainColor;
    
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:color1 forState:UIControlStateHighlighted];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0,-10, 0 , 0)];
    
    if (CurrentSystemVersion < 7.0) {
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 17, 7)];
    }else{
        if (_isleft) {
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
            
        }else{
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
            
        }
    }
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    
    [btn setBlock:^(BlockButton *button){
        action();
    }];
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return barBtnItem ;
}


+ (NSString *) trim:(NSString *)str {
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


+ (BOOL) isEmptyStr:(NSString *)str {
    return ( str==nil || [@"" isEqualToString:[UIUtil trim:str]] );
}

+ (BOOL) isNoEmptyStr:(NSString *)str {
    return ( str!=nil && [UIUtil trim:str].length>0 );
}



+ (void)alert:(NSString*)message
{
    [[TKAlertCenter defaultCenter] postAlertWithMessage:message];
}

+ (void)alert:(NSString*)message image:(UIImage*)image
{
    [[TKAlertCenter defaultCenter] postAlertWithMessage:message image:image];
}



+ (float)getWidthOfText:(NSString *)text font:(UIFont *)font
{
    CGSize titleSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT,40)];
    return titleSize.width;
}


+(float)getWidthOfText:(NSString *)text font:(UIFont *)font lineSpacing:(float)linespacing width:(float)width{
    UILabel * content = [[UILabel alloc] initWithFrame:CGRectMake(0,0, width, 20*SCREEN_H_RATE)];
    content.font = font;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:linespacing];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    content.attributedText = attributedString;
    content.lineBreakMode = NSLineBreakByWordWrapping;
    content.numberOfLines = 0;
    [content sizeToFit];
    return content.frame.size.height;
}

+ (BOOL)isMobileNumber : (NSString *)_mobile{
    return [XYAttributedString isMobileNumber:_mobile];
}


+(NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [[NSString stringWithFormat:            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ]lowercaseString];
}

+ (NSString *)prettyDateWithReference:(NSDate *)reference {
    NSString *suffix = @"之前";
    
    float different = [reference timeIntervalSinceDate:[NSDate date]];
    if (different < 0) {
        different = -different;
        suffix = @"前";
    }
    
    // days = different / (24 * 60 * 60), take the floor value
    float dayDifferent = floor(different / 86400);
    
    int days   = (int)dayDifferent;
    
    
    if (dayDifferent <= 0) {
        if (different < 15*60) {
            return @"刚刚";
        }
        
        if (different < 60 * 60) {
            return [NSString stringWithFormat:@"%d分钟%@", (int)(different / 60), suffix];
        }
        
        if (different < 86400) {
            return [NSString stringWithFormat:@"%d小时%@", (int)(different / 3600), suffix];
        }
        
        
    }
    else if (days < 7) {
        return [NSString stringWithFormat:@"%d天%@", days, suffix];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:reference];
    
    return destDateString;
}

+ (NSString *)HJRprettyDateWithReference:(NSDate *)reference {
    NSString *suffix = @"之前";
    
    float different = [reference timeIntervalSinceDate:[NSDate date]];
    if (different < 0) {
        different = -different;
        suffix = @"前";
    }
    
    // days = different / (24 * 60 * 60), take the floor value
    float dayDifferent = floor(different / 86400);
    
    int days   = (int)dayDifferent;
    
    
    if (dayDifferent <= 0) {
        if (different < 15*60) {
            return @"刚刚";
        }
        
        if (different < 60 * 60) {
            return [NSString stringWithFormat:@"%d分钟%@", (int)(different / 60), suffix];
        }
        
        if (different < 86400) {
            return [NSString stringWithFormat:@"%d小时%@", (int)(different / 3600), suffix];
        }
        
        
    }
    else if (days < 2) {
        return [NSString stringWithFormat:@"昨天"];
    }
    
    NSDateFormatter * newData = [[NSDateFormatter alloc] init];
    [newData setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [newData stringFromDate:[NSDate date]];
    NSLog(@"---当前的时间的字符串 =%@",currentDateStr);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:reference];
     NSLog(@"---记录的时间的字符串 =%@",destDateString);
    
    if ([[currentDateStr substringToIndex:4] isEqualToString:[destDateString substringToIndex:4]]) {
        NSDateFormatter * retuerDateString = [[NSDateFormatter alloc] init];
        [retuerDateString setDateFormat:@"MM-dd"];
        NSString *retuString = [retuerDateString stringFromDate:reference];
        return retuString;
    }else {
         return destDateString;
    }
    
   
}

+ (NSString *)prettyDateChangeWithReference:(NSDate *)reference setDateFormat:(NSString *)dateFormat {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    NSString *destDateString = [dateFormatter stringFromDate:reference];
    
    return destDateString;
}

+ (NSString *)prettyDateNoChangeWithReference:(NSDate *)reference {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //例子：需要2016年5月 [dateFormatter setDateFormat:@"yyyy年-MM月"];
    NSString *destDateString = [dateFormatter stringFromDate:reference];
    
    return destDateString;
}

+ (NSString *)getDateFromMiao:(NSString *)date{
    NSString *happendate = @"";
    if (date) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        long long time =[date longLongValue];
        NSDate * d = [NSDate dateWithTimeIntervalSince1970:time/1000.0];
        NSString *destDateString = [dateFormatter stringFromDate:d];
        happendate = destDateString;
    }
    return happendate;
}

+ (NSString *)getNowDateMiao
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;  //  *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a]; //转为字符型
    return timeString;
}


+ (NSString *)getDateFromDate:(NSString *)date isHms:(BOOL)isHms{
    NSString *happendate = @"";
    if (date) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        if (isHms) {
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        }else{
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        }
        long long time =[date longLongValue];
        NSDate * d = [NSDate dateWithTimeIntervalSince1970:time/1000.0];
        NSString *destDateString = [dateFormatter stringFromDate:d];
        happendate = destDateString;
    }
    return happendate;
}

@end
