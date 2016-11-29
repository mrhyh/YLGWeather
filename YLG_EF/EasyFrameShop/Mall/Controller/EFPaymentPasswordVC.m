//
//  EFPaymentPasswordVC.m
//  Dentist
//
//  Created by HqLee on 16/7/14.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "EFPaymentPasswordVC.h"
#import "KYShaker.h"
#import "EFMallViewModel.h"
#import "UIView+JSMAdd.h"

static CGFloat const defaultMargin = 10.0f;

@interface EFPaymentPasswordVC()
/** 控件之间的基本间隙*/
@property (nonatomic, assign) CGFloat margin;
/** 背景视图*/
@property (nonatomic, weak) UIImageView *bgImageView;
/**容器视图*/
@property (nonatomic, weak) UIView *containerView;
/**手机输入框*/
@property (nonatomic, weak) UITextField *phoneTF;
/** 分割线1*/
@property (nonatomic, weak) UIView *separateLine1;
/** 验证码输入框*/
@property (nonatomic, weak) UITextField *codeTF;
/** 获取验证码按钮*/
@property (nonatomic, weak) UIButton *getCodeBtn;
/** 分割线2*/
@property (nonatomic, weak) UIView *separateLine2;
/** 密码输入框*/
@property (nonatomic, weak) UITextField *passwordTF;
/** 分割线3*/
@property (nonatomic, weak) UIView *separateLine3;
/** 确认密码输入框*/
@property (nonatomic, weak) UITextField *confirmPsTF;
/** 确认按钮*/
@property (nonatomic, weak) UIButton *sureBtn;
//定时器time
@property (nonatomic, strong) NSTimer *timer;
//抖动
@property (nonatomic, strong) KYShaker * viewShaker;
//视图模型
@property (nonatomic, strong) EFMallViewModel *viewModel;
//导航栏的黑线
@property (nonatomic, strong) UIImageView *navBarHairlineImageView;

@end

@implementation EFPaymentPasswordVC
#pragma mark ---lazy load
- (CGFloat)margin{
    if (_margin == 0) {
        _margin = defaultMargin;
    }
    return _margin;
}

- (UIImageView *)navBarHairlineImageView{
    if (_navBarHairlineImageView == nil) {
        _navBarHairlineImageView = [self.view findHairlineImageViewUnder:self.navigationController.navigationBar];
    }
    return _navBarHairlineImageView;
}
#pragma mark ---life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavi];
    [self setupView];
}

//同样的在界面出现时候开启隐藏
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navBarHairlineImageView.hidden = YES;
    
}
//在页面消失的时候就让出现
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navBarHairlineImageView.hidden = NO;
//    self.navigationController.navigationBar.translucent = YES;
}

- (void)setupNavi{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar. barTintColor = EF_MainColor;
//    self.navigationController.navigationBar.translucent = NO;
    BOOL isSetPayPassword = [[EFUserDefault objectForKey:EFIsSetPayPassWord] boolValue];
    if (isSetPayPassword == YES) {
        self.title = @"修改支付密码";
    }else{
        self.title = @"设置支付密码";
    }
}

