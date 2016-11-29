//
//  RSToolRequest.m
//  Risk
//
//  Created by ylgwhyh on 16/7/20.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSToolRequest.h"

@implementation RSToolRequest

+ (NSDictionary *)returnTttpHeaderFieldsWithVersion:(NSString *)version{
    
    NSString * token = @"";
    token = MFRiskLoginToken;
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    
    if ( (version == nil) || [version isEqualToString:@""] || [version isEqualToString:@" "] ) {
        version = @"1.0";
    }
    
    NSDictionary *dic = [[NSDictionary alloc] init];
    dic =  @{@"version":version,@"token":token};
    
    return dic;
}


@end
