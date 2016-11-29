//
//  MedicineTypesVC.m
//  Risk
//
//  Created by ylgwhyh on 16/6/30.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RiskTypesLeftVC.h"
#import "RiskTypeModel.h"
#import "RiskTypesLeftCell.h"
#import "RSRiskViewModel.h"
#import "RSRiskBannerModel.h"
#import "SVProgressHUD.h"
#import "TZImagePickerController.h"
#import "RiskTypesRightVC.h"
#import "RiskTypeDetailVC.h"
#import "RiskTypeFDARightVC.h"
#import "RiskTypeFDALeftVC.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "MineVC.h"

@interface RiskTypesLeftVC () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, TZImagePickerControllerDelegate>

@property (nonatomic, strong) NSMutableArray *riskTypesArray;
@property (nonatomic, strong) NSArray *sectionTitleArray;
@property (nonatomic, strong) NSIndexPath *oldSelectIndexPath;
@property (nonatomic, strong) RSRiskViewModel *viewModel;

@property (nonatomic, assign) BOOL isJoinBool;  //第一次加入此控制器

@property (nonatomic, strong) NSString * showSectionInteger;
@property (nonatomic, strong) UIButton * seletBtn;
@property (nonatomic, assign) BOOL  isSeleted;

//未开启FDA
@property (nonatomic, strong) UISplitViewController  *splitViewController;
@property (nonatomic, strong) RiskTypesLeftVC *leftVC;
@property (nonatomic, strong) RiskTypesRightVC<UISplitViewControllerDelegate> *rightVC;
@property(nonatomic, assign) BOOL isShowFDA;
@property (nonatomic, strong) UITableView *noFDATableView;

//开启FDA
@property (nonatomic, strong) RiskTypeFDALeftVC *riskTypeFDALeftVC;
@property (nonatomic, strong) UISplitViewController  *fdaSplitVC;


//FDA相关

@property (nonatomic, strong) NSMutableArray *riskArray;
@property (nonatomic, strong) NSMutableArray <RSRFDAModel *>*sourceDataArray;
@property (nonatomic, strong) UIColor *oldNavigationBGColor;
@property (nonatomic, strong) UIColor *oldNavigationTitleColor;
@property (nonatomic, strong) UILabel *navigationTitleLabel;
@property (nonatomic, strong) UITableView *fdaTableView;

@property (nonatomic, strong) UITapGestureRecognizer * hiddenGesture;//收回侧边栏 点击事件

@end

@implementation RiskTypesLeftVC {
    UIColor *textColor;
}

static NSString * const RiskTypesLeftVC_RiskTypesLeftCell_ID = @"RiskTypesLeftVC_RiskTypesLeftCell_ID";

- (void ) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //[self initUIBeforeViewAppear];
}

- (void ) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [self requestData];
}

- (void) initData {
    
    _isShowFDA = NO;
    
    textColor = EF_TextColor_TextColorSecondary;
    
    _viewModel = [[RSRiskViewModel alloc] initWithViewController:self];
    textColor = EF_TextColor_TextColorSecondary;
    
    if(_riskTypesArray == nil ) {
        _riskTypesArray = [[NSMutableArray alloc] init];
    }

    _riskArray = [[NSMutableArray alloc] init];
    
}

- (void )requestData {
    [RSMethod ylg_SVProgressHUD_showWithSVProgressHUDMaskTypeNone];
    [self.viewModel findAllRiskCategory];
    
    //FDA
    if (_isHideNavigationTitleLabelBOOL == NO ) {  //第一次进入此控制器
        
        [self.viewModel findAllFDARiskCategory:0 size:150];
        
        if (self.sourceDataArray.count > 0 ) {  //右边默认显示
            RSRFDAModel *model  = self.sourceDataArray[0];
            if ([self.delegate respondsToSelector:@selector(RiskTypeFDALeftVC:didSelectedRiskTypeFDALeftVC:)] ) {
                //[self.delegate RiskTypeFDALeftVC:self didSelectedRiskTypeFDALeftVC:model];
            }
        }
    }else {
        [self.fdaTableView reloadData];
    }
    [_viewModel getUnReadMsgCount];
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initNavigateView];
    [self initNoFDAUI];
    [self initFDAUI];
    [self changeFDAUI];
}

