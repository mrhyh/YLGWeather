//
//  SaleRecordVC.m
//  Risk
//
//  Created by Cherie Jeong on 16/8/31.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "SaleRecordVC.h"
#import "RSRiskViewModel.h"
#import "SaleTableViewCell.h"

#define SaleRecordsIdentifier @"SaleRecordsIdentifier"

@interface SaleRecordVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) RSRiskViewModel * viewModel;
@property (nonatomic,strong) NSMutableArray * salesList;
@property (nonatomic,strong) KYTableView * table;
@property (nonatomic,strong) UILabel     * noDataLB;
@property (nonatomic,assign) int currentPage;

@end

@implementation SaleRecordVC

- (NSMutableArray *)salesList {
    if (!_salesList) {
        _salesList = [[NSMutableArray alloc]init];
    }
    return _salesList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"销售记录";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _currentPage = 0;
    
    _viewModel = [[RSRiskViewModel alloc]initWithViewController:self];
    [_viewModel getMySaleRecordWithPage:0 Size:149];
    
}

- (void)setupTablView {
    if (_table == nil) {
        WS(weakSelf);
        self.table = [[KYTableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) andUpBlock:^{
            [_salesList removeAllObjects];
            if (weakSelf.viewModel.saleMdoel.records.first) {
                weakSelf.currentPage = 0;
                [weakSelf.viewModel getMySaleRecordWithPage:weakSelf.currentPage Size:149];
            }else {
                weakSelf.currentPage--;
                [weakSelf.viewModel getMySaleRecordWithPage:weakSelf.currentPage Size:149];
            }
            
        } andDownBlock:^{
            
            if (weakSelf.viewModel.saleMdoel.records.last) {
                [UIUtil alert:@"已经是最后一页"];
                [weakSelf.table endLoading];
            }else {
                weakSelf.currentPage++;
                [weakSelf.viewModel getMySaleRecordWithPage:weakSelf.currentPage Size:149];
            }
            
        }];
        [self.view addSubview:self.table];
        self.table.dataSource = self;
        self.table.delegate = self;
        self.table.backgroundColor = EF_BGColor_Primary;
        self.table.separatorStyle = UITableViewCellAccessoryNone;
        [self.table registerClass:[SaleTableViewCell class] forCellReuseIdentifier:SaleRecordsIdentifier];
        
        
        _noDataLB = [[KYMHLabel alloc]initWithTitle:@"暂无销售记录，下拉刷新" BaseSize:CGRectMake(0, 80, SCREEN_WIDTH, 30) LabelColor:[UIColor clearColor] LabelFont:15 LabelTitleColor:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackNormal] TextAlignment:NSTextAlignmentCenter];
        [_table addSubview:_noDataLB];
        _noDataLB.hidden = YES;
    }
    
    if (_salesList.count <= 0) {
        _noDataLB.hidden = NO;
    }else {
        _noDataLB.hidden = YES;
    }
    
    [_table reloadData];
}

#pragma mark TableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecordList * model = self.salesList[indexPath.row];
    
    SaleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SaleRecordsIdentifier];
    
    if (cell == nil) {
        cell = [[SaleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SaleRecordsIdentifier];
    }
    
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * headView = [[UIView alloc]init];
    
    UILabel * totalMoneyLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 30)];
    totalMoneyLB.backgroundColor = [UIColor clearColor];
    totalMoneyLB.font = Font(15);
    totalMoneyLB.text = [NSString stringWithFormat:@"销售总额: %.2f元",_viewModel.saleMdoel.totalMoney];
    totalMoneyLB.textAlignment = NSTextAlignmentLeft;
    totalMoneyLB.textColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary];
    [headView addSubview:totalMoneyLB];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackDivider];
    [headView addSubview:line];
    
    if (_salesList.count <= 0) {
        return nil;
    }
    
    return  headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.salesList.count;
}

//自适应高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id model = self.salesList[indexPath.row];
    return [_table cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[SaleTableViewCell class] contentViewWidth:[self cellContentViewWith]];
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = SCREEN_WIDTH;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPath.row);
    
}




- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result {
    if (action == RSRisk_NS_ENUM_getMySaleRecord) {
        if (result.status == NetworkModelStatusTypeSuccess) {
            [self.salesList addObjectsFromArray:_viewModel.saleMdoel.records.content];
            
            
            [self setupTablView];
        }
        [self.table endLoading];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
