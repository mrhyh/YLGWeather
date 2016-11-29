//
//  EFMallModel.m
//  EF_MallDemo
//
//  Created by HqLee on 16/6/17.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFMallModel.h"

//收货地址本地数据键
#define EFMallConsigneeModel_UserDefault @"EFMallConsigneeModel_UserDefault"



// 默认收货地址字典对应userDefault的key
NSString *const EFDefaultConsigneeAddressKey = @"EFDefaultConsigneeAddressKey";
//收货人name
NSString *const EFDefaultConsigneeNameKey = @"EFDefaultConsigneeNameKey";
//收货人电话
NSString *const EFDefaultConsigneePhoneKey = @"EFDefaultConsigneePhoneKey";
//收货人所在地区ID
NSString *const EFDefaultConsigneeRegionIDKey = @"EFDefaultConsigneeRegionIDKey";
//收货人详细地址
NSString *const EFDefaultConsigneeDetailAddressKey = @"EFDefaultConsigneeDetailAddressKey";
//收货人邮编
NSString *const EFDefaultConsigneeZipCodeKey = @"EFDefaultConsigneeZipCodeKey";

//收货地址模型
@implementation EFMallConsigneeModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"specifications" : [Specifications class]};
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.consignee forKey:@"consignee"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.objectId forKey:@"objectId"];
    [aCoder encodeObject:self.zipCode forKey:@"zipCode"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.consignee = [aDecoder decodeObjectForKey:@"consignee"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.regionId = [aDecoder decodeObjectForKey:@"objectId"];
        self.zipCode = [aDecoder decodeObjectForKey:@"zipCode"];
    }
    return self;
}


/* 保存收货地址*/
- (void) saveEFMallConsigneeModel: (EFMallConsigneeModel *) efMallConsigneeModel{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:efMallConsigneeModel];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:data forKey:EFMallConsigneeModel_UserDefault];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/*读取收货地址*/
- (EFMallConsigneeModel *)readEFMallConsigneeModel {
    
    NSUserDefaults *userDefaultsRead = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaultsRead objectForKey:EFMallConsigneeModel_UserDefault];
    EFMallConsigneeModel *model  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return model;
}

@end
//商品列表模型
@implementation EFMallGoodListModel
@end
//商品详情列表
@implementation ProductDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"otherProductSpecifications" : [OtherProductSpecification class],
             @"images" : [Image class],
             @"productSpecification" : [ProductSpecification class],
             @"specifications" : [Specifications class]};
}
@end
@implementation Image
@end
@implementation Shop
@end
@implementation Brand
@end
@implementation Logo
@end

@implementation Specifications
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"values" : [Values class]};
}

@end

@implementation ProductCommentModel
@end

@implementation Values
@end

//产品列表模型
@implementation EFProductListModel
@end

@implementation Evaluater
@end
@implementation Shopitem
@end
@implementation HotTagModel
@end
@implementation OtherProductSpecification
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"productSpecification" : [ProductSpecification class]};
}
@end
@implementation ProductSpecification
@end
@implementation CategoryModel
@end
