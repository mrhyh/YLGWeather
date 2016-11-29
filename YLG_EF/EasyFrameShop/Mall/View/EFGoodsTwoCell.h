//
//  EFGoodsTwoCell.h
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/14.
//  Copyright © 2016年 MH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFGoodModel.h"
#import "EFOrderListModel.h"

typedef void(^EFGoodsTwoCellButtonClickBlock)(NSInteger number);

@protocol EFGoodsTwoCellDelegate <NSObject>

@optional
- (void)rightPayment:(NSInteger)orderStatusIngeter;
- (void)leftCancelOrder:(NSInteger)orderStatusIngeter;

@end
@interface EFGoodsTwoCell : UITableViewCell

@property (nonatomic, strong) UIView *bottomLineView;



/* 订单总价*/
@property (nonatomic, assign) NSInteger sumPrice;
@property (nonatomic, strong) OrderproductModel *orderproductModel;
@property (nonatomic, copy) NSString *orderStatus; //订单状态
@property (nonatomic, assign) NSInteger *sumPriceInteger; //每个订单的总价
@property (nonatomic, strong) NSIndexPath *indexPath; //记录cell的位置


@property (nonatomic, strong) KYMHButton *leftButton;
@property (nonatomic, strong) KYMHButton *rightButton;

@property (nonatomic, weak) id<EFGoodsTwoCellDelegate> delegate;


- (void)EFGoodsTwoCellRightButton:(EFGoodsTwoCellButtonClickBlock)block;
- (void)EFGoodsTwoCellLeftButton:(EFGoodsTwoCellButtonClickBlock)block;


@end
