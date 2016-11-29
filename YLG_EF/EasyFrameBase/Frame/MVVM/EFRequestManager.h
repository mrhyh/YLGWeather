//
//  EFRequestManager.h
//  Symiles
//
//  Created by mini珍 on 16/3/4.
//  Copyright © 2016年 KingYon LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

@class EFNetworkModel;

#if NS_BLOCKS_AVAILABLE
typedef void (^EFRequestCallBackBlock)(BOOL isSuccess,EFNetworkModel * result);
#endif

@interface EFRequestManager : NSObject
@property(nonatomic,strong)NSString *HOST;//域名
@property(nonatomic,strong)NSString *PATH;//请求路径
@property(nonatomic,strong)NSString *METHOD;//提交方式
@property(nonatomic,strong)NSDictionary *httpHeaderFields;//Http头参数设置
@property(nonatomic,strong)NSDictionary *params; //使用字典参数
@property(nonatomic,assign)NSTimeInterval timeoutInterval;//默认是60S
@property(nonatomic,strong)NSDictionary *requestFiles_Upload; //上传文件字典
@property(nonatomic,assign)BOOL *ShowDebugPrint; //是否显示请求信息
+(id)Request;
- (void)startCallBack:(EFRequestCallBackBlock)_callBack;
@end

//内部数据解析
@interface  EFNetworkModel : NSObject
@property (nonatomic,assign)int status;
@property (nonatomic,strong)NSString *message;
@property (nonatomic,strong)NSDictionary *allDic;
@property (nonatomic,strong)id data;
@property (nonatomic,assign)BOOL isArray;
@property (nonatomic,assign)BOOL isNoData;
@property (nonatomic,assign)BOOL isJsonError;

- (instancetype)initWithJsonData : (NSData *)_jsonData;
- (instancetype)initWithDictionary : (NSDictionary *)_dictionary;
@end
