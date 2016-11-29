//
//  ErrorViewModel.m
//  EasyFrame_iOS2.0
//
//  Created by Cherie Jeong on 16/8/11.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "ErrorViewModel.h"
#import "ErrorRequest.h"

@implementation ErrorViewModel

- (void)sendErrorLogWithSource:(NSInteger)_source
                   ErrorMethod:(NSString *)_errorMethod
            ErrorMethodVersion:(NSString *)_errorMethodVersion
                    AppVersion:(NSString *)_appVersion
                     OsVersion:(NSString *)_osVersion
                    DeviceType:(NSInteger)_deviceType
                   ProjectName:(NSString *)_projectName
                    LogContent:(NSString *)_logContent
{
    ErrorRequest * request = [ErrorRequest requestWithPOST];
    request.source = _source;
    request.errorMethod = _errorMethod;
    request.errorMethodVersion = _errorMethodVersion;
    request.appVersion = _appVersion;
    request.osVersion = _osVersion;
    request.deviceType = _deviceType;
    request.projectName = _projectName;
    request.logContent = _logContent;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        //根据相应的tag删除请求，避免重复请求
        [self delRequestWithTag:ErrorLogCallBackActionLogin];
        
        if (callBackStatus == CallBackStatusRequestFailure ) {//说明请求失败，可能是服务器出错
            NSLog(@"未连接到服务器");
            
        }else if (callBackStatus == CallBackStatusRequestError){//说明请求成功，但可能输入有误等原因，无法正确获得请求结果，原因可由result的status、message和inputError进行相应的逻辑处理
            NSLog(@"错误日志发送失败，无法正确获得请求结果");
            
        }else if (callBackStatus == CallBackStatusSuccess){//说明请求成功，正确获得请求结果
            
            NSLog(@"错误日志发送成功");
        }
        
    } Request:request WithTag:ErrorLogCallBackActionLogin];
    
    
}

@end
