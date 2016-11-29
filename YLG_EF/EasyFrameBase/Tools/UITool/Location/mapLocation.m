//
//  mapLocation.m
//  Map
//
//  Created by KingYon on 15/4/14.
//  Copyright (c) 2015年 KingYon. All rights reserved.
//

#import "mapLocation.h"

@implementation mapLocation
#pragma mark 标点上的主标题
- (NSString *)title{
    return @"您的位置!";
}


#pragma  mark 标点上的副标题
- (NSString *)subtitle{
    NSMutableString *ret = [NSMutableString new];
    if (_state) {
        [ret appendString:_state];
    }
    if (_city) {
        [ret appendString:_city];
    }
    if (_city && _state) {
        [ret appendString:@", "];
    }
    if (_streetAddress && (_city || _state || _zip)) {
        [ret appendString:@"  "];
    }
    if (_streetAddress) {
        [ret appendString:_streetAddress];
    }
    if (_zip) {
        [ret appendFormat:@",  %@",_zip];
    }
    return ret;
}
@end