- (void) changeFDAUI {
    if (_isShowFDA) {
        //_fdaSplitVC.view.hidden = NO;
        //_splitViewController.view.hidden = YES;
        self.noFDATableView.hidden = YES;
        self.fdaTableView.hidden = NO;
        _riskTypeFDALeftVC.tableView.hidden = NO;
        [self.fdaTableView reloadData];
        
    } else {
        //_fdaSplitVC.view.hidden = YES;
        //_splitViewController.view.hidden = NO;
        self.noFDATableView.hidden = NO;
        self.fdaTableView.hidden = YES;
        _riskTypeFDALeftVC.tableView.hidden = YES;
        [self.noFDATableView reloadData];
    }
}

- (void) initNoFDAUI {
    self.noFDATableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
    self.noFDATableView.tableHeaderView.backgroundColor = RGBColor(213, 213, 220);
    [self.noFDATableView registerClass:[RiskTypesLeftCell class] forCellReuseIdentifier:RiskTypesLeftVC_RiskTypesLeftCell_ID];
    self.noFDATableView.emptyDataSetSource = self;
    self.noFDATableView.emptyDataSetDelegate = self;
    self.noFDATableView.delegate = self;
    self.noFDATableView.dataSource = self;
    self.noFDATableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.noFDATableView.tableFooterView = [UIView new];
    
    self.noFDATableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.viewModel findAllRiskCategory];
    }];
    [self.view addSubview:self.noFDATableView];
    [self.noFDATableView reloadData];
}

- (void)initNavigateView {
    UIView *leftNavigationBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
    
    KYMHLabel *staticLabel = [[KYMHLabel alloc] initWithTitle:@"FDA" BaseSize:CGRectMake(0, 0,40, 30) LabelColor:nil LabelFont:normalFontSize LabelTitleColor:[UIColor whiteColor] TextAlignment:NSTextAlignmentCenter];
    [leftNavigationBGView addSubview:staticLabel];
    
    UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(CGRectGetMaxX(staticLabel.frame)+5, 0, 50, 20)];
    switchButton.transform = CGAffineTransformMakeScale(MFCommonSwitchZoomProportion, MFCommonSwitchZoomProportion);
    switchButton.layer.cornerRadius = 15;
    [switchButton setOn:NO];
    if(switchButton.on == NO) {
        switchButton.backgroundColor = [UIColor whiteColor];
    }
    [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [leftNavigationBGView addSubview:switchButton];
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavigationBGView];
    self.navigationItem.rightBarButtonItem = barBtnItem;
    
    UIButton * moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(0, 0, 44, 44);
    [moreBtn setImage:Img(@"text_menu") forState:0];
    [moreBtn addTarget:self action:@selector(showLeftVC) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithCustomView:moreBtn];
    self.navigationItem.leftBarButtonItem = leftBtn;
}

//显示侧边栏
- (void)showLeftVC {
    [[EFAppManager shareInstance].sideAndTabHome showLeftView];
    if (_hiddenGesture == nil) {
        _hiddenGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenLeftVC)];
    }
    
    [self.view addGestureRecognizer:_hiddenGesture];
    
}

//收回侧边栏
- (void)hiddenLeftVC {
    [[EFAppManager shareInstance].sideAndTabHome hiddenLeftView];
    [self.view removeGestureRecognizer:_hiddenGesture];
}

- (void )initFDAUI {
    WS(weakSelf)
    self.fdaTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64,SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
    self.fdaTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.fdaTableView.emptyDataSetSource = self;
    self.fdaTableView.emptyDataSetDelegate = self;
    self.fdaTableView.tableFooterView = [UIView new];
    self.fdaTableView.delegate = self;
    self.fdaTableView.dataSource = self;
    
    self.fdaTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (_isHideNavigationTitleLabelBOOL == NO ) {   //第一个页面才用刷新
            [weakSelf requestData];
        }else {
            [self.fdaTableView.mj_header endRefreshing];
        }
    }];
    [self.view addSubview:self.fdaTableView];
    [self.fdaTableView reloadData];
}

#pragma mark initUI FDA

