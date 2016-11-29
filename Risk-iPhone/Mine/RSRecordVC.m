//
//  RSRecordVC.m
//  Risk
//
//  Created by Cherie Jeong on 16/7/15.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSRecordVC.h"
#import "RSMineRecordCell.h"

#import "RSRiskViewModel.h"
#import "RSRecordModel.h"

#define RecordTableviewCell @"RecordTableviewCell"

@interface RSRecordVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)KYTableView * table;
@property (nonatomic, strong)RSRiskViewModel * viewModel;

@property (nonatomic, strong) KYMHLabel * noDataLB;
@property (nonatomic, assign) int currentPage;

@end

@implementation RSRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提交记录";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _currentPage = 0;
    _viewModel = [[RSRiskViewModel alloc]initWithViewController:self];
    [_viewModel findSubmitRecordsWithPage:0 size:149];
    
    
}

- (void)initTable {
    if (_table == nil) {
        WS(weakSelf);
        self.table = [[KYTableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) andUpBlock:^{
            if (weakSelf.viewModel.recordModel.first) {
                weakSelf.currentPage = 0;
                [weakSelf.viewModel findSubmitRecordsWithPage:weakSelf.currentPage size:149];
            }else {
                weakSelf.currentPage--;
                [weakSelf.viewModel findSubmitRecordsWithPage:weakSelf.currentPage size:149];
            }
            
        } andDownBlock:^{
            
            if (weakSelf.viewModel.recordModel.last) {
                [UIUtil alert:@"已经是最后一页"];
                [weakSelf.table endLoading];
            }else {
                weakSelf.currentPage++;
                [weakSelf.viewModel findSubmitRecordsWithPage:weakSelf.currentPage size:149];
            }
            
        }];
        [self.view addSubview:self.table];
        self.table.dataSource = self;
        self.table.delegate = self;
        self.table.backgroundColor = EF_BGColor_Primary;
        self.table.separatorStyle = UITableViewCellAccessoryNone;
        [self.table registerClass:[RSMineRecordCell class] forCellReuseIdentifier:RecordTableviewCell];
        
        _noDataLB = [[KYMHLabel alloc]initWithTitle:@"暂无提交记录，下拉刷新" BaseSize:CGRectMake(0, 80, SCREEN_WIDTH, 30) LabelColor:[UIColor clearColor] LabelFont:15 LabelTitleColor:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackNormal] TextAlignment:NSTextAlignmentCenter];
        [_table addSubview:_noDataLB];
        _noDataLB.hidden = YES;
    }
    
    if (_viewModel.recordModel.content.count <= 0) {
        _noDataLB.hidden = NO;
    }else {
        _noDataLB.hidden = YES;
    }
    
    [_table reloadData];
}

#pragma mark TableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Record * model = self.viewModel.recordModel.content[indexPath.row];
    
    RSMineRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:RecordTableviewCell];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.recordModel.content.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}


//自适应高度
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    id model;
//    if (self.viewModel.newsContents.content.count>0) {
//        model = [self.viewModel.newsContents.content objectAtIndex:indexPath.row];
//    }
//    return [self.table cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[NewsListCell class] contentViewWidth:[self cellContentViewWith]];
//}
//
//- (CGFloat)cellContentViewWith
//{
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//
//    // 适配ios7
//    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
//        width = [UIScreen mainScreen].bounds.size.height;
//    }
//    return width;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPath.row);
    
}

- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result {
    if (action == RSRisk_NS_ENUM_findSubmitRecords) {
        if (result.status == 200) {
            if (self.viewModel.recordModel.content.count > 0) {
            }
            [self initTable];
            [_table endLoading];
        }
    }
}


@end
