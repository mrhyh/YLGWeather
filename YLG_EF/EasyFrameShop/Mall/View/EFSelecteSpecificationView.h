//
//  EFSelecteSpecificationView.h
//  EF_MallDemo
//
//  Created by HqLee on 16/6/23.
//  Copyright © 2016年 MH. All rights reserved.
//  选择产品规格的view

#import <UIKit/UIKit.h>
#import "EFMallModel.h"

typedef void (^SelectHandler)(NSString *result, NSInteger objectId);

@interface EFSelecteSpecificationView : UIView
/**
 *  创建选择规格的视图
 *
 *  @return 实例对象
 */
+ (instancetype)SelecteSepacificationView;
/**
 *  弹出规格视图
 */
- (void)push;
/**
 *  产品模型
 */
@property (nonatomic, strong) ProductDetailModel *productDetailModel;

@property (nonatomic, copy) SelectHandler selectHandler;
@end