- (void) initUIBeforeViewAppear {
    _oldNavigationBGColor = self.navigationController.navigationBar.tintColor; //记录Navigation原来的颜色
    _oldNavigationTitleColor = self.navigationController.navigationBar.titleTextAttributes[NSForegroundColorAttributeName]; //记录Navigation原来的文字颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    NSDictionary *textAttributes=[NSDictionary dictionaryWithObjectsAndKeys:RGBColor(110, 133, 152),NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:textAttributes];
    
    //在此控制器第一次在左边显示title，之后就隐藏
    if(_isHideNavigationTitleLabelBOOL) {
        _navigationTitleLabel.hidden = YES;
        self.navigationController.navigationBar.tintColor = RGBColor(110, 133, 152);
    }else {
        if(_navigationTitleLabel == nil ) {
            _navigationTitleLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
            _navigationTitleLabel.textAlignment = NSTextAlignmentLeft;
            _navigationTitleLabel.textColor = RGBColor(110, 133, 152);
            _navigationTitleLabel.font = Font(MFRiskTypeNoFDAFontSize);
            [self updateNavigationTitle];
            
            UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_navigationTitleLabel];
            self.navigationItem.leftBarButtonItem = barBtnItem;
        }
        _navigationTitleLabel.hidden = NO;
    }
}


#pragma mark Other Method 

- (void)switchAction:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    
    if (isButtonOn) {
        NSLog(@"是");
        _isShowFDA = YES;
        
        if (_sourceDataArray.count <= 0) {
            [self.viewModel findAllFDARiskCategory:0 size:MFDefaultMaximumPageSize];
        }

    }else {
        NSLog(@"否");
        _isShowFDA = NO;
        if (_riskTypesArray.count <= 0) {
                [self.viewModel findAllRiskCategory];
        }
    }
    [self changeFDAUI];
}

- (void ) updateNavigationTitle {
    if (_sourceDataArray.count > 0) {
        RSRFDAModel *model = _sourceDataArray[0];
        _navigationTitleLabel.text = model.name;
    }
}

//进入时默认请求一次（仅仅一次）
- (void ) defaultRequestData {
    if (_isHideNavigationTitleLabelBOOL == NO ) {  //第一次进入此控制器
        if (self.sourceDataArray.count > 0 ) {  //右边默认显示
            if ([self.delegate respondsToSelector:@selector(RiskTypeFDALeftVC:didSelectedRiskTypeFDALeftVC:)] ) {
                //[self.delegate RiskTypeFDALeftVC:self didSelectedRiskTypeFDALeftVC:model];
            }
        }
    }
}

- ( void ) delegateAction:(RSRFDAModel *) model {
    if ([self.delegate respondsToSelector:@selector(RiskTypeFDALeftVC:didSelectedRiskTypeFDALeftVC:)] ) {
        //[self.delegate RiskTypeFDALeftVC:self didSelectedRiskTypeFDALeftVC:model];
    }
}

