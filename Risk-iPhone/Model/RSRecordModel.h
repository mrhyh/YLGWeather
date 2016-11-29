//
//  RSRecordModel.h
//  Risk
//
//  Created by Cherie Jeong on 16/8/4.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Record;
@interface RSRecordModel : NSObject


@property (nonatomic, assign) NSInteger number;

@property (nonatomic, strong) NSArray<Record *> *content;

@property (nonatomic, assign) NSInteger numberOfElements;

@property (nonatomic, assign) NSInteger totalPages;

@property (nonatomic, assign) NSInteger size;

@property (nonatomic, assign) BOOL last;

@property (nonatomic, assign) NSInteger totalElements;

@property (nonatomic, assign) BOOL first;


@end

@interface Record : NSObject

@property (nonatomic, copy) NSString *conent;

@property (nonatomic, assign) long long submitTime;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, assign) long long handleTime;

@end

