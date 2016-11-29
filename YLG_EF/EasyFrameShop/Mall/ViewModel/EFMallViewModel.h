//
//  EFMallViewModel.h
//  EF_MallDemo
//
//  Created by HqLee on 16/6/15.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFBaseViewModel.h"
#import "EFMallModel.h"
typedef NS_ENUM(EFViewControllerCallBackAction,EFMallViewModelCallBackAction){
    EFMallViewModelCallBackActionGetAddressList = 1,//得到所有收货地址的tag
    EFMallViewModelCallBackActionAddAddress = 2,//添加一个收货地址的tag
    EFMallViewModelCallBackActionSaveAddress = 3,//保存一个收货地址的tag
    EFMallViewModelCallBackActionDelAddress = 4,//删除一个收货地址的tag
    EFMallViewModelCallBackActionAddShopCar = 5,//添加一个商品到购物车的tag
    EFMallViewModelCallBackActionGoodsList = 6,//获取商品列表的tag
    EFMallViewModelCallBackActionGoodDetail = 7,//商品详情的tag
    EFMallViewModelCallBackActionShopDetail = 8,//店铺详情的tag
    EFMallViewModelCallBackActionCommentList = 9,//商品评价列表的tag
    EFMallViewModelCallBackActionProductsList = 10,//产品列表的tag
    EFMallViewModelCallBackActionProductDetail = 11,//产品详情的tag
    EFMallViewModelCallBackActionCommentProduct = 12,//评价产品的tag
    EFMallViewModelCallBackActionGetHotTags = 13,//获取热门标签的tag
    EFMallViewModelCallBackActionGetCategory = 14,//获取一级类别栏目的tag
    EFMallViewModelCallBackActionSetPayPassword = 15,//设置支付密码
    EFMallViewModelCallBackActionGetValidateCode = 16,//获取验证码
    EFMallViewModelCallBackActionModifyPayPassword = 17,//修改支付密码
};

@interface EFMallViewModel : EFBaseViewModel
/**
 *  获取收货地址列表
 */
- (void)getAllConsigneeAddressList;

/**
 *  添加一个收货地址
 *
 *  @param consigneeModel 收货地址模型
 */
- (void)addConsigneeAddress:(EFMallConsigneeModel *)consigneeModel;

/**
 *  保存一个收货地址
 *
 *  @param consigneeModel 收货地址模型
 */
- (void)saveConsigneeAddress:(EFMallConsigneeModel *)consigneeModel;
/**
 *  删除一个收货地址
 *
 *  @param objectId 收货地址的Id
 */
- (void)delConsigneeAddress:(NSString *)objectId;
/**
 *  获取商品列表
 *
 *  @param requestParams 请求参数模型
 */
- (void)getGoodsList:(NSDictionary *)requestParams;
/**
 *  获取商品详情
 *
 *  @param productId 商品ID
 */
- (void)goodDetailWithProductID:(NSString *)goodId;
/**
 *  获取店铺详情
 *
 *  @param shopId 店铺ID
 */
- (void)getStoreDetailWithShopId:(NSString *)shopId;
/**
 *  获取评价列表
 *
 *  @param page 页码
 */
- (void)getCommentList:(NSInteger )page andProductId:(NSString *)productId;
/**
 *  获取产品列表
 *
 *  @param requestParams 请求参数模型
 */
- (void)getProductsList:(NSDictionary *)requestParams;
/**
 *  获取产品详情
 *
 *  @param productId 产品ID
 */
- (void)productDetailWithProductID:(NSString *)productId;
/**
 *  添加一个产品到购物车
 *
 *  @param goodId 产品的Id
 */
- (void)addShopCarWithProductId:(NSString *)productId quantity:(NSString *)quantity;
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
                          anonymous:(BOOL)isAnonmous;

/**
 *  获取热门标签
 */
- (void)getHotTags;
/**
 *  返回商品的一级栏目ID
 */
- (void)getCategory;
/**
 *  设置支付密码
 *
 *  @param mobile       手机号
 *  @param payPassword  支付密码
 *  @param validateCode 验证码
 */
- (void)setPaymentPasswordWithMobile:(NSString *)mobile
                         payPassword:(NSString *)payPassword
                        validateCode:(NSString *)validateCode;
/**
 *  修改支付密码
 *
 *  @param mobile       手机号
 *  @param payPassword  支付密码
 *  @param validateCode 验证码
 */
- (void)modifyPaymentPasswordWithMobile:(NSString *)mobile
                            payPassword:(NSString *)payPassword
                           validateCode:(NSString *)validateCode;
/**
 *  获取设置支付密码的验证码
 *
 *  @param mobile 手机号
 */
- (void)getPayPasswordSecurityCodeWithMobile:(NSString *)mobile;

@end