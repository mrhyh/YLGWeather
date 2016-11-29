//
//  EFMallSearchVC.m
//  EF_MallDemo
//
//  Created by HqLee on 16/6/22.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFMallSearchVC.h"
#import "EFMallViewModel.h"
#import "EFMallDetailsVC.h"
#import "EFMallModel.h"
#import "EFMallCell.h"

static NSString *const mallCellID = @"mall";

@interface EFMallSearchVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) KYTableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString *keyWords;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) EFMallViewModel *viewModel;
@property (nonatomic, strong) NSMutableDictionary *requestParams;
@end

@implementation EFMallSearchVC
#pragma mark --- lazy load
- (NSMutableArray *)searchResults{
    if (_searchResults == nil) {
        _searchResults = [NSMutableArray array];
    }
    return _searchResults;
}

- (EFMallViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[EFMallViewModel alloc] initWithViewController:self];
    }
    return _viewModel;
}

- (NSMutableDictionary *)requestParams{
    if (_requestParams == nil) {
        _requestParams = [NSMutableDictionary dictionary];
    }
    return _requestParams;
}
#pragma mark --- life cycle
- (instancetype)initWithKeyWords:(NSString *)keyWords{
    if (self = [super init]) {
        _keyWords = [keyWords copy];
        [self.requestParams setObject:keyWords forKey:@"keyword"];
        [self.requestParams setObject:@(self.page) forKey:@"page"];
        [self.requestParams setObject:@(30) forKey:@"size"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    [self setupView];
    [self.viewModel getProductsList:self.requestParams];
    [SVProgressHUD showWithStatus:@"正在搜索"];
}

- (void)setupNavi{
    self.title = @"搜索结果";
}

- (void)setupView{
    WS(weakSelf)
    KYTableView *tableView = [[KYTableView alloc] initWithFrame:CGRectZero andUpBlock:^{
        weakSelf.page = 0;
        [weakSelf.requestParams setObject:@(self.page) forKey:@"page"];
        [weakSelf.viewModel getProductsList:self.requestParams];
    } andDownBlock:^{
        weakSelf.page += 1;
        [weakSelf.requestParams setObject:@(self.page) forKey:@"page"];
        [weakSelf.viewModel getProductsList:self.requestParams];
    }];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[EFMallCell class] forCellReuseIdentifier:mallCellID];
    [self.view addSubview:tableView];
    tableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.tableView = tableView;
}

#pragma mark ---<UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EFMallCell *cell = [tableView dequeueReusableCellWithIdentifier:mallCellID];
    EFMallGoodListModel *productModel = self.searchResults[indexPath.row];
    cell.listModel = productModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 122;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EFMallGoodListModel *productModel = self.searchResults[indexPath.row];
    EFMallDetailsVC *detailsVC = [[EFMallDetailsVC alloc] initWithProductId:[NSString stringWithFormat:@"%zd",productModel.objectId]];
    [self.navigationController pushViewController:detailsVC animated:YES];
}

- (void)dealloc{
    [self.viewModel cancelAndClearAll];
    [SVProgressHUD dismiss];
}

#pragma mark ---网络请求回调
- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    [SVProgressHUD dismiss];
    if (action == EFMallViewModelCallBackActionProductsList) {
        [self.tableView endLoading];
        if (result.status == NetworkModelStatusTypeSuccess) {
            NSArray *goodList = [NSArray yy_modelArrayWithClass:[EFProductListModel class] json:result.content[@"content"]];
            if (self.page == 0) {
                [self.searchResults removeAllObjects];
                [self.searchResults addObjectsFromArray:goodList];
                [self.tableView reloadData];
            }else{
                if (goodList.count > 0) {
                    [self.searchResults addObjectsFromArray:goodList];
                    [self.tableView reloadData];
                }else{
                    [UIUtil alert:@"没有更多商品啦!"];
                }
            }
        }else{
            [UIUtil alert:@"数据加载失败"];
            if (self.page != 0) {
                self.page -= 1;
            }
        }
    }
}
@end
