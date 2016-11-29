//
//  SaleModel.m
//  Risk
//
//  Created by Cherie Jeong on 16/8/31.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "SaleModel.h"

@implementation SaleModel


+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"records" : [Records class]};
}
@end

@implementation Records

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"content" : [RecordList class]};
}

@end

@implementation RecordList

@end


