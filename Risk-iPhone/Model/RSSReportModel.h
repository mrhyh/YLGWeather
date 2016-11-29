//
//  RSSReportModel.h
//  Risk
//
//  Created by ylgwhyh on 16/7/21.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//  统计报表模型

#import <Foundation/Foundation.h>

@class reportModel;
@interface RSSReportModel : NSObject


@property (nonatomic, assign) NSInteger number;

@property (nonatomic, strong) NSArray<reportModel *> *content;

@property (nonatomic, assign) NSInteger numberOfElements;

@property (nonatomic, assign) NSInteger totalPages;

@property (nonatomic, assign) NSInteger size;

@property (nonatomic, assign) BOOL last;

@property (nonatomic, assign) NSInteger totalElements;

@property (nonatomic, assign) BOOL first;


@end

@interface reportModel : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) int objectId;

@property (nonatomic, copy) NSString *fdaType;

@property (nonatomic, copy) NSString *catName;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *nums;

@property (nonatomic, assign) NSInteger index;

@end

