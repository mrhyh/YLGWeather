//
//  RSOpinionVC.m
//  Risk
//
//  Created by Cherie Jeong on 16/7/15.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSOpinionVC.h"
#import "IQKeyboardManager.h"
#import "RSRiskViewModel.h"

@interface RSOpinionVC ()<UITextViewDelegate> {
    NSString  * _defaultStr;
    
}

@property (nonatomic,strong)RSRiskViewModel * viewModel;
@property (nonatomic, strong) UITextView *textTV;
@property (copy, nonatomic)NSString      * defaultStr1;
@property (strong, nonatomic)KYMHLabel   * label1;

@end

@implementation RSOpinionVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.view.backgroundColor = EF_BGColor_Primary;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initNavi];
    [self initUI];
}

- (void)initNavi {
    WS(weakSelf)
    KYMHButton * _notiMsgBtn = [[KYMHButton alloc]initWithbarButtonItem:self Title:@"" BaseSize:CGRectMake(0, 0, 40, 40) ButtonColor:[UIColor clearColor] ButtonFont:17 ButtonTitleColor:[UIColor clearColor] Block:^{
        [weakSelf sendOpinion];
    }];
    [_notiMsgBtn setTitle:@"提交" forState:0];
    [_notiMsgBtn setTitleColor: [UIColor whiteColor] forState:0];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:_notiMsgBtn];
    self.navigationItem.rightBarButtonItem = item;
}



- (void)sendOpinion {
    if ([UIUtil isEmptyStr:_textTV.text] || [_textTV.text isEqualToString:_defaultStr]) {
        [UIUtil alert:@"请输入您的宝贵意见！"];
        return;
    }
    
    if ([_textTV.text length] <= 10) {
        [UIUtil alert:@"内容过短无法发送"];
        return;
    }
    
    if (_viewModel == nil) {
        _viewModel = [[RSRiskViewModel alloc]initWithViewController:self];
    }
    [_viewModel submitFeedback:_textTV.text];
    
}

- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result {
    if (action == RSRisk_NS_ENUM_submitFeedback) {
        if (result.status == 200) {
            [UIUtil alert:@"提交成功"];
            _textTV.text = _defaultStr;
            [_textTV resignFirstResponder];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [UIUtil alert:@"提交失败"];
        }
    }
}

- (void)initUI {
    _defaultStr = @"有什么问题和建议请告诉我们吧，我们会尽快为您解决";
    if (_textTV == nil) {
        _textTV = [[UITextView alloc] initWithFrame:CGRectMake(10, 74, SCREEN_WIDTH-20, SCREEN_HEIGHT*0.4-20)];
        _textTV.backgroundColor = [UIColor whiteColor];
        _textTV.text = _defaultStr;
        _textTV.font = Font(15);
        _textTV.textColor = [UIColor grayColor];
        [self.view addSubview:_textTV];
        _textTV.delegate = self;
        _textTV.inputAccessoryView = [UIView new];
        _textTV.showsVerticalScrollIndicator = NO;
        _textTV.alwaysBounceVertical = YES;
        [_textTV.layer setBorderWidth:1.0];
        [_textTV.layer setBorderColor:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackDivider].CGColor];
        _textTV.layer.cornerRadius = 5;
        
        _defaultStr1 = @"200";
        
        _label1 = [[KYMHLabel alloc] initWithTitle:_defaultStr1 BaseSize:CGRectMake(10, CGRectGetMaxY(_textTV.frame)+10, SCREEN_WIDTH-20, 20) LabelColor:[UIColor clearColor] LabelFont:13 LabelTitleColor:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary] TextAlignment:NSTextAlignmentRight];
        [self.view addSubview:_label1];
    }
}

#pragma mark TextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:_defaultStr]) {
        textView.text = @"";
        
    }else {
        
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if ([UIUtil isEmptyStr:textView.text]) {
        textView.text = _defaultStr;
        
    }else {
        
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger existedLength = textView.text.length;
    NSLog(@"existedLength%ld",(long)existedLength);
    _defaultStr1 = [NSString stringWithFormat:@"%ld",200-existedLength];
    _label1.text = _defaultStr1;
}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (text.length == 0)
        return YES;
    NSInteger existedLength = textView.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = text.length;
    if (existedLength + selectedLength + replaceLength > 200) {
        [UIUtil alert:@"最多输入200个字"];
        return NO;
    }
    
    _defaultStr1 = [NSString stringWithFormat:@"%ld",200-existedLength];
    _label1.text = _defaultStr1;
    
    return YES;
}


- (void)dealloc {
    if (self.viewModel) {
        [self.viewModel cancelAndClearAll];
        self.viewModel = nil;
    }
}


@end
