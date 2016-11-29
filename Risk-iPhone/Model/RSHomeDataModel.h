//
//  RSHomeDataModel.h
//  Risk
//
//  Created by ylgwhyh on 16/7/22.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSDateCenterModel.h"
#import "RSRiskDetailModel.h"
#import "RSAllImageModel.h"

@class Filesitems,Mainimage;
@interface RSHomeDataModel : NSObject


@property (nonatomic, assign) NSInteger categoryId;

@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, strong) NSArray<Filesitems *> *filesItems;

@property (nonatomic, assign) BOOL hasChild;


@end
@interface Filesitems : NSObject

@property (nonatomic, strong) Mainimage *mainImage;

@property (nonatomic, strong) NSString * imageContent;

@property (nonatomic, assign) NSInteger fileId;

@property (nonatomic, assign) NSInteger readCount;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger categoryId;

@property (nonatomic, assign) NSInteger fileSize;

@property (nonatomic, copy) NSString *smallFileSize;

@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, assign) BOOL isVideo;

@property (nonatomic, copy) NSString *uploadDate;

@property (nonatomic, copy) NSString * riskFilePath;

@property (nonatomic, assign) int objectId;

@property (nonatomic, strong) ContentsocailModel *contentSocail; 

@end

@interface Mainimage : NSObject

@property (nonatomic, copy) NSString *url;

@end

