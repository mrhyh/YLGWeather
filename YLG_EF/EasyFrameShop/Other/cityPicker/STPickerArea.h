//
//  STPickerArea.h
//  STPickerView
//
//  Created by https://github.com/STShenZhaoliang/STPickerView on 16/2/15.
//  Copyright © 2016年 shentian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPickerView.h"
NS_ASSUME_NONNULL_BEGIN
@class STPickerArea;
@protocol  STPickerAreaDelegate<NSObject>

- (void)pickerArea:(STPickerArea *)pickerArea provinceDict:(NSDictionary *)provinceDict cityDict:(NSDictionary *)cityDict districtDict:(NSDictionary *)districtDict;

@end
@interface STPickerArea : STPickerView
/**
 *  初始化地区选择器
 *
 *  @param provinceDict 省份对应的dict
 *  @param cityDict     城市对应的dict
 *  @param districtDict 地区对应的dict
 *
 *  @return 日期选择器
 */
- (instancetype)initWithProvinceDict:(NSDictionary *) provinceDict cityDict:(NSDictionary *)cityDict districtDict:(NSDictionary *)districtDict;

/** 1.中间选择框的高度，default is 32*/
@property (nonatomic, assign)CGFloat heightPickerComponent;
@property(nonatomic, weak)id <STPickerAreaDelegate>delegate;
@end
NS_ASSUME_NONNULL_END