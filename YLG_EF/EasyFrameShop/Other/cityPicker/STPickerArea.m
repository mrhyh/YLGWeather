//
//  STPickerArea.m
//  STPickerView
//
//  Created by https://github.com/STShenZhaoliang/STPickerView on 16/2/15.
//  Copyright © 2016年 shentian. All rights reserved.
//

#import "STPickerArea.h"

@interface STPickerArea()<UIPickerViewDataSource, UIPickerViewDelegate>

/** 1.数据源数组 */
@property (nonatomic, strong, nullable)NSArray *arrayRoot;
/** 2.当前省数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayProvince;
/** 3.当前城市数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayCity;
/** 4.当前地区数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayArea;
/** 5.当前选中数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arraySelected;

/** 6.省份 */
@property (nonatomic, strong, nullable)NSDictionary *provinceDict;
/** 7.城市 */
@property (nonatomic, strong, nullable)NSDictionary *cityDict;
/** 8.地区 */
@property (nonatomic, strong, nullable)NSDictionary *areaDict;

/** 省份对应的index */
@property (nonatomic, assign) NSInteger provinceIndex;
/** 城市对应的index */
@property (nonatomic, assign) NSInteger cityIndex;
/** 地区对应的index */
@property (nonatomic, assign) NSInteger districtIndex;

//regionFileName 路径
@property (nonatomic, copy) NSString *regionFileName;
@end

@implementation STPickerArea
- (instancetype)initWithProvinceDict:(NSDictionary *)provinceDict cityDict:(NSDictionary *)cityDict districtDict:(NSDictionary *)districtDict{
    if (self == [super init]) {
        if (provinceDict != nil && cityDict != nil && districtDict!= nil) {
            self.provinceDict = provinceDict;
            self.cityDict = cityDict;
            self.areaDict = districtDict;
            [self regionWithProvinceDict:provinceDict cityDict:cityDict districtDict:districtDict];
            [self.pickerView selectRow:self.provinceIndex inComponent:0 animated:YES];
            [self.pickerView selectRow:self.cityIndex inComponent:1 animated:YES];
            [self.pickerView selectRow:self.districtIndex inComponent:2 animated:YES];
        }
    }
    return self;
}

#pragma mark - --- init 视图初始化 ---
- (void)setupUI
{
    // 1.获取数据
    [self.arrayRoot enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.arrayProvince addObject:obj];
        
    }];
    
    [[self.arrayRoot firstObject][@"children"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.arrayCity addObject:obj];
        
    }];
    
    [[[self.arrayRoot firstObject][@"children"] firstObject][@"children"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.arrayArea addObject:obj];
    }];
    
    self.provinceDict = self.arrayProvince[0];
    self.cityDict = self.arrayCity[0];
    self.areaDict = self.arrayArea[0];
    
    // 2.设置视图的默认属性
    _heightPickerComponent = 32;
    [self setTitle:@"请选择城市地区"];
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];

}
#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.arrayProvince.count;
    }else if (component == 1) {
        return self.arrayCity.count;
    }else{
        return self.arrayArea.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.heightPickerComponent;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.arraySelected = self.arrayRoot[row][@"children"];

        [self.arrayCity removeAllObjects];
        [self.arrayArea removeAllObjects];
        [self.arraySelected enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.arrayCity addObject:obj];
            
        }];
        
        [[self.arraySelected firstObject][@"children"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.arrayArea addObject:obj];
        }];
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];

    }else if (component == 1) {
        [self.arrayArea removeAllObjects];
        
        if (self.arraySelected.count != 0) {//避免第一次进来直接选择第二个滚轮没数据程序crash
            [[self.arraySelected objectAtIndex:row][@"children"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.arrayArea addObject:obj];
            }];
        }else{
            self.arraySelected  = [self.arrayRoot objectAtIndex:self.provinceIndex][@"children"];
            [[self.arraySelected objectAtIndex:row][@"children"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.arrayArea addObject:obj];
            }];
        }
        
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];

    }else{
    }

    [self reloadData];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{

    NSString *text;
    if (component == 0) {
        text =  self.arrayProvince[row][@"name"];
    }else if (component == 1){
        text =  self.arrayCity[row][@"name"];
    }else{
        if (self.arrayArea.count > 0) {
            text = self.arrayArea[row][@"name"];
        }else{
            text =  @"";
        }
    }


    UILabel *label = [[UILabel alloc]init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:15]];
    [label setText:text];
    return label;
}

