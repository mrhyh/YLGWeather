//
//  EFPushCommentVC.h
//  EF_MallDemo
//
//  Created by HqLee on 16/6/21.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFBaseViewController.h"
#import "EFOrderListModel.h"


@interface EFPushCommentVC : EFBaseViewController

@property (nonatomic, assign) NSInteger objectId; //订单Id

- (instancetype)initWithOrderProduct:(OrderproductModel *)orderProduct;
@end
