//
//  EFMallCell.h
//  EF_MallDemo
//
//  Created by MH on 16/6/13.
//  Copyright © 2016年 MH. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "EFMallModel.h"

@interface EFMallCell : UITableViewCell
//@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) EFMallGoodListModel *listModel;
@end

