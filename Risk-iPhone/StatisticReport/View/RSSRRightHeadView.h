//
//  RSSRRightHeadView.h
//  Risk
//
//  Created by ylgwhyh on 16/8/12.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSReportModel.h"

@interface RSSRRightHeadView : UIView

@property (nonatomic, strong) reportModel *model;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, strong) KYMHLabel *medicalRecordNumLabel;
@property (nonatomic, strong) KYMHLabel *nameLabel;
@property (nonatomic, strong) KYMHLabel *phoneNumLabel;
@property (nonatomic, strong) KYMHLabel *mensesDataLabel;

- (id) initWithFrame:(CGRect)frame;

@end
