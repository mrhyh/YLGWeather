//
//  RSVAPatientArchiveVC.h
//  Risk
//
//  Created by ylgwhyh on 16/7/7.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "EFBaseViewController.h"

@class RSVisitArchiveModel;

@interface RSVAPatientArchiveVC : EFBaseViewController


@property (nonatomic, strong) RSVisitArchiveModel *model;

@property (nonatomic, copy) void (^rsVAPatientArchiveVCBlock)(BOOL isRefresh);

/**
 *  保存类型，0代表是编辑，1代表是新建
 */
@property (nonatomic, assign) NSInteger saveTypeRSVAPatientArchiveInteger;

@end
