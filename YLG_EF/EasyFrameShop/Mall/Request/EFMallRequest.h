//
//  EFMallRequest.h
//  EF_MallDemo
//
//  Created by HqLee on 16/6/15.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFRequest.h"
#import "EFMallModel.h"
#import "EFMailHeader.h"

/**
 *  获取地址列表
 */
@interface EFMallGetAddressListRequest : EFRequest

@end
/**
 *  添加一个收货地址
 */
@interface EFMallAddAddressRequest : EFRequest
@property (nonatomic, strong) EFMallConsigneeModel *consigneeModel;
@end
/**
 *  保存一个收货地址
 */
@interface EFMallSaveAddressRequest : EFRequest
@property (nonatomic, strong) EFMallConsigneeModel *consigneeModel;
@end
/**
 *  删除一个收货地址
 */
@interface EFMallDelAddressRequest : EFRequest
@property (nonatomic, copy) NSString *objectId;
@end
/**
 * 添加一个商品到购物车
 */
@interface EFMallAddGoodToShopCardRequest : EFRequest
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *quantity;
@end
/**
 *  获取商品列表
 */
@interface EFMallGetGoodListRequest : EFRequest
@property (nonatomic, strong) NSDictionary *requestParams;
@end
/**
 *  商品详情
 */
@interface EFGoodDetailRequest : EFRequest
@property (nonatomic, copy) NSString *productId;
@end
/**
 *  店铺详情
 */
@interface EFStoreDetailRequest : EFRequest
@property (nonatomic, copy) NSString *shopId;
@end
/**
 *  评论列表
 */
@interface EFCommentListRequest : EFRequest
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger size;
@end
/**
 *  获取产品列表
 */
@interface EFMallGetProductListRequest : EFRequest
@property (nonatomic, strong) NSDictionary *requestParams;
@end
/**
 *  产品详情
 */
@interface EFProductDetailRequest : EFRequest
@property (nonatomic, copy) NSString *productId;
@end
/**
 *  评价产品
 */
@interface EFCommentProductRequest : EFRequest
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, assign) NSInteger orderItemId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) BOOL isAnonymous;
@property (nonatomic, assign) CGFloat score;
@end
/**
 *  获取热门标签 
 */
@interface EFGetHotTagsRequest : EFRequest
@end
/**
 *  获取一级栏目类别
 */
@interface EFGetCategoryRequest : EFRequest
@end

@interface EFSetPayPasswordRequest : EFRequest
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *payPassword;
@property (nonatomic, copy) NSString *validateCode;
@end

@interface EFGetCodeRequest : EFRequest
@property (nonatomic, copy) NSString *mobile;
@end