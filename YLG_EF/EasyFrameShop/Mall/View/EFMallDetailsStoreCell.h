//
//  EFMallDetailsStoreCell.h
//  EF_MallDemo
//
//  Created by MH on 16/6/13.
//  Copyright © 2016年 MH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFMallModel.h"
#import "EFOrderListModel.h"

@interface EFMallDetailsStoreCell : UITableViewCell

@property (nonatomic, strong) OrderShop *orderShop;
@property (nonatomic, strong) ProductDetailModel *productDetail;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) void (^phoneButtonClickedBlock)(NSIndexPath *indexPath);

@end
