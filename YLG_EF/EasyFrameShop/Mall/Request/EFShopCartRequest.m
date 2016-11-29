//
//  EFShopCartRequest.m
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/20.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFShopCartRequest.h"

@implementation EFShopCartRequest

@end

@implementation EFClearItemsRequest

- (void)startCallBack:(RequestCallBackBlock)_callBack {
    self.urlPath = @"/rest/xx/cart/clearItems";
//    self.params = @{
//                    @"categoryId":@(self.categoryId)
//                    };
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"Version":@"1.0",@"token":token};
    [super startCallBack:_callBack];
}

@end


@implementation EFGetShopCartItemsRequest

- (void)startCallBack:(RequestCallBackBlock)_callBack {
    self.urlPath = @"/rest/xx/cart/items";
    self.params = @{
                                        @"page":@(self.page),
                                        @"size":@(self.size)
                    };
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"Version":@"1.0",@"token":token};
    [super startCallBack:_callBack];
}

@end

@implementation EFRemoveItemsRequest

- (void)startCallBack:(RequestCallBackBlock)_callBack {
    self.urlPath = @"/rest/xx/cart/removeItems";
    self.params = @{
                    @"productIds":self.productIds
                    };
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"Version":@"1.0",@"token":token};
    [super startCallBack:_callBack];
}

@end

@implementation EFUpdateItemQuantityRequest

- (void)startCallBack:(RequestCallBackBlock)_callBack {
    self.urlPath = @"/rest/xx/cart/updateItemQuantity";
    self.params = @{
                    @"productId":@(self.productId),
                    @"quantity":@(self.quantity)
                    };
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"Version":@"1.0",@"token":token};
    [super startCallBack:_callBack];
}

@end

/*****************商城-订单管理服务rest接口****************************/

@implementation CreateOrder

- (void)startCallBack:(RequestCallBackBlock)_callBack {
    self.urlPath = @"/rest/xx/order/create";
    self.params = @{
                    @"consigneeRegionId": self.consigneeRegionId,
                    @"isInvoice":@(self.isInvoice),
                    @"shippingMethodId":@(self.shippingMethodId),
                    @"consigneeName":self.consigneeName,
                    @"consigneeMobile":self.consigneeMobile,
                    @"consigneeAddress":self.consigneeAddress,
                    @"consigneeZipCode":self.consigneeZipCode,
                    @"invoiceTitle":self.invoiceTitle,
                    @"orderProductId":self.orderProductId,
                    @"orderProductCount":self.orderProductCount,
                    @"notes":self.notes,
                    @"isWalletPay":@(self.isWalletPay),
                    @"payPassword":self.payPassword
                    };
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"Version":@"1.0",@"token":token};
    [super startCallBack:_callBack];
}

@end

@implementation MyOrderList

- (void)startCallBack:(RequestCallBackBlock)_callBack {
    self.urlPath = @"/rest/xx/order/my";
    self.params = @{
                        @"page":@(self.page),
                        @"size":@(self.size),
                        @"status":self.status
                        };
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"Version":@"1.0",@"token":token};
    [super startCallBack:_callBack];
}

@end


@implementation CancelOrder

- (void)startCallBack:(RequestCallBackBlock)_callBack {
    self.urlPath = [NSString stringWithFormat:@"/rest/xx/order/%ld/cancel",(long)self.orderId];
    
    self.params = @{
                    @"caulse":self.caulse
                    };
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"Version":@"1.0",@"token":token};
    [super startCallBack:_callBack];
}

@end

@implementation ConfirmOrder

- (void)startCallBack:(RequestCallBackBlock)_callBack {
    self.urlPath = @"/rest/xx/order/{id}/confirm";
    self.params = @{
                    @"orderId":@(self.orderId)
                    };
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"Version":@"1.0",@"token":token};
    [super startCallBack:_callBack];
}

@end


@implementation DeleteOrder

- (void)startCallBack:(RequestCallBackBlock)_callBack {
    self.urlPath = @"/rest/xx/order/{id}/delete";
    self.params = @{
                    @"orderId":@(self.orderId)
                    };
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"Version":@"1.0",@"token":token};
    [super startCallBack:_callBack];
}

@end

@implementation FinishOrder

