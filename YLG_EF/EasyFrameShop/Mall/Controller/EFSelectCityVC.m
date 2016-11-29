//
//  EFSelectCityVC.m
//  Dentist
//
//  Created by HqLee on 16/7/13.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "EFSelectCityVC.h"
#import "EFMallModel.h"

static NSString *cellID = @"city";

@interface EFSelectCityVC()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic, copy) SelectHandler selectHandler;
//cityFileName 路径
@property (nonatomic, copy) NSString *regionFileName;
//根数组
@property (nonatomic, strong) NSArray *cityArray;
// 搜索框
@property (nonatomic, strong) UISearchBar *searchBar;
//搜索的城市数组
@property (nonatomic, strong) NSMutableArray *searchCities;
//列表视图
@property (nonatomic, strong) UITableView *tableView;
// 是否是search状态
@property(nonatomic, assign) BOOL isSearch;
@end
@implementation EFSelectCityVC
#pragma mark --- lazy load
- (UISearchBar *)searchBar{
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.0f)];
        _searchBar.translucent  = YES;
        _searchBar.delegate = self;
        _searchBar.placeholder  = @"城市名称或首字母";
        _searchBar.keyboardType = UIKeyboardTypeDefault;
        [_searchBar setBarTintColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
        [_searchBar.layer setBorderWidth:0.5f];
        [_searchBar.layer setBorderColor:[UIColor colorWithWhite:0.7 alpha:1.0].CGColor];
    }
    return _searchBar;
}

- (NSString *)regionFileName{
    if (_regionFileName == nil) {
        _regionFileName = [[NSBundle mainBundle] pathForResource:@"citySort.plist" ofType:nil];
    }
    return _regionFileName;
}

- (NSArray *)cityArray
{
    if (_cityArray == nil) {
        _cityArray = [[NSArray alloc]initWithContentsOfFile:self.regionFileName];
    }
    return _cityArray;
}

- (NSMutableArray *)searchCities{
    if (_searchCities == nil) {
        _searchCities = [NSMutableArray array];
    }
    return _searchCities;
}

#pragma mark --- life cycle
- (instancetype)initWithSelectHandler:(SelectHandler)selectHandler{
    if (self = [super init]) {
        self.selectHandler = [selectHandler copy];
    }
    return self;
}

- (void)viewDidLoad{
    [self setupNavi];
    [self setupView];
}

- (void)setupNavi{
    self.title = @"选择城市";
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn sizeToFit];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setupView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 44;
    tableView.sectionFooterHeight = 0;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    [self.view addSubview:tableView];
    tableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    [tableView setTableHeaderView:self.searchBar];
    self.tableView = tableView;
}

#pragma mark searchBarDelegete

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    UIButton *btn=[searchBar valueForKey:@"_cancelButton"];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.searchCities removeAllObjects];
    if (searchText.length == 0) {
        self.isSearch = NO;
    }else{
        self.isSearch = YES;
        for (NSDictionary *dict in self.cityArray) {
            
            for (NSDictionary *cityDict in dict[@"cities"]) {
                NSString *city = cityDict[@"name"];
                if ([city containsString:searchText]) {
                    [self.searchCities addObject:cityDict];
                    break;
                }
            }
            
            if ([[searchText uppercaseString]  isEqualToString:dict[@"firstC"]]) {
                [self.searchCities addObjectsFromArray:dict[@"cities"]];
                break;
            }
        }
    }
    [self.tableView reloadData];
}
//添加搜索事件：
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    searchBar.text=@"";
    [searchBar resignFirstResponder];
    [self.tableView reloadData];
}


#pragma mark ---<UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isSearch) {
        return 1;
    }else{
        return self.cityArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isSearch) {
        return self.searchCities.count;
    }else{
        NSArray *cities = self.cityArray[section][@"cities"];
        return cities.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (self.isSearch) {
        NSDictionary *dict = self.searchCities[indexPath.row];
        cell.textLabel.text = dict[@"name"];
    }else{
        NSDictionary *cityDict = self.cityArray[indexPath.section];
        NSArray *dictArray = cityDict[@"cities"];
        NSDictionary *dict = dictArray[indexPath.row];
        cell.textLabel.text = dict[@"name"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = nil;
    if (self.isSearch) {
        dict = self.searchCities[indexPath.row];
    }else{
        NSDictionary *cityDict = self.cityArray[indexPath.section];
        NSArray *dictArray = cityDict[@"cities"];
        dict = dictArray[indexPath.row];
    }
    !self.selectHandler ? :self.selectHandler(dict[@"name"],dict[@"objectId"]);
    [self.searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in self.cityArray) {
        [arrayM addObject:dict[@"firstC"]];
    }
    return [arrayM copy];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.isSearch) {
        return nil;
    }else{
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        titleView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.15];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 20)];
        [titleView addSubview:titleLabel];
        NSString *title = [self.cityArray objectAtIndex:section][@"firstC"];
        titleLabel.text = title;
        return titleView;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.isSearch) {
        return 0;
    }else{
        return 20.f;
    }
}

- (void)backBtnClick{
    [self.searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
