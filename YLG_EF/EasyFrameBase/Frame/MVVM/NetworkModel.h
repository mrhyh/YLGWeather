//
//  NetworkModel.h
//  Dentist
//
//  Created by HqLee on 16/5/12.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InputError.h"

//网络请求服务器返回的状态码的类型
typedef NS_ENUM(NSInteger,NetworkModelStatusType) {
    /**服务器返回内容为空*/
    NetworkModelStatusTypeNoContent = -100,
    /**服务器返回的格式有误*/
    NetworkModelStatusTypeServerDataFromatError = -101,
    /**服务器异常错误*/
    NetworkModelStatusTypeServerUnusualError = -200,
    /**网络请求成功类型*/
    NetworkModelStatusTypeSuccess = 200,
    /**客户端输入有误*/
    NetworkModelStatusTypeInputError = 400,
    /**表示用户没有权限（令牌、用户名、密码错误）*/
    NetworkModelStatusTypeNoRightToAccess = 401,
    /** 表示用户得到授权（与401错误相对），但是访问是被禁止的*/
    NetworkModelStatusTypeForbidToAccess = 403,
    /**用户发出的请求针对的是不存在的记录，服务器没有进行操作*/
    NetworkModelStatusTypeNoRecord = 404,
    /**用户请求的格式不可得（比如用户请求JSON格式，但是只有XML格式*/
    NetworkModelStatusTypeFormatError = 406,
    /**用户请求的资源被永久删除，且不会再得到的*/
    NetworkModelStatusTypeResourcesNotFind = 410,
    /**服务器发生错误，用户将无法判断发出的请求是否成功*/
    NetworkModelStatusTypeServerError = 500,
    /**其他错误*/
    NetworkModelStatusTypeOtherError = 501,
    /**用户未登陆*/
    NetworkModelStatusTypeUserNoLogin = 1000,
    
};

//callBack中的状态码
typedef NS_ENUM(NSInteger,CallBackStatus) {
    /**请求成功，服务器返回200*/
    CallBackStatusSuccess = 0,
    /**请求错误，服务器返回自定义错误码*/
    CallBackStatusRequestError = 1,
    /**请求失败，服务器出错*/
    CallBackStatusRequestFailure = 2
};

@interface  NetworkModel : NSObject
/**
 *  网络请求返回的状态码
 *
 */
@property (nonatomic,assign)NetworkModelStatusType status;

/**
 *  网络返回的message消息
 */
@property (nonatomic,strong)NSString *message;
/**
 *  网络返回的json字典
 */
@property (nonatomic,strong)NSDictionary *jsonDict;
/**
 *  网络请求成功时返回content内容
 */
@property (nonatomic,strong)id content;
/**
 *  错误内容
 */
@property (nonatomic, strong) InputError *inputError;

@property (nonatomic, assign) NSInteger tag;

/**
 *  以jsonData初始化
 *
 *  @param jsonData json格式数据
 *
 *  @return 字典对象
 */
- (instancetype)initWithJsonData : (NSData *)jsonData;
/**
 *  打印请求
 *
 *  @return 打印网络模型的状态码和message
 */
- (NSString *)description;
@end
