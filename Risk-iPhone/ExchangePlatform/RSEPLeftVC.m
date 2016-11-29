//
//  RSEPLeftVC.m
//  Risk
//
//  Created by ylgwhyh on 16/7/15.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSEPLeftVC.h"
#import "RiskTypeModel.h"
#import "RSEPLeftCell.h"
#import "EMClient.h"
#import <HyphenateSDK/EMSDK.h>
#import "EMOptions.h"
#import "EMClient.h"
#import "EaseSDKHelper.h"
#import "EMSDK.h"
#import "RSRiskViewModel.h"
#import "EaseChatToolbar.h"
#import "IMessageModel.h"
#import "EaseMessageViewController.h"
#import "TZImagePickerController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "RSHuanXinVC.h"


@interface RSEPLeftVC () <UITableViewDelegate, UITableViewDataSource, EaseMessageViewControllerDataSource, EaseMessageViewControllerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) NSMutableArray *riskTypesArray;
@property (nonatomic, strong) NSIndexPath *oldSelectIndexPath;
@property (nonatomic, strong) EMGroup *chatGroup;
@property (nonatomic, strong) id<IMessageModel> model;
@property (nonatomic, strong)  RSRiskViewModel *viewModel;

@end

@implementation RSEPLeftVC {
    UIColor *tableViewBGColor;
}

static NSString * const RiskTypesLeftVC_RiskTypesLeftCell_ID = @"RiskTypesLeftVC_RiskTypesLeftCell_ID";

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [EFAppManager shareInstance].sideAndTabHome.rootViewController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [EFAppManager shareInstance].sideAndTabHome.rootViewController.navigationBar.hidden = YES;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
    [self requestData];
}

- (void )requestData {
    WS(weakSelf)
    BOOL isNotLoginSuccessForHuanXin = [MFUserDefaults boolForKey:MFHuanXin_IsNotLoginSuccessUserdefaultKey];
    NSLog(@"isNotLoginSuccessForHuanXin=%d",isNotLoginSuccessForHuanXin);

    
    if (YES == [RS_UserModel ShareUserModel].isLogin  && YES == isNotLoginSuccessForHuanXin) {
        [RSHuanXinVC rs_loginEasemob];  //如果已经登录了账号，启动时自动登录环信并加入群组
    }
    
    [[EMClient sharedClient].groupManager getGroupSpecificationFromServerByID:HuanXin_Group_Id includeMembersList:YES completion:^(EMGroup *aGroup, EMError *aError) {
        if ([UIUtil isEmptyStr:aError.errorDescription] ) {
            NSLog(@"获取群聊成员列表成功");
            weakSelf.chatGroup = aGroup;
            NSString *arrrayString = [_chatGroup.occupants componentsJoinedByString:@","];
            [self.viewModel getUserProfileByEasemob:arrrayString];
        }else {
            NSLog(@"获取群聊成员列表失败，原因:%@",aError.errorDescription);
            [self.tableView.mj_header endRefreshing];
        }
    }];
}

- (void) initUI {
    
    self.title = @"交流群成员";
    
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self.tableView registerClass:[RSEPLeftCell class] forCellReuseIdentifier:RiskTypesLeftVC_RiskTypesLeftCell_ID];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero]; //去掉tableView滚动到底部时的空白，对于某些时候tableView底部有空白的情况
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone; //去掉下划线
    self.tableView.backgroundColor = tableViewBGColor;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData];
    }];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(testNotificationOne:) name:MF_RefreshHeadImage_Notification object:nil];
}



- (void) initData {
    tableViewBGColor = RGBColor(245, 244, 245);
    if(_riskTypesArray == nil ) {
        _riskTypesArray = [[NSMutableArray alloc] init];
    }
    _viewModel = [[RSRiskViewModel alloc] initWithViewController:self];
}

#pragma mark Other Method

- (void) testNotificationOne:(NSNotification *)notification{
    NSLog(@"testNotificationOne");
    [self requestData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _riskTypesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RSEPLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:RiskTypesLeftVC_RiskTypesLeftCell_ID];
    HuanXinUserModel *model = [_riskTypesArray objectAtIndex:indexPath.row];
    cell.backgroundColor = tableViewBGColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - EaseMessageViewControllerDataSource
- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message {
    //用户可以根据自己的用户体系，根据buddy设置用户昵称和头像
    //将环信的id名和替换成我们自己的用户名
    //id<IMessageModel> model = nil;
    self.model = nil;
    
    _riskTypesArray = [[HuanXinUserModel getHuanXinUserModelArrays] mutableCopy];
    for (int i=0; i<_riskTypesArray.count; i++ ) {
        HuanXinUserModel *hxuModel = _riskTypesArray[i];
        
#ifdef DEBUG
        NSLog(@"message.from=%@",message.from);
        NSLog(@"hxuModel.easemobId=%@",hxuModel.easemobId);
#endif
        
        if ([message.from isEqualToString:hxuModel.easemobId] ) {
            self.model = [ [EaseMessageModel alloc] initWithMessage:message];
             self.model.avatarURLPath = hxuModel.head.url;//头像网络地址
             self.model.nickname = hxuModel.nickname;//用户昵称
             self.model.avatarImage = [UIImage imageNamed:@"ic_defaultavatar"];
        }else {
        }
    }
    return self.model;
}

#pragma mark DZNEmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无联系人";
    UIColor *textColor = EF_TextColor_TextColorSecondary;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: textColor};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

#pragma mark ViewModel回调

- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    if ( RSRisk_NS_ENUM_getUserProfileByEasemob == action ) {
        if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeSuccess) {
            [_riskTypesArray removeAllObjects];
            _riskTypesArray = [(NSMutableArray*)self.viewModel.rsEaseMobUserListModel.content mutableCopy];
            NSArray *array = self.viewModel.rsEaseMobUserListModel.content;
            [HuanXinUserModel saveHuanXinUserModelArrays:(NSMutableArray *)array];
            [self.tableView reloadData];
        }else {
            [self.tableView.mj_header endRefreshing];
        }
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
