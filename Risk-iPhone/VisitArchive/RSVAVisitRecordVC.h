//
//  RSVAVisitRecordVC.h
//  Risk-iPhone
//
//  Created by ylgwhyh on 16/9/8.
//  Copyright © 2016年 Cherie Jeong. All rights reserved.
//  随访档案编辑界面

#import <UIKit/UIKit.h>

@class RSVisitArchiveModel,PatientfollowsModel;

@interface RSVAVisitRecordVC : UIViewController

@property (nonatomic, strong) RSVisitArchiveModel *model;

@property (nonatomic, copy) void (^rsVAPatientArchiveVCBlock)(BOOL isRefresh);

@property (nonatomic, copy) void (^rsVAPatientArchiveVCPatientfollowsModelBlock)(NSMutableArray <PatientfollowsModel *>*modelArray);

@end
