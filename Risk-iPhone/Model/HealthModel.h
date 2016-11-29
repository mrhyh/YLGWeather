//
//  HealthModel.h
//  Risk
//
//  Created by Cherie Jeong on 16/8/3.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSAllImageModel.h"

@class Content,Mainimg,ContentsocailModel,SmallMainImageModel;
@interface HealthModel : NSObject


@property (nonatomic, assign) NSInteger number;

@property (nonatomic, strong) NSArray<Content *> *content;

@property (nonatomic, assign) NSInteger numberOfElements;

@property (nonatomic, assign) NSInteger totalPages;

@property (nonatomic, assign) NSInteger size;

@property (nonatomic, assign) BOOL last;

@property (nonatomic, assign) NSInteger totalElements;

@property (nonatomic, assign) BOOL first;


@end
@interface Content : NSObject

@property (nonatomic, strong) Mainimg *mainImage;

@property (nonatomic, strong) SmallMainImageModel *smallMainImage;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *imageContent;

@property (nonatomic, copy) NSString *fileSize;

@property (nonatomic, copy) NSString *smallFileSize;

@property (nonatomic, copy) NSString *uploadDate;

@property (nonatomic, copy) NSString * riskFilePath;

@property (nonatomic, assign) NSInteger readCount;

@property (nonatomic, assign) NSInteger price;

@property (nonatomic, assign) BOOL isVideo;

@property (nonatomic, assign) NSInteger objectId;

@property (nonatomic, assign) NSInteger categoryId;

@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, strong) ContentsocailModel *contentSocail;

@property (nonatomic, strong) NSString * tags;

@property (nonatomic, assign) int tagsId;

@property (nonatomic, strong) NSString * type;

@end

@interface Mainimg : NSObject

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) NSInteger objectId;

@end

