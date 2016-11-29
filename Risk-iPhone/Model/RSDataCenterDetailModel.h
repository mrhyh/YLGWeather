//
//  RSDataCenterDetailModel.h
//  Risk
//
//  Created by ylgwhyh on 16/8/3.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ContentsocailModel,Mainimage;
@interface RSDataCenterDetailModel : NSObject


@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, assign) NSInteger fileSize;

@property (nonatomic, copy) NSString *riskFilePath;

@property (nonatomic, assign) NSInteger smallFileSize;

@property (nonatomic, copy) NSString *smallRiskFilePath;

@property (nonatomic, copy) NSString *isVideo;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) CGFloat price;

@property (nonatomic, copy) NSString *riskFileContent;

@property (nonatomic, assign) BOOL isFile;

@property (nonatomic, copy) NSString *md5code;

@property (nonatomic, copy) NSString *smallMd5code;

@property (nonatomic, copy) NSString *uploadDate;

@property (nonatomic, strong) ContentsocailModel *contentSocail;

@property (nonatomic, strong) Mainimage *mainImage;

@property (nonatomic, assign) NSInteger readCount;

@property (nonatomic, copy) NSString *imageContent;

@property (nonatomic, assign) NSInteger objectId;

@property (nonatomic, assign) NSInteger categoryId;

@property (nonatomic, copy) NSString * fileType;    //RiskFile--资料中心   HealthFile--健康教育


@end
//@interface ContentsocailModel : NSObject
//
//@property (nonatomic, assign) BOOL isPraise;
//
//@property (nonatomic, assign) NSInteger praisedCount;
//
//@property (nonatomic, assign) BOOL isFavorite;
//
//@end

//@interface Mainimage : NSObject
//
//@property (nonatomic, copy) NSString *url;
//
//@property (nonatomic, assign) NSInteger objectId;
//
//@end

