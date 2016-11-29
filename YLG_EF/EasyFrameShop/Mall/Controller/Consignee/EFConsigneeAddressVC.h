//
//  EFConsigneeAddressVC.h
//  EF_MallDemo
//
//  Created by HqLee on 16/6/17.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFBaseViewController.h"
#import "EFMallModel.h"

typedef void (^EFMallCompleteHandler)(EFMallConsigneeModel *efMallConsigneeModel);

@interface EFConsigneeAddressVC : EFBaseViewController
- (instancetype)initWithCompleteHandler:(EFMallCompleteHandler)completeHandler;
@end
