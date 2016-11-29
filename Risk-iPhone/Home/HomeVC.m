//
//  HomeVC.m
//  Risk-iPhone
//
//  Created by Cherie Jeong on 16/8/24.
//  Copyright © 2016年 Cherie Jeong. All rights reserved.
//

#import "HomeVC.h"
#import "HYBLoopScrollView.h"
#import "RSRiskViewModel.h"
#import "BBFlashCtntLabel.h"
#import "LoginVC.h"
#import "HomeTableViewCell.h"
#import "RSDataSecondCenterVC.h"
#import "RSMoreDataVC.h"
#import "RSVideoVC.h"
#import "RSDataVC.h"
#import "RSAdWebVC.h"
#import "RSSearchVC.h"
#import "MineVC.h"
#import "EMClient.h"
#import "UITabBar+badge.h"
#import "UIButton+TouchAreaInsets.h"

@interface HomeVC () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *carouselUrlArray;
@property (nonatomic, weak)   HYBLoopScrollView *loopView; //轮播
@property (nonatomic, strong) UIView *searchView; //搜索

@property (nonatomic,strong)  RSRiskViewModel * viewModel;
@property (nonatomic,strong)  NSArray * msgsArray;
@property (nonatomic,strong)  BBFlashCtntLabel * lbl;

@property (nonatomic, strong) EMGroup *chatGroup;
@property (nonatomic, strong) UIScrollView * refershBackView;  //刷新
@property (nonatomic, strong) UIView * noDataBackView;
@property (nonatomic, strong) UIView * flashBackView;


@property (nonatomic, strong) UITapGestureRecognizer * hiddenGesture;//收回侧边栏 点击事件

@end

@implementation HomeVC {
    KYMHImageView * adImageView;
    CGFloat loopViewH;
    CGFloat flashLabeH;
    CGFloat tableViewDefaultH;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_viewModel == nil) {
        _viewModel = [[RSRiskViewModel alloc]initWithViewController:self];
    }
    //每次进入该界面获取系统未读消息数和滚动公告显示内容
    [_viewModel getSystemNotice];
    [_viewModel getUnReadMsgCount];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.loopView startTimer];
    [self requestGetUserProfileByEasemob];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.loopView pauseTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
    [self requestAction];
    [self initNotification];
}

- (void)requestAction {
    WS(weakSelf)
    if (NO == [RS_UserModel ShareUserModel].isLogin ) {
        LoginVC * vc = [[LoginVC alloc]initWithCompleteBlock:^(BOOL isSussces) {
        }];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }
    //获取数据
    [self.viewModel getSystemAdvertisementsByPositions:@"home"];
    [self.viewModel getNewVersion];
}

- (void)initData {
    tableViewDefaultH = MFCommonCellH * 3+40;
    loopViewH = SCREEN_WIDTH*0.413;
    flashLabeH = 30;
    self.viewModel = [[RSRiskViewModel alloc]initWithViewController:self];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateApp:) name:MF_UpdateApp object:nil];
}

- (void)updateApp:(NSNotification *)notification {
    NSLog(@"updateApp...");
    [self.viewModel getNewVersion];
}

#pragma mark InitUI

- (void) initUI {
    
    self.title = @"出生缺陷风险咨询工作站";//设置navigationbar的title；
    self.navigationController.title =
    @"首页";
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置navigationbar颜色
    self.navigationController.navigationBar.barTintColor = EF_MainColor;
    //设置title颜色
    UIColor * color = EF_TextColor_TextColorNavigation;
    self.navigationController.navigationBar.tintColor = color;
    if (CurrentSystemVersion > 8.2) {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17 weight:UIFontWeightMedium],NSForegroundColorAttributeName:color}];
    }else{
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:color}];
    }
    
    [self setupSearchBtn];
    [self initRefershBackView];
    [self initDataBackView];
}

- (void)initNotification {
    //通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestGetUserProfileByEasemob) name:MFRequestGetUserProfileByEasemobNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LogoutAction) name:EFLoginInvalidNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationAction:) name:MF_Notification_DrugInformationUpdate object:nil];
}


