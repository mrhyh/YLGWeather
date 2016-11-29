//
//  Request.m
//  KYiOS
//
//  Created by mini珍 on 15/9/14.
//  Copyright (c) 2015年 mini珍. All rights reserved.
//

#import "EFRequest.h"
#import "UIUtil.h"


#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <YYModel/YYModel.h>

//#import "ErrorViewModel.h"  //错误日志


static CGFloat const defaultTimeOut = 10;
NSString *const EFLoginInvalidNotification = @"EFLoginInvalidNotification";

@interface EFRequest()
@property (nonatomic, copy, readwrite) NSString *method;
@property (nonatomic, copy) NSString *serverAddressURL;

//@property (nonatomic, strong)ErrorViewModel * viewModel;

@end
@implementation EFRequest
/**
 *  创建request的GET请求
 *
 *  @return request对象
 */
+(id)requestWithGET{
    return [[self alloc] initGetRequest];
}
/**
 *  创建request的POST请求
 *
 *  @return request对象
 */
+ (id)requestWithPOST{
    return [[self alloc]initPostRequest];
}
/**
 *  判断网络是否可用
 *
 *  @return 判断结果 BOOL
 */
- ( BOOL )isNetworkReachable{
    
    // Create zero addy
    
    struct sockaddr_in zeroAddress;
    
    bzero (&zeroAddress, sizeof (zeroAddress));
    
    zeroAddress. sin_len = sizeof (zeroAddress);
    
    zeroAddress. sin_family = AF_INET ;
    
    // Recover reachability flags
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress ( NULL , ( struct sockaddr *)&zeroAddress);
    
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags (defaultRouteReachability, &flags);
    
    CFRelease (defaultRouteReachability);
    
    if (!didRetrieveFlags)
        
    {
        
        return NO ;
        
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable ;
    
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired ;
    
    return (isReachable && !needsConnection) ? YES : NO ;
    
}


- (id)initGetRequest{
    if(self = [self init]){
        self.tag = -1;
        self.method = @"GET";
        if ([self isNetworkReachable] ==NO){
            [UIUtil alert:@"请检查你的网络"];
        }
    }
    return self;
}

- (id)initPostRequest{
    if(self = [self init]){
        self.tag = -1;
        self.method = @"POST";
        if ([self isNetworkReachable] ==NO){
            [UIUtil alert:@"请检查你的网络"];
        }
    }
    return self;
}


- (void)loadRequest{
    self.params = [NSDictionary dictionary];
    self.httpHeaderFields = [NSDictionary dictionary];
    self.requestFiles_Upload = [NSDictionary dictionary];
}

- (void)startCallBack:(RequestCallBackBlock)callBack{
    

    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    
    //**HTTPS请求专属**
    manager.securityPolicy = securityPolicy;
    //**
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //请求头
    if (self.httpHeaderFields.count>0) {
        for (NSString * key in self.httpHeaderFields.allKeys) {
            [manager.requestSerializer setValue:[self.httpHeaderFields objectForKey:key] forHTTPHeaderField:key];
        }
    }
    //超时时间
    [manager.requestSerializer setTimeoutInterval:defaultTimeOut];
    //请求地址
    NSString * url;
    if (self.baseURL) {
        url = self.baseURL;
    }else{
        url = [NSString stringWithFormat:@"%@%@",self.serverAddressURL,self.urlPath];
    }

#ifdef DEBUG
    NSLog(@"\n----RequestURL : %@\n/----Parameters :\n%@\n  -----------",url,self.params);
    NSLog(@"\n----self.httpHeaderFields : %@",self.httpHeaderFields);
    NSLog(@"\n----self.requestFiles_Upload : %@",self.requestFiles_Upload);
#endif
    //请求正文
    if ([self.method isEqualToString:@"GET"]) {
        _request = [manager GET:url parameters:self.params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NetworkModel *nm = [[NetworkModel alloc] initWithJsonData:responseObject];
            //登录失效：被挤下线时发出通知
            if (nm.status == NetworkModelStatusTypeUserNoLogin) {
                [[NSNotificationCenter defaultCenter] postNotificationName:EFLoginInvalidNotification object:nil];
            }
            nm.tag = self.tag;
            
            //只有状态码是 NetworkModelStatusTypeSuccess 表示数据请求成功
            if (nm.status == NetworkModelStatusTypeSuccess) {
                callBack(CallBackStatusSuccess,nm);
            }
            else{//其他任何情况都表示请求错误，可能是输入有误等，需要自行处理
                
                //错误日志提交 暂不可用
//                if (_viewModel == nil) {
//                    _viewModel = [[ErrorViewModel alloc] initWithViewController:self];
//                }
//                [_viewModel sendErrorLogWithSource:2 ErrorMethod:url ErrorMethodVersion:self.httpHeaderFields[@"version"] AppVersion:APP_VERSION OsVersion:SystemVersion DeviceType:[DeviceModel hasSuffix:@"iPhone"]?2:3 ProjectName:APP_NAME LogContent:@""];
                
                callBack(CallBackStatusRequestError,nm);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NetworkModel *nm = [[NetworkModel alloc] init];
            nm.tag = self.tag;
            nm.status = NetworkModelStatusTypeServerUnusualError;
            //nm.message = @"服务器异常错误！";
            nm.content = error.userInfo;
            NSLog(@"%@",nm.message);
            if([error.userInfo.allKeys containsObject:@"com.alamofire.serialization.response.error.data"]){
                NSData *data = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"----------ERROR MESSAGE : %@",string);
            }
            if (callBack && !_canceled) {
                //请求不成功，可能是服务器错误等
                callBack(CallBackStatusRequestFailure,nm);
                NSLog(@"服务器异常错误！");
            }
            
#warning TODO 超时统一处理，确认后删除TODO
            if ( error.code == -1001 ) {
                [SVProgressHUD dismiss];
                [UIUtil alert:@"网络超时"];
            }else if (error.code == 1009) {
                [SVProgressHUD dismiss];
                [UIUtil alert:@"似乎已断开与互联网的连接,请检查网络"];
            }
            
            NSLog(@"------error:%@",error);
        }];
    }else{
        _request = [manager POST:url parameters:self.params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if (self.requestFiles_Upload.count >0) {
                for (int i = 0 ; i < [self.requestFiles_Upload count] ; i ++) {
                    NSString *key = [[self.requestFiles_Upload allKeys] objectAtIndex:i];
                    id value = [self.requestFiles_Upload objectForKey:key];
                    if([value isKindOfClass:[UIImage class]]) {
                        NSData *data = UIImagePNGRepresentation(value);
                        [formData appendPartWithFileData:data name:key fileName:@"test.jpg" mimeType:@"jpg"];
                    } else if([value isKindOfClass:[NSString class]]) {
                        NSString *path = value;
                        NSString *fileName = [path lastPathComponent];
                        NSString *exestr = [path pathExtension];
                        NSData *data = [NSData dataWithContentsOfFile:value];
                        [formData appendPartWithFileData:data name:key fileName:fileName mimeType:exestr];
                    }
                }
            }
            if (self.requestImages.count>0) {
                for (int i = 0; i < self.requestImages.count; i++) {
                    id value = [self.requestImages objectAtIndex:i];
                    NSData *data = UIImagePNGRepresentation(value);
                    [formData appendPartWithFileData:data name:@"file" fileName:@"image.jpg" mimeType:@"jpg"];
                }
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NetworkModel *nm = [[NetworkModel alloc] initWithJsonData:responseObject];
            nm.tag = self.tag;
            //登录失效：被挤下线时发出通知
            if (nm.status == NetworkModelStatusTypeUserNoLogin) {
                [[NSNotificationCenter defaultCenter] postNotificationName:EFLoginInvalidNotification object:nil];
            }
            //只有状态码是 NetworkModelStatusTypeSuccess 表示数据请求成功
            if (nm.status == NetworkModelStatusTypeSuccess) {
                callBack(CallBackStatusSuccess,nm);
            }
            else{//其他任何情况都表示请求错误，可能是输入有误等，需要自行处理
                
                //错误日志提交 暂不可用
//                if (_viewModel == nil) {
//                    _viewModel = [[ErrorViewModel alloc] initWithViewController:self];
//                }
//                [_viewModel sendErrorLogWithSource:2 ErrorMethod:url ErrorMethodVersion:self.httpHeaderFields[@"version"] AppVersion:APP_VERSION OsVersion:SystemVersion DeviceType:[DeviceModel hasSuffix:@"iPhone"]?2:3 ProjectName:APP_NAME LogContent:@""];
                
                callBack(CallBackStatusRequestError,nm);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NetworkModel *nm = [[NetworkModel alloc] init];
            nm.status = NetworkModelStatusTypeServerUnusualError;
            nm.tag = self.tag;
            //nm.message = @"服务器异常错误!";
            nm.content = error.userInfo;
            if([error.userInfo.allKeys containsObject:@"com.alamofire.serialization.response.error.data"]){
                NSData *data = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"----------ERROR MESSAGE : %@",string);
            }
            NSLog(@"%@",nm.content);
            NSLog(@"%@",nm.message);
            if (callBack && !_canceled) {
                callBack(CallBackStatusRequestFailure,nm);
            }
            
        }];
    }
}

