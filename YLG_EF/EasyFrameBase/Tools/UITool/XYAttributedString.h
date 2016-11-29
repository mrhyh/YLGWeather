//
//  XYAttributedString.h
//  WeiXiaoYuan
//
//  Created by 云 on 13-10-16.
//  Copyright (c) 2013年 iFreedom.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYAttributedString : NSObject


+ (CGSize)sizeWithString:(NSString *)_string andFont:(UIFont *)_font;
+ (CGSize)sizeWithString:(NSString *)_string andFont:(UIFont *)_font andBoundeSize:(CGSize)_size;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+ (NSString*) replaceUnicode:(NSString*)aUnicodeString;
+ (NSString*) replaceSpaceUnicode:(NSString*)aUnicodeString;
+ (NSString *)md5:(NSString *)_str;

+ (BOOL)isPureInt:(NSString*)string;
+ (BOOL)isPureFloat:(NSString*)string;

@end
