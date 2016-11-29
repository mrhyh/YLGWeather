//
//  EFConsigneeAddressVC.m
//  EF_MallDemo
//
//  Created by HqLee on 16/6/17.
//  Copyright © 2016年 MH. All rights reserved.
//  已添加的收货地址列表

#import "EFConsigneeAddressVC.h"
#import "EFMallViewModel.h"
#import "EFAddAddressVC.h"
#import "EFAddAddressCell.h"
#import "EFEditAddressVC.h"
#import "EFMallModel.h"
#import <objc/runtime.h>

static NSString *const addAddressCellID = @"addAddressCell";
static NSString *const addressListCellID = @"addressListCell";
static NSString *const kEFMallCompleteHandlerBlockKey = @"kEFMallCompleteHandlerBlockKey";

@interface EFConsigneeAddressVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
//列表视图
@property (nonatomic, weak) KYTableView *tableView;
//地址列表
@property (nonatomic, strong) NSArray *addressList;
//视图模型
@property (nonatomic, strong) EFMallViewModel *viewModel;
//完成时的回调
@property (nonatomic, copy) EFMallCompleteHandler completeHandler;
//声明一个属性，记录删除的收货地址
@property (nonatomic, strong) EFMallConsigneeModel *consigneeModel;
//是否选择收货地址
@property (nonatomic,assign) BOOL isChooseAddress;
@end

@implementation EFConsigneeAddressVC
#pragma mark --- lazy load
- (EFMallViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[EFMallViewModel alloc] initWithViewController:self];
    }
    return _viewModel;
}
#pragma mark --- life cycle
- (instancetype)initWithCompleteHandler:(EFMallCompleteHandler)completeHandler{
    if (self = [super init]) {
        _completeHandler = [completeHandler copy];
        _isChooseAddress = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavi];
    [self.viewModel getAllConsigneeAddressList];
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"正在加载收货地址"];
}
- (void)setupNavi{
    self.title = @"收货地址管理";
    self.navigationController.navigationBar.hidden = NO;    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    editBtn.bounds = CGRectMake(0, 0, 40, 20);
    editBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
    [editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setupTableView{
    WS(weakSelf)
    KYTableView *tableView = [[KYTableView alloc] initWithFrame:CGRectZero andUpBlock:^{
        [weakSelf.viewModel getAllConsigneeAddressList];
    } andDownBlock:^{
        [weakSelf.tableView endLoading];
    } andStyle:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    tableView.sectionHeaderHeight = 10;
    tableView.sectionFooterHeight = 0;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}

#pragma mark ---<UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return self.addressList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        EFAddAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:addAddressCellID];
        if (cell == nil) {
            cell = [[EFAddAddressCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:addAddressCellID];
        }
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addressListCellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:addressListCellID];
        }
        EFMallConsigneeModel *consigneeModel = self.addressList[indexPath.row];
        NSLog(@"%@",consigneeModel.zipCode);
        if (consigneeModel.isDefault == YES) {
            NSDictionary *defaultConsignee = @{EFDefaultConsigneeNameKey : consigneeModel.consignee,
                                               EFDefaultConsigneePhoneKey: consigneeModel.phone,
                                               EFDefaultConsigneeRegionIDKey : consigneeModel.districtId,
                                               EFDefaultConsigneeDetailAddressKey : consigneeModel.address,
                                               EFDefaultConsigneeZipCodeKey : consigneeModel.zipCode};
            [[NSUserDefaults standardUserDefaults] setObject:defaultConsignee forKey:EFDefaultConsigneeAddressKey];
            if ([[NSUserDefaults standardUserDefaults] synchronize]) {
                NSLog(@"默认收货地址同步成功");
            }else{
                NSLog(@"默认收货地址同步失败!");
            }
        }
        UIView *separateLine = [[UIView alloc] initWithFrame:CGRectMake(10, 69, SCREEN_WIDTH - 20, 1)];
        separateLine.backgroundColor = EF_BGColor_Primary;
        [cell addSubview:separateLine];
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/Disclosure Indicator"]]];
        arrowImageView.size = CGSizeMake(10, 15);
        cell.accessoryView = arrowImageView;
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",consigneeModel.consignee,consigneeModel.phone];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@",consigneeModel.areaName,consigneeModel.address];
        if (indexPath.row == self.addressList.count - 1) {
            separateLine.hidden = YES;
        }else{
            separateLine.hidden = NO;
        }
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return @"删除";
    }else{
        return nil;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return YES;
    }else{
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            self.consigneeModel = self.addressList[indexPath.row];
            [SVProgressHUD setMinimumDismissTimeInterval:1.0];
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD showWithStatus:@"正在删除收货地址"];
            [self.viewModel delConsigneeAddress:self.consigneeModel.objectId];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EFBaseViewController *vc = nil;
    EFMallConsigneeModel *consigneeModel = self.addressList[indexPath.row];
    if (indexPath.section == 0) {
        vc = [[EFAddAddressVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        if (self.isChooseAddress == YES) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认使用该收货地址？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            void (^alertViewBlock)(NSInteger index) = ^(NSInteger index){
                if (index == 1) {
                    self.completeHandler(consigneeModel);
                    [self.navigationController popViewControllerAnimated:YES];
                }
            };
            objc_setAssociatedObject(alertView, &kEFMallCompleteHandlerBlockKey, alertViewBlock, OBJC_ASSOCIATION_COPY);
            [alertView show];
        }else{
            vc = [[EFEditAddressVC alloc] initWithConsigneeModel:consigneeModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    }else{
        return 70;
    }
}

- (void)dealloc{
    [SVProgressHUD dismiss];
    [self.viewModel cancelAndClearAll];
    NSLog(@"dealloc----%@",[self class]);
}

#pragma mark --- event response
- (void)editBtnClick:(UIButton *)btn{
    self.tableView.editing = !self.tableView.isEditing;
    if (self.tableView.isEditing) {
        [btn setTitle:@"完成" forState:UIControlStateNormal];
    }else{
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
    }
}

#pragma mark --- 网络请求回调
- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    [SVProgressHUD dismiss];
    if (action == EFMallViewModelCallBackActionGetAddressList) {
        [self.tableView endLoading];
        if (result.status == NetworkModelStatusTypeSuccess) {
            self.addressList = [NSArray yy_modelArrayWithClass:[EFMallConsigneeModel class] json:result.content];
            if (self.addressList.count == 0) {
                [UIUtil alert:@"你还没有添加任何收货地址!"];
            }else{
                 [self.tableView reloadData];
            }
        }else{
            [UIUtil alert:@"加载数据失败"];
        }
    }else if (action == EFMallViewModelCallBackActionGetAddressList){
        if (result.status == NetworkModelStatusTypeSuccess) {
           [UIUtil alert:@"删除成功"];
            //如果删除的地址是默认的收货地址，情况默认收货地址
            if (self.consigneeModel.isDefault == YES) {
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:EFDefaultConsigneeAddressKey];
                if ([[NSUserDefaults standardUserDefaults] synchronize]) {
                    NSLog(@"默认收货地址删除成功");
                }else{
                    NSLog(@"默认收货地址删除失败!");
                }
            }
            [self.viewModel getAllConsigneeAddressList];
        }else{
           [UIUtil alert:@"删除失败"];
        }
    }
}

#pragma mark --- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    void (^block)(NSInteger index) = objc_getAssociatedObject(alertView, &kEFMallCompleteHandlerBlockKey);
    block(buttonIndex);
}
@end
