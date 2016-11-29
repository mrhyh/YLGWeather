//
//  EFRequestManager.m
//  Symiles
//
//  Created by mini珍 on 16/3/4.
//  Copyright © 2016年 KingYon LTD. All rights reserved.
//

#import "EFRequestManager.h"

@interface EFRequestManager ()
{
    NSString *configName;//配置路径
    NSDictionary *reqConfig;//配置字典
    
    BOOL      AllowInvaild;//允许无效证书
    int       TimeOut;//超时时间
    NSString *severAddress;//请求地址
}
@end

@implementation EFRequestManager

+(id)Request{
    return [[self alloc]initRequest];
}

#pragma mark- 初始化

-(id)initRequest{
    self = [self init];
    if(self){
        [self loadRequest];
        [self reloadConfigData];
    }
    return self;
}

//初始化参数对象
-(void)loadRequest{
    self.params = [NSDictionary dictionary];
    self.httpHeaderFields = [NSDictionary dictionary];
    self.requestFiles_Upload = [NSDictionary dictionary];
}

//加载配置文件
- (void)reloadConfigData{
    AllowInvaild = NO;
    TimeOut = 15;
    severAddress = @"";
    
    configName = @"EFRequestConfig.plist";
    //从Docment下面去拿配置文件
    NSString *confPath = [[EFFileManager getDocumentConfigsPath] stringByAppendingPathComponent:configName];
    NSData *configData = [EFFileManager getFileDataByPath:confPath];
    
    //从项目资源中去拿配置文件
    if(configData == nil){
        confPath = [[NSBundle mainBundle] pathForResource:@"EFRequestConfig" ofType:@"plist"];
        configData = [EFFileManager getFileDataByPath:confPath];
    }
    if (configData == nil) {
        reqConfig = [NSDictionary dictionary];
    }
    else{
        reqConfig = [[NSDictionary alloc] initWithContentsOfFile:confPath];
    }
    
    AllowInvaild = [reqConfig[@"AllowInvalidCertificates"] boolValue];
    TimeOut = [reqConfig[@"TimeoutInterval"] intValue];
    severAddress = reqConfig[@"ServerAddress"];
}


#pragma mark- 请求

- (void)startCallBack:(EFRequestCallBackBlock)_callBack{
    
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    //允许出现无效证书请求，跨证书请求（eg:https）
    if (AllowInvaild) {
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy = securityPolicy;
    }

    //请求头
    if (self.httpHeaderFields.count>0) {
        for (NSString * key in self.httpHeaderFields.allKeys) {
            [manager.requestSerializer setValue:[self.httpHeaderFields objectForKey:key] forHTTPHeaderField:key];
        }
    }
    //超时时间
    [manager.requestSerializer setTimeoutInterval:TimeOut];
    //请求地址
    NSString * url;
    if (self.HOST) {
        url = [NSString stringWithFormat:@"%@%@",self.HOST,self.PATH];
    }else{
        url = [NSString stringWithFormat:@"%@%@",severAddress,self.PATH];
    }
#ifdef DEBUG
    if (self.ShowDebugPrint) {
        NSLog(@"\n----请求路径 : %@\n/----请求参数 :\n%@\n  -----------",url,self.params);
        NSLog(@"\n 上传文件 : %@ \n",self.httpHeaderFields);
    }
#endif
    //请求正文
    if ([self.METHOD isEqualToString:@"GET"]) {
        [manager GET:url parameters:self.params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            EFNetworkModel *nm = [[EFNetworkModel alloc] initWithJsonData:responseObject];
            
#ifdef DEBUG
            if (self.ShowDebugPrint) {
                NSLog(@"\n 返回的字典是: %@ \n",nm.allDic);
            }
#endif
            
            if (nm.status == 200) {
                _callBack(YES,nm);
            }else{
                _callBack(NO,nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            _callBack(NO,nil);
        }];
    }else{
        [manager POST:url parameters:self.params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if (self.requestFiles_Upload.count >0) {
                for (int i = 0 ; i < [self.requestFiles_Upload count] ; i ++) {
                    NSString *key = [[self.requestFiles_Upload allKeys] objectAtIndex:i];
                    id value = [self.requestFiles_Upload objectForKey:key];
                    if([value isKindOfClass:[UIImage class]]) {
                        NSData *data = UIImageJPEGRepresentation(value,0.95);
                        [formData appendPartWithFileData:data name:key fileName:@"test.jpg" mimeType:@"jpg"];
                    } else if([value isKindOfClass:[NSString class]]) {
                        NSData *data = [NSData dataWithContentsOfFile:value];
                        [formData appendPartWithFileData:data name:key fileName:@"attachment.zip" mimeType:@"zip"];
                    }
                }
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            EFNetworkModel *nm = [[EFNetworkModel alloc] initWithJsonData:responseObject];
#ifdef DEBUG
            if (self.ShowDebugPrint) {
                NSLog(@"\n 返回的字典是: %@ \n",nm.allDic);
            }
#endif
            if (nm.status == 200) {
                _callBack(YES,nm);
            }else{
                _callBack(NO,nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            _callBack(NO,nil);
        }];
    }
}
@end

#pragma mark- 数据处理
@implementation EFNetworkModel

- (instancetype)initWithDictionary : (NSDictionary *)_dictionary{
    self = [super init];
    if (self) {
        NSDictionary * dic = _dictionary;
        self.allDic = _dictionary;
        if (!dic || [dic count] <= 0) {
            self.isJsonError = YES;
            self.status = -1;
        }
        else{
            self.status = [[dic objectForKey:@"status"] intValue];
            self.message = [dic objectForKey:@"message"];
            self.data = [dic objectForKey:@"data"];
            if (!self.data && [self.data count] <= 0) {
                self.isNoData = YES;
            }
            else if([self.data isKindOfClass:[NSArray class]]){
                self.isArray = YES;
            }
        }
    }
    return self;
}

- (instancetype)initWithJsonData : (NSData *)_jsonData
{
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:_jsonData options:NSJSONReadingMutableLeaves error:&error];
    if (!dic || [dic count] <= 0) {
        self = [super init];
        self.isJsonError = YES;
        self.status = -1;
    }
    else{
        self = [self initWithDictionary:dic];
    }
    return self;
}

@end