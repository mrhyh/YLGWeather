//
//  RiskFactorModel.h
//  Risk
//
//  Created by ylgwhyh on 16/7/1.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RiskTypeModel.h"
#import "RiskFactorModel.h"

@class RiskTypeModel, RiskFactorNextModel, RiskFactorNext2Model, RiskFactorNext3Model;

@interface RiskFactorModel : NSObject

@property (copy, nonatomic) NSString *name;
@property (nonatomic, strong) NSArray<RiskFactorNextModel *> *content;

@end

@interface RiskFactorNextModel : NSObject

@property (copy, nonatomic) NSString *name;
@property (nonatomic, strong) NSArray<RiskFactorNext2Model *> *content;

@end


@interface RiskFactorNext2Model : NSObject

@property (copy, nonatomic) NSString *name;
@property (nonatomic, strong) NSArray<RiskFactorNext3Model *> *content;


@end


@interface RiskFactorNext3Model : NSObject

@property (copy, nonatomic) NSString *name;

@end
