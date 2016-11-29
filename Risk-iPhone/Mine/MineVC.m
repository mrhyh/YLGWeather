//
//  MineVC.m
//  Risk-iPhone
//
//  Created by Cherie Jeong && ylgwhyh on 16/8/24.
//  Copyright © 2016年 Cherie Jeong. All rights reserved.
//

#import "MineVC.h"
#import "RSRiskViewModel.h"
#import "EFLoginViewModel.h"
#import "LoginVC.h"
#import "RSMineCollectionViewCell.h"
#import "RSMessageVC.h"
#import "RSOpinionVC.h"
#import "RSMyInfoVC.h"
#import "RSMWebViewVC.h"
#import "ChangePassWordVC.h"
#import "SaleRecordVC.h"
#import "RSRecordVC.h"
#import "MyCollecVC.h"
#import "EMClient.h"

#define MineCollectionViewCellId @"MineCollectionViewCellId"

@interface MineVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UIView * headerView;
@property (nonatomic,strong) UILabel * titleLB;
@property (nonatomic,strong) KYMHButton * notiMsgBtn;

@property (nonatomic,strong) KYMHButton * loginBtn;

@property (nonatomic,strong) UIImageView * headImageView;
@property (nonatomic,strong) UILabel * nameLB;
@property (nonatomic,strong) UILabel * userNameLabel;

@property (nonatomic,strong) KYMHButton * logOutBtn;

@property (nonatomic,strong) UICollectionView * collectionView;

@property (nonatomic,strong) UILabel * noteLb;
@property (nonatomic,strong) UILabel * mobileLB;

@property (nonatomic,strong) EFLoginViewModel * viewModel;
@property (nonatomic,strong) RSRiskViewModel * msgViewModel;

@property (nonatomic, strong) UITapGestureRecognizer * hiddenGesture;//收回侧边栏 点击事件

@property (nonatomic, assign) int unReadCount; //未读消息数量
@end

@implementation MineVC

+ (MineVC*)shareInstance{
    static MineVC *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[MineVC alloc] init];
    });
    return sharedManager;
}

-(void)viewWillAppear:(BOOL)animated
{
    if (_msgViewModel == nil) {
        _msgViewModel = [[RSRiskViewModel alloc]initWithViewController:self];
    }
    [_msgViewModel getUnReadMsgCount];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel = [[EFLoginViewModel alloc]initWithViewController:self];
    _msgViewModel = [[RSRiskViewModel alloc]initWithViewController:self];
    [self initUI];
    [self initNotification];
}


#pragma mark InitNotification


- (void)initNotification {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationAction:) name:MF_Notification_DrugInformationUpdate object:nil];
}

#pragma mark Notification Action 

- (void) notificationAction:(NSNotification *)notification{
    if (YES == [UserModel ShareUserModel].isDurgUpdate) {
        [self initCollectionView];
        [self.collectionView reloadData];
    }
}


#pragma mark initUI

- (void) initUI {
    self.title = @"个人中心";
    [self initNaviView];
    [self initHeaderView];
    [self initCollectionView];
    [self initButtonView];
}

- (void)initCollectionView {

    CGFloat collectionItem = 100;  //6p+的尺寸
    CGFloat UICollectionViewH = 440;
    CGFloat collectionItemW = SCREEN_WIDTH/4;
    
    if (SCREEN_HEIGHT <=568) {
        collectionItem = 65;
        UICollectionViewH = 320;
        collectionItemW = SCREEN_WIDTH/4;
    }else if (SCREEN_HEIGHT > 568 && SCREEN_HEIGHT <= 667) {
        collectionItem = 90;
        UICollectionViewH = 410;
    }
    
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.itemSize = CGSizeMake(collectionItemW, collectionItem);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 174, SCREEN_WIDTH, UICollectionViewH) collectionViewLayout:flowLayout];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
    
    //注册cell
    [_collectionView registerClass:[RSMineCollectionViewCell class] forCellWithReuseIdentifier:MineCollectionViewCellId];
}

- (void)initNaviView {
    WS(weakSelf)
    _notiMsgBtn = [[KYMHButton alloc]initWithbarButtonItem:self Title:@"" BaseSize:CGRectMake(0, 0, 40, 40) ButtonColor:[UIColor clearColor] ButtonFont:17 ButtonTitleColor:[UIColor clearColor] Block:^{
        [weakSelf pushMsgVC];
    }];
    [_notiMsgBtn setImage:Img(@"ic_notifbar_icon") forState:0];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:_notiMsgBtn];
    self.navigationItem.rightBarButtonItem = item;
    
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

