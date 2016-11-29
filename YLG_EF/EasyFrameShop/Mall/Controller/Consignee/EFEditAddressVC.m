//
//  EFEditAddressVC.m
//  EF_MallDemo
//
//  Created by HqLee on 16/6/17.
//  Copyright © 2016年 MH. All rights reserved.
//  编辑收货地址

#import "EFEditAddressVC.h"
#import "EFMallViewModel.h"
#import "STPickerArea.h"
#import "EFMallModel.h"

@interface EFEditAddressVC ()<STPickerAreaDelegate>
@property (nonatomic, strong) EFMallViewModel *viewModel;
//收货人
@property (nonatomic, weak) UITextField *consigneeTF;
//电话
@property (nonatomic, weak) UITextField *mobileTF;
//邮编
@property (nonatomic, weak) UITextField *zipCodeTF;
//所在地区
@property (nonatomic, weak) UILabel *detailRegionLabel;
//收货地址
@property (nonatomic, weak) UITextField *addressTF;
//是否设置为默认地址
@property (nonatomic, assign) BOOL isDefault;
//地址模型
@property (nonatomic, strong) EFMallConsigneeModel *consigneeModel;
//地区pilst文件的路径
@property (nonatomic, copy) NSString *regionFileName;
//地区的数组
@property (nonatomic, copy) NSArray *arrayRoot;

//身份对应的字典
@property (nonatomic, strong) NSDictionary *provinceDict;
//城市对应的字典
@property (nonatomic, strong) NSDictionary *cityDict;
//地区对应的字典
@property (nonatomic, strong) NSDictionary *districtDict;
//标记将要修改的收货地址是否为默认收货地址，便于后面更改时，清空本地缓存
@property (nonatomic, assign) BOOL isDefaultAlready;
@end

@implementation EFEditAddressVC
#pragma mark --- lazy load
- (EFMallViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[EFMallViewModel alloc] initWithViewController:self];
    }
    return _viewModel;
}

