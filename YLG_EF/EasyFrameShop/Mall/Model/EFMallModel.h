//
//  EFMallModel.h
//  EF_MallDemo
//
//  Created by HqLee on 16/6/17.
//  Copyright © 2016年 MH. All rights reserved.
//

#import <Foundation/Foundation.h>

// 默认收货地址字典对应userDefault的key
UIKIT_EXTERN NSString *const EFDefaultConsigneeAddressKey;
//收货人name
UIKIT_EXTERN NSString *const EFDefaultConsigneeNameKey;
//收货人电话
UIKIT_EXTERN NSString *const EFDefaultConsigneePhoneKey;
//收货人所在地区ID
UIKIT_EXTERN NSString *const EFDefaultConsigneeRegionIDKey;
//收货人详细地址
UIKIT_EXTERN NSString *const EFDefaultConsigneeDetailAddressKey;
//收货人邮编
UIKIT_EXTERN NSString *const EFDefaultConsigneeZipCodeKey;



/** 收货地址model */
@class Image,Shop,Brand,Logo,Specifications,Values,ProductSpecification,OtherProductSpecification;
@class Evaluater,Head;
@class Image,Shopitem;
@interface EFMallConsigneeModel : NSObject
/**是否默认*/
@property (nonatomic, assign) BOOL isDefault;
/**收货人*/
@property (nonatomic, copy) NSString *consignee;
/**地区名称*/
@property (nonatomic, copy) NSString *areaName;
/**详细地址*/
@property (nonatomic, copy) NSString *address;
/** 电话*/
@property (nonatomic, copy) NSString *phone;
/** 邮编 */
@property (nonatomic, copy) NSString *zipCode;
/** 收货地址对应的Id*/
@property (nonatomic, copy) NSString *objectId;
/** 收货人所在地区ID*/
@property (nonatomic, copy) NSString *regionId;
/** 省份ID */
@property (nonatomic, copy) NSString *provinceId;
/** 城市ID */
@property (nonatomic, copy) NSString *cityId;
/** 区县ID*/
@property (nonatomic, copy) NSString *districtId;

/* 保存收货地址*/
- (void) saveEFMallConsigneeModel: (EFMallConsigneeModel *) efMallConsigneeModel;
/*读取收货地址*/
- (EFMallConsigneeModel *)readEFMallConsigneeModel;


@end

/** 商品列表model */
@interface EFMallGoodListModel : NSObject
/** 销量 */
@property (nonatomic, assign) NSInteger sales;
/** 店铺 */
@property (nonatomic, strong) Shopitem *shopItem;
/** 售价  */
@property (nonatomic, assign) NSInteger price;
/** 评价分数  */
@property (nonatomic, assign) NSInteger evaluateScore;
/** 商品图片  */
@property (nonatomic, strong) Image *image;
/** 市场价  */
@property (nonatomic, assign) NSInteger marketPrice;
/** 商品ID */
@property (nonatomic, assign) NSInteger objectId;
/** 名称 */
@property (nonatomic, copy) NSString *name;
/** 标签 */
@property (nonatomic, strong) NSArray<NSString *> *tags;
@end


/**
 *  产品详情模型
 */
@interface ProductDetailModel : NSObject
/** 编号 */
@property (nonatomic, copy) NSString *sn;
/** 店铺 */
@property (nonatomic, strong) Shopitem *shopItem;
/** 市场价 */
@property (nonatomic, assign) NSInteger marketPrice;
/** 重量，单位克 */
@property (nonatomic, assign) NSInteger weight;
/** 介绍 */
@property (nonatomic, copy) NSString *introduce;
/** 售价 */
@property (nonatomic, assign) NSInteger price;
/** 评论数 */
@property (nonatomic, assign) NSInteger commentCount;
/** 产品编号 */
@property (nonatomic, copy) NSString *productCode;
/** 销量 */
@property (nonatomic, assign) NSInteger sales;
/** 商品ID */
@property (nonatomic, assign) NSInteger goodsId;
/** 规格图片 */
@property (nonatomic, strong) Image *image;
/** 图片集 */
@property (nonatomic, strong) NSArray <Image *>*images;
/** 评价分数 */
@property (nonatomic, assign) CGFloat score;
/** 库存 */
@property (nonatomic, assign) NSInteger stock;
/** 对象ID */
@property (nonatomic, assign) NSInteger objectId;
/** 名称 */
@property (nonatomic, copy) NSString *name;
/** 评价数量 */
@property (nonatomic, assign) NSInteger scoreCount;
/** 总评分 */
@property (nonatomic, assign) CGFloat totalScore;
/** 该产品的规格 */
@property (nonatomic, strong) NSArray <ProductSpecification *> *productSpecification;
/** 规格对应的值 */
@property (nonatomic, strong) NSArray <Specifications *> *specifications;
/** 其他规格 */
@property (nonatomic, strong) NSArray <OtherProductSpecification *> *otherProductSpecifications;
@end

