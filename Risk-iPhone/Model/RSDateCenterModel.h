//
//  RSDateCenterModel.h
//  Risk
//
//  Created by ylgwhyh on 16/7/21.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSDateCenterModel.h"
#import "RSRiskDetailModel.h"
#import "RSAllImageModel.h"

@class FilesitemsModel, MainImage;
@interface RSDateCenterModel : NSObject

@property (nonatomic, assign) NSInteger categoryId;

@property (nonatomic, copy) NSString *categoryName;

/*16进制颜色值*/
@property (nonatomic, copy) NSString *color;

/*资料中心图标*/
@property (nonatomic, copy) NSString *imageUrl;


@property (nonatomic, assign) BOOL hasChild;

@property (nonatomic, strong) NSArray<FilesitemsModel *> *filesItems;


@end

@interface FilesitemsModel : NSObject

@property (nonatomic, assign) NSInteger categoryId;

@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger objectId;

@property (nonatomic, assign) NSInteger readCount;

@property (nonatomic, strong) MainImage *mainImage;

@property (nonatomic, strong) SmallMainImageModel *smallMainImage;

@property (nonatomic, assign) BOOL isVideo;

@property (nonatomic, assign) long fileSize;

@property (nonatomic, copy) NSString *smallFileSize;

@property (nonatomic, copy) NSString *riskFilePath;

@property (nonatomic, copy) NSString *uploadDate;

@property (nonatomic, strong) ContentsocailModel *contentSocail;

/*富文本*/
@property (nonatomic, copy) NSString *riskFileContent;

@property (nonatomic, assign) BOOL isFile;

@property (nonatomic, strong) NSString * tags;

@property (nonatomic, assign) int tagsId;

@property (nonatomic, assign) BOOL isTool;

@end

@interface MainImage : NSObject

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) NSInteger objectId;

@end


