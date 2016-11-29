//
//  EFMallViewModel.m
//  EF_MallDemo
//
//  Created by HqLee on 16/6/15.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFMallViewModel.h"
#import "EFMallRequest.h"   

@implementation EFMallViewModel
/**
 *  获取所有的收货人
 */
- (void)getAllConsigneeAddressList{
    EFMallGetAddressListRequest *request = [EFMallGetAddressListRequest requestWithGET];
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:EFMallViewModelCallBackActionGetAddressList];
        
        [self.viewController callBackAction:EFMallViewModelCallBackActionGetAddressList Result:result];
    } Request:request WithTag:EFMallViewModelCallBackActionGetAddressList];
}

/**
 *  添加一个收货地址
 *
 *  @param consigneeModel 收货地址模型
 */
- (void)addConsigneeAddress:(EFMallConsigneeModel *)consigneeModel{
    EFMallAddAddressRequest *request = [EFMallAddAddressRequest requestWithPOST];
    request.consigneeModel = consigneeModel;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:EFMallViewModelCallBackActionAddAddress];
        
        [self.viewController callBackAction:EFMallViewModelCallBackActionAddAddress Result:result];
    } Request:request WithTag:EFMallViewModelCallBackActionAddAddress];
}

/**
 *  保存一个收货地址
 *
 *  @param objectId 收货地址的Id
 */
- (void)saveConsigneeAddress:(EFMallConsigneeModel *)consigneeModel{
    EFMallSaveAddressRequest *request = [EFMallSaveAddressRequest requestWithPOST];
    request.consigneeModel = consigneeModel;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:EFMallViewModelCallBackActionSaveAddress];
        
        [self.viewController callBackAction:EFMallViewModelCallBackActionSaveAddress Result:result];
    } Request:request WithTag:EFMallViewModelCallBackActionSaveAddress];
}
/**
 *  删除一个收货地址
 *
 *  @param objectId 收货地址的Id
 */
- (void)delConsigneeAddress:(NSString *)objectId{
    EFMallDelAddressRequest *request = [EFMallDelAddressRequest requestWithPOST];
    request.objectId = objectId;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:EFMallViewModelCallBackActionDelAddress];
        
        [self.viewController callBackAction:EFMallViewModelCallBackActionDelAddress Result:result];
    } Request:request WithTag:EFMallViewModelCallBackActionDelAddress];
}

/**
 *  获取商品列表
 *
 *  @param requestParams 请求参数模型
 */
- (void)getGoodsList:(NSDictionary *)requestParams{
    EFMallGetGoodListRequest *request = [EFMallGetGoodListRequest requestWithGET];
    request.requestParams = requestParams;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:EFMallViewModelCallBackActionGoodsList];
        
        [self.viewController callBackAction:EFMallViewModelCallBackActionGoodsList Result:result];
    } Request:request WithTag:EFMallViewModelCallBackActionGoodsList];
}
/**
 *  获取商品详情
 *
 *  @param productId 商品ID
 */
- (void)goodDetailWithProductID:(NSString *)productId{
    EFGoodDetailRequest *request = [EFGoodDetailRequest requestWithGET];
    request.productId = productId;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:EFMallViewModelCallBackActionGoodDetail];
        
        [self.viewController callBackAction:EFMallViewModelCallBackActionGoodDetail Result:result];
    } Request:request WithTag:EFMallViewModelCallBackActionGoodDetail];
}

/**
 *  获取店铺详情
 *
 *  @param shopId 店铺ID
 */
- (void)getStoreDetailWithShopId:(NSString *)shopId{
    EFStoreDetailRequest *request = [EFStoreDetailRequest requestWithGET];
    request.shopId = shopId;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:EFMallViewModelCallBackActionShopDetail];
        
        [self.viewController callBackAction:EFMallViewModelCallBackActionShopDetail Result:result];
    } Request:request WithTag:EFMallViewModelCallBackActionShopDetail];
}

/**
 *  获取评价列表
 *
 *  @param page 页码
 */
- (void)getCommentList:(NSInteger )page andProductId:(NSString *)productId{
    EFCommentListRequest *request = [EFCommentListRequest requestWithGET];
    request.productId = productId;
    request.size = 30;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:EFMallViewModelCallBackActionCommentList];
        
        [self.viewController callBackAction:EFMallViewModelCallBackActionCommentList Result:result];
    } Request:request WithTag:EFMallViewModelCallBackActionCommentList];
}

/**
 *  获取产品列表
 *
 *  @param requestParams 请求参数模型
 */
- (void)getProductsList:(NSDictionary *)requestParams{
    EFMallGetProductListRequest *request = [EFMallGetProductListRequest requestWithPOST];
    request.requestParams = requestParams;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:EFMallViewModelCallBackActionProductsList];
        
        [self.viewController callBackAction:EFMallViewModelCallBackActionProductsList Result:result];
    } Request:request WithTag:EFMallViewModelCallBackActionProductsList];
}
/**
 *  获取产品详情
 *
 *  @param productId 产品ID
 */
