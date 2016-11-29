//
//  ErrorViewModel.h
//  EasyFrame_iOS2.0
//
//  Created by Cherie Jeong on 16/8/11.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFBaseViewModel.h"

typedef NS_ENUM(EFViewControllerCallBackAction,ErrorViewModelCallBackAction){
    ErrorLogCallBackActionLogin = 1<<0,
};

@interface ErrorViewModel : EFBaseViewModel

/**
 *  错误日志
 *
 *  @param _source             错误来源  0-后台,1-Android,2-ios
 *  @param _errorMethod        接口名称
 *  @param _errorMethodVersion 接口名称版本号
 *  @param _appVersion         客户端版本号
 *  @param _osVersion          操作系统版本号
 *  @param _deviceType         客户端类型 :0-andorid手机,1-andorid平板,2-ipad,3-iphone
 *  @param _projectName        项目名称
 *  @param _logContent         日志内容；
 */
- (void)sendErrorLogWithSource:(NSInteger)_source
                   ErrorMethod:(NSString *)_errorMethod
            ErrorMethodVersion:(NSString *)_errorMethodVersion
                    AppVersion:(NSString *)_appVersion
                     OsVersion:(NSString *)_osVersion
                    DeviceType:(NSInteger)_deviceType
                   ProjectName:(NSString *)_projectName
                    LogContent:(NSString *)_logContent;


@end
