
//  Created by ylgwhyh on 16/6/13.
//  Copyright © 2016年 MH. All rights reserved.
//  返回购物车列表模型

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EFMallModel.h"

@class ShopCartContentModel,Productitem,CartImage,Shopitem;
@interface EFCartModel : NSObject

@property (nonatomic, assign) BOOL select;  //标记这个模型是否被选中
@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *sizeStr;
@property (nonatomic, copy) NSString *nameStr;
@property (nonatomic, copy) NSString *dateStr;
@property (nonatomic, retain)UIImage *image;


@property (nonatomic, assign) NSInteger number;

@property (nonatomic, strong) NSArray<ShopCartContentModel *> *content;

@property (nonatomic, assign) NSInteger numberOfElements;

@property (nonatomic, assign) NSInteger totalPages;

@property (nonatomic, assign) NSInteger size;

@property (nonatomic, assign) BOOL last;

@property (nonatomic, assign) NSInteger totalElements;

@property (nonatomic, assign) BOOL first;


@end

@interface ShopCartContentModel : NSObject

@property (nonatomic, assign) BOOL select;  //标记这个模型是否被选中

@property (nonatomic, assign) NSInteger objectId;

@property (nonatomic, strong) Productitem *productItem;

@property (nonatomic, assign) NSInteger quantity;

@end

@interface Productitem : NSObject

@property (nonatomic, assign) CGFloat score;

@property (nonatomic, assign) NSInteger scoreCount;

@property (nonatomic, assign) NSInteger marketPrice;

@property (nonatomic, assign) NSInteger weight;

@property (nonatomic, assign) NSInteger stock;

@property (nonatomic, assign) NSInteger price;

@property (nonatomic, strong) CartImage *image;

@property (nonatomic, assign) NSInteger totalScore;

@property (nonatomic, assign) NSInteger objectId;

@property (nonatomic, copy) NSString *sn;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) Shopitem *shopItem;

@end

@interface CartImage : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSInteger objectId;
@end



