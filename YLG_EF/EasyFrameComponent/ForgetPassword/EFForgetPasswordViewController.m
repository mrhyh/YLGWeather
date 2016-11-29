//
//  EFForgetPasswordViewController.m
//  demo
//
//  Created by HqLee on 16/5/19.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//  忘记密码

#import "EFForgetPasswordViewController.h"
#import "EFForgetPasswordViewModel.h"

#import "SVProgressHUD.h"

static CGFloat const defaultMargin = 10.0f;



@interface EFForgetPasswordViewController ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) EFForgetPasswordViewModel *viewModel;


//EasyFrame.plist文件的路径
//@property (nonatomic, copy) NSString *plistPath;
//登录背景视图名字
@property (nonatomic, strong) UIImage *LoginVCBGImage;

//忘记密码背景视图名字
@property (nonatomic, strong) UIImage *forgetPwdVCBGImage;

@property (nonatomic, strong) KYShaker * viewShaker;

@end

@implementation EFForgetPasswordViewController

#pragma mark --- lazy load
//- (NSString *)plistPath{
//    if (_plistPath == nil) {
//        _plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame_" ofType:@"plist"];
//        if (_plistPath == nil) {
//            _plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame" ofType:@"plist"];
//        }
//    }
//    return _plistPath;
//}

- (UIImage *)LoginVCBGImage{
    if (_LoginVCBGImage == nil) {
        NSString *imageName = [[NSDictionary alloc] initWithContentsOfFile:self.plistPath][@"MainLayout"][@"LoginVCBGImageName"];
        UIImage *image = [UIImage imageNamed:imageName];
        _LoginVCBGImage = image ? image: [UIImage imageNamed:[NSString stringWithFormat:@"resource.bundle/%@",imageName]];
    }
    return _LoginVCBGImage;
}


- (UIImage *)forgetPwdVCBGImage{
    if (_forgetPwdVCBGImage == nil) {
        NSString *imageName = [[NSDictionary alloc] initWithContentsOfFile:self.plistPath][@"MainLayout"][@"LoginVCBGImageName"];
        UIImage *image = [UIImage imageNamed:imageName];
        _forgetPwdVCBGImage = image ? image: [UIImage imageNamed:[NSString stringWithFormat:@"resource.bundle/%@",imageName]];
    }
    return _forgetPwdVCBGImage;
}


- (CGFloat)margin{
    if (_margin == 0) {
        _margin = defaultMargin;
    }
    return _margin;
}

#pragma mark ---life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewModel];
    [self layoutViewController];
}
    
