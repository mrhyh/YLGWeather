//
//  RSMsgMdoel.h
//  Risk
//
//  Created by Cherie Jeong on 16/8/5.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSGContent;
@interface RSMsgMdoel : NSObject


@property (nonatomic, assign) NSInteger number;

@property (nonatomic, strong) NSArray<MSGContent *> *content;

@property (nonatomic, assign) NSInteger numberOfElements;

@property (nonatomic, assign) NSInteger totalPages;

@property (nonatomic, assign) NSInteger size;

@property (nonatomic, assign) BOOL last;

@property (nonatomic, assign) NSInteger totalElements;

@property (nonatomic, assign) BOOL first;


@end
@interface MSGContent : NSObject

@property (nonatomic, assign) BOOL isRead;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *summary;

@property (nonatomic, assign) long long sendDate;

@property (nonatomic, assign) NSInteger displayTemp;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger objectId;

@property (nonatomic, copy) NSString *type;

@end

