//
//  RiskTypeModel.h
//  Risk
//
//  Created by ylgwhyh on 16/6/30.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RiskTypeModel : NSObject

@property (assign, nonatomic) BOOL isSelect;
@property (assign, nonatomic) NSInteger integer;
@property (copy, nonatomic) NSString *idstr;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *url;

@end