- (void)initHeaderView {
    _loginBtn = [KYMHButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(0, 64, SCREEN_WIDTH, 100);
    [_loginBtn setTitle:@"点击登录" forState:0];
    _loginBtn.titleLabel.font = Font(20);
    _loginBtn.titleLabel.textColor = [UIColor whiteColor];
    _loginBtn.backgroundColor = EF_MainColor;
    _loginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_loginBtn addTarget:self action:@selector(Login) forControlEvents:UIControlEventTouchUpInside];
    _loginBtn.hidden = YES;
    [self.view addSubview:_loginBtn];
    
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 100)];
    _headerView.backgroundColor = EF_MainColor;
    [self.view addSubview:_headerView];
    _headerView.hidden = YES;
    
    UIButton * editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.backgroundColor = [UIColor clearColor];
    editBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    [editBtn addTarget:self action:@selector(pushInfoVC) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:editBtn];
    
    _headImageView =  [[UIImageView alloc]init];
    _headImageView.backgroundColor = [UIColor clearColor];
    
    _nameLB = [[UILabel alloc]init];
    _nameLB.textColor = [UIColor whiteColor];
    _nameLB.font = Font(17);
    _nameLB.textAlignment = NSTextAlignmentLeft;
    
    _userNameLabel = [[UILabel alloc] init];
    _userNameLabel.textColor = [UIColor whiteColor];
    _userNameLabel.font = Font(14);
    _userNameLabel.textAlignment = NSTextAlignmentLeft;
    
    _logOutBtn = [KYMHButton buttonWithType:UIButtonTypeCustom];
    [_logOutBtn setTitle:@"注销" forState:0];
    _logOutBtn.titleLabel.font = Font(17);
    _logOutBtn.titleLabel.textColor = [UIColor whiteColor];
    _logOutBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_logOutBtn addTarget:self action:@selector(LogoutAciton) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView * rightView = [[UIImageView alloc]init];
    rightView.backgroundColor = [UIColor clearColor];
    [rightView setImage:Img(@"ic_arrow_right_1")];
    
    NSArray * views = @[_headImageView,_nameLB,_logOutBtn,rightView,_userNameLabel];
    [_headerView sd_addSubviews:views];
    
    _headImageView.sd_layout
    .leftSpaceToView(_headerView,10)
    .centerYEqualToView(_headerView)
    .widthIs(70)
    .heightIs(70);
    _headImageView.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];
    
    _nameLB.sd_layout
    .leftSpaceToView(_headImageView,10)
    .topEqualToView(_headImageView)
    .heightIs(20)
    .widthIs(SCREEN_WIDTH/3*2);
    
    _userNameLabel.sd_layout
    .leftSpaceToView(_headImageView,10)
    .centerYEqualToView(_headImageView)
    .heightIs(20)
    .widthIs(SCREEN_WIDTH/3*2);
    
    _logOutBtn.sd_layout
    .bottomEqualToView(_headImageView)
    .leftEqualToView(_nameLB)
    .heightIs(20)
    .widthIs(50);
    
    rightView.sd_layout
    .rightSpaceToView(_headerView,10)
    .centerYEqualToView(_headerView)
    .widthIs(10)
    .heightIs(16);
    
    if (![UserModel ShareUserModel].isLogin) {
        _loginBtn.hidden = NO;
        _headImageView.hidden = YES;
    }else {
        _headerView.hidden = NO;
        _loginBtn.hidden = YES;
        _headImageView.hidden = NO;
        _nameLB.text = [UserModel ShareUserModel].nickname;
        _userNameLabel.text = [RS_UserModel ShareUserModel].username;
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:[UserModel ShareUserModel].head.url] placeholderImage:Img(@"ic_defaultavatar")];
    }
}