/**
 *  品牌
 */
@interface Brand : NSObject
/** 对象ID */
@property (nonatomic, assign) NSInteger objectId;
/** 品牌名称 */
@property (nonatomic, copy) NSString *name;
/** 品牌官网 */
@property (nonatomic, copy) NSString *url;
/** 品牌 */
@property (nonatomic, strong) Logo *logo;

@end

/**
 *  品牌
 */
@interface Logo : NSObject
/** 附件访问地址 */
@property (nonatomic, copy) NSString *url;
/** 对象ID */
@property (nonatomic, assign) NSInteger objectId;

@end

/**
 *  规格
 */
@interface Specifications : NSObject
/** 商品规格名称 */
@property (nonatomic, copy) NSString *name;
/** 商品规格值 */
@property (nonatomic, strong) NSArray<Values *> *values;
/** 对象ID */
@property (nonatomic, assign) NSInteger objectId;
@end

/**
 *  商品规格值
 */
@interface Values : NSObject
/** 规格图片 */
@property (nonatomic, strong) Image *image;
/** 规格文本值 */
@property (nonatomic, copy) NSString *text;
/** 对象ID */
@property (nonatomic, assign) NSInteger objectId;

@end

@interface Image : NSObject
/** 图片地址 */
@property (nonatomic, copy) NSString *url;
/** 图片ID */
@property (nonatomic, assign) NSInteger objectId;
@property (nonatomic, strong) UIImage *orignImage;
@end

@interface Shop : NSObject
/** 商铺电话  */
@property (nonatomic, copy) NSString *contact;
/** 店铺ID */
@property (nonatomic, assign) NSInteger objectId;
/** 商铺名称 */
@property (nonatomic, copy) NSString *name;
/** 商铺地址  */
@property (nonatomic, copy) NSString *address;
/** 品牌 */
@property (nonatomic, strong) Logo *logo;
@end

/**
 *  评价列表模型
 */
@interface ProductCommentModel : NSObject
/** 评论分数 */
@property (nonatomic, assign) CGFloat score;
/** 评论内容 */
@property (nonatomic, copy) NSString *content;
/** 评论人 */
@property (nonatomic, strong) Evaluater *evaluater;
/** 评论时间 */
@property (nonatomic, assign) NSInteger evaluateTime;
/** 对象ID */
@property (nonatomic, assign) NSInteger objectId;

@end

/**
 *  评论人
 */
@interface Evaluater : NSObject
/** 评论人性别 */
@property (nonatomic, copy) NSString *sex;
/** 对象ID */
@property (nonatomic, assign) NSInteger objectId;
/** 姓名 */
@property (nonatomic, copy) NSString *nickname;
/** 头像 */
@property (nonatomic, strong) Head *head;

@end

/**
 *  产品列表
 */
@interface EFProductListModel : NSObject

@property (nonatomic, assign) NSInteger score;

@property (nonatomic, assign) NSInteger scoreCount;

@property (nonatomic, assign) NSInteger marketPrice;

@property (nonatomic, assign) NSInteger weight;

@property (nonatomic, assign) NSInteger stock;

@property (nonatomic, assign) NSInteger price;

@property (nonatomic, strong) Image *image;

@property (nonatomic, assign) NSInteger totalScore;

@property (nonatomic, assign) NSInteger objectId;

@property (nonatomic, copy) NSString *sn;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) Shopitem *shopItem;

@end

/**
 *  店铺模型
 */
@interface Shopitem : NSObject

@property (nonatomic, copy) NSString *contact;

@property (nonatomic, assign) NSInteger objectId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *address;

@end

/**
 *  热门标签
 */
@interface HotTagModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger objectId;
@end
/**
 *  其他规格模型
 */
@interface OtherProductSpecification : NSObject
/** 规格名字 */
@property (nonatomic, copy) NSString *name;
/** 对象ID */
@property (nonatomic, assign) NSInteger objectId;
/** 价格*/
@property (nonatomic, assign) NSInteger price;
/** 商品编号 */
@property (nonatomic, copy) NSString *sn;
/** 库存 */
@property (nonatomic, assign) NSInteger stock;
/** 规格模型 */
@property (nonatomic, strong) NSArray <ProductSpecification *> *productSpecification;
@end

/**
 *  规格模型
 */
@interface ProductSpecification : NSObject
/** 规格名字 */
@property (nonatomic, copy) NSString *name;
/** 对象ID */
@property (nonatomic, copy) NSString *objectId;
/** 商品规格值 */
@property (nonatomic, strong) Values *value;
@end

/**
 *  栏目类别模型
 */
@interface CategoryModel : NSObject
/** 规格名字 */
@property (nonatomic, copy) NSString *name;
/** 对象ID */
@property (nonatomic, copy) NSString *objectId;
@end
