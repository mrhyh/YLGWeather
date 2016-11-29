//
//  InputError.m
//  Dentist
//
//  Created by HqLee on 16/5/12.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "InputError.h"

@implementation InputError
- (instancetype)initWithErrorDict:(NSDictionary *)errorDict{
    if (self = [super init]) {
        self.objectErrors = errorDict[@"objectErrors"];
        self.fieldErrors = errorDict[@"fieldErrors"];
    }
    return self;
}
@end