- (void)setupView{
    //输入文字颜色
    UIColor *textFieldTextColor = EF_TextColor_WhiteNormal;
    //输入框的背景色
    NSString *bgTextFiledColorStr = SkinThemeKey_BGTextFiledColorLogin;
    //主色调
    UIColor *mainColor = EF_MainColor;
    //文字输入框占位文字颜色
    UIColor *placeHolderColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_LoginTextFieldPlaceHolderColor andAlpha:0.4];
    //分割线颜色
    UIColor *separateLineColor = placeHolderColor;
    //背景图片
    //    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_main"]];
    UIImageView *bgImageView = [[UIImageView alloc] init];
    [bgImageView setBackgroundColor:mainColor];
    [self.view addSubview:bgImageView];
    self.bgImageView = bgImageView;
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [EFSkinThemeManager getTextFileBackgroundColorWithKey:bgTextFiledColorStr];
    containerView.layer.cornerRadius = 6;
    containerView.layer.masksToBounds = YES;
    [self.view addSubview:containerView];
    self.containerView = containerView;
    
    UITextField *phoneTF = [[UITextField alloc] init];
    phoneTF.keyboardType = UIKeyboardTypePhonePad;
    phoneTF.placeholder = @"手机号";
    phoneTF.textColor = textFieldTextColor;
    [phoneTF setValue:placeHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    phoneTF.backgroundColor = [UIColor clearColor];
    [containerView addSubview:phoneTF];
    self.phoneTF = phoneTF;
    
    UIView *separateLine1 = [[UIView alloc] init];
    separateLine1.backgroundColor = separateLineColor;
    [containerView addSubview:separateLine1];
    self.separateLine1 = separateLine1;
    
    UITextField *codeTF = [[UITextField alloc] init];
    codeTF.keyboardType = UIKeyboardTypeNumberPad;
    codeTF.placeholder = @"验证码";
    codeTF.textColor = textFieldTextColor;
    [codeTF setValue:placeHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    codeTF.backgroundColor = [UIColor clearColor];
    [containerView addSubview:codeTF];
    self.codeTF = codeTF;
    
    UIButton *getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [getCodeBtn setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.1]];
    [getCodeBtn setTitleColor:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_TextColorButtonNormal] forState:UIControlStateNormal];
    [getCodeBtn setTitleColor:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_TextColorButtonDisable] forState:UIControlStateDisabled];
    [getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getCodeBtn setTitle:@"60秒后重发" forState:UIControlStateDisabled];
    [getCodeBtn addTarget:self action:@selector(getCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:getCodeBtn];
    self.getCodeBtn = getCodeBtn;
    
    UIView *separateLine2 = [[UIView alloc] init];
    separateLine2.backgroundColor = separateLineColor;
    [containerView addSubview:separateLine2];
    self.separateLine2 = separateLine2;
    
    UITextField *passwordTF = [[UITextField alloc] init];
    passwordTF.placeholder = @"密码";
    passwordTF.textColor = textFieldTextColor;
    [passwordTF setValue:placeHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    passwordTF.secureTextEntry = YES;
    passwordTF.backgroundColor = [UIColor clearColor];
    [containerView addSubview:passwordTF];
    self.passwordTF = passwordTF;
    
    UIView *separateLine3 = [[UIView alloc] init];
    separateLine3.backgroundColor = separateLineColor;
    [containerView addSubview:separateLine3];
    self.separateLine3 = separateLine3;
    
    UITextField *confirmPsTF = [[UITextField alloc] init];
    confirmPsTF.placeholder = @"确认密码";
    confirmPsTF.textColor = textFieldTextColor;
    [confirmPsTF setValue:placeHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    confirmPsTF.secureTextEntry = YES;
    confirmPsTF.backgroundColor = [UIColor clearColor];
    [containerView addSubview:confirmPsTF];
    self.confirmPsTF = confirmPsTF;
    
    NSArray * ar = @[self.phoneTF,self.passwordTF,self.codeTF,self.confirmPsTF];
    self.viewShaker = [[KYShaker alloc] initWithViewsArray:ar];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.layer.cornerRadius = 6;
    sureBtn.layer.masksToBounds = YES;
    sureBtn.backgroundColor = [UIColor whiteColor];
    [sureBtn setTitleColor:mainColor forState:UIControlStateNormal];
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    self.sureBtn = sureBtn;
    
    self.bgImageView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.containerView.sd_layout.topSpaceToView(self.view,20).widthRatioToView(self.view,0.8).centerXEqualToView(self.view);
    self.phoneTF.sd_layout.topSpaceToView(self.containerView,self.margin).leftSpaceToView(self.containerView,self.margin).rightSpaceToView(self.containerView,self.margin).heightIs(30);
    self.separateLine1.sd_layout.topSpaceToView(self.phoneTF,self.margin).leftEqualToView(self.phoneTF).rightEqualToView(self.phoneTF).heightIs(1);
    self.codeTF.sd_layout.topSpaceToView(self.separateLine1,self.margin).leftEqualToView(self.phoneTF).rightEqualToView(self.phoneTF).heightIs(30);
    self.getCodeBtn.sd_layout.rightEqualToView(self.codeTF).centerYEqualToView(self.codeTF).widthIs(100).heightIs(30);
    self.getCodeBtn.layer.cornerRadius = 5;
    self.getCodeBtn.layer.masksToBounds = YES;
    self.separateLine2.sd_layout.topSpaceToView(self.codeTF,self.margin).leftEqualToView(self.phoneTF).rightEqualToView(self.phoneTF).heightIs(1);
    self.passwordTF.sd_layout.topSpaceToView(self.separateLine2,self.margin).leftEqualToView(self.phoneTF).rightEqualToView(self.phoneTF).heightIs(30);
    self.separateLine3.sd_layout.topSpaceToView(self.passwordTF,self.margin).leftEqualToView(self.phoneTF).rightEqualToView(self.phoneTF).heightIs(1);
    self.confirmPsTF.sd_layout.topSpaceToView(self.separateLine3,self.margin).leftEqualToView(self.phoneTF).rightEqualToView(self.phoneTF).heightIs(30);
    [self.containerView setupAutoHeightWithBottomView:self.confirmPsTF bottomMargin:self.margin];
    
    self.sureBtn.sd_layout.topSpaceToView(self.containerView,20).centerXEqualToView(self.view).heightIs(45).widthRatioToView(self.containerView,1);
}

#pragma mark--- 按钮点击事件
- (void)getCodeBtnClick:(UIButton *)getCodeBtn{
    if ([UIUtil isEmptyStr:self.phoneTF.text]) {
        [UIUtil alert:@"请输入手机号"];
        [self.viewShaker shake];
        return;
    }
    if (![XYAttributedString isMobileNumber:self.phoneTF.text]) {
        [UIUtil alert:@"手机号码格式不正确!"];
        [self.viewShaker shake];
        return;
    }
    [self.viewModel getPayPasswordSecurityCodeWithMobile:self.phoneTF.text];
}

- (void)sureBtnClick{
    if ([UIUtil isEmptyStr:self.phoneTF.text]) {
        [UIUtil alert:@"请输入手机号"];
        [self.viewShaker shake];
        return;
    }
    if (![XYAttributedString isMobileNumber:self.phoneTF.text]) {
        [UIUtil alert:@"手机号码格式不正确!"];
        [self.viewShaker shake];
        return;
    }
    if ([UIUtil isEmptyStr:self.codeTF.text]) {
        [UIUtil alert:@"请输入验证码"];
        [self.viewShaker shake];
        return;
    }
    if (self.codeTF.text.length !=6) {
        [UIUtil alert:@"请输入6位支付密码"];
        [self.viewShaker shake];
        return;
    }
    
    if ([UIUtil isEmptyStr:self.confirmPsTF.text]) {
        [UIUtil alert:@"请再次输入密码"];
        [self.viewShaker shake];
        return;
    }
    
    if (![self.confirmPsTF.text isEqualToString:self.passwordTF.text]) {
        [UIUtil alert:@"请核对两次输入的密码"];
        [self.viewShaker shake];
        return;
    }
    
    BOOL isSetPayPassword = [[EFUserDefault objectForKey:EFIsSetPayPassWord] boolValue];
    
    if (isSetPayPassword == YES) {
        [self.viewModel modifyPaymentPasswordWithMobile:self.phoneTF.text payPassword:self.passwordTF.text validateCode:self.codeTF.text];
        [SVProgressHUD setMinimumDismissTimeInterval:1.0];
        [SVProgressHUD showWithStatus:@"支付密码修改中..."];
    }else{
        [self.viewModel setPaymentPasswordWithMobile:self.phoneTF.text payPassword:self.passwordTF.text validateCode:self.codeTF.text];
        [SVProgressHUD setMinimumDismissTimeInterval:1.0];
        [SVProgressHUD showWithStatus:@"支付密码设置中..."];
    }
}

#pragma mark --- 定时器事件
static NSInteger i = 60;
- (void)calculateGetCodeTime{
    i --;
    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%02zd秒后重发",i] forState:UIControlStateDisabled];
    if (i < 0) {
        [self removeTimer];
        self.getCodeBtn.enabled = YES;
        [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        i = 60;
    }
    
}

- (void)dealloc{
    [SVProgressHUD dismiss];
    i = 60;
    [self removeTimer];
    [self.viewModel cancelAndClearAll];
    self.viewModel = nil;
}

- (void)removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark--- 网络请求回调
- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    [SVProgressHUD dismiss];
    if (action == EFMallViewModelCallBackActionGetValidateCode) {
        if (result.status == NetworkModelStatusTypeSuccess) {
            [UIUtil alert:@"获取验证码成功"];
            self.getCodeBtn.enabled = NO;
            self.codeTF.text = result.message;
            self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(calculateGetCodeTime) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
            [self.timer fire];
        }else if ([result.message isEqualToString:@"验证码获取间隔时间不能少于60秒"]) {
            [UIUtil alert:@"验证码已发送，请稍后再试"];
        }else {
            [UIUtil alert:@"获取验证码失败"];
        }
    }if (action == EFMallViewModelCallBackActionSetPayPassword) {
        if (result.status == NetworkModelStatusTypeSuccess) {
            [UIUtil alert:@"支付密码设置成功"];
            [EFUserDefault setObject:@(YES) forKey:EFIsSetPayPassWord];
//            [DentistUserModel shareInstance].isSetPayPassword = YES;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [UIUtil alert:@"支付密码设置失败"];
        }
    }if (action == EFMallViewModelCallBackActionModifyPayPassword) {
        if (result.status == NetworkModelStatusTypeSuccess) {
            [UIUtil alert:@"支付密码修改成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [UIUtil alert:@"支付密码修改失败"];
        }
    }
}

#pragma mark--- setter && getter
- (EFMallViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[EFMallViewModel alloc] initWithViewController:self];
    }
    return _viewModel;
}
@end