- (void)initDataBackView {
    _noDataBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 230)];
    _noDataBackView.backgroundColor = [UIColor clearColor];
    [_refershBackView addSubview:_noDataBackView];
    _noDataBackView.hidden = YES;
    _noDataBackView.center = CGPointMake(CGRectGetMidX(_refershBackView.frame), CGRectGetMidY(_refershBackView.frame));
    
    KYMHImageView * imageView = [[KYMHImageView alloc]initWithImage:Img(@"ic_nodata") BaseSize:CGRectMake(0, 0, 300, 200) ImageViewColor:[UIColor clearColor]];
    [_noDataBackView addSubview:imageView];
    
    NSString *text = @"暂无数据";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary]};
    NSAttributedString * string = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
    KYMHLabel * nodataLB = [[KYMHLabel alloc]initWithTitle:@"" BaseSize:CGRectMake(0, 200, 300, 30) LabelColor:[UIColor clearColor] LabelFont:15 LabelTitleColor:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary] TextAlignment:NSTextAlignmentCenter];
    [_noDataBackView addSubview:nodataLB];
    
    nodataLB.attributedText = string;
}

- (void)initRefershBackView {
    WS(weakSelf)
    _refershBackView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-50-64)];
    _refershBackView.alwaysBounceVertical = NO;
    _refershBackView.showsVerticalScrollIndicator = NO;
    _refershBackView.showsHorizontalScrollIndicator = NO;
    _refershBackView.bounces = YES;
    _refershBackView.backgroundColor = RGBColor(242, 246, 250);
    [self.view addSubview:_refershBackView];
    
    _refershBackView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.viewModel getSystemAdvertisementsByPositions:@"home"];
    }];
}

- (void)createUI {
    //初始化顺序不能改变
    [self showFlashLabel];
    [self initSearchView];
    [self initCarouselView];
    [self initDataView];
}


#pragma mark ButtonAction

