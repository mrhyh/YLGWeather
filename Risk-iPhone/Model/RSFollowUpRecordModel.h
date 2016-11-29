//
//  RSFollowUpRecordModel.h
//  Risk
//
//  Created by ylgwhyh on 16/7/25.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSVisitArchiveModel,PatientrisksModel,PatientfollowsModel;
@interface RSFollowUpRecordModel : NSObject


@property (nonatomic, assign) NSInteger number;

@property (nonatomic, strong) NSArray<RSVisitArchiveModel *> *content;

@property (nonatomic, assign) NSInteger numberOfElements;

@property (nonatomic, assign) NSInteger totalPages;

@property (nonatomic, assign) NSInteger size;

@property (nonatomic, assign) BOOL last;

@property (nonatomic, assign) NSInteger totalElements;

@property (nonatomic, assign) BOOL first;


@end

@interface RSVisitArchiveModel : NSObject

@property (nonatomic, copy) NSString *menstruationTime;

@property (nonatomic, copy) NSString *phoneNum;

@property (nonatomic, copy) NSString *pregnancyNum;

@property (nonatomic, copy) NSString *bornNum;

@property (nonatomic, strong) NSArray<PatientrisksModel *> *patientRisks;

@property (nonatomic, copy) NSString *childbirthTime;

@property (nonatomic, strong) NSArray<PatientfollowsModel *> *patientFollows;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *patientId;

@property (nonatomic, copy) NSString *address;

//@property (nonatomic, copy) NSString *exposureFactorString;

@property (nonatomic, copy) NSString *medicalRecordNo; //病历号

- (id ) init;

@end

@interface PatientrisksModel : NSObject

@property (nonatomic, copy) NSString *startTime;

@property (nonatomic, copy) NSString *riskId;

@property (nonatomic, copy) NSString *endTime;

@property (nonatomic, copy) NSString *dosage;

@property (nonatomic, copy) NSString *riskName;

@property (nonatomic, copy) NSString *objectId;

- (id ) init;
@end

@interface PatientfollowsModel : NSObject

@property (nonatomic, copy) NSString *objectId;

@property (nonatomic, copy) NSString *flowTime;

@property (nonatomic, copy) NSString *flowResult;

- (id) init;

@end

