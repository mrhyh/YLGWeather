//
//  LoginVC.m
//  Risk-iPhone
//
//  Created by Cherie Jeong on 16/8/25.
//  Copyright © 2016年 Cherie Jeong. All rights reserved.
//

#import "LoginVC.h"
#import "LoginViewModel.h"
#import "SVProgressHUD.h"
#import "UserModel.h"
#import "RS_UserModel.h"
#import <YYModel/YYModel.h>
#import "AppDelegate+EaseMob.h"
#import "EMOptions.h"
#import "EMClient.h"
#import "EaseSDKHelper.h"
#import "EMSDK.h"
#import <HyphenateSDK/EMSDK.h>
#import "RSHuanXinVC.h"
#import "IQKeyboardManager.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface LoginVC ()<UITextFieldDelegate>

//登录背景视图名字
@property (nonatomic, strong) UIImage *LoginVCBGImage;
//登录Logo的大图名字
@property (nonatomic, strong) UIImage *APPLogoBigImage;
//登录Logo的小图名字
@property (nonatomic, strong) UIImage *APPLogoSmallImage;


@property (nonatomic,strong) LoginViewModel * viewModel;
@property (nonatomic, copy) CompleteBlock completeBlock;
@property (nonatomic,strong) NSString *token;

/**  手机号输入 */
@property (nonatomic, strong) UITextField *phoneTF;
/** 密码输入*/
@property (nonatomic, strong) UITextField *passwordTF;
/**登录按钮 */
@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) KYShaker * viewShaker;

@end

@implementation LoginVC {
    NSString * userName;
}

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

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (instancetype)initWithCompleteBlock:(CompleteBlock)completeBlock {
    
    if (self = [super init]) {
        self.completeBlock = completeBlock;
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    IQKeyboardManager *iqMagager = [IQKeyboardManager sharedManager];
    iqMagager.keyboardDistanceFromTextField = 120;
    
    self.fd_interactivePopDisabled = YES;
    
    self.view.backgroundColor = EF_MainColor;
    self.viewModel = [[LoginViewModel alloc]initWithViewController:self];
    
    
    //全局背景色
    UIColor *bgColor = EF_MainColor;
    //分割线颜色
    UIColor *separateLineColor = EF_TextColor_WhiteDivider;
    
    //背景图片
    UIImageView *bgImageView = [[UIImageView alloc] init];
    [self.view addSubview:bgImageView];
    if (self.LoginVCBGImage) {
        bgImageView.image = self.LoginVCBGImage;
    }else{
        bgImageView.backgroundColor = bgColor;
    }
    
    UIView *textFieldContainerView = [[UIView alloc] init];
    textFieldContainerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:textFieldContainerView];
    
    UILabel * nameLB = [[UILabel alloc]init];
    nameLB.text = @"用户名:";
    nameLB.font = Font(17);
    nameLB.textColor = [UIColor whiteColor];
    [textFieldContainerView addSubview:nameLB];
    
    _phoneTF = [[UITextField alloc] init];
    _phoneTF.keyboardType = UIKeyboardTypeNamePhonePad;
    _phoneTF.placeholder = @"请输入用户名";
    _phoneTF.font = Font(16);
    _phoneTF.textColor = [UIColor whiteColor];
    [_phoneTF setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_phoneTF setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    _phoneTF.backgroundColor = [UIColor clearColor];
    _phoneTF.delegate = self;
    [textFieldContainerView addSubview:_phoneTF];
    
    UIView *separateLine = [[UIView alloc] init];
    separateLine.backgroundColor = separateLineColor;
    [textFieldContainerView addSubview:separateLine];
    
    UILabel * pawLB = [[UILabel alloc]init];
    pawLB.text = @"密    码:";
    pawLB.font = Font(17);
    pawLB.textColor = [UIColor whiteColor];
    [textFieldContainerView addSubview:pawLB];
    
    _passwordTF = [[UITextField alloc] init];
    _passwordTF.placeholder = @"请输入密码";
    _passwordTF.font = Font(16);
    _passwordTF.textColor = [UIColor whiteColor];
    [_passwordTF setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_passwordTF setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    _passwordTF.backgroundColor = [UIColor clearColor];
    _passwordTF.delegate = self;
    _passwordTF.secureTextEntry = YES;
    [textFieldContainerView addSubview:_passwordTF];
    
    
    [_phoneTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_passwordTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *separateLine1 = [[UIView alloc] init];
    separateLine1.backgroundColor = separateLineColor;
    [textFieldContainerView addSubview:separateLine1];
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.backgroundColor = RGBColor(28, 183, 92);
    _loginBtn.alpha = 0.7;
    [_loginBtn setTitle:@"登   录" forState:UIControlStateNormal];
    _loginBtn.titleLabel.font = Font(15);
    _loginBtn.userInteractionEnabled = NO;
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [textFieldContainerView addSubview:_loginBtn];
    
    
    
    bgImageView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    textFieldContainerView.sd_layout.centerXEqualToView(self.view).centerYIs(CGRectGetMidY(self.view.frame)+50).widthIs(320).heightIs(200);
    nameLB.sd_layout.leftSpaceToView(textFieldContainerView,20).topSpaceToView(textFieldContainerView,15).widthIs(80).heightIs(30);
    _phoneTF.sd_layout.leftSpaceToView(nameLB,5).bottomEqualToView(nameLB).rightSpaceToView(textFieldContainerView,20).heightIs(20);
    separateLine.sd_layout.leftEqualToView(nameLB).rightEqualToView(_phoneTF).topSpaceToView(nameLB,5).heightIs(2);
    pawLB.sd_layout.leftEqualToView(nameLB).topSpaceToView(separateLine,5).widthIs(80).heightIs(30);
    _passwordTF.sd_layout.leftSpaceToView(pawLB,5).bottomEqualToView(pawLB).rightSpaceToView(textFieldContainerView,20).heightIs(20);
    separateLine1.sd_layout.leftEqualToView(pawLB).rightEqualToView(_passwordTF).topSpaceToView(pawLB,5).heightIs(2);
    _loginBtn.sd_layout.leftSpaceToView(textFieldContainerView,20).rightSpaceToView(textFieldContainerView,20).topSpaceToView(separateLine1,30).heightIs(40);
    _loginBtn.sd_cornerRadius = [NSNumber numberWithInt:6];
    
    
    NSString * textStr = @"成都脉讯科技有限公司\n客服热线：13881742844";
    
    UILabel * bottomLB = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-100, SCREEN_WIDTH, 100)];
    bottomLB.textColor = [UIColor whiteColor];
    bottomLB.font = Font(14);
    bottomLB.text = textStr;
    bottomLB.textAlignment = NSTextAlignmentCenter;
    bottomLB.numberOfLines = 0;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [textStr length])];
    bottomLB.attributedText = attributedString;
    
    [self.view addSubview:bottomLB];
    
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    
    userName = [[NSUserDefaults standardUserDefaults] objectForKey:RiskUserName];
    if (![UIUtil isEmptyStr:userName]) {
        _phoneTF.text = userName;
    }
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    
    [self.view endEditing:YES];
    
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if ([UIUtil isNoEmptyStr:_phoneTF.text] && [UIUtil isNoEmptyStr:_passwordTF.text]) {
        _loginBtn.alpha = 1.0;
        _loginBtn.userInteractionEnabled =  YES;
    }else {
        _loginBtn.alpha = 0.7;
        _loginBtn.userInteractionEnabled = NO;
    }
}

