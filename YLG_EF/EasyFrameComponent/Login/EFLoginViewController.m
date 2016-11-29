//
//  EFLoginViewController.m
//  demo
//
//  Created by HqLee on 16/5/19.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//  普通的登录界面

#import "EFLoginViewController.h"
#import "EFForgetPasswordViewController.h"
#import "EFRegisterViewController.h"
#import "UserModel.h"
static CGFloat const defaultMargin = 10.0f;

@interface EFLoginViewController ()
//从plist文件中加载的相关配置
@property (nonatomic, strong) NSDictionary *dict;
//忘记密码控制器
@property (nonatomic, strong) EFForgetPasswordViewController *forgetPasswordVC;
//注册的控制器
@property (nonatomic, strong) EFRegisterViewController *registerVC;
//用户token
@property (nonatomic, copy) NSString * token;
//EasyFrame.plist文件的路径
//@property (nonatomic, copy) NSString *plistPath;
//登录背景视图名字
@property (nonatomic, strong) UIImage *LoginVCBGImage;
//登录Logo的大图名字
@property (nonatomic, strong) UIImage *APPLogoBigImage;
//登录Logo的小图名字
@property (nonatomic, strong) UIImage *APPLogoSmallImage;

@property (nonatomic, strong) KYShaker * viewShaker;

//注册界面VC
@property (nonatomic, strong) NSString * registVCName;
//忘记密码界面VC
@property (nonatomic, strong) NSString * forgetPassWordVCName;
@end

@implementation EFLoginViewController
#pragma mark --- lazy load
//- (NSString *)plistPath{
//    if (_plistPath == nil) {
//       _plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame_" ofType:@"plist"];
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

- (UIImage *)APPLogoBigImage{
    if (_APPLogoBigImage == nil) {
        NSString *imageName = [[NSDictionary alloc] initWithContentsOfFile:self.plistPath][@"MainLayout"][@"AppLogoBigImageName"];
        UIImage *image = [UIImage imageNamed:imageName];
        _APPLogoBigImage = image ? image: [UIImage imageNamed:[NSString stringWithFormat:@"resource.bundle/%@",imageName]];
    }
    return _APPLogoBigImage;
}

- (UIImage *)APPLogoSmallImage{
    if (_APPLogoSmallImage ==nil) {
        NSString *imageName = [[NSDictionary alloc] initWithContentsOfFile:self.plistPath][@"MainLayout"][@"AppLogoSmallImageName"];
        UIImage *image = [UIImage imageNamed:imageName];
        _APPLogoSmallImage = image ? image: [UIImage imageNamed:[NSString stringWithFormat:@"resource.bundle/%@",imageName]];
    }
    return _APPLogoSmallImage;
}

- (CGFloat)margin{
    if (_margin == 0) {
        _margin = defaultMargin;
    }
    return _margin;
}
#pragma mark --- life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewModel];
    [self layoutViewController];
}

- (void)dealloc{
    
}

