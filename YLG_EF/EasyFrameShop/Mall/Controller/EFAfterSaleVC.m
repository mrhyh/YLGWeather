//
//  EFAfterSaleVC.m
//  EF_MallDemo
//
//  Created by HqLee on 16/6/24.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFAfterSaleVC.h"
#import "IQTextView.h"
#import "EFShopCartViewModel.h"

@interface EFAfterSaleVC ()
@property (nonatomic, strong) EFShopCartViewModel *viewModel;
@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, assign) NSInteger objectId;
@end

@implementation EFAfterSaleVC
#pragma mark --- lazy load
- (EFShopCartViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[EFShopCartViewModel alloc] initWithViewController:self];
    }
    return _viewModel;
}
#pragma mark ---life cycle
- (instancetype)initWithObjectId:(NSInteger)objectId{
    if (self = [super init]) {
        _objectId = objectId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavi];
    [self setupView];
}

- (void)setupNavi{
    self.title = @"申请售后";
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)setupView{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *placeView = [[UIView alloc] init];
    placeView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:placeView];
    placeView.sd_layout.centerXEqualToView(self.view).heightIs(45).widthIs(20).bottomSpaceToView(self.view,10);
    
    UIButton *returnGoodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnGoodBtn setTitle:@"退货" forState:UIControlStateNormal];
    [returnGoodBtn addTarget:self action:@selector(returnGoodBtnClick) forControlEvents:UIControlEventTouchUpInside];
    returnGoodBtn.backgroundColor = RGBColor(251, 121, 0);
    [returnGoodBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:returnGoodBtn];
    returnGoodBtn.sd_layout.leftSpaceToView(self.view,15).heightIs(45).rightSpaceToView(placeView,0).bottomSpaceToView(self.view,10);
    
    UIButton *returnMoneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnMoneyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    returnMoneyBtn.backgroundColor = RGBColor(251, 121, 0);
    [returnMoneyBtn setTitle:@"退款" forState:UIControlStateNormal];
    [returnMoneyBtn addTarget:self action:@selector(returnMoneyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnMoneyBtn];
    returnMoneyBtn.sd_layout.leftSpaceToView(placeView,0).heightIs(45).rightSpaceToView(self.view,15).bottomSpaceToView(self.view,10);

    
    UIView *separateLine = [[UIView alloc] init];
    separateLine.backgroundColor = [UIColor grayColor];
    [self.view addSubview:separateLine];
    separateLine.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).heightIs(1).bottomSpaceToView(placeView,10);
    
    IQTextView *textView = [[IQTextView alloc] init];
    textView.placeholder = @"请说明您申请售后的原因";
    [self.view addSubview:textView];
    self.textView = textView;
    
    textView.sd_layout.bottomSpaceToView(separateLine,10).topSpaceToView(self.view,20).leftSpaceToView(self.view,15).rightSpaceToView(self.view,15);
}

#pragma mark --- event response
- (void)returnGoodBtnClick{
    if (self.textView.text.length == 0) {
        [UIUtil alert:@"申请售后的原因不能为空哦!"];
        return;
    }
    [self.viewModel ApplyReturnGood:self.objectId andReason:self.textView.text callBackBlock:^(CallBackStatus callBackStatus, NetworkModel *result) {
        if (result.status == NetworkModelStatusTypeSuccess) {
            [UIUtil alert:@"申请退货成功!"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [UIUtil alert:@"申请退货失败!"];
        }
    }];
}

- (void)returnMoneyBtnClick{
    if (self.textView.text.length == 0) {
        [UIUtil alert:@"申请售后的原因不能为空哦!"];
        return;
    }
    [self.viewModel ApplyReturnMoney:self.objectId andReason:self.textView.text  callBackBlock:^(CallBackStatus callBackStatus, NetworkModel *result) {
        if (result.status == NetworkModelStatusTypeSuccess) {
            [UIUtil alert:@"申请退款成功!"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [UIUtil alert:@"申请退款失败!"];
        }
    }];
}
@end