//消息中心
- (void)pushMsgVC {
    [self clearBadgeAction];
    RSMessageVC * vc = [[RSMessageVC alloc]initWithCallBack:^(BOOL isSuccess) {
        NSURL * url = [NSURL URLWithString:[UserModel ShareUserModel].head.url];
        [_headImageView sd_setImageWithURL:url placeholderImage:Img(@"ic_defaultavatar")];
        _nameLB.text = [UserModel ShareUserModel].nickname;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

//基本资料
- (void)pushInfoVC {
    RSMyInfoVC * vc = [[RSMyInfoVC alloc]initWithCallBack:^(BOOL isSuccess) {
        
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:[UserModel ShareUserModel].head.url] placeholderImage:Img(@"ic_defaultavatar")];
        _nameLB.text = [UserModel ShareUserModel].nickname;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

//注销
- (void)LogoutAciton {
    [self.viewModel UserLogout];
    [MFUserDefaults setBool:YES forKey:MFIsLogoutUserdefaultKey];
    [MFUserDefaults synchronize];
}

//登录
- (void)Login {
    LoginVC * vc = [[LoginVC alloc]initWithCompleteBlock:^(BOOL isSussces) {
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 13;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RSMineCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:MineCollectionViewCellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.index = (int)indexPath.row;
    
    if (11 == indexPath.row) {
        if (YES == [UserModel ShareUserModel].isDurgUpdate) {
            [cell showBadge];
            [cell setBadgeFrame:CGRectMake(50*SCREEN_W_RATE, 5, 8, 8)];
        }else {
            [cell clearBadge];
        }
    }
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //    //临时改变个颜色，看好，只是临时改变的。如果要永久改变，可以先改数据源，然后在cellForItemAtIndexPath中控制。（和UITableView差不多吧！O(∩_∩)O~）
    //    cell.backgroundColor = [UIColor greenColor];
    NSLog(@"item======%ld",(long)indexPath.item);
    NSLog(@"row=======%ld",(long)indexPath.row);
    NSLog(@"section===%ld",(long)indexPath.section);
    
    switch (indexPath.row) {
        case 0: {
            //修改密码
            ChangePassWordVC * vc = [[ChangePassWordVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1: {
            //使用有效期
            NSString * startTime = [UIUtil getDateFromMiao:[NSString stringWithFormat:@"%lld",[RS_UserModel ShareUserModel].beginDate]];
            NSString * endTime = [UIUtil getDateFromMiao:[NSString stringWithFormat:@"%lld",[RS_UserModel ShareUserModel].endDate]];
            endTime = [NSString stringWithFormat:@"开始日期：%@\n有效期至：%@",startTime,endTime];
            UIAlertController * controller = [UIAlertController alertControllerWithTitle:@"使用有效期" message:endTime preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"关闭");
            }];
            
            [controller addAction:cancelAction];
            
            [self presentViewController:controller animated:YES completion:nil];
        }
            break;
        case 2: {
            
            //全局跳转
            MyCollecVC * vc = [[MyCollecVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3: {
            //销售记录
            SaleRecordVC * vc = [[SaleRecordVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4: {
            //专家点评
            RSMWebViewVC *vc = [[RSMWebViewVC alloc] initWithTitle:@"专家点评"];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 5: {
            //广告
            RSMWebViewVC *vc = [[RSMWebViewVC alloc] initWithTitle:@"广告服务"];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 6: {
            //大事记
            RSMWebViewVC *vc = [[RSMWebViewVC alloc] initWithTitle:@"大事记"];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 7: {
            //专家团队"
            RSMWebViewVC *vc = [[RSMWebViewVC alloc] initWithTitle:@"专家团队"];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 8: {
            //提交记录
            RSRecordVC * vc = [[RSRecordVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 9: {
            //关于我们
            RSMWebViewVC *vc = [[RSMWebViewVC alloc] initWithTitle:@"关于我们"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 10: {
            //意见反馈
            RSOpinionVC * vc = [[RSOpinionVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 11: {
            //更新记录
            [self clearBadgeOfCell:indexPath collectionView:collectionView];
            RSMWebViewVC *vc = [[RSMWebViewVC alloc] initWithTitle:@"更新记录"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 12:{
            //检查版本更新
            [_msgViewModel getNewVersion];
        }
            
        default:
            break;
    }
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


//底部
- (void)initButtonView {
    
    _noteLb = [[UILabel alloc]init];
    _noteLb.textColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary];
    _noteLb.font = Font(11);
    _noteLb.text = @"技术支持：\n全国妇幼卫生监测办公室\n中国出生缺陷监测中心";
    _noteLb.textAlignment = NSTextAlignmentCenter;
    
    _mobileLB = [[UILabel alloc]init];
    _mobileLB.textColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackNormal];
    _mobileLB.font = Font(13);
    _mobileLB.text = @"客服热线：13817422844";
    _mobileLB.textAlignment = NSTextAlignmentCenter;
    
    NSArray * views = @[_noteLb,_mobileLB];
    [self.view sd_addSubviews:views];
    
    _mobileLB.sd_layout
    .bottomSpaceToView(self.view,5)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(25);
    
    _noteLb.sd_layout
    .bottomSpaceToView(_mobileLB,0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .autoHeightRatio(0);
}


#pragma mark logoutHuanXin

- (void ) logoutHuanXin {
    //1.1解除绑定

    [[EMClient sharedClient] logout:NO completion:^(EMError *aError) {
        if ([UIUtil isEmptyStr:aError.errorDescription] ) {
            NSLog(@"解除绑定成功");
        }else {
            NSLog(@"解除绑定失败%@",aError.errorDescription);
        }

    }];
}

//下载新版本app
- (void)downLoadApp {
    
    NSURL * appurl = [NSURL URLWithString:[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",APP_PlistURL]];
    dispatch_after(0.2, dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] openURL:appurl];
    });
    
}

#pragma mark --- viewModel 回调
- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    [SVProgressHUD dismiss];
    if (action == LoginCallBackActionUserLogout) {
        if (result.status == NetworkModelStatusTypeSuccess) {
            [UIUtil alert:@"登出成功"];
            [UserModel Logout];
            _headerView.hidden = YES;
            _loginBtn.hidden = NO;
            [self logoutHuanXin];
            
            [MFUserDefaults setBool:YES forKey:MFIsLogoutUserdefaultKey];
            [MFUserDefaults synchronize];
            
            LoginVC *vc = [[LoginVC alloc]initWithCompleteBlock:^(BOOL isSussces) {
                _headerView.hidden = NO;
                _loginBtn.hidden = YES;

                NSURL * url = [NSURL URLWithString:[UserModel ShareUserModel].head.url];
                [_headImageView sd_setImageWithURL:url placeholderImage:Img(@"ic_defaultavatar")];
                _nameLB.text = [UserModel ShareUserModel].nickname;
            }];
            vc.isReferrsh = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            [UIUtil alert:@"登出失败"];
        }
    }
    
    if (action == RSRisk_NS_ENUM_getUnReadMsgCount) {
        if (result.status == NetworkModelStatusTypeSuccess) {
            NSLog(@"获取未读消息数量成功：%@",result.content);
            _unReadCount = [result.content intValue];
            [self changeMsgNum:_unReadCount];
            
        }else if (result.status == NetworkModelStatusTypeUserNoLogin) {
            NSLog(@"未登录或登录已失效");
            [UserModel Logout];
            [self.viewModel UserLogout];
        }
    }
    
    if (action == RSRisk_NS_ENUM_getNewVersion) {
        if (result.status == 200) {
            
            WS(weakSelf)
            if (![APP_VERSION isEqualToString:_msgViewModel.versionModel.version] &&  (nil != _msgViewModel.versionModel.version) ) {
                NSLog(@"APP_VERSION=%@",APP_VERSION);
                UIAlertController * versionController = [UIAlertController alertControllerWithTitle:@"版本更新" message:[NSString stringWithFormat:@"新版本：%@\n%@",_msgViewModel.versionModel.version,_msgViewModel.versionModel.updateContent] preferredStyle:UIAlertControllerStyleAlert];
                [versionController addAction:[UIAlertAction actionWithTitle:@"稍后再说" style:UIAlertActionStyleCancel handler:nil]];
                [versionController addAction:[UIAlertAction actionWithTitle:@"现在更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //前往更新
                    
                    [weakSelf downLoadApp];
                }]];
                [self presentViewController:versionController animated:YES completion:nil];
            }else {
                
                UIAlertController * versionController = [UIAlertController alertControllerWithTitle:@"版本信息" message:[NSString stringWithFormat:@"版本号：%@\n已经是最新版本",_msgViewModel.versionModel.version] preferredStyle:UIAlertControllerStyleAlert];
                [versionController addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil]];
                
                [self presentViewController:versionController animated:YES completion:nil];
            }
            NSLog(@"new--%@ old---%@",_msgViewModel.versionModel.version,APP_VERSION);
            
        }else {
            [UIUtil alert:@"获取版本信息失败"];
        }
    }
}

#pragma mark 小红点

//清楚cell的小红点
- (void)clearBadgeOfCell:(NSIndexPath *)indexPath collectionView:(UICollectionView *)collectionView{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath: indexPath];
    [cell clearBadge]; //去掉cell的小红点
    [UserModel ShareUserModel].isDurgUpdate = NO;
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}


- (void)changeMsgNum:(int)number {
    if (number <= 0 && NO == [UserModel ShareUserModel].isDurgUpdate) {
        [self clearBadgeAction];
    }else {
        [self showBadgeAction];
    }
}

//显示Tabbar和消息通知Button的小红点
- (void)showBadgeAction{
    if (_unReadCount > 0) {
        [_notiMsgBtn showBadge];
        [_notiMsgBtn setBadgeFrame:CGRectMake(25,  5, 8, 8)];
    }
    if (YES == [UserModel ShareUserModel].isDurgUpdate) {
        //Do nothing
    }
    if (_unReadCount > 0 && YES == [UserModel ShareUserModel].isDurgUpdate) {
        UITabBarItem *item = self.navigationController.tabBarItem;
        [item setBadgeFrame:CGRectMake(25,  5, 8, 8)];
        [item showBadge];
    }
}

//清除Tabbar和消息通知Button的小红点
- (void)clearBadgeAction{
    if (_unReadCount <= 0) {
        [_notiMsgBtn clearBadge];
    }
    
    if (NO == [UserModel ShareUserModel].isDurgUpdate) {
        //Do nothing
    }
    
    if (_unReadCount <= 0 && NO == [UserModel ShareUserModel].isDurgUpdate) {
        UITabBarItem *item = self.navigationController.tabBarItem;
        [item clearBadge];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
