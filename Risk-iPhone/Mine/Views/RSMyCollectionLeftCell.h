//
//  RSMyCollectionLeftCell.h
//  Risk
//
//  Created by Cherie Jeong on 16/8/8.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RSMyCollectRiskModel.h"

@interface RSMyCollectionLeftCell : UITableViewCell

@property (nonatomic, strong) Risks *model;
@property (nonatomic, strong) UIView *lineView;

@end
