//
//  RSFollowUpRecordModel.m
//  Risk
//
//  Created by ylgwhyh on 16/7/25.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSFollowUpRecordModel.h"

@implementation RSFollowUpRecordModel


+ (NSDictionary *)objectClassInArray{
    return @{@"content" : [RSVisitArchiveModel class]};
}
@end


@implementation RSVisitArchiveModel

+ (NSDictionary *)objectClassInArray{
    return @{@"patientRisks" : [PatientrisksModel class], @"patientFollows" : [PatientfollowsModel class]};
}

- (id) init {
    if(self = [super init])
    {
        _menstruationTime = 0;
        _phoneNum = @"";
        _pregnancyNum = @"";
        _bornNum = @"";
        _name = @"";
        _patientId = @"";
        _address = @"";
        //_exposureFactorString = @"";
        _medicalRecordNo = @"";
        _menstruationTime = 0;
        _phoneNum = @"";
        _pregnancyNum = @"";
        _bornNum = @"";
        _childbirthTime = 0;
        _patientRisks = [[NSArray alloc] init];
        
        PatientrisksModel *prModel = [[PatientrisksModel alloc] init];
        _patientRisks = @[prModel];
        
        _patientFollows = [[NSArray alloc]init];
        PatientfollowsModel *pfModel = [[PatientfollowsModel alloc] init];
        _patientFollows = @[pfModel];
        
    }
    return self;
}

@end


@implementation PatientrisksModel

- (id) init {
    if(self = [super init])
    {
        _startTime = 0;
        _riskId = @"";
        _endTime = 0;
        _dosage = @"";
        _riskId = @"";
        _riskName = @"";
        _objectId = @"";
    }
    return self;
}

@end


@implementation PatientfollowsModel

- (id) init {
    if(self = [super init])
    {
        _objectId = @"";
        _flowTime = 0;
        _flowResult = @"";
    }
    return self;
}

@end


