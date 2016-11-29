//
//  GW_EditNameVC.m
//  Guwang
//
//  Created by MH on 16/5/12.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "GW_EditNameVC.h"
#import "IQKeyboardManager.h"

#define Regex @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]*"

@interface GW_EditNameVC ()<UITextFieldDelegate>
@property (copy, nonatomic)NSString      * name;

@property (nonatomic,strong)UITextField * tf;

@end

@implementation GW_EditNameVC{
    
    BOOL _wasKeyboardManagerEnabled;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];

}

- (instancetype)initWithCallBack:(GW_EditNameVCCallBack)callBack{
    WS(weakSelf);
    self = [super init];
    if (self) {
        weakSelf.callBack = callBack;
    }
    return self;
}

- (void)initNavigateView{
   
    UIColor * color = EF_TextColor_TextColorNavigation;
    UIButton * btn= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 44)];
    [btn setTitle:@"确认" forState:0];
    [btn setTitleColor:color forState:0];
    [btn addTarget:self action:@selector(rightAction_name) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barBtnItem;
}

- (void)rightAction_name{
    
    [_tf resignFirstResponder];
    
    if (!_name) {
        [UIUtil alert:@"您尚未输入昵称！"];
        return;
    }
    
    if ([self isPureInt:_name]) {
        [UIUtil alert:@"姓名不能是纯数字"];
        return;
    }
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    if (![pred evaluateWithObject:_name]) {
        [UIUtil alert:@"姓名只能由汉字、英文字母和数字组成"];
        return;
    }
    
    
    WS(weakSelf);
    weakSelf.callBack(weakSelf.name);
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"修改昵称";
    [self initNavigateView];
   
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 54, SCREEN_WIDTH, 40)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    _tf = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 40)];
    _tf.textColor = EF_TextColor_TextColorPrimary;
    _tf.delegate = self;
    _tf.backgroundColor = [UIColor whiteColor];
    _tf.font = [UIFont systemFontOfSize:17];
    _tf.textAlignment = NSTextAlignmentLeft;
    _tf.placeholder = _nameStr;
    _tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_tf setValue:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary] forKeyPath:@"_placeholderLabel.textColor"];
    [backView addSubview:_tf];
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo)];
    [self.view addGestureRecognizer:tapGesture];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)Actiondo{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark  UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    _name = textField.text;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    if (string.length == 0)
        return YES;
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength + selectedLength + replaceLength > 10) {
        [UIUtil alert:@"最多输入10个字"];
        return NO;
    }
    
    return YES;
}

#pragma mark - 判断字符串 是否为中文
- (BOOL) validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fff]{2,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}

#pragma mark - 判断 用户名
- (BOOL) validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}

#pragma amrk - 判断 密码
- (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

#pragma mark - 判断输入是否为全数字
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string]; //定义一个NSScanner，扫描string
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

@end
