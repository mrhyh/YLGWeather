//
//  EFGoodSpecificationCell.h
//  EF_MallDemo
//
//  Created by HqLee on 16/6/23.
//  Copyright © 2016年 MH. All rights reserved.
//  商品规格cell

#import <UIKit/UIKit.h>

typedef void (^completeHandler)(NSString *productID);

@interface EFGoodSpecificationCell : UITableViewCell
@property (nonatomic, copy) NSString *selectResult;
@end