- (void)layoutViewController{
    //全局背景色
    UIColor *bgColor = EF_BGColor_Primary;
    //输入文字颜色
    UIColor *textFieldTextColor = EF_TextColor_TextColorLoginPrimary;
    //输入框的背景色
    NSString *bgTextFiledColorStr = SkinThemeKey_BGTextFiledColorLogin;
    //分割线颜色
    UIColor *separateLineColor = EF_TextColor_WhiteDivider;
    //按钮的背景色
    UIColor *btnBGColor = EF_BGButtonColor_Normal
    //文字输入框占位文字颜色
    UIColor *placeHolderColor = EF_TextColor_LoginTextFieldPlaceHolderColor;
    
    //背景图片
    UIImageView *bgImageView = [[UIImageView alloc] init];
    [self.view addSubview:bgImageView];
    self.bgImageView = bgImageView;

    if (self.LoginVCBGImage) {
        bgImageView.image = self.LoginVCBGImage;
    }else{
        bgImageView.backgroundColor = bgColor;
    }

    if (self.forgetPwdVCBGImage) {
        bgImageView.image = self.forgetPwdVCBGImage;
    }else{
        bgImageView.backgroundColor = bgColor;
    }

    
    UIView *topView = [[UIView alloc] init];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor clearColor];
    self.topView = topView;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_TextColorNavigation] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    self.backBtn = backBtn;
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.textColor = EF_TextColor_TextColorNavigation;
    topLabel.font = [UIFont boldSystemFontOfSize:17];
    topLabel.text = @"重置密码";
    [topLabel sizeToFit];
    [topView addSubview:topLabel];
    self.topLabel = topLabel;
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [EFSkinThemeManager getTextFileBackgroundColorWithKey:bgTextFiledColorStr];
    containerView.layer.cornerRadius = 6;
    containerView.layer.masksToBounds = YES;
    [self.view addSubview:containerView];
    self.containerView = containerView;
    
    UITextField *phoneTF = [[UITextField alloc] init];
    phoneTF.keyboardType = UIKeyboardTypePhonePad;
    phoneTF.textColor = textFieldTextColor;
    [phoneTF setValue:placeHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    phoneTF.placeholder = @"手机号";
    phoneTF.backgroundColor = [UIColor clearColor];
    [containerView addSubview:phoneTF];
    self.phoneTF = phoneTF;
    
    UIView *separateLine1 = [[UIView alloc] init];
    separateLine1.backgroundColor = separateLineColor;
    [containerView addSubview:separateLine1];
    self.separateLine1 = separateLine1;
    
    UITextField *codeTF = [[UITextField alloc] init];
    codeTF.keyboardType = UIKeyboardTypeNumberPad;
    codeTF.textColor = textFieldTextColor;
    [codeTF setValue:placeHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    codeTF.placeholder = @"验证码";
    codeTF.backgroundColor = [UIColor clearColor];
    [containerView addSubview:codeTF];
    self.codeTF = codeTF;
    
    UIButton *getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    getCodeBtn.backgroundColor = btnBGColor;
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
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.layer.cornerRadius = 6;
    sureBtn.layer.masksToBounds = YES;
    sureBtn.backgroundColor = btnBGColor;
    [sureBtn setTitleColor:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_TextColorButtonNormal] forState:UIControlStateNormal];
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    self.sureBtn = sureBtn;
    
    NSArray * ar = @[self.phoneTF,self.passwordTF,self.codeTF,self.confirmPsTF];
    self.viewShaker = [[KYShaker alloc] initWithViewsArray:ar];
    
    self.bgImageView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.topView.sd_layout.topSpaceToView(self.view,0).leftEqualToView(self.view).rightEqualToView(self.view).heightIs(64);
    self.backBtn.sd_layout.topSpaceToView(self.topView,20).leftSpaceToView(self.topView,10).widthIs(40).heightIs(40);
    self.topLabel.sd_layout.centerXEqualToView(self.topView).topSpaceToView(self.topView,20).heightIs(44);
    self.containerView.sd_layout.topSpaceToView(self.view,104).widthRatioToView(self.view,0.8).centerXEqualToView(self.view);
    self.phoneTF.sd_layout.topSpaceToView(self.containerView,self.margin).leftSpaceToView(self.containerView,self.margin).rightSpaceToView(self.containerView,self.margin).heightIs(30);
    self.separateLine1.sd_layout.topSpaceToView(self.phoneTF,self.margin).leftEqualToView(self.phoneTF).rightEqualToView(self.phoneTF).heightIs(0.5);
    self.codeTF.sd_layout.topSpaceToView(self.separateLine1,self.margin).leftEqualToView(self.phoneTF).rightEqualToView(self.phoneTF).heightIs(30);
    self.getCodeBtn.sd_layout.rightEqualToView(self.codeTF).centerYEqualToView(self.codeTF).widthIs(100).heightIs(30);
    self.getCodeBtn.layer.cornerRadius = 5;
    self.getCodeBtn.layer.masksToBounds = YES;
    self.separateLine2.sd_layout.topSpaceToView(self.codeTF,self.margin).leftEqualToView(self.phoneTF).rightEqualToView(self.phoneTF).heightIs(0.5);
    self.passwordTF.sd_layout.topSpaceToView(self.separateLine2,self.margin).leftEqualToView(self.phoneTF).rightEqualToView(self.phoneTF).heightIs(30);
    self.separateLine3.sd_layout.topSpaceToView(self.passwordTF,self.margin).leftEqualToView(self.phoneTF).rightEqualToView(self.phoneTF).heightIs(0.5);
    self.confirmPsTF.sd_layout.topSpaceToView(self.separateLine3,self.margin).leftEqualToView(self.phoneTF).rightEqualToView(self.phoneTF).heightIs(30);
    [self.containerView setupAutoHeightWithBottomView:self.confirmPsTF bottomMargin:self.margin];
    
    self.sureBtn.sd_layout.topSpaceToView(self.containerView,20).centerXEqualToView(self.view).heightIs(45).widthRatioToView(self.containerView,1);
}

#pragma mark ---event response
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
    if ([UIUtil isEmptyStr:self.passwordTF.text]) {
        [UIUtil alert:@"请输入密码"];
        [self.viewShaker shake];
        return;
    }
    BOOL isLong = [self isValidatePassword:self.passwordTF.text];
    if (isLong == NO) {
        [UIUtil alert:@"密码为6-12位数字或字母"];
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
    [self.viewModel resetPasswordWithPhoneNumber:self.phoneTF.text codeNumber:self.codeTF.text newPassWord:self.confirmPsTF.text];
    [SVProgressHUD showWithStatus:@"正在重置密码"];
}

- (BOOL)isValidatePassword:(NSString *)password{
    NSString *regex = @"^[\x21-\x7E]{6,12}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:password];
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
    [self.viewModel getPasswordCodeWithMobile:self.phoneTF.text];
    [SVProgressHUD showWithStatus:@"正在获取验证码"];
}

- (void)backBtnClick{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromParentViewController];
    }];
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
    if (action & PasswordCallBackActionPasswordCode) {
        if (result.status == NetworkModelStatusTypeSuccess) {
           [UIUtil alert:@"获取验证码成功"];
            self.getCodeBtn.enabled = NO;
            self.codeTF.text = result.message;
            self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(calculateGetCodeTime) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
            [self.timer fire];
            
        }else{
            [UIUtil alert:@"获取验证码失败"];
        }
    }
    
    if (action & PasswordCallBackActionResetPassword) {
        if (result.status == NetworkModelStatusTypeSuccess) {
            [UIUtil alert:@"密码重置成功"];
            [self backBtnClick];
        }else{
            [UIUtil alert:@"密码重置失败"];
        }
    }
}

#pragma mark--- setter && getter
- (EFForgetPasswordViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[EFForgetPasswordViewModel alloc] initWithViewController:self];
    }
    return _viewModel;
}
@end
