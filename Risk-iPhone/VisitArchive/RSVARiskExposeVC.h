//
//  RSVARiskExposeVC.h
//  Risk-iPhone
//
//  Created by ylgwhyh on 16/9/8.
//  Copyright © 2016年 Cherie Jeong. All rights reserved.
//  风险暴露因素编辑界面

#import <UIKit/UIKit.h>


@class RSVisitArchiveModel,PatientrisksModel;

@interface RSVARiskExposeVC : UIViewController

@property (nonatomic, strong) RSVisitArchiveModel *model;

@property (nonatomic, copy) void (^rsVAPatientArchiveVCBlock)(BOOL isRefresh);

@property (nonatomic, copy) void (^rsVAPatientArchiveVCPatientrisksModelBlock)(NSMutableArray <PatientrisksModel *> *modelArray);

@end
