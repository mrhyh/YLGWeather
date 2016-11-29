//
//  RSRFDAModel.h
//  Risk
//
//  Created by ylgwhyh on 16/7/25.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//  FDA风险分类所有栏目模型

#import <Foundation/Foundation.h>

@interface RSRFDAModel : NSObject

@property (nonatomic, assign) NSInteger objectId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray<RSRFDAModel *> *beans;

@end



