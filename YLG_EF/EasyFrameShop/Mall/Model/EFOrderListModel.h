//
//  EFOrderListModel.h
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/21.
//  Copyright © 2016年 MH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrderModel,OrderShop,OrderproductModel,OrderImage;
@interface EFOrderListModel : NSObject

@property (nonatomic, assign) NSInteger number;

@property (nonatomic, strong) NSArray<OrderModel *> *content;

@property (nonatomic, assign) NSInteger numberOfElements;

@property (nonatomic, assign) NSInteger totalPages;

@property (nonatomic, assign) NSInteger size;

@property (nonatomic, assign) BOOL last;

@property (nonatomic, assign) NSInteger totalElements;

@property (nonatomic, assign) BOOL first;

@end

/*整个产品*/
@interface OrderModel : NSObject

@property (nonatomic, copy) NSString *orderStatus;

/*具体某个商品信息*/
@property (nonatomic, strong) NSArray<OrderproductModel *> *orderProduct;

@property (nonatomic, assign) NSInteger objectId;

@property (nonatomic, strong) OrderShop *shop;

@property (nonatomic, assign) NSInteger price;

@end

@interface OrderShop : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *contact;

@property (nonatomic, assign) NSInteger objectId;

@property (nonatomic, copy) NSString *address;

@end

@interface OrderproductModel : NSObject

@property (nonatomic, copy) NSString *sn;

@property (nonatomic, assign) NSInteger quantity;

@property (nonatomic, assign) NSInteger objectId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) OrderImage *image;

@property (nonatomic, assign) NSInteger price;

@property (nonatomic, assign) NSInteger orderItemId;

@property (nonatomic, assign) BOOL hasCommented;

//评论所需的字段
@property (nonatomic, assign) CGFloat score;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) BOOL isAnonymous;

@end

@interface OrderImage : NSObject

@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSInteger objectId;

@end

