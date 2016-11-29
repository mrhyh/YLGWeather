//
//  EFMallDetailsTopCell.h
//  EF_MallDemo
//
//  Created by MH on 16/6/13.
//  Copyright © 2016年 MH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFMallModel.h"

@interface EFMallDetailsTopCell : UITableViewCell
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) void (^commentButtonClickedBlock)(NSIndexPath *indexPath);
@property (nonatomic, strong) ProductDetailModel *productDetail;
@end
