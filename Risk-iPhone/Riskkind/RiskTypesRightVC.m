//
//  RiskTypesDetailVC.m
//  Risk
//
//  Created by ylgwhyh on 16/6/30.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RiskTypesRightVC.h"
#import "RiskDetailTypeModel.h"
#import "RiskTypeModel.h"
#import "RiskFactorModel.h"
#import "RiskTypeDetailVC.h"
#import "RSRiskViewModel.h"
#import "SVProgressHUD.h"

@interface RiskTypesRightVC ( ) <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) NSMutableArray *riskArray;
@property (nonatomic, strong) NSMutableArray *sourceDataArray;

@property (nonatomic, strong) UISwitch *switchButton;
@property (nonatomic, assign) BOOL isSwitchButton;
@property (nonatomic, assign) BOOL isSwitchButtonStatus;

@property (nonatomic, strong) UIColor *oldNavigationBGColor;
@property (nonatomic, strong) UIColor *oldNavigationTitleColor;
@property (nonatomic, strong)  UILabel *navigationTitleLabel;

@property (nonatomic, strong)  RSRiskViewModel *viewModel;

@end

@implementation RiskTypesRightVC {
    UIColor *textColor;
}

- (void ) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initNavigationProperty];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData ];
    [self initUI];
    [self requestData];
    [self initNavigateView]; //默认创建，根据情况隐藏或显示
}

#pragma mark requestData

- (void )requestData {
    if (_isHideNavigationTitleLabelBOOL ) {  //跳转到同一个控制器
        [RSMethod ylg_SVProgressHUD_showWithSVProgressHUDMaskTypeNone];
         [self.viewModel findNextCategory:_typeModel.objectId];
    }
}

#pragma mark createSwitch

- (void ) initNavigateView {
    _switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 90, 34)];
    _switchButton.layer.cornerRadius = 18;
    [_switchButton setOn:NO];
    _isSwitchButtonStatus = NO;
    if(_switchButton.on == NO) {
        _switchButton.backgroundColor = [UIColor whiteColor];
    }
    [_switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_switchButton];
    self.navigationItem.rightBarButtonItem = barBtnItem;
}

#pragma mark buttonAction

- (void)switchAction:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    
    if (isButtonOn) {
        NSLog(@"是"); //项目
        _isSwitchButtonStatus = YES;
        [self.viewModel findCategoryAllContent:_typeModel.objectId];
    }else {
        NSLog(@"否"); //分类
        _isSwitchButtonStatus = NO;
        [self.viewModel findNextCategory:_typeModel.objectId];
    }
     _isSwitchButton = YES;  //右边显示全部
}

#pragma mark init

- (void) initData {
    textColor = EF_TextColor_TextColorSecondary;
    _sourceDataArray = [[NSMutableArray alloc] init];
    _riskArray = [[NSMutableArray alloc] init];
    _viewModel = [[RSRiskViewModel alloc] initWithViewController:self];
}

- (void )initUI {
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
}

- (void ) initNavigationProperty {
    
    //在此控制器第一次在左边显示title
    if(_isHideNavigationTitleLabelBOOL) {
        _navigationTitleLabel.hidden = YES;
    }else {
        if(_navigationTitleLabel == nil ) {
            _navigationTitleLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
            _navigationTitleLabel.textAlignment = NSTextAlignmentLeft;
            _navigationTitleLabel.font = Font(MFRiskTypeNoFDAFontSize);
            _navigationTitleLabel.text = @"--";
            UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_navigationTitleLabel];
            self.navigationItem.leftBarButtonItem = barBtnItem;
        }
        _navigationTitleLabel.hidden = NO;
    }
}
#pragma mark Set

- (void ) setTabBarRootNC:(UINavigationController *)tabBarRootNC {
    _tabBarRootNC = tabBarRootNC;
}

- (void) setTypeModel:(ChildrensModel *)typeModel {
    if ( nil == _typeModel) {
            _typeModel = [[ChildrensModel alloc] init];
    }
    _typeModel = typeModel;

    if (NO == _isSwitchButtonStatus) {
        [_switchButton setOn:NO];
    }else {
        [_switchButton setOn:YES];
    }
    
    if ( _isHideNavigationTitleLabelBOOL == NO ) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        _navigationTitleLabel.text = typeModel.lastPageName;
        _typeModel.secondKindId = typeModel.objectId;  //右边第一个页面记录Id
        if (_isSwitchButtonStatus) {
            [self.viewModel findCategoryAllContent:_typeModel.objectId];
        }else {
            [self.viewModel findNextCategory:_typeModel.objectId];
        }
        
    }
}

- (void)setSplitViewController:(UISplitViewController *)splitViewController {
    _splitViewController = splitViewController;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"RiskTypesRightVC_Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    //如果下页还有数据
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    ChildrensModel *model = self.sourceDataArray[indexPath.row];
    cell.textLabel.text = model.name;
    cell.textLabel.font = [UIFont systemFontOfSize:MFRiskTypeNoFDAFontSize];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChildrensModel *model = self.sourceDataArray[indexPath.row];
    if (model.nextPage ) {
        
        RiskTypesRightVC *next = [[RiskTypesRightVC alloc] init];
        next.tabBarRootNC = _tabBarRootNC;
        next.isHideNavigationTitleLabelBOOL = YES;
        next.typeModel = model;
        next.typeModel.secondKindId = _typeModel.secondKindId;
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:model.name style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:next animated:YES];
    }else {
        RiskTypeDetailVC *next = [[RiskTypeDetailVC alloc] init];
        next.objectId = (int)model.objectId;
        [self.navigationController pushViewController:next animated:YES];
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

#pragma mark ViewModel 回调
- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    if (action & RSRisk_NS_ENUM_findNextCategory) {
        if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeSuccess) {
            _sourceDataArray = [self.viewModel.childrensModelArray mutableCopy];
            if (_sourceDataArray.count > 0 ) {
                [self.tableView reloadData];  //必须先刷新数据
                [self.tableView scrollToRowAtIndexPath:IndexZero atScrollPosition:UITableViewScrollPositionTop animated:YES];
                ChildrensModel *model = _sourceDataArray[0];
                if (model.nextPage ) {  //有下一页
                    _switchButton.hidden = NO;
                }else {
                    _switchButton.hidden = YES;
                }
                if (_isSwitchButton ) {
                    _switchButton.hidden = NO;
                }
            }else {
                  [self.tableView reloadData];
            }
        }else {
            [RSMethod ylg_showSuccessWithStatus:result.message];
        }
    } else {
        [_sourceDataArray removeAllObjects];
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
