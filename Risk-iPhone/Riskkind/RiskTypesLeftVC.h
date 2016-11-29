//
//  MedicineTypesVC.h
//  Risk
//
//  Created by ylgwhyh on 16/6/30.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//  风险类别

#import <UIKit/UIKit.h>
#import "RSRiskBannerModel.h"
#import "RiskTypeFDARightVC.h"
#import "RSRFDAModel.h"

@class RiskTypesLeftVC, RiskTypeModel;

@protocol RiskTypesLeftVCDelegate <NSObject>

@optional

- (void)riskTypesVC:(RiskTypesLeftVC *)RiskTypesVC didSelectedRiskType:(ChildrensModel *)model;

@end

@interface RiskTypesLeftVC : UIViewController

@property (nonatomic, weak) id <RiskTypesLeftVCDelegate > delegate;




//FDA相关

@property (nonatomic, strong) RiskTypeModel *typeModel;

/***  标志是否隐藏navigationTitle，同时表示是否是第一次调用此控制器（YES，代表不是） */
@property (nonatomic, assign) BOOL isHideNavigationTitleLabelBOOL;

@property (nonatomic, strong) RiskTypeFDARightVC *riskTypeFDARightVC;

//@property (nonatomic, weak) id <RiskTypeFDALeftVCDelegate> delegate;


@property (nonatomic, strong) RSRFDAModel *model;


@end
