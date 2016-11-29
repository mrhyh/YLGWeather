//
//  EFLoginWithThirdViewController.m
//  demo
//
//  Created by HqLee on 16/5/23.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//  带有第三方登录的登录界面

#import "EFLoginWithThirdViewController.h"
#import "EFForgetPasswordViewController.h"
#import "EFRegisterViewController.h"
#import "EFLoginViewModel.h"
#import "UserModel.h"
#import "EFViewControllerManager.h"
static CGFloat const defaultMargin = 10.0f;
static CGFloat const animateDuration = 0.25;

@interface EFLoginWithThirdViewController ()
//从plist文件中加载的相关配置
@property (nonatomic, strong) NSDictionary *dict;
//忘记密码控制器
@property (nonatomic, strong) EFForgetPasswordViewController *forgetPasswordVC;
//注册的控制器
@property (nonatomic, strong) EFRegisterViewController *registerVC;
//viewModel
@property (nonatomic, strong) EFLoginViewModel *viewModel;
//第三方登录视图
@property (nonatomic, weak) EFThirdPartyLoginView *thirdView;
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
//APPLogo容器视图
@property (nonatomic, weak) UIView *AppLogoContainerView;
//是否必须登录
@property (nonatomic, assign) BOOL isLoginWhenFirstLaunchApp;
@end

@implementation EFLoginWithThirdViewController
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

- (BOOL)isLoginWhenFirstLaunchApp {
    
    self.isLoginWhenFirstLaunchApp = [[[NSDictionary alloc] initWithContentsOfFile:self.plistPath][@"MainLayout"][@"isLoginWhenFirstLaunchApp"] boolValue];
  
    return _isLoginWhenFirstLaunchApp;
}

- (CGFloat)margin{
    if (_margin == 0) {
        _margin = defaultMargin;
    }
    return _margin;
}
#pragma mark--- life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [[EFLoginViewModel alloc]initWithViewController:self];
    [self layoutViewController];
}

- (void)layoutViewController{
    
    //全局背景色
    UIColor *bgColor = EF_BGColor_Primary;
    //文字颜色
    UIColor *textColor = EF_TextColor_TextColorLoginPrimary;
    //次级文字颜色
    UIColor *textSecondCOlor = EF_TextColor_TextColorLoginSecondary;
    //输入文字颜色
    UIColor *textFieldTextColor = EF_TextColor_WhiteNormal;
    //输入框的背景色
    NSString *bgTextFiledColorStr = SkinThemeKey_BGTextFiledColorLogin;
    //分割线颜色（账号、密码）
    UIColor *separateLineColor = EF_TextColor_WhiteDivider;
    //按钮的背景色
    UIColor *btnBGColor = EF_BGButtonColor_Normal
    
//    self.isLoginWhenFirstLaunchApp = [[[NSDictionary alloc] initWithContentsOfFile:_plistPath][@"MainLayout"][@"isLoginWhenFirstLaunchApp"] boolValue];
    
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
    
    if (!self.isLoginWhenFirstLaunchApp) {
         UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       [closeBtn setTitle:@"返回" forState:0];
        closeBtn.backgroundColor = [UIColor clearColor];
        closeBtn.titleLabel.textColor = textSecondCOlor;
        [closeBtn addTarget:self action:@selector(closeTheLoginView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:closeBtn];
        self.closeBtn = closeBtn;
    }else {
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.backgroundColor = [UIColor clearColor];
        closeBtn.titleLabel.textColor = textSecondCOlor;
        [self.view addSubview:closeBtn];
        self.closeBtn = closeBtn;
    }

   
    
    
    UIView *textFieldContainerView = [[UIView alloc] init];
    textFieldContainerView.backgroundColor = [EFSkinThemeManager getTextFileBackgroundColorWithKey:bgTextFiledColorStr];
    textFieldContainerView.layer.cornerRadius = 6;
    textFieldContainerView.layer.masksToBounds = YES;
    [self.view addSubview:textFieldContainerView];
    self.textFieldContainerView = textFieldContainerView;
    
    UITextField *phoneTF = [[UITextField alloc] init];
    phoneTF.keyboardType = UIKeyboardTypePhonePad;
    phoneTF.placeholder = @"手机号";
//    phoneTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:@{NSForegroundColorAttributeName:separateLineColor}];
    phoneTF.textColor = textFieldTextColor;
    phoneTF.backgroundColor = [UIColor clearColor];
    [textFieldContainerView addSubview:phoneTF];
    self.phoneTF = phoneTF;
    
    UIView *separateLine = [[UIView alloc] init];
    separateLine.backgroundColor = separateLineColor;
    [textFieldContainerView addSubview:separateLine];
    self.separateLine = separateLine;
    
    UITextField *passwordTF = [[UITextField alloc] init];
    passwordTF.placeholder = @"密码";
//    passwordTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName:separateLineColor}];
    passwordTF.textColor = textFieldTextColor;
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
    [loginBtn setTitleColor:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_TextColorLoginPrimary] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    self.loginBtn = loginBtn;
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"还没有账户?";
    tipLabel.textAlignment = NSTextAlignmentRight;
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textColor = textSecondCOlor;
    tipLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:tipLabel];
    self.tipLabel = tipLabel;
    
    UILabel *registerLabel = [[UILabel alloc] init];
    registerLabel.userInteractionEnabled = YES;
    registerLabel.font = [UIFont systemFontOfSize:13];
    registerLabel.textAlignment = NSTextAlignmentRight;
    registerLabel.textColor = textSecondCOlor;
    NSMutableAttributedString *attributeStrM = [[NSMutableAttributedString alloc] initWithString:@"点此注册"];
    [attributeStrM addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [attributeStrM length])];
    registerLabel.attributedText = attributeStrM;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRegister)];
    [registerLabel addGestureRecognizer:tap];
    [self.view addSubview:registerLabel];
    self.registerLabel = registerLabel;
    
    EFThirdPartyLoginView *thirdView = [EFThirdPartyLoginView thirdPartyView];
    thirdView.delegate = self;
    [self.view addSubview:thirdView];
    self.thirdView = thirdView;
    
    //注意添加的顺序，一定是按照添加控件的顺序一一添加约束
    self.closeBtn.sd_layout.leftSpaceToView(self.view,20).topSpaceToView(self.view,20).widthIs(40).heightIs(30);
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
    self.textFieldContainerView.sd_layout.leftSpaceToView(self.view,35).rightSpaceToView(self.view,35).topSpaceToView(self.AppLogoContainerView,0).heightIs(100);
    self.phoneTF.sd_layout.leftSpaceToView(self.textFieldContainerView,self.margin).rightSpaceToView(self.textFieldContainerView,self.margin).topSpaceToView(self.textFieldContainerView,self.margin).heightIs(35);
    self.separateLine.sd_layout.heightIs(1).leftEqualToView(self.phoneTF).rightEqualToView(self.phoneTF).topSpaceToView(self.phoneTF,self.margin * 0.5);
    self.passwordTF.sd_layout.leftEqualToView(self.phoneTF).rightEqualToView(self.phoneTF).topSpaceToView(self.separateLine,self.margin * 0.5).heightIs(35);
    self.forgetCodeBtn.sd_layout.rightSpaceToView(self.textFieldContainerView,self.margin).centerYEqualToView(self.passwordTF).heightIs(20).widthIs(20);
    self.loginBtn.sd_layout.leftEqualToView(self.textFieldContainerView).rightEqualToView(self.textFieldContainerView).topSpaceToView(self.textFieldContainerView,self.margin).heightIs(45);
    self.registerLabel.sd_layout.rightEqualToView(self.loginBtn).topSpaceToView(self.loginBtn,10).widthIs(70).heightIs(20);
    self.tipLabel.sd_layout.rightSpaceToView(self.registerLabel,10).widthIs(100).heightIs(20).topEqualToView(self.registerLabel);
    

    
    if (IS_IPHONE4) {
        self.thirdView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomSpaceToView(self.view,-75).heightIs(135);
        self.thirdView.thirdPartyLabel.userInteractionEnabled = YES;
    }
    else{
        self.thirdView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomSpaceToView(self.view,20).heightIs(135);
        self.thirdView.thirdPartyLabel.userInteractionEnabled = NO;
    }
    
}


