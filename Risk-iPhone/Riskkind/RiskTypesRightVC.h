//
//  RiskTypesDetailVC.h
//  Risk
//
//  Created by ylgwhyh on 16/6/30.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//  风险类别详细内容

#import <UIKit/UIKit.h>
#import "RSRiskKindVC.h"
#import "RSRiskBannerModel.h"

@class RiskTypeModel;

@interface RiskTypesRightVC : UITableViewController <UISplitViewControllerDelegate>

@property (nonatomic, strong) ChildrensModel *typeModel;
@property (nonatomic, strong) UISplitViewController  *splitViewController;

/* 为No，代表健康分类右边是第一页*/
@property (nonatomic, assign) BOOL isHideNavigationTitleLabelBOOL;

@property (nonatomic, strong) UINavigationController *tabBarRootNC;

@end
