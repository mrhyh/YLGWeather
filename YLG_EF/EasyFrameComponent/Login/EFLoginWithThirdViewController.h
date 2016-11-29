//
//  EFLoginWithThirdViewController.h
//  demo
//
//  Created by HqLee on 16/5/23.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "EFBaseViewController.h"
#import "EFThirdPartyLoginView.h"

@interface EFLoginWithThirdViewController : EFBaseViewController<EFThirdPartyLoginViewDelegate>
/** 控件之间的基本间隙*/
@property (nonatomic, assign) CGFloat margin;
/** 背景图*/
@property (nonatomic, weak) UIImageView *bgImageView;
/** APPLogo大图*/
@property (nonatomic, weak) UIImageView *APPLogoBigImageView;
/** APPLogo小图*/
@property (nonatomic, weak) UIImageView *APPLogoSmallImageView;
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
@property (nonatomic, weak) UILabel *registerLabel;
/** 分割线*/
@property (nonatomic, weak) UIView *separateLine;
/**iPhone4 4s适配时所用*/
@property (nonatomic, weak) UIScrollView *mainScrollView;
//APP是否为必须登录，否添加关闭按钮
@property (nonatomic, weak) UIButton *closeBtn;
//忘记密码按钮点击
- (void)forgetCodeBtnDidClick;
//登录按钮点击
- (void)loginBtnClick;
//注册按钮点击
- (void)tapRegister;


@end
