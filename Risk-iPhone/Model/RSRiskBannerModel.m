//
//  RSRiskBannerModel.m
//  Risk
//
//  Created by ylgwhyh on 16/7/20.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSRiskBannerModel.h"

@implementation RSRiskBannerModel


+ (NSDictionary *)objectClassInArray{
    return @{@"content" : [RiskBannerModel class]};
}
@end
@implementation RiskBannerModel

+ (NSDictionary *)objectClassInArray{
    return @{@"childrens" : [ChildrensModel class]};
}

@end


@implementation ChildrensModel

@end


