//
//  RSVAriskFactorCell.h
//  Risk
//
//  Created by ylgwhyh on 16/7/7.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PatientrisksModel;

typedef void(^RSVAriskFactorCellHeadBlock)(BOOL isSelected);


@interface RSVAriskFactorCell : UITableViewCell

@property (nonatomic, strong) PatientrisksModel *model;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, assign) NSInteger numberInteger;

- (void)RSVAriskFactorCellHeadSelectBlock:(RSVAriskFactorCellHeadBlock )block;

@end
