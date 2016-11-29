//
//  RSToolRequest.h
//  Risk
//
//  Created by ylgwhyh on 16/7/20.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "EFRequest.h"

@interface RSToolRequest : EFRequest

+ (NSDictionary *)returnTttpHeaderFieldsWithVersion:(NSString *)version;

@end