//登录按钮点击
- (void)loginBtnClick {
    
    NSArray * ar = @[self.phoneTF,self.passwordTF];
    self.viewShaker = [[KYShaker alloc] initWithViewsArray:ar];
    if ([UIUtil isEmptyStr:self.phoneTF.text]) {
        [UIUtil alert:@"请输入用户名"];
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
    
    [self.viewModel loginWithPhoneNumber:self.phoneTF.text password:self.passwordTF.text md5Code:[self getUUID] type:IS_IPAD?1:2];
    [SVProgressHUD showWithStatus:@"正在登录"];
}

- (BOOL)isValidatePassword:(NSString *)password{
    NSString *regex = @"^[\x21-\x7E]{6,12}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:password];
}

#pragma mark --- viewModel 回调
- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    
    [SVProgressHUD dismiss];
    if (action & LoginCallBackActionLogin) {
        if (result.status == NetworkModelStatusTypeSuccess) {
            [UIUtil alert:@"登录成功"];
            self.token = result.content[@"token"];
            [self.viewModel GetMyProfile:self.token];
            
            [RS_UserModel LoginWithModel:result.jsonDict[@"content"]];
            NSLog(@"[RS_UserModel ShareUserModel].username =%@",[RS_UserModel ShareUserModel].username );
            
            
            [[NSUserDefaults standardUserDefaults] setObject:_phoneTF.text forKey:RiskUserName];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [RSHuanXinVC rs_loginEasemob];
            
        }else{
            if (result.status == NetworkModelStatusTypeNoRightToAccess) {
                if ([self IsChinese:result.message]) {
                    [UIUtil alert:result.message];
                }
                [UIUtil alert:@"账号或密码输入错误"];
            }else {
                [UIUtil alert:result.message];
            }
            
        }
    }
    
    if (action & LoginCallBackActionGetMyProfile){
        
        if (result.status == NetworkModelStatusTypeSuccess) {
            [UserModel LoginWithModel:result.jsonDict[@"content"] andToken:self.token];
            [[NSNotificationCenter defaultCenter] postNotificationName:LoginNotificationFromLogin object:nil];
            
            if (_isReferrsh) {
                self.completeBlock(YES);
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            [UIApplication sharedApplication].keyWindow.rootViewController = [[EFAppManager shareInstance] getRootViewController];
            [self cancel];
        }
    }
}

- (void)cancel {
    if (self.viewModel) {
        [self.viewModel cancelAndClearAll];
        self.viewModel = nil;
    }
}

- (BOOL)IsChinese:(NSString *)str {
    for(int i=0; i< [str length];i++) {
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)getUUID{
    //先获取keychain里面的UUID字段，看是否存在
    NSString *uuid = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    NSLog(@"UUID---%@",uuid);
    
    return uuid;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
