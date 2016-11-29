//
//  RSFDALeftVC.m
//  Risk
//
//  Created by ylgwhyh on 16/7/5.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RiskTypeFDALeftVC.h"
#import "RiskFactorModel.h"
#import "RiskDetailTypeModel.h"
#import "RiskTypesRightVC.h"
#import "SVProgressHUD.h"
#import "RSRiskViewModel.h"
#import "RSMethod.h"

@interface RiskTypeFDALeftVC () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *riskArray;
@property (nonatomic, strong) NSMutableArray <RSRFDAModel *>*sourceDataArray;
@property (nonatomic, strong) UIColor *oldNavigationBGColor;
@property (nonatomic, strong) UIColor *oldNavigationTitleColor;
@property (nonatomic, strong) UILabel *navigationTitleLabel;

@property (nonatomic, strong)  RSRiskViewModel *viewModel;

@end

@implementation RiskTypeFDALeftVC {
    UIColor *textColor;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initUIBeforeViewAppear];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
    [self requestData];
}

#pragma mark Request Data

- (void )requestData {
    if (_isHideNavigationTitleLabelBOOL == NO ) {  //第一次进入此控制器
        
        //[RSMethod ylg_SVProgressHUD_showWithSVProgressHUDMaskTypeNone];
        [self.viewModel findAllFDARiskCategory:0 size:120];
        
        if (self.sourceDataArray.count > 0 ) {  //右边默认显示
            RSRFDAModel *model  = self.sourceDataArray[0];
            if ([self.delegate respondsToSelector:@selector(RiskTypeFDALeftVC:didSelectedRiskTypeFDALeftVC:)] ) {
                [self.delegate RiskTypeFDALeftVC:self didSelectedRiskTypeFDALeftVC:model];
            }
        }
    }else {
        [self.tableView reloadData];
    }
}

//进入时默认请求一次（仅仅一次）
- (void ) defaultRequestData {
    if (_isHideNavigationTitleLabelBOOL == NO ) {  //第一次进入此控制器
        if (self.sourceDataArray.count > 0 ) {  //右边默认显示
            RSRFDAModel *model  = self.sourceDataArray[0];
            if ([self.delegate respondsToSelector:@selector(RiskTypeFDALeftVC:didSelectedRiskTypeFDALeftVC:)] ) {
                [self.delegate RiskTypeFDALeftVC:self didSelectedRiskTypeFDALeftVC:model];
            }
        }
    }
}

#pragma mark Init

- (void ) initUI {
    WS(weakSelf)
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (_isHideNavigationTitleLabelBOOL == NO ) {   //第一个页面才用刷新
            [weakSelf requestData];
        }else {
            [self.tableView.mj_header endRefreshing];
        }
    }];
}

- (void) initUIBeforeViewAppear {
//    _oldNavigationBGColor = self.navigationController.navigationBar.tintColor; //记录Navigation原来的颜色
//    _oldNavigationTitleColor = self.navigationController.navigationBar.titleTextAttributes[NSForegroundColorAttributeName]; //记录Navigation原来的文字颜色
//    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];

//    NSDictionary *textAttributes=[NSDictionary dictionaryWithObjectsAndKeys:RGBColor(110, 133, 152),NSForegroundColorAttributeName,nil];
//    [self.navigationController.navigationBar setTitleTextAttributes:textAttributes];

    //在此控制器第一次在左边显示title，之后就隐藏
    if(_isHideNavigationTitleLabelBOOL) {
        _navigationTitleLabel.hidden = YES;
        //self.navigationController.navigationBar.tintColor = RGBColor(110, 133, 152);
    }else {
        if(_navigationTitleLabel == nil ) {
            _navigationTitleLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
            _navigationTitleLabel.textAlignment = NSTextAlignmentLeft;
            //_navigationTitleLabel.textColor = RGBColor(110, 133, 152);
            _navigationTitleLabel.font = Font(MFRiskTypeNoFDAFontSize);
            [self updateNavigationTitle];
            
            UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_navigationTitleLabel];
            self.navigationItem.leftBarButtonItem = barBtnItem;
        }
        _navigationTitleLabel.hidden = NO;
    }
}