#pragma mark - --- event response 事件相应 ---

- (void)selectedOk
{
    [self.delegate pickerArea:self provinceDict:self.provinceDict cityDict:self.cityDict districtDict:self.areaDict];
    [super selectedOk];
}

#pragma mark - --- private methods 私有方法 ---

- (void)reloadData
{
    NSInteger index0 = [self.pickerView selectedRowInComponent:0];
    NSInteger index1 = [self.pickerView selectedRowInComponent:1];
    NSInteger index2 = [self.pickerView selectedRowInComponent:2];
    self.provinceDict = self.arrayProvince[index0];
    self.cityDict = self.arrayCity[index1];
    if (self.arrayArea.count != 0) {
        self.areaDict = self.arrayArea[index2];
    }else{
        self.areaDict = @{};
    }
    
    NSString *title = [NSString stringWithFormat:@"%@ %@ %@", self.provinceDict[@"name"], self.cityDict[@"name"], self.areaDict[@"name"]];
    [self setTitle:title];

}

#pragma mark - --- setters 属性 ---

#pragma mark - --- getters 属性 ---
- (NSString *)regionFileName{
    if (_regionFileName == nil) {
        _regionFileName = [[NSBundle mainBundle] pathForResource:@"region.plist" ofType:nil];
    }
    return _regionFileName;
}

- (NSArray *)arrayRoot
{
    if (!_arrayRoot) {
        _arrayRoot = [[NSArray alloc]initWithContentsOfFile:self.regionFileName];
    }
    return _arrayRoot;
}

- (NSMutableArray *)arrayProvince
{
    if (!_arrayProvince) {
        _arrayProvince = [NSMutableArray array];
    }
    return _arrayProvince;
}

- (NSMutableArray *)arrayCity
{
    if (!_arrayCity) {
        _arrayCity = [NSMutableArray array];
    }
    return _arrayCity;
}

- (NSMutableArray *)arrayArea
{
    if (!_arrayArea) {
        _arrayArea = [NSMutableArray array];
    }
    return _arrayArea;
}

- (NSMutableArray *)arraySelected
{
    if (!_arraySelected) {
        _arraySelected = [NSMutableArray array];
    }
    return _arraySelected;
}

#pragma mark --- utility
/**
 *  根据省市区对应的字典回去相应的index
 *
 *  @param provinceDict 省份字典
 *  @param cityDict     城市字典
 *  @param districtDict 地区字典
 */
- (void)regionWithProvinceDict:(NSDictionary *)provinceDict cityDict:(NSDictionary *)cityDict districtDict:(NSDictionary *)districtDict{
    
    [self.arrayCity removeAllObjects];
    [self.arrayArea removeAllObjects];
    [self.arrayCity addObjectsFromArray:provinceDict[@"children"]];
    [self.arrayArea addObjectsFromArray:cityDict[@"children"]];
    [self.arrayRoot enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[dict[@"objectId"] stringValue] isEqualToString:[provinceDict[@"objectId"] stringValue]]) {
            self.provinceIndex = idx;
            *stop = YES;
        }
    }];
    
    [provinceDict[@"children"] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[dict[@"objectId"] stringValue] isEqualToString:[cityDict[@"objectId"] stringValue]]) {
            self.cityIndex = idx;
            *stop = YES;
        }
    }];
    
    [cityDict[@"children"] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[dict[@"objectId"] stringValue] isEqualToString:[districtDict[@"objectId"] stringValue]]) {
            self.districtIndex = idx;
            *stop = YES;
        }
    }];
}
@end