#pragma mark --- event response
//忘记密码按钮点击
- (void)forgetCodeBtnDidClick{
    EFForgetPasswordViewController *vc = [[EFForgetPasswordViewController alloc] init];
    __block UIView *forgetPasswordView = vc.view;
    forgetPasswordView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:forgetPasswordView];
    [self addChildViewController:vc];
    
    [UIView animateWithDuration:0.25 animations:^{
        forgetPasswordView.frame = self.view.bounds;
    }];
}
//登录按钮点击
- (void)loginBtnClick{
    if ([UIUtil isEmptyStr:self.phoneTF.text]) {
        [UIUtil alert:@"请输入手机号"];
        return;
    }
    if ([UIUtil isEmptyStr:self.passwordTF.text]) {
        [UIUtil alert:@"请输入密码"];
        return;
    }
    [self.viewModel loginWithPhoneNumber:self.phoneTF.text password:self.passwordTF.text];
    [SVProgressHUD showWithStatus:@"正在登录"];
}
//注册按钮点击
- (void)tapRegister{
    EFRegisterViewController *vc = [[EFRegisterViewController alloc] init];
    __block UIView *registerView = vc.view;
    registerView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:registerView];
    [self addChildViewController:vc];
    
    [UIView animateWithDuration:animateDuration animations:^{
        registerView.frame = self.view.bounds;
    }];
}
//关闭注册界面
- (void)closeTheLoginView {
    [UIApplication sharedApplication].keyWindow.rootViewController = [[EFAppManager shareInstance] getRootViewController];
}

- (void)tapThirdPartyLabel{
    CGFloat bottomSpace = 0;
    if (self.thirdView.top == 440) {
        bottomSpace = 20;
    }else{
        bottomSpace = -75;
    }
    self.thirdView.sd_layout.bottomSpaceToView(self.view,bottomSpace);
    [UIView animateWithDuration:animateDuration animations:^{
        [self.thirdView updateLayout];
    }];
}

#pragma mark --- viewModel 回调
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
        }
    }
    
}

- (void)dealloc{
    [SVProgressHUD dismiss];
    if (self.viewModel) {
        [self.viewModel cancelAndClearAll];
        self.viewModel = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