/*
- (void)startWithJsonCallBack:(RequestCallBackBlock)callBack {
    
    NSString *jsonString = self.params[@"body"];
    
    //请求地址
    NSString * url;
    if (self.baseURL) {
        url = [NSString stringWithFormat:@"%@%@",self.baseURL,self.urlPath];
    }else{
        url = [NSString stringWithFormat:@"%@%@",self.serverAddressURL,self.urlPath];
    }
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //[req setValue:@"1.0" forHTTPHeaderField:@"version"];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //**HTTPS请求专属**
    manager.securityPolicy = securityPolicy;
    
    //请求头
    if (self.httpHeaderFields.count>0) {
        for (NSString * key in self.httpHeaderFields.allKeys) {
            [req setValue:[self.httpHeaderFields objectForKey:key] forHTTPHeaderField:key];
        }
    }
    

#ifdef DEBUG
    NSLog(@"\n----RequestURL : %@\n/----Parameters :\n%@\n  -----------",url,self.params);
    NSLog(@"\n----self.httpHeaderFields : %@",self.httpHeaderFields);
    NSLog(@"\n----self.requestFiles_Upload : %@",self.requestFiles_Upload);
#endif
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                NetworkModel *nm = [[NetworkModel alloc] initWithJsonData:responseObject];
                nm.tag = self.tag;
                //登录失效：被挤下线时发出通知
                if (nm.status == NetworkModelStatusTypeUserNoLogin) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:EFLoginInvalidNotification object:nil];
                }
                //只有状态码是 NetworkModelStatusTypeSuccess 表示数据请求成功
                if (nm.status == NetworkModelStatusTypeSuccess) {
                    callBack(CallBackStatusSuccess,nm);
                }
                else{//其他任何情况都表示请求错误，可能是输入有误等，需要自行处理
                    callBack(CallBackStatusRequestError,nm);
                }
                
            }
            

            
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NetworkModel *nm = [[NetworkModel alloc] init];
            nm.status = NetworkModelStatusTypeServerUnusualError;
            nm.tag = self.tag;
            nm.message = @"服务器异常错误!";
            nm.content = error.userInfo;
            if([error.userInfo.allKeys containsObject:@"com.alamofire.serialization.response.error.data"]){
                NSData *data = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"----------ERROR MESSAGE : %@",string);
            }
            NSLog(@"%@",nm.content);
            NSLog(@"%@",nm.message);
            if (callBack && !_canceled) {
                callBack(CallBackStatusRequestFailure,nm);
            }

        }
    }] resume];

}
 */

