//
//  RSEPExchangePlatform.m
//  Risk
//
//  Created by ylgwhyh on 16/7/13.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSEPExchangePlatformVC.h"
#import "EaseMessageViewController.h"
#import "RSEPLeftVC.h"

@interface RSEPExchangePlatformVC ()

@property (nonatomic, strong) UISplitViewController  *splitViewController;
@property (nonatomic, strong) RSEPLeftVC *leftVC;
@property (nonatomic, strong) EaseMessageViewController *rightVC;

@end

@implementation RSEPExchangePlatformVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refershViewController];
    [EFAppManager shareInstance].sideAndTabHome.rootViewController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [EFAppManager shareInstance].sideAndTabHome.rootViewController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
}

- (void) initData {
    
}

- (void) initUI {
    [self initVC];
    
   UIButton *_rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [_rightBtn setImage:Img(@"img_default_avatar") forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
}


#pragma mark Other Method

- (void) rightBtnClick {
    RSEPLeftVC * next = [[RSEPLeftVC alloc] init];
    [self.navigationController pushViewController:next animated:YES];
}

#pragma mark initUI

- (void) initVC {
    
    _rightVC = [[EaseMessageViewController alloc] initWithConversationChatter:HuanXin_Group_Id conversationType:EMConversationTypeGroupChat];
    __weak typeof(_rightVC) weakSelf = _rightVC;

    _leftVC = [[RSEPLeftVC alloc] init];
    _leftVC.delegate = (id)weakSelf;
    
    if (nil == _splitViewController) {
        _splitViewController = [[UISplitViewController alloc] init];
        _splitViewController.delegate =(id) weakSelf;
        
        // 设置左侧视图宽度
        _splitViewController.preferredPrimaryColumnWidthFraction = 0.25;         //(0.2即你需要的比例)
        _splitViewController.maximumPrimaryColumnWidth = SCREEN_WIDTH/2;
        _splitViewController.viewControllers = [NSArray arrayWithObjects: _rightVC, _leftVC, nil];
        _splitViewController.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        [self.view addSubview:_splitViewController.view];
    }
     __weak typeof(_leftVC) leftWeakSelf = _leftVC;
#warning TODO 测试
    //_rightVC.dataSource =(id) leftWeakSelf;
     __weak typeof(_rightVC) rightWeakSelf = _rightVC;
    _rightVC.dataSource = rightWeakSelf;
}

#pragma mark Other Action 

- (void) refershViewController { //注销后重新登录需要重新刷新聊天界面
    BOOL isRefersh = [MFUserDefaults boolForKey:MFIsLogoutUserdefaultKey];
    if (isRefersh ) {
        
        [self initData];
        [self initUI];
        
        [MFUserDefaults setBool:YES forKey:MFIsLogoutUserdefaultKey];
        [MFUserDefaults synchronize];
    }
}

- (void)dealloc {
    
}


@end
