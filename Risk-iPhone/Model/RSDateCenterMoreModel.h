//
//  RSDateCenterMoreModel.h
//  Risk
//
//  Created by ylgwhyh on 16/7/22.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//  资料中心更多界面模型

#import <Foundation/Foundation.h>
#import "RSDateCenterModel.h"

@class Content,Mainimage;
@interface RSDateCenterMoreModel : NSObject

@property (nonatomic, assign) NSInteger number;

@property (nonatomic, strong) NSArray<FilesitemsModel *> *content;

@property (nonatomic, assign) NSInteger numberOfElements;

@property (nonatomic, assign) NSInteger totalPages;

@property (nonatomic, assign) NSInteger size;

@property (nonatomic, assign) BOOL last;

@property (nonatomic, assign) NSInteger totalElements;

@property (nonatomic, assign) BOOL first;

@end

