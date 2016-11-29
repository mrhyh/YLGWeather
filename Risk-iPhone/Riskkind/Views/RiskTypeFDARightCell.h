//
//  RiskTypeFDARightCell.h
//  Risk
//
//  Created by ylgwhyh on 16/7/5.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiskTypeModel.h"
#import "RSFDARiskModel.h"


@interface RiskTypeFDARightCell : UITableViewCell

@property(nonatomic, strong) RSFDARiskModel * model;

@property(nonatomic, strong) RSFDARiskModel * histroyModel;

@property(nonatomic, strong) RSFDARiskModel * fileModel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIImageView *indicatorImageView;

@property (nonatomic, copy) NSString *keyWord;

@end
