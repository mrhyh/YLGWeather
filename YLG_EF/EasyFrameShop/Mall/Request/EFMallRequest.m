//
//  EFMallRequest.m
//  EF_MallDemo
//
//  Created by HqLee on 16/6/15.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFMallRequest.h"

@implementation EFMallGetAddressListRequest
- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/xx/receiver/my";
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"version":@"1.0",@"token":token};
    [super startCallBack:callBack];
}
@end

@implementation EFMallAddAddressRequest
- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/xx/receiver/my/add";
    self.params = @{@"isDefault":@(self.consigneeModel.isDefault),
                    @"consignee":self.consigneeModel.consignee,
                    @"regionId":self.consigneeModel.regionId,
                    @"address":self.consigneeModel.address,
                    @"zipCode":self.consigneeModel.zipCode,
                    @"phone":self.consigneeModel.phone};
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"version":@"1.0",@"token":token};
    [super startCallBack:callBack];
}

@end

@implementation EFMallSaveAddressRequest
- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/xx/receiver/my/save";
    self.params = @{@"isDefault":@(self.consigneeModel.isDefault),
                    @"consignee":self.consigneeModel.consignee,
                    @"regionId":self.consigneeModel.regionId,
                    @"address":self.consigneeModel.address,
                    @"zipCode":self.consigneeModel.zipCode,
                    @"phone":self.consigneeModel.phone};
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"version":@"1.0",@"token":token};
    [super startCallBack:callBack];
}
@end

@implementation EFMallDelAddressRequest
- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/xx/receiver/my/dadad/delete";
    self.params = @{@"id":self.objectId};
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"version":@"1.0",@"token":token};
    [super startCallBack:callBack];
}
@end

/**
 * 添加一个商品到购物车
 */
@implementation EFMallAddGoodToShopCardRequest
- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/xx/cart/addItem";
    self.params = @{@"productId":self.productId,
                    @"quantity":@"1"};
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"version":@"1.0",@"token":token};
    [super startCallBack:callBack];
}
@end
/**
 *  获取商品列表
 */
@implementation EFMallGetGoodListRequest
- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/xx/goods/";
//    self.params = @{@"categoryId":@(self.requestParams.categoryId),
//                    @"soldOut":@(self.requestParams.soldOut),
//                    @"regionId":self.requestParams.regionId,
//                    @"attubuteIndexes":self.requestParams.attubuteIndexes,
//                    @"attubuteValues":self.requestParams.attubuteValues,
//                    @"brandId":self.requestParams.brandId,
//                    @"sort":self.requestParams.sort,
//                    @"page":@(self.requestParams.page),
//                    @"size":@(self.requestParams.size)};
//    self.params = @{@"page":@(self.requestParams.page),
//                    @"size":@(self.requestParams.size)};
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"version":@"1.0",@"token":token};
    [super startCallBack:callBack];
}
@end
/**
 *  商品详情
 */
@implementation EFGoodDetailRequest
- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = [NSString stringWithFormat:@"/rest/xx/goods/%@",self.productId];
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"version":@"1.0",@"token":token};
    [super startCallBack:callBack];
}
@end

/**
 *  机构详情
 */
@implementation EFStoreDetailRequest
- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = [NSString stringWithFormat:@"/rest/xx/shop/%@",self.shopId];
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"version":@"1.0",@"token":token};
    [super startCallBack:callBack];
}
@end
/**
 *  评价列表
 */
@implementation EFCommentListRequest
- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = [NSString stringWithFormat:@"/rest/xx/product/%@/evaluates",self.productId];
    self.params = @{@"page":@(self.page),
                    @"size":@(self.size)};
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"version":@"1.0",@"token":token};
    [super startCallBack:callBack];
}
@end

/**
 *  获取产品列表
 */
@implementation EFMallGetProductListRequest
- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = [NSString stringWithFormat:@"/rest/xx/product/products"];
    self.params = self.requestParams;
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"version":@"1.0",@"token":token};
    [super startCallBack:callBack];
}
@end
/**
 *  产品详情
 */
@implementation EFProductDetailRequest
- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = [NSString stringWithFormat:@"/rest/xx/product/%@",self.productId];
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"version":@"1.0",@"token":token};
    [super startCallBack:callBack];
}
@end

/**
 *  评价产品
 */
@implementation EFCommentProductRequest
- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = [NSString stringWithFormat:@"/rest/xx/product/%zd/evaluate",self.productId];
    self.params = @{@"score":@(self.score),
                    @"orderItemId":@(self.orderItemId),
                    @"content":self.content == nil ? @"" : self.content,
                    @"anonymous":@(self.isAnonymous)};
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"version":@"1.0",@"token":token};
    [super startCallBack:callBack];
}
@end
/**
 *  获取热门标签
 */
@implementation EFGetHotTagsRequest
- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/xx/tag/hots";
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"version":@"1.0",@"token":token};
    [super startCallBack:callBack];
}
@end

@implementation EFGetCategoryRequest
- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/xx/category/getCategory";
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"version":@"1.0",@"token":token};
    [super startCallBack:callBack];
}

@end
@implementation EFSetPayPasswordRequest
- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/user/setPayPassword";
    self.params = @{@"mobile":self.mobile,
                    @"payPassword":self.payPassword,
                    @"validateCode":self.validateCode};
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"version":@"1.0",@"token":token};
    [super startCallBack:callBack];
}

@end

@implementation EFGetCodeRequest
- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/user/sendSetPayPasswordSecurityCodeToMobile";
    self.params = @{@"mobile":self.mobile};
    NSString * token = @"";
    if ([UserModel ShareUserModel].token) {
        token = [UserModel ShareUserModel].token;
    }
    self.httpHeaderFields = @{@"version":@"1.0",@"token":token};
    [super startCallBack:callBack];
}
@end