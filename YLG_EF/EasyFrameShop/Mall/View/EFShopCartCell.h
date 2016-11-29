//
//  EFShopCartCell.h
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/15.
//  Copyright © 2016年 MH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFCartModel.h"


@class EFCartModel;

typedef void(^EFNumberChangedBlock)(NSInteger number);
typedef void(^EFCellSelectedBlock)(BOOL select);

@interface EFShopCartCell : UITableViewCell

//商品数量
@property (assign,nonatomic)NSInteger efNumber;
@property (assign,nonatomic)BOOL efSelected;

@property (nonatomic, strong) UIView *lineView; //细的

- (void)EFReloadDataWithModel:(ShopCartContentModel* )model;
- (void)EFNumberAddWithBlock:(EFNumberChangedBlock )block;
- (void)EFNumberCutWithBlock:(EFNumberChangedBlock )block;
- (void)EFCellSelectedWithBlock:(EFCellSelectedBlock )block;
- (void)EFShopCartCellTextFieldChange:(EFNumberChangedBlock )block;

@end