- (void ) firstJoinRequestData {
    if (_isJoinBool == NO ) { //第一次进入此页面
        
        RiskBannerModel *rbModel = [[RiskBannerModel alloc] init];
        
        if (_riskTypesArray.count > 0) {
            rbModel = _riskTypesArray[0];
        }
        
        if (rbModel.childrens.count >0 ) {
            
            ChildrensModel *model = rbModel.childrens[0];
            if ([self.delegate respondsToSelector:@selector(riskTypesVC:didSelectedRiskType:)]) {
                model.lastPageName = rbModel.name;
                [self.delegate riskTypesVC:self didSelectedRiskType:model];
            }
        }
    }
    _isJoinBool = YES;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
//    if (self.noFDATableView == tableView) {
//            return _riskTypesArray.count;
//    }else {
//            return _sourceDataArray.count;
//    }
    
    if (NO == _isShowFDA) {
            return _riskTypesArray.count;
    }else {
          return _sourceDataArray.count;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    if (self.noFDATableView == tableView) {
//        RiskBannerModel *model = _riskTypesArray[section];
//        return  model.childrens.count;
//    }else {
//        if (_sourceDataArray.count > 0) {
//            RSRFDAModel *rsModel = _sourceDataArray[section];
//            return rsModel.beans.count;
//        }else {
//            return 0;
//        }
//    }
    
    
    if (NO == _isShowFDA) {
        RiskBannerModel *model = _riskTypesArray[section];
        return  model.childrens.count;

    }else {
        if (_sourceDataArray.count > 0) {
            RSRFDAModel *rsModel = _sourceDataArray[section];
            return rsModel.beans.count;
        }else {
            return 0;
        }

    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (NO == _isShowFDA) {
        RiskTypesLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:RiskTypesLeftVC_RiskTypesLeftCell_ID];
        
        if (!cell) {
            cell = [[RiskTypesLeftCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:RiskTypesLeftVC_RiskTypesLeftCell_ID];
        }
        
        RiskBannerModel *rbModel = _riskTypesArray[indexPath.section];
        ChildrensModel *model = rbModel.childrens[indexPath.row];
        model.integer = indexPath.row+1;
        cell.model = model;
        return cell;

    }else {
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (NO == _isShowFDA) {
        if(_oldSelectIndexPath != nil ) {
            //取消以前选中的
            RiskBannerModel *rbModel = _riskTypesArray[_oldSelectIndexPath.section];
            ChildrensModel *oldModel = rbModel.childrens[_oldSelectIndexPath.row];
            oldModel.isSelect = NO;
            
            [self.noFDATableView reloadRowsAtIndexPaths:@[_oldSelectIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic] ;
        }
        
        //选中当前的
        RiskBannerModel *rbModel = _riskTypesArray[indexPath.section];
        ChildrensModel *model = rbModel.childrens[indexPath.row];
        model.isSelect = YES;
        
        [self.noFDATableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic] ;
        _oldSelectIndexPath = indexPath;  //记录当前选中的cell
        
        if ([self.delegate respondsToSelector:@selector(riskTypesVC:didSelectedRiskType:)]) {
            
            model.lastPageName = rbModel.name;
            [self.delegate riskTypesVC:self didSelectedRiskType:model];
        }
        _isJoinBool = YES;

        RiskTypesRightVC *next = [[RiskTypesRightVC alloc] init];
        next.isHideNavigationTitleLabelBOOL = YES;
        next.typeModel = model;
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:model.name style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:next animated:YES];
    }else {
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
                [self delegateAction:rsRFDAModel];
            }
        }

    }
    
}

#pragma mark - Table view  delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * headView = [[UIView alloc]init];
    headView.backgroundColor = RGBColor(226, 226, 226);
    
    UILabel * titleLB = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, 44)];
    titleLB.textColor = RGBColor(46, 83, 111);
    titleLB.font = Font(15);
    [headView addSubview:titleLB];
    
    RiskBannerModel *model = _riskTypesArray[section];
    titleLB.text = model.name;
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (NO == _isShowFDA) {
        return 40;
    }else {
        return 44;
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
- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result {
    [SVProgressHUD dismiss];
    [self.noFDATableView.mj_header endRefreshing];
    [self.fdaTableView.mj_header endRefreshing];
    if (action == RSRisk_NS_ENUM_findAllRiskCategory) {
        if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeSuccess) {
            _riskTypesArray = [self.viewModel.riskBannerModelArray mutableCopy];
            
            if (_riskTypesArray.count > 0 ) { //判断第一section、第一row是否存在
                RiskBannerModel *rbModel = _riskTypesArray[0];
                if (rbModel.childrens.count > 0) {
                    ChildrensModel *model  = rbModel.childrens[0];
                    model.isSelect = YES;
                }
                [self.noFDATableView reloadData];
                _oldSelectIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];     //默认选中第一个
                
                [self firstJoinRequestData];
            }
            [self.noFDATableView reloadData];
        }else {
            [UIUtil alert:result.message];
        }
    }
    
    if (action == RSRisk_NS_ENUM_findAllFDARiskCategory) {
        if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeSuccess) {
            _sourceDataArray = [self.viewModel.rsRFDAModelArray mutableCopy];
            
            [self updateNavigationTitle];
            [self defaultRequestData];
            [self.fdaTableView reloadData];
        }else {
            [RSMethod ylg_showSuccessWithStatus:result.message];
        }
    }
    
    
    if (action == RSRisk_NS_ENUM_getUnReadMsgCount) {
        if (result.status == 200) {
            
             [[MineVC shareInstance] changeMsgNum:_viewModel.unReadMsgCount];
        }
    }

}



#pragma mark dealloc

- (void)dealloc{
    if (self.viewModel) {
        [self.viewModel cancelAndClearAll];
        self.viewModel = nil;
    }
    
    [SVProgressHUD dismiss];
}

@end
