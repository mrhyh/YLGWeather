//
//  EFSettingViewController.m
//  demo
//
//  Created by HqLee on 16/5/19.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "EFSettingViewController.h"
#import "EFSettingCell.h"
#import "EFAccountSettingVC.h"
#import "EFViewControllerManager.h"
#import "EFLoginWithThirdViewController.h"
#import "EFLoginViewController.h"
#import "EFLoginViewModel.h"
#import "UserModel.h"
#import "SVProgressHUD.h"
#import "UIUtil.h"
#import "EFSkinThemeManager.h"
@interface EFSettingViewController ()
/**列表内容,只读，初始化从plist文件中加载*/
@property (nonatomic, copy) CompleteBlock completeBlock;
@property (nonatomic, strong ,readwrite) NSArray *settingArray;
@property (nonatomic,strong)EFLoginViewModel * viewModel;
//登录界面VC
@property (nonatomic, strong) NSString * loginVCName;
@end

@implementation EFSettingViewController

static NSString *cellId = @"SettingCell";

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    !self.completeBlock ? :self.completeBlock(YES);
}

- (instancetype)init{
    return [self initWithCompleteBlock:nil];
}

- (instancetype)initWithCompleteBlock:(CompleteBlock)completeBlock {
    
    if (self = [super init]) {
        self.completeBlock = completeBlock;
        NSString *plistPath = nil;
        plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame_" ofType:@"plist"];
        //如果没有创建EasyFrame_.plist文件，那么直接加载框架内部自带的
        if (plistPath == nil) {
            plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame" ofType:@"plist"];
        }
        NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        
        self.settingArray = [dictionary objectForKey:@"Setting"];
        
        self.loginVCName = [[NSDictionary alloc] initWithContentsOfFile:plistPath][@"MainLayout"][@"LoginViewControllerName"];
    }
    return self;
}

#pragma mark --- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [[EFLoginViewModel alloc]initWithViewController:self];
    [self setupNavi];
    [self setupTableView];
    
}

- (void)setupNavi{
    self.title = @"设置";
}

- (void)setupTableView{
    self.tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableview];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.scrollEnabled =YES;
    self.tableview.sectionFooterHeight = 0;
    self.tableview.sectionHeaderHeight = 10;
    self.tableview.backgroundColor = EF_BGColor_Primary;
    self.tableview.separatorStyle = UITableViewCellAccessoryNone;
    self.tableview.contentInset = UIEdgeInsetsMake(-25, 0, 44, 0);
    [self.tableview registerClass:[EFSettingCell class] forCellReuseIdentifier:cellId];
}

- (void)skinChange{
    
    [super skinChange];
    self.tableview.backgroundColor = EF_BGColor_Primary;
    //设置title颜色
    UIColor * color = EF_TextColor_TextColorNavigation;
    UIColor * mainColor = EF_MainColor;
    //修改导航栏的标题颜色，和背景颜色
    [self.navigationController.navigationBar setBarTintColor:mainColor];
    //设置所有按钮的颜色（包括返回按钮的颜色）
    [self.navigationController.navigationBar setTintColor:color];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:color}];
}

#pragma mark ---<UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.settingArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.settingArray[section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    EFSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    NSArray *array = self.settingArray[indexPath.section];
    NSDictionary *settingDict = array[indexPath.row];
    cell.settingDict = settingDict;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *array = self.settingArray[indexPath.section];
    NSDictionary *settingDict = array[indexPath.row];
    NSString *title = settingDict[@"title"];
    if ([title isEqualToString:@"账号设置"]) {
        EFAccountSettingVC *vc = [[EFAccountSettingVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([title isEqualToString:@"退出登录"]) {
        UIAlertView * alert1 = [[UIAlertView alloc]initWithTitle:@"" message:@"你确定要退出吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert1 show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            [SVProgressHUD showWithStatus:@"正在登出"];
            [self.viewModel UserLogout];
        }
            break;
        case 1:{
            
        }
            break;
            
        default:
            break;
    }
}


#pragma mark --- viewModel 回调
- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    [SVProgressHUD dismiss];
    if (action & LoginCallBackActionUserLogout) {
        if (result.status == NetworkModelStatusTypeSuccess) {
            [UIUtil alert:@"登出成功"];
            [UserModel Logout];
            
            const char *className = [self.loginVCName cStringUsingEncoding:NSUTF8StringEncoding];
            Class aClass = objc_getClass(className);
            [UIApplication sharedApplication].keyWindow.rootViewController = [[aClass alloc]init];
//            [UIApplication sharedApplication].keyWindow.rootViewController = [[EFViewControllerManager shareInstance] rootViewController];
            
        }else{
            [UIUtil alert:@"登出失败"];
        }
    }
}

- (void)dealloc {
    if (self.viewModel) {
        [self.viewModel cancelAndClearAll];
        self.viewModel = nil;
    }
}


@end
