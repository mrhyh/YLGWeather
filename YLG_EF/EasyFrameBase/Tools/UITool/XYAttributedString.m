//
//  XYAttributedString.m
//  WeiXiaoYuan
//
//  Created by 云 on 13-10-16.
//  Copyright (c) 2013年 iFreedom.com. All rights reserved.
//

#import "XYAttributedString.h"
#import <CommonCrypto/CommonDigest.h>

@implementation XYAttributedString

+ (CGSize)sizeWithString:(NSString *)_string andFont:(UIFont *)_font{
    CGSize size;
#ifdef BUILDIOS7
    if (ISIOS7) {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:_font, NSFontAttributeName,nil];
        size = [_string sizeWithAttributes:attributes];
    }
    else
    {
        size = [_string sizeWithFont:_font];
    }
#else
    size = [_string sizeWithFont:_font];
#endif
    return size;
}



+ (CGSize)sizeWithString:(NSString *)_string andFont:(UIFont *)_font andBoundeSize:(CGSize)_size{
    CGSize  size;
#ifdef BUILDIOS7
    if (ISIOS7) {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:_font, NSFontAttributeName,nil];
        CGRect rect = [_string boundingRectWithSize:_size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        size = rect.size;
    }else{
        size = [_string sizeWithFont:_font constrainedToSize:_size lineBreakMode:NSLineBreakByTruncatingTail];
    }
#else
    size = [_string sizeWithFont:_font constrainedToSize:_size lineBreakMode:NSLineBreakByCharWrapping];
#endif
    return size;
}


+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * MOBILE = @"^1(2[0-9]|3[0-9]|4[0-9]|5[0-9]|6[0-9]|7[0-9]|8[0-9]|9[0-9])\\d{8}$";
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56]|7[678])\\d{8}$";
//    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if (([regextestmobile evaluateWithObject:mobileNum] == YES))
//        || ([regextestcm evaluateWithObject:mobileNum] == YES)
//        || ([regextestct evaluateWithObject:mobileNum] == YES)
//        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}



+ (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

+ (BOOL)isPureFloat:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}


+ (NSString*) replaceUnicode:(NSString*)aUnicodeString{
    
    NSString *tempStr1 = [aUnicodeString stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                           
                                                           mutabilityOption:NSPropertyListImmutable
                           
                                                                     format:NULL
                           
                                                           errorDescription:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
    
}

+ (NSString*) replaceSpaceUnicode:(NSString*)aUnicodeString{
    
    return [aUnicodeString stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
}

+ (NSString *)md5:(NSString *)_str{
    
    const char *cStr = [_str UTF8String];
    
    unsigned char result[16];
    
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    
    return [NSString stringWithFormat:
            
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            
            result[0], result[1], result[2], result[3],
            
            result[4], result[5], result[6], result[7],
            
            result[8], result[9], result[10], result[11],
            
            result[12], result[13], result[14], result[15]
            
            ]; 
    
}
@end