- (void)layoutViewController{
    //全局背景色
    UIColor *bgColor = EF_BGColor_Primary;
    //文字颜色
    UIColor *textColor = EF_TextColor_TextColorLoginPrimary;
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
    
    //APPLogo容器视图
    UIView *AppLogoContainerView = [[UIView alloc] init];
    [self.view addSubview:AppLogoContainerView];
    self.AppLogoContainerView = AppLogoContainerView;
    

    //APPLogoBigImage
    if (self.APPLogoBigImage) {
        UIImageView *APPLogoBigImageView = [[UIImageView alloc] initWithImage:self.APPLogoBigImage];
        [AppLogoContainerView addSubview:APPLogoBigImageView];
        self.APPLogoBigImageView = APPLogoBigImageView;
    }
    //AppLogoSmallImage
    if (self.APPLogoSmallImage) {
        UIImageView *APPLogoSmallImageView = [[UIImageView alloc] initWithImage:self.APPLogoSmallImage];
        [AppLogoContainerView addSubview:APPLogoSmallImageView];
        self.APPLogoSmallImageView = APPLogoSmallImageView;
    }
    UIView *textFieldContainerView = [[UIView alloc] init];
    textFieldContainerView.backgroundColor = [EFSkinThemeManager getTextFileBackgroundColorWithKey:bgTextFiledColorStr];
    textFieldContainerView.layer.cornerRadius = 6;
    textFieldContainerView.layer.masksToBounds = YES;
    [self.view addSubview:textFieldContainerView];
    self.textFieldContainerView = textFieldContainerView;
    //注册VC
    self.registVCName = [[NSDictionary alloc] initWithContentsOfFile:self.plistPath][@"MainLayout"][@"RegisterViewControllName"];
    //忘记密码VC
    self.forgetPassWordVCName = [[NSDictionary alloc] initWithContentsOfFile:self.plistPath][@"MainLayout"][@"ForgetPassWordViewControllName"];
    
    UITextField *phoneTF = [[UITextField alloc] init];
    phoneTF.keyboardType = UIKeyboardTypePhonePad;
    phoneTF.placeholder = @"手机号";
    phoneTF.textColor = textFieldTextColor;
    [phoneTF setValue:placeHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    phoneTF.backgroundColor = [UIColor clearColor];
    [textFieldContainerView addSubview:phoneTF];
    self.phoneTF = phoneTF;
    
    UIView *separateLine = [[UIView alloc] init];
    separateLine.backgroundColor = separateLineColor;
    [textFieldContainerView addSubview:separateLine];
    self.separateLine = separateLine;
    
    UITextField *passwordTF = [[UITextField alloc] init];
    passwordTF.placeholder = @"密码";
    passwordTF.textColor = textFieldTextColor;
    [passwordTF setValue:placeHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    passwordTF.backgroundColor = [UIColor clearColor];
    passwordTF.secureTextEntry = YES;
    [textFieldContainerView addSubview:passwordTF];
    self.passwordTF = passwordTF;
    
    UIButton *forgetCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetCodeBtn setImage:Img(@"resource.bundle/ic_forgetpassword") forState:0];
    [forgetCodeBtn addTarget:self action:@selector(forgetCodeBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [textFieldContainerView addSubview:forgetCodeBtn];
    self.forgetCodeBtn = forgetCodeBtn;
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.layer.cornerRadius = 6;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.backgroundColor = btnBGColor;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_TextColorButtonNormal] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    self.loginBtn = loginBtn;
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.layer.cornerRadius = 6;
    registerBtn.layer.masksToBounds = YES;
    [registerBtn setTitle:@"创建新账户" forState:UIControlStateNormal];
    registerBtn.backgroundColor = btnBGColor;
    [registerBtn setTitleColor:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_TextColorButtonNormal] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    self.registerBtn = registerBtn;
    
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"还没有账户？";
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textColor = textColor;
    tipLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:tipLabel];
    self.tipLabel = tipLabel;
    
    //注意添加的顺序，一定是按照添加控件的顺序一一添加约束
    self.bgImageView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.AppLogoContainerView.sd_layout.topSpaceToView(self.view,20).leftEqualToView(self.view).rightEqualToView(self.view).heightIs(SCREEN_HEIGHT/3.0f);
    //APPLogoBigImage的约束
    if (self.APPLogoBigImage) {
        if (IS_IPHONE4 || IS_IPHONE5) {
            CGFloat ratio = SCREEN_HEIGHT / 667.0f;
            self.APPLogoBigImageView.sd_layout.topSpaceToView(self.AppLogoContainerView,20).centerXEqualToView(self.AppLogoContainerView).heightIs(self.AppLogoContainerView.size.height * ratio).widthIs(self.APPLogoBigImageView.size.width * ratio);
        }else{
            self.APPLogoBigImageView.sd_layout.topSpaceToView(self.AppLogoContainerView,20).centerXEqualToView(self.AppLogoContainerView);
        }
    }
    //AppLogoSmallImage
    if (self.APPLogoSmallImage) {
        self.APPLogoSmallImageView.sd_layout.centerYEqualToView(self.AppLogoContainerView).centerXEqualToView(self.AppLogoContainerView);

    }
    self.textFieldContainerView.sd_layout.leftSpaceToView(self.view,35).rightSpaceToView(self.view,35).topSpaceToView(self.AppLogoContainerView,20).heightIs(100);
    self.phoneTF.sd_layout.leftSpaceToView(self.textFieldContainerView,self.margin).rightSpaceToView(self.textFieldContainerView,self.margin).topSpaceToView(self.textFieldContainerView,self.margin).heightIs(35);
    self.separateLine.sd_layout.heightIs(0.5).leftEqualToView(self.phoneTF).rightEqualToView(self.phoneTF).topSpaceToView(self.phoneTF,self.margin * 0.5);
    self.passwordTF.sd_layout.leftEqualToView(self.phoneTF).rightEqualToView(self.phoneTF).topSpaceToView(self.separateLine,self.margin * 0.5).heightIs(35);
    self.loginBtn.sd_layout.leftEqualToView(self.textFieldContainerView).rightEqualToView(self.textFieldContainerView).topSpaceToView(self.textFieldContainerView,self.margin).heightIs(45);
    self.forgetCodeBtn.sd_layout.rightSpaceToView(self.textFieldContainerView,self.margin).centerYEqualToView(self.passwordTF).heightIs(20).widthIs(20);
    self.registerBtn.sd_layout.leftEqualToView(self.textFieldContainerView).rightEqualToView(self.textFieldContainerView).bottomSpaceToView(self.view,20).heightIs(45);
    self.tipLabel.sd_layout.centerXEqualToView(self.view).autoHeightRatio(0).widthRatioToView(self.view,1).bottomSpaceToView(self.registerBtn,self.margin);
}

#pragma mark --- event response
//忘记密码按钮点击
- (void)forgetCodeBtnDidClick{
    [self.view endEditing:YES];
    
    const char *className = [self.forgetPassWordVCName cStringUsingEncoding:NSUTF8StringEncoding];
    Class aClass = objc_getClass(className);
    UIViewController *vc = [[aClass alloc]init];
    
    __block UIView *forgetPasswordView = vc.view;
    forgetPasswordView.backgroundColor = [UIColor whiteColor];
    forgetPasswordView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:forgetPasswordView];
    [self addChildViewController:vc];
    
    [UIView animateWithDuration:0.25 animations:^{
        forgetPasswordView.frame = self.view.bounds;
    }];
}
//登录按钮点击
- (void)loginBtnClick{
    NSArray * ar = @[self.phoneTF,self.passwordTF];
    self.viewShaker = [[KYShaker alloc] initWithViewsArray:ar];
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

    [self.viewModel loginWithPhoneNumber:self.phoneTF.text password:self.passwordTF.text];
    [SVProgressHUD showWithStatus:@"正在登录"];
}

