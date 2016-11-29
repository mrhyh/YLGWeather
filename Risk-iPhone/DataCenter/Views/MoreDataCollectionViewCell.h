//
//  MoreDataCollectionViewCell.h
//  Risk
//
//  Created by Cherie Jeong on 16/7/7.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSDateCenterModel.h"
#import "HealthModel.h"

@interface MoreDataCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) NSIndexPath * indexPath;

@property (nonatomic, strong ) FilesitemsModel *model;

@property (nonatomic, strong) Content * healthModel;

- (instancetype)initWithFrame:(CGRect)frame;

@end