//登录超时处理
- (void)LogoutAction {
    WS(weakSelf)
    if ([UserModel ShareUserModel].isLogin) {
        [UIUtil alert:@"您的登录状态已失效，请重新登录"];
        [UserModel Logout];
        LoginVC * vc = [[LoginVC alloc]initWithCompleteBlock:^(BOOL isSussces) {
            if (weakSelf.viewModel == nil) {
                weakSelf.viewModel = [[RSRiskViewModel alloc]initWithViewController:weakSelf];
            }
            [weakSelf.viewModel getSystemAdvertisementsByPositions:@"home"];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//搜索
- (void)setupSearchBtn {
    UIButton * moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(0, 0, 44, 44);
    [moreBtn setImage:Img(@"text_menu") forState:0];
    [moreBtn addTarget:self action:@selector(showLeftVC) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    
   UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithCustomView:moreBtn];
    self.navigationItem.leftBarButtonItem = rightBtn;
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

- (void)searchAction:(UIButton *)searchBtn {
    //跳转至搜索页
    RSSearchVC * vc = [[RSSearchVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)requestGetUserProfileByEasemob {
    WS(weakSelf)
    [[EMClient sharedClient].groupManager getGroupSpecificationFromServerByID:HuanXin_Group_Id includeMembersList:YES completion:^(EMGroup *aGroup, EMError *aError) {
        if ( [UIUtil isEmptyStr:aError.errorDescription] ) {
            NSLog(@"获取成功");
            _chatGroup = aGroup;  //_chatGroup包括所有的群ID
            NSString *arrayString = [_chatGroup.occupants componentsJoinedByString:@","];
            [weakSelf.viewModel getUserProfileByEasemob:arrayString callBackBlock:^(CallBackStatus callBackStatus, NetworkModel *result) {
                NSArray *array = weakSelf.viewModel.rsEaseMobUserListModel.content;
                [HuanXinUserModel saveHuanXinUserModelArrays:(NSMutableArray *)array];
            }];
        }else {
             NSLog(@"首页获取群成员失败，原因：%@", aError.errorDescription);
        }
    }];
}

- (void) initDataView {
    UITableView *oneDataView = [self returnDataViewWithFrame:CGRectMake(10, flashLabeH+ loopViewH+15, SCREEN_WIDTH-20, tableViewDefaultH) index:0];

    oneDataView.backgroundColor = [UIColor whiteColor];
    [_refershBackView addSubview:oneDataView];
    
    UITableView *twoDataView = [self returnDataViewWithFrame:CGRectMake(10, CGRectGetMaxY(oneDataView.frame)+20, SCREEN_WIDTH-20, tableViewDefaultH) index:1];
    twoDataView.backgroundColor = [UIColor whiteColor];
    [_refershBackView addSubview:twoDataView];
    
    UITableView *threeDataView = [self returnDataViewWithFrame:CGRectMake(10, CGRectGetMaxY(twoDataView.frame)+20, SCREEN_WIDTH-20, tableViewDefaultH) index:2];
    threeDataView.backgroundColor = [UIColor whiteColor];
    [_refershBackView addSubview:threeDataView];
    
    [_refershBackView setContentSize:CGSizeMake(0, CGRectGetMaxY(threeDataView.frame)+20)];
}

//轮播
- (void)showFlashLabel {
    
    if (_lbl == nil) {
        _flashBackView = [[UIView alloc]initWithFrame:CGRectMake(0,  loopViewH, SCREEN_WIDTH, flashLabeH)];
        _flashBackView.backgroundColor = [UIColor whiteColor];
        [_refershBackView addSubview:_flashBackView];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        line.backgroundColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackDivider];
        [_flashBackView addSubview:line];
        
        KYMHImageView * msgImg = [[KYMHImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
        [msgImg setImage:Img(@"gonggao")];
        [_flashBackView addSubview:msgImg];
        
        CGRect rect = CGRectMake(5+30,  0, SCREEN_WIDTH-(5+30), 30);
        _lbl = [[BBFlashCtntLabel alloc] initWithFrame:rect];
        _lbl.backgroundColor = [UIColor clearColor];
        _lbl.leastInnerGap = 50.f;
        _lbl.repeatCount = 0;
        _lbl.speed = BBFlashCtntSpeedMild;
        _lbl.font = [UIFont systemFontOfSize:15];
        _lbl.textColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary];
        
        [_flashBackView addSubview:_lbl];
    }

    NSString *str = @"";
    for (int i = 0; i < _msgsArray.count; i++) {
        MSGContent * msgModel = _msgsArray[i];
        
        if (i == 0) {
            str = [NSString stringWithFormat:@"%@:%@",msgModel.title,msgModel.content];
        }else {
            str = [NSString stringWithFormat:@"%@              %@:%@",str,msgModel.title,msgModel.content];
        }
    }
    _lbl.text = str;
}

//精品展示

- (UITableView *)returnDataViewWithFrame:(CGRect)frame index:(int)_index{
    UITableView * tableview = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.tag = _index + 555;
    tableview.scrollEnabled = NO;
    
    return tableview;
}

- (void)moreClickAction:(KYMHButton *)_moreBtn {
    KYMHButton * moreBtn = _moreBtn;
    int index = (int)moreBtn.tag - 200;
    
    RSHomeDataModel *model = self.viewModel.filesArray[index];
    
    switch (index) {
        case 0:{
            if (model.hasChild) {
                RSDataSecondCenterVC * vc = [[RSDataSecondCenterVC alloc]init];
                vc.categoryId = (int)model.categoryId;
                vc.categoryName = model.categoryName;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                RSMoreDataVC *vc = [[RSMoreDataVC alloc]init];
                vc.categoryId = (int)model.categoryId;
                vc.categoryName = model.categoryName;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 2:{
            self.navigationController.tabBarController.selectedIndex = 3;
        }
            break;
        case 1:{
            if (model.hasChild) {
                RSDataSecondCenterVC * vc = [[RSDataSecondCenterVC alloc]init];
                vc.categoryId = (int)model.categoryId;
                vc.categoryName = model.categoryName;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                RSMoreDataVC *vc = [[RSMoreDataVC alloc]init];
                vc.categoryId = (int)model.categoryId;
                vc.categoryName = model.categoryName;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark Other Action

- (void) searchViewClick {
    //跳转至搜索页
    RSSearchVC * vc = [[RSSearchVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 小红点
- (void)showBadgeAction{
    UIViewController *requiredViewController = [ self.tabBarController.viewControllers objectAtIndex:4];
    UITabBarItem *item = requiredViewController.tabBarItem;

    [item showBadge];
    [item setBadgeFrame:CGRectMake(25,  5, 8, 8)];
}


#pragma mark Notification Action 

- (void) notificationAction:(NSNotification *)notification{
    [self showBadgeAction];
}


#pragma mark TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 3;
    return self.viewModel.filesArray.count; //防止服务端没数据时崩溃
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"MFCommonCellH=%f",MFCommonCellH);
    return MFCommonCellH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * headView = [UIView new];
    
    int index = (int)tableView.tag - 555;
    RSHomeDataModel *model = self.viewModel.filesArray[index];
    
    KYMHLabel *staticLabel = [[KYMHLabel alloc] initWithTitle:model.categoryName BaseSize:CGRectMake(10, 10, 150, 20) LabelColor:nil LabelFont:normalFontSize LabelTitleColor:[UIColor redColor] TextAlignment:NSTextAlignmentLeft];
    [staticLabel FontWeight:10];
    [headView addSubview:staticLabel];
    
    KYMHButton * moreBtn = [KYMHButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setTitle:@"更多..." forState:0];
    moreBtn.titleLabel.font = Font(13);
    [moreBtn setTitleColor:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackNormal] forState:0];
    [moreBtn setTouchAreaInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    
    moreBtn.frame = CGRectMake(SCREEN_WIDTH-20-50, 10, 50, 20);
    [headView addSubview:moreBtn];
    moreBtn.tag = index+200;
    [moreBtn addTarget:self action:@selector(moreClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return headView;
}

#pragma mark ------------------ TableViewCell的创建 -----------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int index = (int)tableView.tag - 555;

    RSHomeDataModel *model = self.viewModel.filesArray[index];
    
    static NSString *CellIdentifier = @"MySendRedCell";
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell ) {
        cell = [[HomeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    
    if (model.filesItems.count >= indexPath.row+1) { //防止服务器返回异常时数组越界
        Filesitems * fModel = model.filesItems[indexPath.row];
        cell.model = fModel;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int index = (int)tableView.tag - 555;
    RSHomeDataModel *model = self.viewModel.filesArray[index];
    
      if (model.filesItems.count >= indexPath.row+1) { //防止服务器返回异常时数组越界
          Filesitems * fModel = model.filesItems[indexPath.row];
          
          if(fModel.isVideo ) {
              RSVideoVC *next= [[RSVideoVC alloc]initWithCallBack:^(BOOL isSuccess) {
                  fModel.contentSocail.readCount += 1;
                  [tableView reloadData];
              }];
              next.title = @"视频";
              next.objectId = fModel.objectId;
              [self.navigationController pushViewController:next animated:YES];
          }else {
              RSDataVC *vc = [[RSDataVC alloc]initWithCallBack:^(BOOL isSuccess) {
                  fModel.contentSocail.readCount += 1;
                  [tableView reloadData];
              }];
              vc.objectId = (int)fModel.objectId;
              [self.navigationController pushViewController:vc animated:YES];
          }
      }
}

//下载新版本app
- (void)downLoadApp {
    
    NSURL * appurl = [NSURL URLWithString:[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",APP_PlistURL]];
    
    dispatch_after(0.2, dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] openURL:appurl];
    });
    
}


- (void) initCarouselView {
    WS(weakSelf)
    
    if (_loopView == nil) {
        NSTimeInterval timeInterval =5.0;
        _loopView = [HYBLoopScrollView loopScrollViewWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, loopViewH) imageUrls:_carouselUrlArray timeInterval:timeInterval didSelect:^(NSInteger atIndex) {
            NSLog(@"点击轮播%ld",(long)atIndex);
            
            if (weakSelf.viewModel.advertisArray.count >= atIndex+1) { //防止数组越界
                RSADModel * model = weakSelf.viewModel.advertisArray[atIndex];
                [_viewModel updateAdClickCount:model.objectId];
                RSAdWebVC * vc = [[RSAdWebVC alloc]init];
                vc.adUrl = model.adLink;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } didScroll:^(NSInteger toIndex) {
            
        }];
        _loopView.placeholder = Img(@"jiazai");
        [_refershBackView addSubview:_loopView];
        
        adImageView = [[KYMHImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.413)];
        [adImageView setImage:Img(@"banner01")];
        [_loopView addSubview:adImageView];
        adImageView.hidden = YES;
        
        if (_carouselUrlArray.count <= 0) {
            adImageView.hidden = NO;
        }
        
    }else {
        _loopView.imageUrls = _carouselUrlArray;
        
        if (_carouselUrlArray.count <= 0) {
            adImageView.hidden = NO;
        }else {
            adImageView.hidden = YES;
        }
    }
    [_refershBackView bringSubviewToFront:_searchView];

}

- (void) initSearchView {
    
    if (_searchView == nil) {
        CGFloat searchViewToLeft = 20;
        CGFloat searchViewH = 40;
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 200, 40)];
        _searchView.backgroundColor = [UIColor whiteColor];
        _searchView.layer.cornerRadius = 5;
        [self.refershBackView addSubview:_searchView];

        _searchView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchViewClick)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [_searchView addGestureRecognizer:tapGesture];
        
        KYMHImageView *searchImage = [KYMHImageView new];
        searchImage.image = Img(@"tabbar_search");
        [_searchView addSubview:searchImage];
        
        KYMHLabel *searchLabel = [KYMHLabel new];
        searchLabel.font = Font(normalFontSize);
        searchLabel.textColor = EF_TextColor_TextColorSecondary;
        searchLabel.text = @"如: 阿司匹林、ASPL ";
        searchLabel.textAlignment = NSTextAlignmentLeft;
        [_searchView addSubview:searchLabel];
        
        _searchView.sd_layout
        .bottomSpaceToView(_flashBackView, 20)
        .leftSpaceToView(_refershBackView, searchViewToLeft)
        .rightSpaceToView (_refershBackView, searchViewToLeft)
        .heightIs(searchViewH);

        searchImage.sd_layout
        .centerYEqualToView(_searchView)
        .leftSpaceToView(_searchView, 30)
        .widthIs(25)
        .heightIs(25);
        
        searchLabel.sd_layout
        .centerYEqualToView(_searchView)
        .leftSpaceToView(searchImage, 15)
        .heightIs(25)
        .widthIs(200);
    }
}

#pragma mark -- CallBack
- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result {
    
    [_refershBackView.mj_header endRefreshing];
    
    if (action == RSRisk_NS_ENUM_findIndexFiles) {
        if (result.status ==  200) {
            _noDataBackView.hidden = YES;
            if (self.viewModel.filesArray.count > 0) {
                [self createUI];
            }
        }else {
            if (_carouselUrlArray.count <= 0 && _msgsArray.count <= 0) {
                _noDataBackView.hidden = NO;
                _loopView.hidden = YES;
                _flashBackView.hidden = YES;
            }else {
                _noDataBackView.hidden = YES;
                _loopView.hidden = NO;
                _flashBackView.hidden = NO;
            }
        }
}
    
    if (action == RSRisk_NS_ENUM_getSystemAdvertisementsByPositions) {
        if (result.status ==  200) {
            if (self.viewModel.advertisArray.count > 0) {
                _carouselUrlArray = [NSMutableArray array];
                for (int i = 0; i < self.viewModel.advertisArray.count; i++) {
                    RSADModel * model = self.viewModel.advertisArray[i];
                    NSDictionary * dic = (NSDictionary*)model.attachment[0];
                    NSString * strurl = dic[@"url"];
                    [_carouselUrlArray addObject:strurl];
                }
            }
        }else {
        }
        [_viewModel getSystemNotice];
    }
    
    if (action == RSRisk_NS_ENUM_updateAdClickCount) {
        if (result.status == 200) {
            NSLog(@"更新广告点击次数成功");
        }else {
            NSLog(@"更新广告点击次数成功");
        }
    }
    
    if (action == RSRisk_NS_ENUM_getSystemNotice) {
        if (result.status == 200) {
            _msgsArray = _viewModel.tMsgArray;
            if (_msgsArray.count > 0) {
            }else {
            }
        }
        [_viewModel findIndexFiles];
    }
    
    if (action == RSRisk_NS_ENUM_getUnReadMsgCount) {
        if (result.status == 200) {
            [[MineVC shareInstance] changeMsgNum:_viewModel.unReadMsgCount];
        }
    }
    
    if (action == RSRisk_NS_ENUM_getNewVersion) {
        WS(weakSelf)
        if (result.status == 200 && _viewModel.versionModel.version) {
            [weakSelf updateVersion];
        }else {
        }
    }
}

- (void)updateVersion {
    WS(weakSelf)
    if (![APP_VERSION isEqualToString:_viewModel.versionModel.version]) {
        UIAlertController * versionController = [UIAlertController alertControllerWithTitle:@"版本更新" message:[NSString stringWithFormat:@"新版本：%@\n%@",_viewModel.versionModel.version,_viewModel.versionModel.updateContent] preferredStyle:UIAlertControllerStyleAlert];
        [versionController addAction:[UIAlertAction actionWithTitle:@"稍后再说" style:UIAlertActionStyleCancel handler:nil]];
        [versionController addAction:[UIAlertAction actionWithTitle:@"现在更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //前往更新r
            [weakSelf downLoadApp];
        }]];
        [self presentViewController:versionController animated:YES completion:nil];
    }
    NSLog(@"new--%@ old---%@",_viewModel.versionModel.version,APP_VERSION);
}

@end
