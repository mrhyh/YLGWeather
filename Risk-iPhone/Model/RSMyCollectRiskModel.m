//
//  RSMyCollectRiskModel.m
//  Risk
//
//  Created by Cherie Jeong on 16/8/8.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSMyCollectRiskModel.h"

@implementation RSMyCollectRiskModel


+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"risks" : [Risks class]};
}
@end


@implementation Risks

@end


