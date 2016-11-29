//
//  RSRecordModel.m
//  Risk
//
//  Created by Cherie Jeong on 16/8/4.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSRecordModel.h"

@implementation RSRecordModel


+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"content" : [Record class]};
}
@end
@implementation Record

@end


