//
//  RSStatisticsReportVC.m
//  Risk
//
//  Created by ylgwhyh on 16/6/29.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSStatisticsReportVC.h"
#import "RSSRLeftVC.h"
#import "RSSRRightVC.h"

@interface RSStatisticsReportVC () <RSSRLeftVCDelegate>

@property (nonatomic, strong) UISplitViewController  *splitViewController;
@property (nonatomic, strong) RSSRLeftVC *leftVC;
@property (nonatomic, strong) RSSRRightVC *rightVC;

@end

@implementation RSStatisticsReportVC

- (void )viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
    
}

- (void) initData {
    
}

- (void) initUI {
    
    [self initLeftTableView];
}

#pragma mark initUI

- (void) initLeftTableView {
    
    _rightVC = [[RSSRRightVC alloc] init];
    _rightVC.tabBarRootNC = self.navigationController;
    
    _leftVC = [[RSSRLeftVC alloc] init];
    __weak typeof(_rightVC) weakSelf = _rightVC;
    _leftVC.delegate = (id)weakSelf;
    
    _splitViewController = [[UISplitViewController alloc] init];
    
    
    // 设置左侧视图宽度
    _splitViewController.preferredPrimaryColumnWidthFraction = 0.25;    //(0.2即你需要的比例)
    _splitViewController.maximumPrimaryColumnWidth = SCREEN_WIDTH/2;
    _splitViewController.viewControllers = [NSArray arrayWithObjects:_leftVC, _rightVC, nil];
    _splitViewController.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self.view addSubview:_splitViewController.view];
    
}

@end
