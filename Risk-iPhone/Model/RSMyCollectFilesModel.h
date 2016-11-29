//
//  RSMyCollectFilesModel.h
//  Risk
//
//  Created by Cherie Jeong on 16/8/8.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSRiskDetailModel.h"

@class Riskfiles,MainImg;
@interface RSMyCollectFilesModel : NSObject


@property (nonatomic, strong) NSArray<Riskfiles *> *riskFiles;


@end

@interface Riskfiles : NSObject

@property (nonatomic, copy) NSString *imageContent;

@property (nonatomic, strong) MainImg *mainImage;

@property (nonatomic, assign) BOOL isVideo;

@property (nonatomic, assign) NSInteger readCount;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger categoryId;

@property (nonatomic, copy) NSString *riskFilePath;

@property (nonatomic, assign) NSInteger fileSize;

@property (nonatomic, copy) NSString *smallFileSize;

@property (nonatomic, copy) NSString *smallRiskFilePath;

@property (nonatomic, assign) CGFloat price;

@property (nonatomic, assign) NSInteger objectId;

@property (nonatomic, copy) NSString *uploadDate;

@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, strong) ContentsocailModel *contentSocail;

@end

@interface MainImg : NSObject

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) NSInteger objectId;

@end

