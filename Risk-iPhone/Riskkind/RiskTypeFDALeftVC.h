//
//  RSFDALeftVC.h
//  Risk
//
//  Created by ylgwhyh on 16/7/5.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "EFBaseViewController.h"
#import "RiskTypeModel.h"
#import "RiskTypeFDARightVC.h"
#import "RSRFDAModel.h"

@class RiskTypeFDALeftVC, RiskTypeModel;

@protocol RiskTypeFDALeftVCDelegate <NSObject>

- (void)RiskTypeFDALeftVC:(RiskTypeFDALeftVC *)RiskTypeFDALeftVC didSelectedRiskTypeFDALeftVC:(RSRFDAModel *)model;

@end


@interface RiskTypeFDALeftVC : UITableViewController

@property (nonatomic, strong) RiskTypeModel *typeModel;

/***  标志是否隐藏navigationTitle，同时表示是否是第一次调用此控制器（YES，代表不是） */
@property (nonatomic, assign) BOOL isHideNavigationTitleLabelBOOL;

@property (nonatomic, strong) RiskTypeFDARightVC<UISplitViewControllerDelegate> *riskTypeFDARightVC;

@property (nonatomic, weak) id <RiskTypeFDALeftVCDelegate> delegate;


@property (nonatomic, strong) RSRFDAModel *model;

@end
