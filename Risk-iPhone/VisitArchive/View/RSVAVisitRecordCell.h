//
//  RSVAVisitRecordCell.h
//  Risk
//
//  Created by ylgwhyh on 16/7/7.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PatientfollowsModel;

typedef void(^RSVAVisitRecordCellHeadBlock)(BOOL isSelected);

@interface RSVAVisitRecordCell : UITableViewCell

@property (nonatomic, strong) PatientfollowsModel *model;

@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, assign) NSInteger numberInteger; //左边索引号

@property (nonatomic, assign) BOOL isShowButtonBool;

- (void)RSVAVisitRecordCellHeadSelectBlock:(RSVAVisitRecordCellHeadBlock )block;

@end
