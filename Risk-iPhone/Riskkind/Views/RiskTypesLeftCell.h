//
//  RiskTypesLeftCell.h
//  Risk
//
//  Created by ylgwhyh on 16/7/1.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiskTypeModel.h"
#import "RSRiskBannerModel.h"

#import "AllHealthModel.h"

@interface RiskTypesLeftCell : UITableViewCell

@property (nonatomic, strong) UIColor *labelBGColor;
@property (nonatomic, strong) Children *riskTypeModel;

@property (nonatomic, strong) ChildrensModel *model;

@end
