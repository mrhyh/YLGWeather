//
//  RSMedicineDetailVC.h
//  Risk
//
//  Created by ylgwhyh on 16/7/12.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//  药物详情页面

#import "EFBaseViewController.h"
#import "RSRiskDetailModel.h"

@interface RSMedicineDetailVC : EFBaseViewController

@property (nonatomic, strong ) RSRiskDetailModel *model;

@property (nonatomic, copy) NSString *clickWebViewPushString;

@end
