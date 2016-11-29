//
//  HTNewsImgModel.h
//  Haitangshequ
//
//  Created by zhaoxiaoyun on 14-3-4.
//  Copyright (c) 2014年 zxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTNewsImgModel : NSObject

@property (nonatomic,strong) NSString * imgId;
@property (nonatomic,strong) NSString * imageUrl;
@property (nonatomic,strong) NSString * description;

- (id)initWithDictionary:(NSDictionary *)_dic;
@end
