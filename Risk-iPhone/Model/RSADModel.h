//
//  RSADModel.h
//  Risk
//
//  Created by Cherie Jeong on 16/7/25.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Attachment;

@interface RSADModel : NSObject

@property (nonatomic, assign) int adType;

@property (nonatomic, copy) NSString *adTitle;

@property (nonatomic, copy) NSString *adLink;

@property (nonatomic, assign) int linkType;

@property (nonatomic, assign) int objectId;

@property (nonatomic, copy) NSString *adContent;

@property (nonatomic, strong) NSArray<Attachment *> *attachment;

@end

@interface Attachment : NSObject

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) int objectId;

@end



