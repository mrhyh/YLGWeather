//
//  RSRiskKindVC.m
//  Risk
//
//  Created by ylgwhyh on 16/6/29.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSRiskKindVC.h"
#import "RiskTypesLeftVC.h"
#import "RiskTypesRightVC.h"
#import "RiskTypeFDALeftVC.h"
#import "RiskTypeFDARightVC.h"
#import "RSRiskBannerModel.h"
#import "RSRiskViewModel.h"

@interface RSRiskKindVC() <RiskTypesLeftVCDelegate, UISplitViewControllerDelegate>

//未开启FDA
@property (nonatomic, strong) UISplitViewController  *splitViewController;
@property (nonatomic, strong) RiskTypesLeftVC *leftVC;
@property (nonatomic, strong) RiskTypesRightVC<UISplitViewControllerDelegate> *rightVC;
@property(nonatomic, assign) BOOL isShowFDA;


//开启FDA
@property (nonatomic, strong) RiskTypeFDARightVC<UISplitViewControllerDelegate> *riskTypeFDARightVC;
@property (nonatomic, strong) RiskTypeFDALeftVC *riskTypeFDALeftVC;
@property (nonatomic, strong) UISplitViewController  *fdaSplitVC;


@property (nonatomic,strong) RSRiskViewModel * viewModel;  //获取未读系统消息数量

@end

@implementation RSRiskKindVC

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_viewModel == nil) {
        _viewModel = [[RSRiskViewModel alloc]initWithViewController:self];
    }
    [_viewModel getUnReadMsgCount];
}

- (void ) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- ( void ) initData {
    
    _isShowFDA = NO;
}

- (void) initUI {
    
    [self initNavigateView];
    [self initNoFDAUI];
    [self initFDAUI];
    [self changeFDAUI];
}

- (void) changeFDAUI {
    
    if (_isShowFDA) {
        _fdaSplitVC.view.hidden = NO;
        _splitViewController.view.hidden = YES;
    } else {
        _fdaSplitVC.view.hidden = YES;
        _splitViewController.view.hidden = NO;
    }
}

- (void) initNoFDAUI {
    
    _leftVC = [[RiskTypesLeftVC alloc] init];
    _leftVC.delegate = self;
    
    _rightVC = [[RiskTypesRightVC alloc] init];
    _rightVC.tabBarRootNC = self.navigationController;
    
    UINavigationController *rightNav =
    [[UINavigationController alloc] initWithRootViewController:
     _rightVC];
    
    _splitViewController = [[UISplitViewController alloc] init];
    _splitViewController.delegate = _rightVC;
    
    // 设置左侧视图宽度
    _splitViewController.preferredPrimaryColumnWidthFraction = 0.5;         //(0.2即你需要的比例)
    _splitViewController.maximumPrimaryColumnWidth = SCREEN_WIDTH/2;
    _splitViewController.viewControllers = [NSArray arrayWithObjects:_leftVC, rightNav, nil];
    _splitViewController.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self.view addSubview:_splitViewController.view];
}

- (void )initFDAUI {
    _riskTypeFDARightVC = [[RiskTypeFDARightVC alloc] init];
    __weak typeof(_riskTypeFDARightVC) weakSelf = _riskTypeFDARightVC;
    _riskTypeFDARightVC.rsRiskKindVC = self;
    
    _riskTypeFDALeftVC = [[RiskTypeFDALeftVC alloc] init];
    _riskTypeFDALeftVC.delegate = (id)weakSelf;
    _riskTypeFDALeftVC.riskTypeFDARightVC = _riskTypeFDARightVC;
    
    UINavigationController *leftNav =
    [[UINavigationController alloc] initWithRootViewController:
     _riskTypeFDALeftVC];
    
    _fdaSplitVC = [[UISplitViewController alloc] init];
    _fdaSplitVC.delegate = _riskTypeFDARightVC;
    
    // 设置左侧视图宽度
    _fdaSplitVC.preferredPrimaryColumnWidthFraction = 0.5;         //(0.2即你需要的比例)
    _fdaSplitVC.maximumPrimaryColumnWidth = SCREEN_WIDTH/2;
    _fdaSplitVC.viewControllers = [NSArray arrayWithObjects:leftNav, _riskTypeFDARightVC, nil];
    _fdaSplitVC.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self.view addSubview:_fdaSplitVC.view];
}

- (void)initNavigateView{
    UIView *leftNavigationBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 34)];
    
    UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 90, 34)];
    switchButton.layer.cornerRadius = 18;
    [switchButton setOn:NO];
    if(switchButton.on == NO) {
        switchButton.backgroundColor = [UIColor whiteColor];
    }
    [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [leftNavigationBGView addSubview:switchButton];
    
    KYMHLabel *staticLabel = [[KYMHLabel alloc] initWithTitle:@"FDA" BaseSize:CGRectMake(CGRectGetMaxX(switchButton.frame) + 5, 0, 50, 34) LabelColor:nil LabelFont:normalFontSize LabelTitleColor:[UIColor whiteColor] TextAlignment:NSTextAlignmentLeft];
    [staticLabel FontWeight:20];
    [leftNavigationBGView addSubview:staticLabel];
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavigationBGView];
    self.navigationItem.leftBarButtonItem = barBtnItem;
}

- (void)switchAction:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    
    if (isButtonOn) {
            NSLog(@"是");
        _isShowFDA = YES;
         }else {
            NSLog(@"否");
             _isShowFDA = NO;
        }
    [self changeFDAUI];
}

#pragma mark 未开启FDA  RiskTypesLeftVCDelegate

- (void)riskTypesVC:(RiskTypesLeftVC *)RiskTypesVC didSelectedRiskType:(ChildrensModel *)type {
    
    _rightVC.typeModel = type;
    
}


- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result {
    
    if (action == RSRisk_NS_ENUM_getUnReadMsgCount) {
        if (result.status == 200) {
            
            UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
            UITabBarController *tabController = (UITabBarController*)rootController;
            UIViewController *requiredViewController = [tabController.viewControllers objectAtIndex:7];
            UITabBarItem *item = requiredViewController.tabBarItem;
            
            if (_viewModel.unReadMsgCount > 0) {
                [item showBadge];
                [item setBadgeCenterOffset:CGPointMake(-25, 10)];
            }else {
                [item clearBadge];
            }
        }
    }
    
}

@end
