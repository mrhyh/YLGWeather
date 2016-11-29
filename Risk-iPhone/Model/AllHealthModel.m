//
//  AllHealthModel.m
//  Risk
//
//  Created by Cherie Jeong on 16/8/3.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "AllHealthModel.h"

@implementation AllHealthModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"children" : [Children class]};
}

@end


@implementation Children

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"children" : [Children class]};
}

@end


