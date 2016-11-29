//
//  WebUtil.m
//  EF_MallDemo
//
//  Created by MH on 16/6/14.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "WebUtil.h"

@implementation WebUtil
+ (NSString *)getNormalImage:(NSString *)date{
    if ([date rangeOfString:@"width="].location !=NSNotFound){
        NSRange rangeh = [date rangeOfString:@"height="];
        NSRange rangeh1 = [date rangeOfString:@" src"];
        NSRange rangehX = NSMakeRange(rangeh.location, rangeh1.location-rangeh.location);
        NSString *rangestrh = [date substringWithRange:rangehX];
        rangestrh = [date stringByReplacingOccurrencesOfString:rangestrh withString:@""];
        
        NSRange rangew = [rangestrh rangeOfString:@"width="];
        NSRange rangew1 = [rangestrh rangeOfString:@"></div>"];
        NSRange rangewX = NSMakeRange(rangew.location, rangew1.location-rangew.location);
        NSString *rangestrw = [rangestrh substringWithRange:rangewX];
        rangestrw = [rangestrh stringByReplacingOccurrencesOfString:rangestrw withString:@"width=\"100%\""];
        return rangestrw;
    }else{
        NSRange rangew = [date rangeOfString:@"jpg\""];
        NSRange rangewX = NSMakeRange(rangew.location, rangew.length);
        NSString *rangestrw = [date substringWithRange:rangewX];
        rangestrw = [date stringByReplacingOccurrencesOfString:rangestrw withString:@"jpg\"width=\"100%\""];
        return rangestrw;
    }
}
@end
