//
//  EFForgetPasswordViewController.h
//  demo
//
//  Created by HqLee on 16/5/19.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
////  忘记密码

#import "EFBaseViewController.h"

@interface EFForgetPasswordViewController : EFBaseViewController
/** 控件之间的基本间隙*/
@property (nonatomic, assign) CGFloat margin;
/** 背景视图*/
@property (nonatomic, weak) UIImageView *bgImageView;
/**顶部容器视图*/
@property (nonatomic, weak) UIView *topView;
/**顶部Label*/
@property (nonatomic, weak) UILabel *topLabel;
/**返回按钮*/
@property (nonatomic, weak) UIButton *backBtn;
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



/**  确认按钮点击事件*/
- (void)sureBtnClick;
/**  返回按钮点击事件*/
- (void)backBtnClick;
@end
