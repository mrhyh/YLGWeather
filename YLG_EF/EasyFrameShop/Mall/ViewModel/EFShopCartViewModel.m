//
//  EFShopCartModel.m
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/20.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFShopCartViewModel.h"
#import "EFShopCartRequest.h"

@implementation EFShopCartViewModel

/****************商城-购物车信息管理******************/
- (void)EFClearItems {
    EFClearItemsRequest *request = [EFClearItemsRequest requestWithPOST];

    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:EFMailShopCart_ClearItems];
        if (callBackStatus == CallBackStatusRequestFailure) {
            //            [UIUtil alert:@"服务器出错"];
            return ;
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
        }
        [self.viewController callBackAction:EFMailShopCart_ClearItems Result:result];
    } Request:request WithTag:EFMailShopCart_ClearItems];
}

- (void)EFGetShopCartItems:(int)_page Size:(int) _size{
    _cartModelContentArray = [NSMutableArray array];
    EFViewControllerCallBackAction efViewControllerCallBackAction = EFMailShopCart_Items;
    EFGetShopCartItemsRequest *request = [EFGetShopCartItemsRequest requestWithPOST];
    request.page = _page;
    request.size = _size;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            //            [UIUtil alert:@"服务器出错"];
            return ;
        }else if (callBackStatus == CallBackStatusRequestError){
              [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
        }else if (callBackStatus == CallBackStatusSuccess){
            if ([result.jsonDict[@"status"] intValue] == 200) {
                _cartModel = [EFCartModel yy_modelWithDictionary:result.jsonDict[@"content"]];
                [_cartModelContentArray removeAllObjects];
                for(int i=0; i<_cartModel.content.count; i++) {
                    ShopCartContentModel *shopCartContentModel = [ShopCartContentModel yy_modelWithJSON:_cartModel.content[i]];
                    [_cartModelContentArray addObject:shopCartContentModel];
                }
                
               
                 //分类
                _cartClassifyModelArray = [NSMutableArray array];
                NSMutableArray *shopItemArray = [NSMutableArray array];
                for(int i=0; i<_cartModelContentArray.count; i ++)  {
                     ShopCartContentModel *shopCartContentModel = _cartModelContentArray[i];
                    
                    NSNumber *tempNumBer = [NSNumber numberWithInteger:shopCartContentModel.productItem.shopItem.objectId];
                    if([shopItemArray containsObject:tempNumBer]) {
                        continue;
                    }else {
                        [shopItemArray addObject:tempNumBer];
                    }
                }
                for(int i=0; i<shopItemArray.count ; i++ ) {
                    NSMutableArray *tempArray = [NSMutableArray array];
                    for(int j=0; j<_cartModelContentArray.count ; j++) {
                        
                        ShopCartContentModel *shopCartContentModel = _cartModelContentArray[j];
                        if(shopCartContentModel.productItem.shopItem.objectId == [shopItemArray[i] integerValue]) {
                            [tempArray addObject:shopCartContentModel];
                        }
                    }
                    if(tempArray.count != 0) {
                        [_cartClassifyModelArray addObject:tempArray];
                    }
                }
            }
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}

/*从我的购物车当中删除购物项*/
- (void)EFRemoveItemsWithProductIds:(NSString *)_productIds callBackBlock:(RequestCallBackBlock )callBackBlock {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = EFMailShopCart_RemoveItems;
    EFRemoveItemsRequest *request = [EFRemoveItemsRequest requestWithPOST];
    request.productIds = _productIds;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            //            [UIUtil alert:@"服务器出错"];
            return ;
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            callBackBlock(callBackStatus, result);
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}


/* 修改购物项目数量*/
- (void)UpdateItemQuantityWithProductId:(NSInteger)_productIds Quantity:(NSInteger)_quantity callBackBlock:(RequestCallBackBlock )callBackBlock{
    EFViewControllerCallBackAction efViewControllerCallBackAction = EFMailShopCart_UpdateItemQuantity;
    EFUpdateItemQuantityRequest *request = [EFUpdateItemQuantityRequest requestWithPOST];
    request.productId = _productIds;
    request.quantity = _quantity;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            //            [UIUtil alert:@"服务器出错"];
            return ;
        }else if (callBackStatus == CallBackStatusRequestError){
          
        }else if (callBackStatus == CallBackStatusSuccess){
            
        }
        callBackBlock(callBackStatus, result);
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
        
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}


/****************商城-订单管理服务rest接口**************/

