//
//  CitySelectView.m
//  pdb
//
//  Created by mini珍 on 15/12/9.
//  Copyright © 2015年 MH. All rights reserved.
//

#import "EFSelectView.h"
#import "EFMallViewModel.h"

@interface EFSelectView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * m_table;
    NSArray * m_arr;
    int m_objectId;
    NSArray *filtrateArray;
    EFMallViewModel *viewModel;
    NSString *cityString;
}
//cityFileName 路径
@property (nonatomic, copy) NSString *regionFileName;
//根数组
@property (nonatomic, strong) NSArray *arrayRoot;
@end

@implementation EFSelectView


- (instancetype)initWithFrame:(CGRect)frame ObjectId:(int)objectId Array:(NSMutableArray*)array andCity:(NSString *)city andSelectBlock:(EFSelectViewBlock)block{
    self = [super initWithFrame:frame];
    if (self) {
        
        callBack = block;
        m_arr = [NSMutableArray array];
        m_objectId = objectId;
        viewModel = [[EFMallViewModel alloc] initWithViewController:self];
        cityString = city;
        
//        UIColor * color = EF_MainColor;
//        self.layer.cornerRadius = 5;
//        self.layer.masksToBounds = YES;
//        self.layer.borderColor = color.CGColor;
//        self.layer.borderWidth = 1;
        
        NSString *plistPath = nil;
        plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame_" ofType:@"plist"];
        //如果没有创建EasyFrame_.plist文件，那么直接加载框架内部自带的
        if (plistPath == nil) {
            plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame" ofType:@"plist"];
        }
        
        filtrateArray = [NSDictionary dictionaryWithContentsOfFile:plistPath][@"Mall"][@"FiltrateArray"];
        NSArray * arr1 = nil;
        if (cityString != nil) {
            arr1 = [NSArray yy_modelArrayWithClass:[CategoryModel class] json:[self arrayWithCity:cityString]];
        }
        NSArray * arr2 = [NSArray yy_modelArrayWithClass:[CategoryModel class] json:filtrateArray[2]];;
        if (m_objectId == 0) {
            [viewModel getCategory];
        }else if (m_objectId == 1){
             m_arr = arr1.mutableCopy;
        }else if (m_objectId == 2){
            m_arr = arr2.mutableCopy;
        }
        m_table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        m_table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        m_table.delegate = self;
        m_table.dataSource = self;
        m_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:m_table];
        [m_table reloadData];
        
    }
    return self;
}

- (NSArray *)arrayWithCity:(NSString *)city{
    __block NSArray *districts = nil;
    [self.arrayRoot enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([dict[@"name"] isEqualToString:city]) {
            districts = dict[@"districts"];
            *stop = YES;
        }
    }];
    return districts;
}

#pragma mark - --- getters 属性 ---
- (NSString *)regionFileName{
    if (_regionFileName == nil) {
        _regionFileName = [[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil];
    }
    return _regionFileName;
}

- (NSArray *)arrayRoot
{
    if (_arrayRoot == nil) {
        _arrayRoot = [[NSArray alloc]initWithContentsOfFile:self.regionFileName];
    }
    return _arrayRoot;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return m_arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    CategoryModel *category = m_arr[indexPath.row];
    cell.textLabel.text = category.name;
    cell.textLabel.font = [UIFont systemFontOfSize:11];
    cell.textLabel.textColor = EF_TextColor_TextColorPrimary;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30 * SCREEN_H_RATE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CategoryModel *category = m_arr[indexPath.row];
    callBack(category);
}

#pragma mark ---网络请求回调
- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    if (action == EFMallViewModelCallBackActionGetCategory) {
        if (result.status == NetworkModelStatusTypeSuccess) {
            NSMutableArray *arrayM = [NSMutableArray array];
            NSArray *array = [NSArray yy_modelArrayWithClass:[CategoryModel class] json:result.content];
            [arrayM addObjectsFromArray:array];
            CategoryModel *category = [[CategoryModel alloc] init];
            category.name = @"默认分类";
            category.objectId = @"";
            [arrayM insertObject:category atIndex:0];
            m_arr = [arrayM copy];
            [m_table reloadData];
        }else{
            [UIUtil alert:@"无法加载类别信息!"];
        }
    }
}
@end