#pragma mark --- life cycle
- (instancetype)initWithConsigneeModel:(EFMallConsigneeModel *)consigneeModel{
    if (self = [super init]) {
        _consigneeModel = consigneeModel;
        _isDefaultAlready = consigneeModel.isDefault;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    [self setupView];;
}

- (void)setupView{
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:containerView];
    containerView.sd_layout.topSpaceToView(self.view,15).leftEqualToView(self.view).rightEqualToView(self.view);
    
    //收货人
    UILabel *consigneeLabel = [[UILabel alloc] init];
    consigneeLabel.text = @"收货人";
    [containerView addSubview:consigneeLabel];
    consigneeLabel.sd_layout.topSpaceToView(containerView,10).leftSpaceToView(containerView,10).heightIs(30).widthIs(100);
    
    
    UITextField *consigneeTF = [[UITextField alloc] init];
    consigneeTF.placeholder = @"请输入收货人姓名";
    consigneeTF.text = self.consigneeModel.consignee;
    [containerView addSubview:consigneeTF];
    self.consigneeTF = consigneeTF;
    consigneeTF.sd_layout.leftSpaceToView(consigneeLabel,10).rightSpaceToView(containerView,10).heightIs(30).centerYEqualToView(consigneeLabel);
    
    UIView *separateLine1 = [[UIView alloc] init];
    separateLine1.backgroundColor = EF_BGColor_Primary;
    [containerView addSubview:separateLine1];
    separateLine1.sd_layout.leftSpaceToView(containerView,10).rightSpaceToView(containerView,10).topSpaceToView(consigneeTF,10).heightIs(1);
    
    //联系电话
    UILabel *mobileLabel = [[UILabel alloc] init];
    mobileLabel.text = @"联系电话";
    [containerView addSubview:mobileLabel];
    mobileLabel.sd_layout.topSpaceToView(separateLine1,10).leftSpaceToView(containerView,10).heightIs(30).widthIs(100);
    
    
    UITextField *mobileTF = [[UITextField alloc] init];
    mobileTF.placeholder = @"请输入收货人联系电话";
    mobileTF.text = self.consigneeModel.phone;
    mobileTF.keyboardType = UIKeyboardTypeNumberPad;
    [containerView addSubview:mobileTF];
    self.mobileTF = mobileTF;
    mobileTF.sd_layout.leftSpaceToView(mobileLabel,10).rightSpaceToView(containerView,10).heightIs(30).centerYEqualToView(mobileLabel);
    
    UIView *separateLine2 = [[UIView alloc] init];
    separateLine2.backgroundColor = EF_BGColor_Primary;
    [containerView addSubview:separateLine2];
    separateLine2.sd_layout.leftSpaceToView(containerView,10).rightSpaceToView(containerView,10).topSpaceToView(mobileTF,10).heightIs(1);
    
    //邮编
    UILabel *zipCodeLabel = [[UILabel alloc] init];
    zipCodeLabel.text = @"邮编";
    [containerView addSubview:zipCodeLabel];
    zipCodeLabel.sd_layout.topSpaceToView(separateLine2,10).leftSpaceToView(containerView,10).heightIs(30).widthIs(100);
    
    UITextField *zipCodeTF = [[UITextField alloc] init];
    zipCodeTF.placeholder = @"请填写所在地址邮编";
    zipCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    zipCodeTF.text = self.consigneeModel.zipCode;
    [containerView addSubview:zipCodeTF];
    self.zipCodeTF = zipCodeTF;
    zipCodeTF.sd_layout.leftSpaceToView(zipCodeLabel,10).rightSpaceToView(containerView,10).heightIs(30).centerYEqualToView(zipCodeLabel);
    
    UIView *separateLine3 = [[UIView alloc] init];
    separateLine3.backgroundColor = EF_BGColor_Primary;
    [containerView addSubview:separateLine3];
    separateLine3.sd_layout.leftSpaceToView(containerView,10).rightSpaceToView(containerView,10).topSpaceToView(zipCodeTF,10).heightIs(1);
    
    //所在地区
    UILabel *regionLabel = [[UILabel alloc] init];
    regionLabel.text = @"所在地区";
    [containerView addSubview:regionLabel];
    regionLabel.sd_layout.topSpaceToView(separateLine3,10).leftSpaceToView(containerView,10).heightIs(30).widthIs(100);
    
    UIImageView *indicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/Disclosure Indicator"]]];
    [containerView addSubview:indicatorImageView];
    indicatorImageView.sd_layout.centerYEqualToView(regionLabel).rightSpaceToView(containerView,10).widthIs(10).heightIs(15);
    
    UILabel *detailRegionLabel = [[UILabel alloc] init];
    detailRegionLabel.text = [self regionWithProvinceId:self.consigneeModel.provinceId cityId:self.consigneeModel.cityId districtId:self.consigneeModel.districtId];
    detailRegionLabel.textAlignment = NSTextAlignmentLeft;
    detailRegionLabel.userInteractionEnabled = YES;
    [containerView addSubview:detailRegionLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapForChooseRegin)];
    [detailRegionLabel addGestureRecognizer:tap];
    detailRegionLabel.sd_layout.topSpaceToView(separateLine3,10).leftSpaceToView(regionLabel,10).heightIs(30).rightSpaceToView(indicatorImageView,10);
    self.detailRegionLabel = detailRegionLabel;
    
    UIView *separateLine4 = [[UIView alloc] init];
    separateLine4.backgroundColor = EF_BGColor_Primary;
    [containerView addSubview:separateLine4];
    separateLine4.sd_layout.leftSpaceToView(containerView,10).rightSpaceToView(containerView,10).topSpaceToView(detailRegionLabel,10).heightIs(1);
    
    //收货地址
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.text = @"收货地址";
    [containerView addSubview:addressLabel];
    addressLabel.sd_layout.topSpaceToView(separateLine4,10).leftSpaceToView(containerView,10).heightIs(30).widthIs(100);
    
    
    UITextField *addressTF = [[UITextField alloc] init];
    addressTF.placeholder = @"请填写详细收货地址";
    addressTF.text = self.consigneeModel.address;
    [containerView addSubview:addressTF];
    self.addressTF = addressTF;
    addressTF.sd_layout.leftSpaceToView(addressLabel,10).rightSpaceToView(containerView,10).heightIs(30).centerYEqualToView(addressLabel);
    
    [containerView setupAutoHeightWithBottomView:addressTF bottomMargin:10];
    
    UIView *defaultView = [[UIView alloc] init];
    defaultView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:defaultView];
    defaultView.sd_layout.topSpaceToView(containerView,20).leftEqualToView(self.view).rightEqualToView(self.view).heightIs(50);
    
    UILabel *defaultLable = [[UILabel alloc ]init];
    [defaultLable setText:@"设为默认地址"];
    defaultLable.backgroundColor = [UIColor clearColor];
    defaultLable.textAlignment = NSTextAlignmentCenter;
    defaultLable.backgroundColor = [UIColor whiteColor];
    [defaultView addSubview:defaultLable];
    [defaultLable setSingleLineAutoResizeWithMaxWidth:150];
    defaultLable.sd_layout.centerYEqualToView(defaultView).leftSpaceToView(defaultView,10).autoHeightRatio(0);
    
    UISwitch *switchIsDefault = [[UISwitch alloc] init];
    switchIsDefault.on = self.consigneeModel.isDefault;
    [defaultView addSubview:switchIsDefault];
    switchIsDefault.sd_layout.centerYEqualToView(defaultView).rightSpaceToView(defaultView,10);
    [switchIsDefault addTarget:self action:@selector(switchIsDefault:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavi];
}

