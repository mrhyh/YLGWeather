//
//  EFLoginViewController.h
//  demo
//
//  Created by HqLee on 16/5/19.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "EFBaseViewController.h"
#import "EFThirdPartyLoginView.h"
#import "EFLoginViewModel.h"

@interface EFLoginViewController : EFBaseViewController
//viewModel
@property (nonatomic, strong) EFLoginViewModel *viewModel;
/** 控件之间的基本间隙*/
@property (nonatomic, assign) CGFloat margin;
/** 背景图*/
@property (nonatomic, weak) UIImageView *bgImageView;
/** APPLogo大图*/
@property (nonatomic, weak) UIImageView *APPLogoBigImageView;
/** APPLogo小图*/
@property (nonatomic, weak) UIImageView *APPLogoSmallImageView;
//APPLogo容器视图
@property (nonatomic, weak) UIView *AppLogoContainerView;
/**  输入框的容器视图*/
@property (nonatomic, weak) UIView *textFieldContainerView;
/**  手机号输入 */
@property (nonatomic, weak) UITextField *phoneTF;
/** 密码输入*/
@property (nonatomic, weak) UITextField *passwordTF;
/** 忘记密码按钮 */
@property (nonatomic, weak) UIButton *forgetCodeBtn;
/**登录按钮 */
@property (nonatomic, weak) UIButton *loginBtn;
/**提示文字 */
@property (nonatomic, weak) UILabel *tipLabel;
/**注册按钮*/
@property (nonatomic, weak) UIButton *registerBtn;
/** 分割线*/
@property (nonatomic, weak) UIView *separateLine;

//忘记密码按钮点击
- (void)forgetCodeBtnDidClick;
//登录按钮点击
- (void)loginBtnClick;
//注册按钮点击
- (void)registerBtnClick;
@end
