//
//  GoodModel.h
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/13.
//  Copyright © 2016年 MH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodModel : NSObject

@property (nonatomic, copy) NSString *imageString;
@property (nonatomic, copy) NSString *goodNameString;
@property (nonatomic, assign) int goodPriceInt;
@property (nonatomic, assign) int goodNumInt;
@property (nonatomic, assign) int goodSumInt;

/**是否支付*/
@property (nonatomic, assign) BOOL isPay;
/**是否收货*/
@property (nonatomic, assign) BOOL isGetGood;
/**是否评价*/
@property (nonatomic, assign) BOOL isAppraise;
/**申请售后*/
@property (nonatomic, assign) BOOL isAftermarket;

@end