- (void)productDetailWithProductID:(NSString *)productId{
    EFProductDetailRequest *request = [EFProductDetailRequest requestWithGET];
    request.productId = productId;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:EFMallViewModelCallBackActionProductDetail];
        
        [self.viewController callBackAction:EFMallViewModelCallBackActionProductDetail Result:result];
    } Request:request WithTag:EFMallViewModelCallBackActionProductDetail];
}
/**
 *  添加一个产品到购物车
 *
 *  @param goodId 产品的Id
 */
- (void)addShopCarWithProductId:(NSString *)productId
                       quantity:(NSString *)quantity{
    EFMallAddGoodToShopCardRequest *request = [EFMallAddGoodToShopCardRequest requestWithPOST];
    request.productId = productId;
    request.quantity = quantity;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:EFMallViewModelCallBackActionAddShopCar];
        
        [self.viewController callBackAction:EFMallViewModelCallBackActionAddShopCar Result:result];
    } Request:request WithTag:EFMallViewModelCallBackActionAddShopCar];
}
/**
 *  评价产品
 *
 *  @param productId  产品的ID
 *  @param orderItemId 订单ID
 *  @param score      分数
 *  @param content    内容
 *  @param isAnonmous 是否匿名
 */
- (void)commentProductWithProductId:(NSInteger )productId
                        orderItemId:(NSInteger )orderItemId
                              score:(CGFloat)score
                            content:(NSString *)content
                          anonymous:(BOOL)isAnonmous{
    EFCommentProductRequest *request = [EFCommentProductRequest requestWithPOST];
    request.productId = productId;
    request.orderItemId = orderItemId;
    request.score = score;
    request.content = content;
    request.isAnonymous = isAnonmous;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:EFMallViewModelCallBackActionCommentProduct];
        
        [self.viewController callBackAction:EFMallViewModelCallBackActionCommentProduct Result:result];
    } Request:request WithTag:EFMallViewModelCallBackActionCommentProduct];
}

/**
 *  获取热门标签
 */
- (void)getHotTags{
    EFGetHotTagsRequest *request = [EFGetHotTagsRequest requestWithGET];
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:EFMallViewModelCallBackActionGetHotTags];
        
        [self.viewController callBackAction:EFMallViewModelCallBackActionGetHotTags Result:result];
    } Request:request WithTag:EFMallViewModelCallBackActionGetHotTags];
}

/**
 *  返回商品的一级栏目ID
 */
- (void)getCategory{
    EFGetCategoryRequest *request = [EFGetCategoryRequest requestWithGET];
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:EFMallViewModelCallBackActionGetCategory];
        
        [self.viewController callBackAction:EFMallViewModelCallBackActionGetCategory Result:result];
    } Request:request WithTag:EFMallViewModelCallBackActionGetCategory];
}

/**
 *  设置支付密码
 *
 *  @param mobile       手机号
 *  @param payPassword  支付密码
 *  @param validateCode 验证码
 */
- (void)setPaymentPasswordWithMobile:(NSString *)mobile
                         payPassword:(NSString *)payPassword
                        validateCode:(NSString *)validateCode{
    EFSetPayPasswordRequest *request = [EFSetPayPasswordRequest requestWithPOST];
    request.mobile = mobile;
    request.payPassword = payPassword;
    request.validateCode = validateCode;
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:EFMallViewModelCallBackActionSetPayPassword];
        
        [self.viewController callBackAction:EFMallViewModelCallBackActionSetPayPassword Result:result];
    } Request:request WithTag:EFMallViewModelCallBackActionSetPayPassword];
}

/**
 *  修改支付密码
 *
 *  @param mobile       手机号
 *  @param payPassword  支付密码
 *  @param validateCode 验证码
 */
- (void)modifyPaymentPasswordWithMobile:(NSString *)mobile
                            payPassword:(NSString *)payPassword
                           validateCode:(NSString *)validateCode{
    EFSetPayPasswordRequest *request = [EFSetPayPasswordRequest requestWithPOST];
    request.mobile = mobile;
    request.payPassword = payPassword;
    request.validateCode = validateCode;
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:EFMallViewModelCallBackActionModifyPayPassword];
        
        [self.viewController callBackAction:EFMallViewModelCallBackActionModifyPayPassword Result:result];
    } Request:request WithTag:EFMallViewModelCallBackActionModifyPayPassword];
}
/**
 *  获取设置支付密码的验证码
 *
 *  @param mobile 手机号
 */
- (void)getPayPasswordSecurityCodeWithMobile:(NSString *)mobile{
    EFGetCodeRequest *request = [EFGetCodeRequest requestWithGET];
    request.mobile = mobile;
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:EFMallViewModelCallBackActionGetValidateCode];
        
        [self.viewController callBackAction:EFMallViewModelCallBackActionGetValidateCode Result:result];
    } Request:request WithTag:EFMallViewModelCallBackActionGetValidateCode];
}
@end
