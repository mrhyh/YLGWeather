//
//  GoodsCell.h
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/13.
//  Copyright © 2016年 MH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFGoodModel.h"
#import "EFOrderListModel.h"


@interface EFGoodsCell : UITableViewCell

@property (nonatomic, strong) OrderModel *orderModel;
@property (nonatomic, strong) OrderproductModel *orderproductModel;

@property (nonatomic, strong)  EFGoodModel *goodModel;
@end