- (void) initData {
    _viewModel = [[RSRiskViewModel alloc] initWithViewController:self];
    textColor = EF_TextColor_TextColorSecondary;
    _riskArray = [[NSMutableArray alloc] init];
}

#pragma mark ButtonAction

- (void ) backBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Set

- (void ) setModel:(RSRFDAModel *)model {
    _model = model;
    _model.beans = (NSMutableArray *)[NSArray yy_modelArrayWithClass:[RSRFDAModel class] json:_model.beans];
    
    if ( nil == _sourceDataArray ) {
        _sourceDataArray = [[NSMutableArray alloc ] init];
    }
    [_sourceDataArray addObject:_model];
    [self updateNavigationTitle];
}


- (void)setRiskTypeFDARightVC:(RiskTypeFDARightVC<UISplitViewControllerDelegate> *)riskTypeFDARightVC {
    _riskTypeFDARightVC = riskTypeFDARightVC;
}

#pragma mark Lazy loading

- (NSMutableArray *)sourceDataArray {
    if (nil == _sourceDataArray ) {
        _sourceDataArray = [[NSMutableArray alloc ] init];
    }
    return _sourceDataArray;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"RiskTypesRightVC_Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    if (self.sourceDataArray.count > 0 ) {
        RSRFDAModel *firstModel =  self.sourceDataArray[indexPath.section];
        RSRFDAModel *model  = firstModel.beans[indexPath.row];
        cell.textLabel.text = model.name;
        cell.textLabel.font = Font(MFRiskTypeNoFDAFontSize);
    }

    return cell;
}

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView {
    return _sourceDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_sourceDataArray.count > 0) {
        RSRFDAModel *rsModel = _sourceDataArray[section];
        return rsModel.beans.count;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_sourceDataArray.count > 0 ) {
        RSRFDAModel *rsrfdAModel = [_sourceDataArray[indexPath.section] copy];
        RSRFDAModel *rsRFDAModel = [rsrfdAModel.beans[indexPath.row] copy];
        
        if (rsRFDAModel.beans.count > 0 ) { //跳下一页
            
            RiskTypeFDALeftVC *next = [[RiskTypeFDALeftVC alloc] init];
            next.isHideNavigationTitleLabelBOOL = YES;
            next.model = rsRFDAModel;
            __weak typeof(_riskTypeFDARightVC) weakSelf = _riskTypeFDARightVC;
            next.delegate = (id)weakSelf;
            
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:rsRFDAModel.name style:UIBarButtonItemStylePlain target:nil action:nil];
            [self delegateAction:rsRFDAModel];
            [self.navigationController pushViewController:next animated:YES];
        }else {
            //[self delegateAction:rsRFDAModel];
            
            RiskTypeFDARightVC *next = [[RiskTypeFDARightVC alloc] init];
            next.model = rsRFDAModel;
            [self.navigationController pushViewController:next animated:YES];
        }
    }
}

- ( void ) delegateAction:(RSRFDAModel *) model {
    if ([self.delegate respondsToSelector:@selector(RiskTypeFDALeftVC:didSelectedRiskTypeFDALeftVC:)] ) {
        [self.delegate RiskTypeFDALeftVC:self didSelectedRiskTypeFDALeftVC:model];
    }
}

#pragma mark DZNEmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无数据";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: textColor};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

#pragma mark ViewModel回调

- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    
    if (action & RSRisk_NS_ENUM_findAllFDARiskCategory) {
        if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeSuccess) {
            _sourceDataArray = [self.viewModel.rsRFDAModelArray mutableCopy];
            
            [self updateNavigationTitle];
            [self defaultRequestData];
            [self.tableView reloadData];
        }else {
            [RSMethod ylg_showSuccessWithStatus:result.message];
        }
    }
}

- (void ) updateNavigationTitle {
    if (_sourceDataArray.count > 0) {
        RSRFDAModel *model = _sourceDataArray[0];
        _navigationTitleLabel.text = model.name;
    }
}

#pragma mark dealloc

- (void)dealloc{
    if (self.viewModel) {
        [self.viewModel cancelAndClearAll];
        self.viewModel = nil;
    }
}

@end
