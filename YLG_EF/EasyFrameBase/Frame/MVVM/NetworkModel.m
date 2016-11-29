//
//  NetworkModel.m
//  Dentist
//
//  Created by HqLee on 16/5/12.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "NetworkModel.h"



@interface NetworkModel()

/**
 *  NetworkModel 初始化方法
 *
 *  @param dictionary 字典
 *
 *  @return NetworkModel对象实例
 */
- (instancetype)initWithDictionary : (NSDictionary *)dictionary;

@end


@implementation NetworkModel

- (instancetype)initWithDictionary : (NSDictionary *)dictionary{
    
    if (self = [super init]) {
        NSDictionary * dict = dictionary;
        self.jsonDict = dictionary;
        self.status = [[dict objectForKey:@"status"] intValue];
        self.message = [dict objectForKey:@"message"];
        self.content = [dict objectForKey:@"content"];
        NSLog(@"NetworkModelStatusType:(%zd）",self.status);
        NSLog(@"message:(%@)",self.message);
        NSLog(@"content:(%@)",self.content);
        NSDictionary *errorDict = [dict objectForKey:@"inputError"];
        if (errorDict) {
            self.inputError = [[InputError alloc] initWithErrorDict:errorDict];
            NSLog(@"errorDict---:%@",errorDict);
        }
    }
    return self;
}

- (instancetype)initWithJsonData : (NSData *)jsonData
{
    NSString *jsonStr;
    if ( nil == jsonData ) {
        jsonStr =  [NSString stringWithUTF8String:[jsonData bytes]];
    }else {
        jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSError *error;
    NSDictionary *dict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    
    if (dict == nil || [dict count] <= 0) {
        self = [super init];
        if (self) {
            self.status = NetworkModelStatusTypeNoContent;
            self.message = @"服务器返回数据为空！";
            if(error != nil){
                self.status = NetworkModelStatusTypeServerDataFromatError;
                self.message = @"服务器返回数据格式有误！";
            }
            self.content = jsonStr;
            NSLog(@"NetworkModelStatusType---(%zd",self.status);
            NSLog(@"jsonStr---(%@)",jsonStr);
            NSLog(@"message---(%@)",self.message);
        }
    }
    else{
        if (self.status == NetworkModelStatusTypeUserNoLogin) {
            [UserModel Logout];
            NSLog(@"账号未登录");
        }
        self = [self initWithDictionary:dict];
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"---（%zd）---%@---",self.status,self.message];
}

@end

