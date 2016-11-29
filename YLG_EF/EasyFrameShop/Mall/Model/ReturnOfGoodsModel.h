//
//  ReturnOfGoodsModel.h
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/27.
//  Copyright © 2016年 MH. All rights reserved.
//  退货单模型

#import <Foundation/Foundation.h>

@class Items;
@interface ReturnOfGoodsModel : NSObject

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *trackingNo;

@property (nonatomic, copy) NSString *shippingMethod;

@property (nonatomic, copy) NSString *regionName;

@property (nonatomic, copy) NSString *shipper;

@property (nonatomic, assign) NSInteger freight;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *applyReason;

@property (nonatomic, copy) NSString *returnsStatus;

@property (nonatomic, copy) NSString *zipCode;

@property (nonatomic, strong) NSArray<Items *> *items;

@end
@interface Items : NSObject

@property (nonatomic, assign) long long sn;

@property (nonatomic, assign) NSInteger quantity;

@property (nonatomic, assign) NSInteger objectId;

@property (nonatomic, copy) NSString *name;

@end

