//
//  RSVAArchivesModel.h
//  Risk
//
//  Created by ylgwhyh on 16/7/6.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//  随访档案模型

#import <Foundation/Foundation.h>

@interface RSVAArchivesModel : NSObject

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, assign) NSInteger numberInteger;
@property (nonatomic, strong) NSString *nameString;
@property (nonatomic, strong) NSString *phoneNumString;
@property (nonatomic, strong) NSString *mensesDataString;
@property (nonatomic, strong) NSString *estimateTimeString;
@property (nonatomic, strong) NSString *pregnantTimesString;
@property (nonatomic, strong) NSString *babyNumberString;
@property (nonatomic, strong) NSString *exposureFactorString;
@property (nonatomic, strong) NSString *medicalRecordNumString;
@property (nonatomic, strong) NSString *dosageString;
@property (nonatomic, copy) NSString *urlString;


@end
