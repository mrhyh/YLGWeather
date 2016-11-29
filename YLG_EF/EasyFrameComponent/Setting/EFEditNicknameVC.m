//
//  EFEditNicknameVC.m
//  EasyFrame_iOS2.0
//
//  Created by MH on 16/5/24.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFEditNicknameVC.h"

@interface EFEditNicknameVC()
@property (nonatomic, copy) CompleteBlock completeBlock;
@property (nonatomic, weak) UITextField *textField;
@end
@implementation EFEditNicknameVC
#pragma mark ---life cycle
- (instancetype)initWithCompleteBlock:(CompleteBlock)completeBlock{
    if (self = [super init]) {
        self.completeBlock = completeBlock;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setupNavi];
    [self layoutViewController];
}

- (void)setupNavi{
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.bounds = CGRectMake(0, 0, 60, 30);
    [finishBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_TextColorNavigation] forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(finishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:finishBtn];
    self.navigationItem.rightBarButtonItem = settingBarBtnItem;
}

- (void)layoutViewController{
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:containerView];
    containerView.sd_layout.topSpaceToView (self.view,84).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).heightIs(40);
    
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = [UIColor whiteColor];
    textField.placeholder = @"请编辑您的昵称";
    [containerView addSubview:textField];
    self.textField = textField;
    textField.sd_layout.spaceToSuperView(UIEdgeInsetsMake(5, 5, 5, 5));
}

#pragma mark--- event response
- (void)finishBtnClick{
    if (self.textField.text.length == 0 ) {
        [UIUtil alert:@"请输入昵称!"];
        return;
    }
    
    if (self.textField.text.length > 0 || self.textField.text.length < 8) {
        !self.completeBlock? :self.completeBlock(self.textField.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
