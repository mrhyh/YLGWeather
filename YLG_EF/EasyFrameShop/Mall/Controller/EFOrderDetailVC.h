//
//  EFOrderDetailVC.h
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/14.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFBaseViewController.h"
#import "EFOrderListModel.h"

@interface EFOrderDetailVC : EFBaseViewController

/* 订单Id */
@property (nonatomic, assign) NSInteger orderId;
/* 订单状态 */
@property (nonatomic, copy) NSString *orderStatus;
/*  店铺名字 */
@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) OrderModel *orderModel;
@end