/***  创建订单*/
- (void)createOrder:(NSString *)_consigneeRegionId ConsigneeName:(NSString *)_consigneeName ConsigneeMobile:(NSString *)_consigneeMobile ConsigneeAddress:(NSString *)_consigneeAddress ConsigneeZipCode:(NSString *)_consigneeZipCode isInvoice:(NSUInteger)_isInvoice invoiceTitle:(NSString *)_invoiceTitle orderProductId:(NSString *)_orderProductId orderProductCount:( NSString *)_orderProductCount shippingMethodId:(NSInteger)_shippingMethodId  notes:(NSString *)_notes andIsWalletPay:(BOOL)isWalletPay andPayPassword:(NSString *)password{
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = EFMailShopCart_CreateOrder;
    CreateOrder *request = [CreateOrder requestWithPOST];
    request.consigneeRegionId = _consigneeRegionId;
    request.consigneeName = _consigneeName;
    request.consigneeMobile = _consigneeMobile;
    request.consigneeAddress = _consigneeAddress;
    request.consigneeZipCode = _consigneeZipCode;
    request.isInvoice = _isInvoice;
    request.invoiceTitle = _invoiceTitle;
    request.orderProductId = _orderProductId;
    request.orderProductCount = _orderProductCount;
    request.shippingMethodId = _shippingMethodId;
    request.notes = _notes;
    request.isWalletPay = isWalletPay;
    request.payPassword = password;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
            _orderListModel = [EFOrderListModel yy_modelWithDictionary:result.jsonDict[@"content"]];
            _orderModelArray = [NSMutableArray array];
            for(int i=0; i<_orderListModel.content.count; i++) {
                OrderModel *orderModel = [OrderModel yy_modelWithJSON:_orderListModel.content[i]];
                [_orderModelArray addObject:orderModel];
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
        
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}


/***  返回我的订单列表*/
- (void)getMyOrderList:(NSInteger)_page Size: (NSInteger)_size Status:(NSString *)_statusString{
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = EFMailShopCart_MyOrderList;
    MyOrderList *request = [MyOrderList requestWithGET];
    request.page = _page;
    request.size = _size;
    request.status = _statusString;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            //            [UIUtil alert:@"服务器出错"];
            return ;
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            _orderListModel = [EFOrderListModel yy_modelWithDictionary:result.jsonDict[@"content"]];
            _orderModelArray = [NSMutableArray array];
            for(int i=0; i<_orderListModel.content.count; i++) {
                OrderModel *orderModel = [OrderModel yy_modelWithJSON:_orderListModel.content[i]];
                [_orderModelArray addObject:orderModel];
            }
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
        
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}

/***  取消订单*/
- (void)cancelOrder:(NSInteger)_orderId Caulse:(NSString *)_caulse callBackBlock:(RequestCallBackBlock )callBackBlock {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = EFMailShopCart_CancelOrder;
    CancelOrder *request = [CancelOrder requestWithPOST];
    request.orderId = _orderId;
    request.caulse = _caulse;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            //            [UIUtil alert:@"服务器出错"];
            return ;
        }else if (callBackStatus == CallBackStatusRequestError){
        
        }else if (callBackStatus == CallBackStatusSuccess){
            callBackBlock(callBackStatus, result);
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
        
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}

/***  确认订单*/
- (void)confirmOrder:(NSInteger )_orderId {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = EFMailShopCart_ConfirmOrder;
    ConfirmOrder *request = [ConfirmOrder requestWithPOST];
    request.orderId = _orderId;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            //            [UIUtil alert:@"服务器出错"];
            return ;
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
        
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}

/***  刪除订单*/
- (void)DeleteOrder:(NSInteger)_orderId {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = EFMailShopCart_DeleteOrder;
    DeleteOrder *request = [DeleteOrder requestWithPOST];
    request.orderId = _orderId;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            //            [UIUtil alert:@"服务器出错"];
            return ;
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
        
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}


/***  完成订单*/
- (void)FinishOrder:(NSInteger)_orderId callBackBlock:(RequestCallBackBlock )callBackBlock {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = EFMailShopCart_FinishOrder;
    FinishOrder *request = [FinishOrder requestWithPOST];
    request.orderId = _orderId;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            //            [UIUtil alert:@"服务器出错"];
            return ;
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
        }
        callBackBlock(callBackStatus, result);
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
        
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}

/***  支付订单*/
- (void)PayOrder:(NSString *)_orderId callBackBlock:(RequestCallBackBlock )callBackBlock{
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = EFMailShopCart_PayOrder;
    PayOrder *request = [PayOrder requestWithPOST];
    request.orderId = _orderId;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            //            [UIUtil alert:@"服务器出错"];
            return ;
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
           
        }
        if(callBackBlock) {
             callBackBlock(callBackStatus, result);
        }
       
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
        
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}

/***  支付宝支付*/
- (void)AliPay:(NSString *)_orderId callBackBlock:(RequestCallBackBlock )callBackBlock{
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = EFMailShopCart_AliPay;
    AliPay *request = [AliPay requestWithPOST];
    request.orderId = _orderId;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            //            [UIUtil alert:@"服务器出错"];
            return ;
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
        }
        if(callBackBlock) {
            callBackBlock(callBackStatus, result);
        }
        
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
        
    } Request:request WithTag:(int)efViewControllerCallBackAction];

}

