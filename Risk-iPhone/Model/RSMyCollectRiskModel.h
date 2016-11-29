//
//  RSMyCollectRiskModel.h
//  Risk
//
//  Created by Cherie Jeong on 16/8/8.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Risks;
@interface RSMyCollectRiskModel : NSObject

@property (nonatomic, strong) NSArray<Risks *> *risks;


@end
@interface Risks : NSObject

@property (nonatomic, assign) NSInteger objectId;

@property (nonatomic, copy) NSString *englishName;

@property (nonatomic, copy) NSString *fdaType;

@property (nonatomic, copy) NSString *otherName;

@property (nonatomic, copy) NSString *categoryShowName;

@property (nonatomic, copy) NSString *riskName;

@end

