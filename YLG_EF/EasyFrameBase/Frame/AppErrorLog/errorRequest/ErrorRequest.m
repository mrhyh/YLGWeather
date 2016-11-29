//
//  ErrorRequest.m
//  EasyFrame_iOS2.0
//
//  Created by Cherie Jeong on 16/8/11.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "ErrorRequest.h"

@implementation ErrorRequest

- (void)startCallBack:(RequestCallBackBlock)callBack {
    self.urlPath = @"/rest/appErrorLog/saveAppErrorLog";
    self.params = @{@"source":@(self.source),
                    @"errorMethod":self.errorMethod,
                    @"errorMethodVersion":self.errorMethodVersion,
                    @"appVersion":self.appVersion,
                    @"osVersion":self.osVersion,
                    @"deviceType":@(self.deviceType),
                    @"projectName":self.projectName,
                    @"logContent":self.logContent};
    self.httpHeaderFields = @{@"version":@"1.0"};
    [super startCallBack:callBack];
}

@end
