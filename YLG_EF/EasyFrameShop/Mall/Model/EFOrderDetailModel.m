//
//  EFOrderDetailModel.m
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/24.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFOrderDetailModel.h"

@implementation EFOrderDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"orderProduct" : [OrderproductModel class]};
}

@end


