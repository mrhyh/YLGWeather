//
//  RSRiskDetailModel.h
//  Risk
//
//  Created by ylgwhyh on 16/7/22.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//  风险详情分类

#import <Foundation/Foundation.h>

@class ContentsocailModel, menuLsModel;

@interface RSRiskDetailModel : NSObject


@property (nonatomic, copy) NSString *riskCode;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *contentAll;

@property (nonatomic, assign) NSInteger objectId;

@property (nonatomic, strong) ContentsocailModel *contentSocail;

@property (nonatomic, copy) NSString *fdaType;

@property (nonatomic, copy) NSString *englishName;

@property (nonatomic, copy) NSString *categoryShowName;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *otherName;

@property (nonatomic, assign) long long updateTime;

@property (nonatomic, copy) NSString *declare;

@property (nonatomic, strong) NSArray <menuLsModel *> *menuLs;

@end

@interface ContentsocailModel : NSObject

@property (nonatomic, assign) BOOL isPraise;

@property (nonatomic, assign) BOOL isFavorite;

@property (nonatomic, assign) NSInteger praisedCount;

@property (nonatomic, assign) NSInteger readCount;

@end

@interface menuLsModel : NSObject

@property (nonatomic, copy ) NSString *meunName;
@property (nonatomic, copy) NSString *id;

@end

