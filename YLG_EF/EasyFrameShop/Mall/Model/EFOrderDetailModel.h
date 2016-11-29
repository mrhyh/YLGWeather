//
//  EFOrderDetailModel.h
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/24.
//  Copyright © 2016年 MH. All rights reserved.
//  订单详情模型

#import <Foundation/Foundation.h>
#import "EFOrderListModel.h"

@class OrderShop,OrderproductModel,OrderImage;
@interface EFOrderDetailModel : NSObject

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, strong) OrderShop *shop;

@property (nonatomic, assign) NSInteger price;

@property (nonatomic, copy) NSString *consignee;

@property (nonatomic, assign) NSInteger objectId;

@property (nonatomic, copy) NSString *orderStatus;

@property (nonatomic, assign) long long createTime;

@property (nonatomic, strong) NSArray<OrderproductModel *> *orderProduct;

@end




