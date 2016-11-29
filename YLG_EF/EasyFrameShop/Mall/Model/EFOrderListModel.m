//
//  EFOrderListModel.m
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/21.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFOrderListModel.h"

@implementation EFOrderListModel


+ (NSDictionary *)objectClassInArray{
    return @{@"content" : [OrderModel class]};
}
@end
@implementation OrderModel

+ (NSDictionary *)objectClassInArray{
    return @{@"orderProduct" : [OrderproductModel class]};
}

@end


@implementation OrderShop

@end


@implementation OrderproductModel

@end


@implementation OrderImage

@end


