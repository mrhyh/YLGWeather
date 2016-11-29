//
//  InputError.h
//  Dentist
//
//  Created by HqLee on 16/5/12.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InputError : NSObject

@property (nonatomic, strong) NSDictionary *objectErrors;
@property (nonatomic, strong) NSDictionary *fieldErrors;
- (instancetype)initWithErrorDict:(NSDictionary *)errorDict;

@end