- (void)setupNavi{
    self.title = @"添加收货地址";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.bounds = CGRectMake(0, 0, 40, 20);
    saveBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
#pragma mark ---event response
- (void)saveBtnClick{
    if (self.consigneeTF.text.length == 0) {
        [UIUtil alert:@"收人姓名不能为空!"];
        return;
    }
    if (self.mobileTF.text.length == 0) {
        [UIUtil alert:@"联系电话不能为空!"];
        return;
    }
    if (self.zipCodeTF.text.length == 0) {
        [UIUtil alert:@"邮编不能为空!"];
        return;
    }
    if ([self.detailRegionLabel.text isEqualToString:@"请选择您的所在地区"]) {
        [UIUtil alert:@"请选择收货地址!"];
        return;
    }
    if (self.addressTF.text.length == 0) {
        [UIUtil alert:@"收货地址不能为空!"];
        return;
    }
    self.consigneeModel.consignee = self.consigneeTF.text;
    self.consigneeModel.phone = self.mobileTF.text;
    self.consigneeModel.zipCode = self.zipCodeTF.text;
    self.consigneeModel.address = self.addressTF.text;
    
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"正在保存收货地址"];
    [self.viewModel addConsigneeAddress:self.consigneeModel];
}

- (void)dealloc{
    [self.viewModel cancelAndClearAll];
    [SVProgressHUD dismiss];
}

- (void)switchIsDefault:(UISwitch *)sender{
    self.consigneeModel.isDefault = sender.isOn;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)tapForChooseRegin{
    [self.view endEditing:YES];
    STPickerArea *pickerArea = [[STPickerArea alloc]initWithProvinceDict:self.provinceDict cityDict:self.cityDict districtDict:self.districtDict];
    [pickerArea setDelegate:self];
    [pickerArea setContentMode:STPickerContentModeBottom];
    [pickerArea show];
}

#pragma mark ---<STPickerAreaDelegate>
- (void)pickerArea:(STPickerArea *)pickerArea provinceDict:(NSDictionary *)provinceDict cityDict:(NSDictionary *)cityDict districtDict:(NSDictionary *)districtDict{
    self.provinceDict = provinceDict;
    self.cityDict = cityDict;
    self.districtDict = districtDict;
    self.consigneeModel.regionId = districtDict[@"objectId"];
    NSString *text = [NSString stringWithFormat:@"%@ %@ %@", provinceDict[@"name"], cityDict[@"name"], districtDict[@"name"]];
    self.detailRegionLabel.text = text;
}

#pragma mark --- 网络请求回调
- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    [SVProgressHUD dismiss];
    if (action == EFMallViewModelCallBackActionAddAddress) {
        if (result.status == NetworkModelStatusTypeSuccess) {
            [UIUtil alert:@"保存成功"];
            if (self.isDefaultAlready) {//如果修改的收货地址已经是默认收货地址
                if (self.consigneeModel.isDefault == NO) {
                    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:EFDefaultConsigneeAddressKey];
                    if ([[NSUserDefaults standardUserDefaults] synchronize]) {
                        NSLog(@"清空默认收货地址成功");
                    }else{
                        NSLog(@"清空默认收货地址失败!");
                    }
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [UIUtil alert:@"保存失败"];
        }
    }
}

#pragma mark - --- getters 属性 ---
- (NSString *)regionFileName{
    if (_regionFileName == nil) {
        _regionFileName = [[NSBundle mainBundle] pathForResource:@"region.plist" ofType:nil];
    }
    return _regionFileName;
}

- (NSArray *)arrayRoot
{
    if (!_arrayRoot) {
        _arrayRoot = [[NSArray alloc]initWithContentsOfFile:self.regionFileName];
    }
    return _arrayRoot;
}


#pragma mark --- utility
- (NSString *)regionWithProvinceId:(NSString *)provinceId cityId:(NSString *)cityId districtId:(NSString *)districtId{
    
    [self.arrayRoot enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[dict[@"objectId"] stringValue] isEqualToString:provinceId]) {
            self.provinceDict = dict;
            *stop = YES;
        }
    }];
    
    [self.provinceDict[@"children"] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[dict[@"objectId"] stringValue] isEqualToString:cityId]) {
            self.cityDict = dict;
            *stop = YES;
        }
    }];
    
    [self.cityDict[@"children"] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[dict[@"objectId"] stringValue] isEqualToString:districtId]) {
            self.districtDict = dict;
            *stop = YES;
        }
    }];
    
    return [NSString stringWithFormat:@"%@ %@ %@",self.provinceDict[@"name"],self.cityDict[@"name"],self.districtDict[@"name"]];
}
@end
