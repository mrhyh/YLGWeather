//
//  RSRFDAModel.m
//  Risk
//
//  Created by ylgwhyh on 16/7/25.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSRFDAModel.h"



@interface RSRFDAModel () <NSCopying>

@end

@implementation RSRFDAModel 

+ (NSDictionary *)objectClassInArray{
    return @{@"beans" : [RSRFDAModel class]};
}


- (id)copyWithZone:(NSZone *)zone {
    RSRFDAModel *model = [[[self class] allocWithZone:zone] init];
    
    model.objectId = self.objectId;
    model.name = self.name;
    model.beans = [self.beans mutableCopy];

    return model;
}

@end



