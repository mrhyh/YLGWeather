//
//  EFShopCartRequest.h
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/20.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFRequest.h"
#import "EFMailHeader.h"

/*********************商城-购物车信息管理rest接口************************/
@interface EFShopCartRequest : EFRequest

@end


/**
 *  清空我的购物车
 */
@interface EFClearItemsRequest : EFRequest

@end

/**
 *  返回购物车购物项
 */
@interface EFGetShopCartItemsRequest : EFRequest
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int size;
@end

/**
 *  从我的购物车当中删除购物项
 */
@interface EFRemoveItemsRequest : EFRequest
@property (nonatomic, copy) NSString *productIds;
@end

/**
 *  修改购物项目数量
 */
@interface EFUpdateItemQuantityRequest : EFRequest
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, assign) NSInteger quantity;
@end

/****************商城-订单管理服务rest接口**************/


/***  创建订单*/
@interface CreateOrder : EFRequest

@property (nonatomic, copy) NSString *consigneeRegionId;
@property (nonatomic, copy) NSString *consigneeName;
@property (nonatomic, copy) NSString *consigneeMobile;
@property (nonatomic, copy) NSString *consigneeAddress;
@property (nonatomic, copy) NSString *consigneeZipCode;
@property (nonatomic, assign) BOOL isInvoice;
@property (nonatomic, copy) NSString *invoiceTitle;
@property (nonatomic, copy) NSString *orderProductId;
@property (nonatomic, copy) NSString *orderProductCount;
@property (nonatomic, copy) NSString *notes;
@property (nonatomic, assign) NSInteger shippingMethodId;
@property (nonatomic, assign) BOOL isWalletPay;
@property (nonatomic, copy) NSString *payPassword;
@end

/***  返回我的订单列表*/
@interface MyOrderList : EFRequest
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, copy) NSString *status;
@end


/***  取消订单*/
@interface CancelOrder : EFRequest
@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, copy) NSString *caulse;
@end


/***  确认订单*/
@interface ConfirmOrder : EFRequest
@property (nonatomic, assign) NSInteger orderId;
@end


/***  刪除订单*/
@interface DeleteOrder : EFRequest
@property (nonatomic, assign) NSInteger orderId;
@end


/***  完成订单*/
@interface FinishOrder : EFRequest
@property (nonatomic, assign) NSInteger orderId;
@end


/***  支付订单*/
@interface PayOrder : EFRequest
@property (nonatomic, copy) NSString *orderId;
@end

/***  确认收货*/
@interface Received : EFRequest
@property (nonatomic, assign) NSInteger orderId;
@end

/***  根据订单id返回订单详情*/
@interface GetOrderById : EFRequest
@property (nonatomic, assign) NSInteger orderId;
@end

/***  支付宝支付*/
@interface AliPay : EFRequest
@property (nonatomic, copy) NSString *orderId;
@end

/***  余额支付*/
@interface BalancePay : EFRequest
@property (nonatomic, copy) NSString *orderId;
@end

/***  微信支付*/
@interface WeChatPay : EFRequest
@property (nonatomic, copy) NSString *orderId;
@end


/****************商城-退货单信息管理rest接口**************/

#warning TODO 还有很多参数，没写完
/***  申请退货*/
@interface ApplyReturnGood : EFRequest
@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, copy) NSString *reason;
@end

/***  申请退款*/
@interface ApplyReturnMoney: EFRequest
@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, copy) NSString *reason;
@end

/***  返回我的退货单*/
@interface ReturnMyList : EFRequest
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger size;
@end


/*** 根据订单id返回我的退货单*/
@interface FindByOrder : EFRequest
@property (nonatomic, assign) NSInteger id;
@end

/***  获取我的钱包信息 */
@interface EFMyWalletInfoRequest : EFRequest

@end