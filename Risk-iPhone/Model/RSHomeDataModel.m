//
//  RSHomeDataModel.m
//  Risk
//
//  Created by ylgwhyh on 16/7/22.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSHomeDataModel.h"

@implementation RSHomeDataModel



+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"filesItems" : [Filesitems class]};
}
@end


@implementation Filesitems

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"fileId":@"id"
             };
}

@end


@implementation Mainimage

@end


