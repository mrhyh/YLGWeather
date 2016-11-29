//
//  Request.h
//  iFlight
//
//  Created by MH on 15/10/21.
//  Copyright (c) 2015年 MH. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "NetworkModel.h"
#import "AFNetworking.h"

/** 用户医生手动切换后发出的通知 */
UIKIT_EXTERN NSString *const EFLoginInvalidNotification;
#if NS_BLOCKS_AVAILABLE
typedef void (^RequestCallBackBlock)(CallBackStatus callBackStatus,NetworkModel * result);
#endif

@interface EFRequest : NSObject
/**
 *  域名
 */
@property(nonatomic, strong)NSString *baseURL;
/**
 *  请求路径
 */
@property(nonatomic, strong)NSString *urlPath;
/**
 *  请求方式
 */
@property (nonatomic, copy ,readonly) NSString *method;
/**
 *  Http头参数设置
 */
@property(nonatomic, strong)NSDictionary *httpHeaderFields;
/**
 *  JsonString(需要提交Json给后台时，给这个参数赋值即可)
 */
@property(nonatomic, strong)NSString  *jsonString;
/**
 *  使用字典参数
 */
@property(nonatomic, strong)NSDictionary *params;
/**
 *  默认是60S
 */
@property(nonatomic, assign)NSTimeInterval timeoutInterval;
/**
 *  上传文件字典
 */
@property(nonatomic, strong)NSDictionary *requestFiles_Upload;
/**
 *  上传图组
 */
@property (nonatomic ,strong) NSArray *requestImages;


@property(nonatomic, strong,readonly)AFHTTPRequestOperation *request;
@property(nonatomic, assign)int tag;
@property(nonatomic, assign, getter = isCanceled)BOOL canceled;



/**
 *  创建request的GET请求
 *
 *  @return request对象
 */

+(id)requestWithGET;
/**
 *  创建request的POST请求
 *
 *  @return request对象
 */
+ (id)requestWithPOST;

/**
 *  创建request的PUT请求
 *
 *  @return request对象
 */
+ (id)requestWithPUT;


/**
 *  通用的网络请求
 *
 *  @param _callBack 网络请求回调
 */
- (void)startCallBack:(RequestCallBackBlock)callBack;


/**
 *  通用的网络请求(POST with headers and HTTP Body)
 *
 *  @param _callBack 网络请求回调
 */
- (void)startWithJsonCallBack:(RequestCallBackBlock)callBack;

/**
 *  取消一个请求
 */
- (void)cancelRequest;

@end