- (void)startCallBack:(RequestCallBackBlock)_callBack {
    self.urlPath = @"/rest/xx/order/{id}/finish";
    self.urlPath = [NSString stringWithFormat:@"/rest/xx/order/%ld/finish",(long)self.orderId];

    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"Version":@"1.0",@"token":token};
    [super startCallBack:_callBack];
}

@end

@implementation PayOrder

- (void)startCallBack:(RequestCallBackBlock)_callBack {
    self.urlPath = @"/rest/xx/order/pay";
    self.params = @{
                    @"orderIds":self.orderId
                    };
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"Version":@"1.0",@"token":token};
    [super startCallBack:_callBack];
}

@end

@implementation Received

- (void)startCallBack:(RequestCallBackBlock)_callBack {
    self.urlPath = [NSString stringWithFormat:@"/rest/xx/order/%ld/received",(long)self.orderId];
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"Version":@"1.0",@"token":token};
    [super startCallBack:_callBack];
}

@end


@implementation GetOrderById

- (void)startCallBack:(RequestCallBackBlock)_callBack {
    self.urlPath = [NSString stringWithFormat:@"/rest/xx/order/%ld/getOrderById",(long)self.orderId];
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"Version":@"1.0",@"token":token};
    [super startCallBack:_callBack];
}

@end
@implementation AliPay

- (void)startCallBack:(RequestCallBackBlock)_callBack {
    self.urlPath = @"/rest/finance/aliPay";
    self.params = @{
                    @"orderIds":self.orderId
                    };
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"Version":@"1.0",@"token":token};
    [super startCallBack:_callBack];
}

@end
@implementation BalancePay

- (void)startCallBack:(RequestCallBackBlock)_callBack {
    self.urlPath = @"/rest/finance/balancePay";
    self.params = @{
                    @"orderIds":self.orderId
                    };
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"Version":@"1.0",@"token":token};
    [super startCallBack:_callBack];
}

@end

@implementation WeChatPay

- (void)startCallBack:(RequestCallBackBlock)_callBack {
    self.urlPath = @"/rest/finance/wechatPay";
    self.params = @{
                    @"orderIds":self.orderId
                    };
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"Version":@"1.0",@"token":token};
    [super startCallBack:_callBack];
}

@end

/****************商城-退货单信息管理rest接口**************/

@implementation ApplyReturnGood

- (void)startCallBack:(RequestCallBackBlock)_callBack {
    self.urlPath = [NSString stringWithFormat:@"/rest/xx/returns/%ld/return",(long)self.orderId];
    self.params = @{@"shippingMethodId":@"1",
                    @"deliveryCorpId":@"1",
                    @"trackingNo":@"12312312",
                    @"freight": @"12",
                    @"shipperName":@"sfdsfdsfs",
                    @"consigneeRegionId":@"12",
                    @"consigneeAddress":@"dadadad",
                    @"consigneeZipCode" :@"610200",
                    @"consigneeMobile":@"15756986547",
                    @"notes":self.reason};
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"Version":@"1.0",@"token":token};
    [super startCallBack:_callBack];
}

@end

/****************商城-退款信息管理rest接口**************/
@implementation ApplyReturnMoney

- (void)startCallBack:(RequestCallBackBlock)_callBack {
    self.urlPath = [NSString stringWithFormat:@"/rest/xx/refunds/%ld/refunds",(long)self.orderId];
    self.params = @{@"status":@"online",
                    @"paymentMethod":@"你妹",
                    @"bank":@"天地银行",
                    @"account": @"165874641267",
                    @"payee":@"隔壁老王",
                    @"notes":self.reason};
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"Version":@"1.0",@"token":token};
    [super startCallBack:_callBack];
}

@end

@implementation ReturnMyList

- (void)startCallBack:(RequestCallBackBlock)_callBack {
    self.urlPath = @"/rest/xx/returns/my";
    self.params = @{
                    @"page":@(self.page),
                    @"size":@(self.size),
                    };
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"Version":@"1.0",@"token":token};
    [super startCallBack:_callBack];
}

@end

@implementation FindByOrder

- (void)startCallBack:(RequestCallBackBlock)_callBack {

    self.urlPath = [NSString stringWithFormat:@"/rest/xx/returns/%ld/findByOrder", (long)self.id];
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"Version":@"1.0",@"token":token};
    [super startCallBack:_callBack];
}
@end


@implementation EFMyWalletInfoRequest
- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/financial/getMyWallet";
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"version":@"1.0",@"token":token};
    [super startCallBack:callBack];
}
@end