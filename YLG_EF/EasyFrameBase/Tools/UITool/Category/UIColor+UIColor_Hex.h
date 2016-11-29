//
//  UIColor+UIColor_Hex.h
//  出现持续创新中心
//
//  Created by MH on 16/1/5.
//  Copyright © 2016年 KingYon LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]
#define RGB_COLOR(R, G, B) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f]
#define HEX_COLOR(hex) [UIColor colorWithHexString:hex];
#define HEXA_COLOR(hex,alpha) [UIColor colorWithHexString:hex alpha:alpha];

@interface UIColor (UIColor_Hex)

+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