/***  余额支付*/
- (void)BalancePay:(NSString *)_orderId callBackBlock:(RequestCallBackBlock )callBackBlock{
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = EFMailShopCart_BalancePay;
    BalancePay *request = [BalancePay requestWithPOST];
    request.orderId = _orderId;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            //            [UIUtil alert:@"服务器出错"];
            return ;
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
        }
        if(callBackBlock) {
            callBackBlock(callBackStatus, result);
        }
        
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
        
    } Request:request WithTag:(int)efViewControllerCallBackAction];
    
}

/***  微信支付*/
- (void)WeChatPay:(NSString *)_orderId callBackBlock:(RequestCallBackBlock )callBackBlock{
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = EFMailShopCart_WeChatPay;
    WeChatPay *request = [WeChatPay requestWithPOST];
    request.orderId = _orderId;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            //            [UIUtil alert:@"服务器出错"];
            return ;
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
        }
        if(callBackBlock) {
            callBackBlock(callBackStatus, result);
        }
        
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
        
    } Request:request WithTag:(int)efViewControllerCallBackAction];
    
}

/***  确认收货*/
- (void)ReceivedOrder:(NSInteger)_orderId callBackBlock:(RequestCallBackBlock )callBackBlock {
    EFViewControllerCallBackAction efViewControllerCallBackAction = EFMailShopCart_ReceivedOrder;
    Received *request = [Received requestWithPOST];
    request.orderId = _orderId;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            //            [UIUtil alert:@"服务器出错"];
            return ;
        }else if (callBackStatus == CallBackStatusRequestError){
    
        }else if (callBackStatus == CallBackStatusSuccess){
            
        }
        callBackBlock(callBackStatus, result);
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
        
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}

/***  根据订单id返回订单详情*/
- (void)GetOrderById:(NSInteger)_orderId {
    EFViewControllerCallBackAction efViewControllerCallBackAction = EFMailShopCart_GetOrderById;
    GetOrderById *request = [GetOrderById requestWithGET];
    request.orderId = _orderId;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            //            [UIUtil alert:@"服务器出错"];
            return ;
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            _orderDetailModel = [EFOrderDetailModel yy_modelWithDictionary:result.jsonDict[@"content"]];
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
        
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}


    /****************商城-退货单信息管理rest接口**************/

/***  申请退货*/
- (void)ApplyReturnGood:(NSInteger)_orderId andReason:(NSString *)reason callBackBlock:(RequestCallBackBlock )callBackBlock {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = EFMailShopCart_ApplyReturnGood;
    ApplyReturnGood *request = [ApplyReturnGood requestWithPOST];
    request.orderId = _orderId;
    request.reason = reason;
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            //            [UIUtil alert:@"服务器出错"];
            return ;
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
        }
        callBackBlock(callBackStatus, result);
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
        
    } Request:request WithTag:(int)efViewControllerCallBackAction];

}


/*** 申请退款*/
- (void)ApplyReturnMoney:(NSInteger)_orderId andReason:(NSString *)reason callBackBlock:(RequestCallBackBlock )callBackBlock {
    
    ApplyReturnMoney *request = [ApplyReturnMoney requestWithPOST];
    request.orderId = _orderId;
    request.reason = reason;
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:EFMailShopCart_ApplyReturnMoney];
        
        callBackBlock(callBackStatus, result);
    } Request:request WithTag:EFMailShopCart_ApplyReturnMoney];
    
}


/*** 返回我的退货单*/
- (void)ReturnMyList:(int)_page Size:(int) _size {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = EFMailShopCart_ReturnMyList;
    ReturnMyList *request = [ReturnMyList requestWithGET];
    request.page = _page;
    request.size =_size;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            //            [UIUtil alert:@"服务器出错"];
            return ;
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
        }

        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
        
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}


/*** 根据订单id返回我的退货单*/
- (void)FindByOrder:(NSInteger)_orderId {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = EFMailShopCart_FindByOrder;
    FindByOrder *request = [FindByOrder requestWithGET];
    request.id = _orderId;

    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            //            [UIUtil alert:@"服务器出错"];
            return ;
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
             _returnOfGoodsModel = [ReturnOfGoodsModel yy_modelWithDictionary:result.jsonDict[@"content"]];
        }
        
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
        
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}

/** *  获取钱包信息 */
- (void)getMyWalletInfo{
    EFMyWalletInfoRequest *request = [EFMyWalletInfoRequest requestWithGET];
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:EFMailShopCart_WalletInfo];
        
        [self.viewController callBackAction:EFMailShopCart_WalletInfo Result:result];
    } Request:request WithTag:EFMailShopCart_WalletInfo];
}
@end