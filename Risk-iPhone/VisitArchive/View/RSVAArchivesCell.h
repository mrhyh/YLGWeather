//
//  RSVAArchivesCell.h
//  Risk
//
//  Created by ylgwhyh on 16/7/6.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RSVisitArchiveModel;

@interface RSVAArchivesCell : UITableViewCell

@property (nonatomic, strong) RSVisitArchiveModel *model;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, assign) NSInteger numberInteger;

@end
