//
//  ChangePassWordVC.m
//  Risk
//
//  Created by Cherie Jeong on 16/7/28.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "ChangePassWordVC.h"
#import "EFLoginViewModel.h"
#import "RSTextField.h"

@interface ChangePassWordVC ()<UITextFieldDelegate>

@property (nonatomic,strong) RSTextField * oldPwdTF;
@property (nonatomic,strong) RSTextField * kNewPwdTF1;
@property (nonatomic,strong) RSTextField * kNewPwdTF2;

@property  (nonatomic,strong) UIButton *confirmButton;

@property (nonatomic,strong) EFLoginViewModel * viewModel;

@end

@implementation ChangePassWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.viewModel = [[EFLoginViewModel alloc]initWithViewController:self];
    
    [self setUpTextField];
}

- (void)setUpTextField {
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 166)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    UILabel * oldLB = [[UILabel alloc]init];
    oldLB.text = @"旧密码";
    oldLB.font = Font(13);
    oldLB.textAlignment = NSTextAlignmentLeft;
    oldLB.textColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary];
    
    UILabel * kNewLB1 = [[UILabel alloc]init];
    kNewLB1.text = @"新密码";
    kNewLB1.textAlignment = NSTextAlignmentLeft;
    kNewLB1.font = Font(13);
    kNewLB1.textColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary];
    
    UILabel * kNewLB2 = [[UILabel alloc]init];
    kNewLB2.text = @"确认密码";
    kNewLB2.textAlignment = NSTextAlignmentLeft;
    kNewLB2.font = Font(13);
    kNewLB2.textColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary];
    
    _oldPwdTF = [[RSTextField alloc]init];
    _oldPwdTF.delegate = self;
    _oldPwdTF.font = Font(13);
    _oldPwdTF.secureTextEntry = YES;
    _oldPwdTF.autocorrectionType = UITextAutocorrectionTypeNo;
    _oldPwdTF.clearsOnBeginEditing = YES;
    _oldPwdTF.placeholder = @"请输入旧密码";
    _oldPwdTF.textColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackNormal];
    [_oldPwdTF setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    _oldPwdTF.textAlignment = NSTextAlignmentLeft;
    
    _kNewPwdTF1 = [[RSTextField alloc]init];
    _kNewPwdTF1.delegate = self;
    _kNewPwdTF1.font = Font(13);
    _kNewPwdTF1.secureTextEntry = YES;
    _kNewPwdTF1.autocorrectionType = UITextAutocorrectionTypeNo;
    _kNewPwdTF1.clearsOnBeginEditing = YES;
    _kNewPwdTF1.placeholder = @"请输入6-12位新密码";
    _kNewPwdTF1.textColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackNormal];
    [_kNewPwdTF1 setValue:Font(13) forKeyPath:@"_placeholderLabel.font"];
    _kNewPwdTF1.textAlignment = NSTextAlignmentLeft;
    
    _kNewPwdTF2 = [[RSTextField alloc]init];
    _kNewPwdTF2.delegate = self;
    _kNewPwdTF2.font = Font(13);
    _kNewPwdTF2.secureTextEntry = YES;
    _kNewPwdTF2.clearsOnBeginEditing = YES;
    _kNewPwdTF2.autocorrectionType = UITextAutocorrectionTypeNo;
    _kNewPwdTF2.placeholder = @"请确认新密码";
    _kNewPwdTF2.textColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackNormal];
    [_kNewPwdTF2 setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [_kNewPwdTF2 setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [_kNewPwdTF2 setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    _kNewPwdTF2.textAlignment = NSTextAlignmentLeft;
    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackDivider];
    
    UIView * line1 = [[UIView alloc]init];
    line1.backgroundColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackDivider];
    
    UIView * line2 = [[UIView alloc]init];
    line2.backgroundColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackDivider];
    
    _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 300, 50, 50)];
    _confirmButton.backgroundColor = EF_MainColor;
    _confirmButton.layer.cornerRadius = 5;
    _confirmButton.layer.masksToBounds = 5;
    [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmButton];
    
    NSArray * views = @[oldLB,kNewLB1,kNewLB2,_oldPwdTF,_kNewPwdTF1,_kNewPwdTF2,line,line1,line2];
    [backView sd_addSubviews:views];
    
    CGFloat spaceToTop = 15;
    CGFloat spaceFromOldToNew = 10;
    CGFloat spaceToLeft = 10;
    
    
    oldLB.sd_layout
    .leftSpaceToView(backView,spaceToLeft)
    .topSpaceToView(backView,spaceToTop)
    .heightIs(25)
    .widthIs(50);
    
    _oldPwdTF.sd_layout
    .centerYEqualToView(oldLB)
    .leftSpaceToView(oldLB,spaceFromOldToNew)
    .rightSpaceToView(backView,spaceFromOldToNew)
    .heightIs(25);
    
    line.sd_layout
    .leftSpaceToView(backView, 0)
    .topSpaceToView(_oldPwdTF,spaceToTop)
    .widthIs(SCREEN_WIDTH)
    .heightIs(0.5);
    
    kNewLB1.sd_layout
    .leftSpaceToView(backView,spaceToLeft)
    .topSpaceToView(line,spaceToTop)
    .heightIs(25)
    .widthIs(50);
    
    _kNewPwdTF1.sd_layout
    .leftSpaceToView(kNewLB1,spaceFromOldToNew)
    .centerYEqualToView(kNewLB1)
    .rightSpaceToView(backView,spaceToLeft)
    .heightIs(25);
    
    line1.sd_layout
    .leftSpaceToView(backView, 0)
    .topSpaceToView(kNewLB1,spaceToTop)
    .widthIs(SCREEN_WIDTH)
    .heightIs(0.5);
    
    kNewLB2.sd_layout
    .leftSpaceToView(backView,spaceToLeft)
    .topSpaceToView(line1,spaceToTop)
    .heightIs(25)
    .widthIs(60);
    
    _kNewPwdTF2.sd_layout
    .leftSpaceToView(kNewLB2,spaceFromOldToNew)
    .centerYEqualToView(kNewLB2)
    .rightSpaceToView(backView,spaceToLeft)
    .heightIs(25);

    line2.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(_kNewPwdTF2,spaceToTop)
    .rightEqualToView(_kNewPwdTF1)
    .widthIs(SCREEN_WIDTH)
    .heightIs(0.5);
    
    _confirmButton.sd_layout
    .topSpaceToView(backView, 50)
    .leftSpaceToView(self.view, 20)
    .rightSpaceToView(self.view,20)
    .heightIs(40);
}

