//
//  EFMallListModel.h
//  EF_MallDemo
//
//  Created by HqLee on 16/6/15.
//  Copyright © 2016年 MH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EFMallImage;
@interface EFMallListModel : NSObject

@property (nonatomic, assign) NSInteger weight;

@property (nonatomic, assign) NSInteger score;

@property (nonatomic, assign) NSInteger scoreCount;

@property (nonatomic, assign) NSInteger price;

@property (nonatomic, assign) NSInteger stock;

@property (nonatomic, strong) EFMallImage *image;

@property (nonatomic, copy) NSString *sn;

@property (nonatomic, assign) NSInteger marketPrice;

@property (nonatomic, assign) NSInteger totalScore;

@property (nonatomic, assign) NSInteger objectId;

@property (nonatomic, copy) NSString *name;

@end

@interface EFMallImage : NSObject

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) NSInteger objectId;

@end

