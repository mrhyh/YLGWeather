//
//  EFAppraiseListVC.m
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/24.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFCommentListVC.h"
#import "EFShopCartViewModel.h"
#import "EFGoodsCell.h"
#import "EFCommentListCell.h"
#import "EFPushCommentVC.h"

@interface EFCommentListVC ()  < UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) KYTableView *tableView;
@property (nonatomic, strong) UIColor *mainBGColor;
@property (nonatomic, strong) KYMHLabel *noDataLabel;
@property (nonatomic, strong) EFShopCartViewModel *viewModel;


@end

@implementation EFCommentListVC {
    
    CGFloat segmentH;
    CGFloat spaceToLeft;
    CGFloat sectionViewH;
    CGFloat sectionImageH;
    CGFloat sectionFontSize;
}

static NSString * const OrderCell = @"EFMyOrderVCGoodCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDataSource];
    
    //[self.viewModel getMyOrderList:0 Size:20 Status:@"ALL"];
    
    [self initViewPager];
}

-(void)initViewPager {
    
    if(_tableView == nil) {
        _tableView = [self createUITableView];
    }
}

- (void) initDataSource {
    
    self.viewModel = [[EFShopCartViewModel alloc] initWithViewController:self];
    
    segmentH = 40;
    spaceToLeft = 10;
    sectionViewH = 30;
    sectionImageH = 17;
    sectionFontSize = 13;
    
    self.title = @"评论列表";
    _mainBGColor = EF_MainColor;

    _dataSource = [NSMutableArray array];

    for (int i=0; i<_orderModel.orderProduct.count ; i++) {
        OrderproductModel *model = [OrderproductModel yy_modelWithJSON:_orderModel.orderProduct[i]];
        [_dataSource addObject:model];
    }
    
    [self createUITableView];
}

- (KYTableView *)createUITableView{
    
    WS(weakSelf)
    KYTableView *tableView;
    tableView = [[KYTableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) andUpBlock:^{
        [weakSelf.tableView endLoading];

    } andDownBlock:^{
        
        [weakSelf.tableView endLoading];

    }];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[EFCommentListCell class] forCellReuseIdentifier:OrderCell];
    [self.view addSubview:tableView];
    return tableView;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EFCommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderCell];
    OrderproductModel *orderproductModel = _dataSource[indexPath.row];
    cell.orderproductModel = orderproductModel;
    return cell;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 91;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //跳转评价界面
    OrderproductModel *model = _dataSource[indexPath.row];
    EFPushCommentVC *next = [[EFPushCommentVC alloc] initWithOrderProduct:model];
    next.objectId = self.orderModel.objectId;
    [self.navigationController pushViewController:next animated:YES];
}

@end