#pragma mark ButtonAction

- (void)confirmButtonAction {
    [self changePassWord];
}

- (void)changePassWord {
    if ([UIUtil isEmptyStr:_oldPwdTF.text]) {
        [UIUtil alert:@"请输入旧密码"];
        return;
    }
    if ([UIUtil isEmptyStr:_kNewPwdTF1.text] || [_kNewPwdTF1.text length] < 6 || [_kNewPwdTF1.text length] > 12) {
        [UIUtil alert:@"请输入6~12位新密码"];
        return;
    }
    if (![self isValidatePassword:_kNewPwdTF1.text]) {
        [UIUtil alert:@"密码为6-12位数字或英文字母"];
        return;
    }
    if ([UIUtil isEmptyStr:_kNewPwdTF2.text] || [_kNewPwdTF2.text length] < 6 || [_kNewPwdTF2.text length] > 12) {
        [UIUtil alert:@"请再次输入新密码"];
        return;
    }
    if ([_oldPwdTF.text isEqualToString:_kNewPwdTF1.text]) {
        [UIUtil alert:@"旧密码和新密码不能相同"];
        return;
    }
    if (![_kNewPwdTF1.text isEqualToString:_kNewPwdTF2.text]) {
        [UIUtil alert:@"输入的两次新密码不一致，请检查后再次输入"];
        return;
    }
    
    [SVProgressHUD show];
    [_viewModel modifyPassWordWithOldPassWotd:_oldPwdTF.text NewPassWord:_kNewPwdTF1.text];
    
}

- (BOOL)isValidatePassword:(NSString *)password{
    NSString *regex = @"^[\x21-\x7E]{6,12}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:password];
}

- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result {
    if (action & LoginCallBackActionModifyPassWord) {
        [SVProgressHUD dismiss];
        if (result.status == NetworkModelStatusTypeSuccess) {
            //修改成功
            [UserModel Logout];
            [self.view endEditing:YES];
            [UIUtil alert:@"密码修改成功，请重新登录"];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
           [UIUtil alert:[NSString stringWithFormat:@"修改密码失败:%@",result.message]];
        }
    }
}

- (void)dealloc {
    if (_viewModel) {
        [_viewModel cancelAndClearAll];
        _viewModel = nil;
    }
}

@end