- (BOOL)isValidatePassword:(NSString *)password{
    NSString *regex = @"^[\x21-\x7E]{6,12}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:password];
}
//注册按钮点击
- (void)registerBtnClick{
    [self.view endEditing:YES];
    
    const char *className = [self.registVCName cStringUsingEncoding:NSUTF8StringEncoding];
    Class aClass = objc_getClass(className);
    UIViewController *vc = [[aClass alloc]init];
    
    __block UIView *registerView = vc.view;
    registerView.backgroundColor = [UIColor whiteColor];
    registerView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:registerView];
    [self addChildViewController:vc];
    
    [UIView animateWithDuration:0.25 animations:^{
        registerView.frame = self.view.bounds;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark --- setter && getter
- (EFLoginViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[EFLoginViewModel alloc] initWithViewController:self];
    }
    return _viewModel;
}

#pragma mark --- 网络请求回调
- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    [SVProgressHUD dismiss];
    if (action & LoginCallBackActionLogin) {
        if (result.status == NetworkModelStatusTypeSuccess) {
            [UIUtil alert:@"登录成功"];
            self.token = result.content[@"token"];
            [self.viewModel GetMyProfile:self.token];
        }else{
            [UIUtil alert:@"登录失败"];
        }
    }else  if (action & LoginCallBackActionGetMyProfile){
        if (result.status == NetworkModelStatusTypeSuccess) {
            [UserModel LoginWithModel:result.jsonDict[@"content"] andToken:self.token];
            [self dismissViewControllerAnimated:YES completion:nil];
            [UIApplication sharedApplication].keyWindow.rootViewController = [[EFAppManager shareInstance] getRootViewController];
        }else{
        }
    }
}
@end
