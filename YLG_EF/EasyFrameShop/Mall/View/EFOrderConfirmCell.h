//
//  EFOrderConfirmCell.h
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/23.
//  Copyright © 2016年 MH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFOrderListModel.h"
#import "EFGoodModel.h"
#import "EFCartModel.h"

@interface EFOrderConfirmCell : UITableViewCell

@property (nonatomic, strong) OrderModel *orderModel;

@property (nonatomic, strong) ShopCartContentModel *shopCartContentModel;

@property (nonatomic, strong) UIView *lineView;
@end
