//
//  RSRiskBannerModel.h
//  Risk
//
//  Created by ylgwhyh on 16/7/20.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//  风险分类栏目模型

#import <Foundation/Foundation.h>

@class RiskBannerModel,ChildrensModel;
@interface RSRiskBannerModel : NSObject


@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong) NSArray<RiskBannerModel *> *content;

@property (nonatomic, copy) NSString *message;


@end
@interface RiskBannerModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, strong) NSArray<ChildrensModel *> *childrens;

@end

@interface ChildrensModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger objectId;

@property (nonatomic, assign) BOOL nextPage;


//传数据用
@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, assign) NSInteger integer;

@property (nonatomic, copy) NSString *lastPageName; //上一页名字

/*第二级分类Id*/
@property (nonatomic, assign) NSInteger secondKindId;

@end

