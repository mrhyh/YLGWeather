//
//  RSFDARightVC.h
//  Risk
//
//  Created by ylgwhyh on 16/7/5.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "EFBaseViewController.h"
#import "RSRiskKindVC.h"
#import "RiskTypeModel.h"
#import "RSFDARiskModel.h"
#import "RSRFDAModel.h"

@interface RiskTypeFDARightVC : EFBaseViewController <UISplitViewControllerDelegate>

@property (nonatomic, strong) RSRiskKindVC *rsRiskKindVC;

@property (nonatomic, strong) RSRFDAModel *model;

@end