- (void)startWithJsonCallBack:(RequestCallBackBlock)callBack {
    
    NSString *jsonString = self.params[@"body"];
    
    //请求地址
    NSString * url;
    if (self.baseURL) {
        url = [NSString stringWithFormat:@"%@%@",self.baseURL,self.urlPath];
    }else{
        url = [NSString stringWithFormat:@"%@%@",self.serverAddressURL,self.urlPath];
    }
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //**HTTPS请求专属**
    manager.securityPolicy = securityPolicy;
    
    //请求头
    if (self.httpHeaderFields.count>0) {
        for (NSString * key in self.httpHeaderFields.allKeys) {
            [req setValue:[self.httpHeaderFields objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    
#ifdef DEBUG
    NSLog(@"\n----RequestURL : %@\n/----Parameters :\n%@\n  -----------",url,self.params);
    NSLog(@"\n----self.httpHeaderFields : %@",self.httpHeaderFields);
    NSLog(@"\n----self.requestFiles_Upload : %@",self.requestFiles_Upload);
#endif
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
            }
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            NetworkModel *nm = [NetworkModel yy_modelWithJSON:responseObject];
            
            //NetworkModel *nm = [[NetworkModel alloc] initWithJsonData:responseObject];
            nm.tag = self.tag;
            //登录失效：被挤下线时发出通知
            if (nm.status == NetworkModelStatusTypeUserNoLogin) {
                [[NSNotificationCenter defaultCenter] postNotificationName:EFLoginInvalidNotification object:nil];
            }
            //只有状态码是 NetworkModelStatusTypeSuccess 表示数据请求成功
            if (nm.status == NetworkModelStatusTypeSuccess) {
                callBack(CallBackStatusSuccess,nm);
            }
            else{//其他任何情况都表示请求错误，可能是输入有误等，需要自行处理
                callBack(CallBackStatusRequestError,nm);
            }
            
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NetworkModel *nm = [[NetworkModel alloc] init];
            nm.status = NetworkModelStatusTypeServerUnusualError;
            nm.tag = self.tag;
            //nm.message = @"服务器异常错误!";
            nm.content = error.userInfo;
            if([error.userInfo.allKeys containsObject:@"com.alamofire.serialization.response.error.data"]){
                NSData *data = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"----------ERROR MESSAGE : %@",string);
            }
            NSLog(@"%@",nm.content);
            NSLog(@"%@",nm.message);
            if (callBack && !_canceled) {
                callBack(CallBackStatusRequestFailure,nm);
            }
            
        }
    }] resume];
}

- (void)cancelRequest{
    if (self.request) {
        self.canceled = YES;
        [self.request cancel];
    }
}

#pragma mark --- setter && getter
- (NSString *)serverAddressURL{
    if (_serverAddressURL == nil) {
        NSString *plistPath = nil;
        plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame_" ofType:@"plist"];
        //如果没有创建EasyFrame_.plist文件，那么直接加载框架内部自带的
        if (plistPath == nil) {
            plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame" ofType:@"plist"];
        }
        NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        _serverAddressURL = dictionary[@"ServerAddressURL"];
    }
    return _serverAddressURL;
}
@end
