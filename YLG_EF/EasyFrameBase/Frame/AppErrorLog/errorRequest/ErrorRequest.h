//
//  ErrorRequest.h
//  EasyFrame_iOS2.0
//
//  Created by Cherie Jeong on 16/8/11.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFRequest.h"

@interface ErrorRequest : EFRequest

@property (nonatomic,assign) NSInteger source;  //错误来源  0-后台,1-Android,2-ios
@property (nonatomic,copy) NSString * errorMethod;  //接口名称
@property (nonatomic,copy) NSString * errorMethodVersion;  //接口名称版本号
@property (nonatomic,copy) NSString * appVersion;   //客户端版本号
@property (nonatomic,copy) NSString * osVersion;   //操作系统版本号
@property (nonatomic,assign) NSInteger deviceType;  //客户端类型 :0-andorid手机,1-andorid平板,2-ipad,3-iphone;
@property (nonatomic,copy) NSString * projectName;  //项目名称；
@property (nonatomic,copy) NSString * logContent;   //日志内容；

@end
