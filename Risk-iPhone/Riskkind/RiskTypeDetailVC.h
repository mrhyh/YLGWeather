//
//  RiskTypeDetailVC.h
//  Risk
//
//  Created by ylgwhyh on 16/7/2.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "EFBaseViewController.h"

typedef void(^RiskTypeDetailVCRefreshBlock)(BOOL isRefresh);

@interface RiskTypeDetailVC : EFBaseViewController

@property(nonatomic, copy) RiskTypeDetailVCRefreshBlock riskTypeDetailVCRefreshBlock;

@property (nonatomic, assign) int objectId;

@property (nonatomic, assign) BOOL showNavigationView;  //是否显示navibar

@end
