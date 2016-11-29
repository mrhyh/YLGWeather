//
//  SaleModel.h
//  Risk
//
//  Created by Cherie Jeong on 16/8/31.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Records,RecordList;
@interface SaleModel : NSObject


@property (nonatomic, strong) Records *records;

@property (nonatomic, assign) float totalMoney;


@end

@interface Records : NSObject

@property (nonatomic, assign) NSInteger number;

@property (nonatomic, strong) NSArray<RecordList *> *content;

@property (nonatomic, assign) NSInteger numberOfElements;

@property (nonatomic, assign) NSInteger totalPages;

@property (nonatomic, assign) NSInteger size;

@property (nonatomic, assign) BOOL last;

@property (nonatomic, assign) NSInteger totalElements;

@property (nonatomic, assign) BOOL first;

@end

@interface RecordList : NSObject

@property (nonatomic, copy) NSString *saleTime;

@property (nonatomic, copy) NSString *fileName;

@property (nonatomic, assign) int objectId;

@property (nonatomic, copy) NSString *patientName;

@property (nonatomic, assign) float price;

@end

