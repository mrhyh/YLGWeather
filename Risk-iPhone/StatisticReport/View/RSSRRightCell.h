//
//  RSSRRightCell.h
//  Risk
//
//  Created by ylgwhyh on 16/7/12.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSReportModel.h"

@interface RSSRRightCell : UITableViewCell

@property (nonatomic, strong) reportModel *model;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;

@end