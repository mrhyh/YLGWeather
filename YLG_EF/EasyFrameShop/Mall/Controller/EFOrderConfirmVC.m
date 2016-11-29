//
//  EFOrderConfirmVC.m
//  EF_MallDemo
//
//  Created by HqLee on 16/6/15.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFOrderConfirmVC.h"
#import "UIButton+TouchAreaInsets.h"
#import "EFPayAlertView.h"
#import "DCPaymentView.h"
#import "IQKeyboardManager.h"
#import "EFShopCartViewModel.h"
#import "EFOrderDetailVC.h"
#import "EFConsigneeAddressVC.h"
#import "EFPaymentPasswordVC.h"
#import "EFMyOrderVC.h"
#import "AppDelegate+Payment.h"
#import "WXApi.h"
@interface EFOrderConfirmVC ()<UIAlertViewDelegate>
/**
 *  是否需要显示收货人信息，从plist文件中配置
 */
@property (nonatomic, assign) BOOL isNeedConsigneeInfo;

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger tempCount; //数量中间变量
@property (nonatomic, weak) UILabel *moneyLabel;
@property (nonatomic, weak) UILabel *countDetailLabel;
@property (nonatomic, weak) UIButton *selectBtn;//选择是否采用余额支付
@property (nonatomic,strong) NSString * orderIdString;

@property (nonatomic, strong) EFMallConsigneeModel *efMallConsigneeModel;
@property (nonatomic, assign) double balance;

@property (nonatomic, strong) EFShopCartViewModel *viewModel;
@property (nonatomic, strong) OrderModel *orderModel;
@property (nonatomic, weak) UILabel *balanceDetailLabel;
@end

@implementation EFOrderConfirmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PaySuccess) name:@"PaySuccessNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PaySuccess) name:@"PaySuccessNotificationWX" object:nil];
    self.title = @"确认订单";
    self.viewModel = [[EFShopCartViewModel alloc] initWithViewController:self];
    [self initData];
    self.count = 1;
    self.isNeedConsigneeInfo = YES;
    [self setupView];
    [self.viewModel getMyWalletInfo];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [IQKeyboardManager sharedManager].enable = NO;
    
}

- (void) initData {
    
    if(_efMallConsigneeModel == nil) {
        _efMallConsigneeModel = [[EFMallConsigneeModel alloc] init];
        _efMallConsigneeModel = [_efMallConsigneeModel readEFMallConsigneeModel];
    }

}
- (void)setupView{
    
    if (self.view.subviews.count > 0) {
            [self.view removeAllSubviews];
    }
    UIView *goodInfoView = [[UIView alloc] init];
    goodInfoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:goodInfoView];
    goodInfoView.sd_layout.topSpaceToView(self.view,10).leftEqualToView(self.view).rightEqualToView(self.view);
    
    UIView *infoLabelView = [[UIView alloc] init];
    infoLabelView.backgroundColor = HEX_COLOR(@"#f6f6f6");
    [goodInfoView addSubview:infoLabelView];
    infoLabelView.sd_layout.topEqualToView(goodInfoView).leftEqualToView(goodInfoView).rightEqualToView(goodInfoView).heightIs(25);
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.text = @"商品信息";
    infoLabel.font = [UIFont systemFontOfSize:15];
    infoLabel.textColor = EF_TextColor_TextColorSecondary;
    [infoLabelView addSubview:infoLabel];
    infoLabel.sd_layout.centerYEqualToView(infoLabelView).leftSpaceToView(infoLabelView,10).heightIs(20).widthIs(100);
    
    UILabel *goodNameLabel = [[UILabel alloc] init];
    [goodInfoView addSubview:goodNameLabel];
    goodNameLabel.sd_layout.topSpaceToView(infoLabelView,10).leftSpaceToView(goodInfoView,10).widthIs(SCREEN_WIDTH * 0.7 - 20).heightIs(25);
    
    UILabel *goodPriceLabel = [[UILabel alloc] init];
    goodPriceLabel.textAlignment = NSTextAlignmentRight;
    [goodInfoView addSubview:goodPriceLabel];
    goodPriceLabel.sd_layout.centerYEqualToView(goodNameLabel).rightSpaceToView(goodInfoView,10).widthIs(150).heightIs(25);
    
    UIView *separateLine = [[UIView alloc] init];
    separateLine.backgroundColor = EF_BGColor_Primary;
    [goodInfoView addSubview:separateLine];
    separateLine.sd_layout.topSpaceToView(goodNameLabel,10).leftSpaceToView(goodInfoView,10).rightSpaceToView(goodInfoView,10).heightIs(2);
    
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.text = @"数量";
    [goodInfoView addSubview:countLabel];
    countLabel.sd_layout.topSpaceToView(separateLine,10).leftSpaceToView(goodInfoView,10).widthIs(100).heightIs(25);
    
    UIButton *minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [minusBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/btn_decrease"]] forState:UIControlStateNormal];
    [minusBtn setTouchAreaInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [minusBtn addTarget:self action:@selector(minusBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [goodInfoView addSubview:minusBtn];
    
    UILabel *countDetailLabel = [[UILabel alloc] init];
    countDetailLabel.textColor = [UIColor blackColor];
    countDetailLabel.textAlignment = NSTextAlignmentCenter;
    countDetailLabel.text = [NSString stringWithFormat:@"%zd",self.count];
    countDetailLabel.backgroundColor = RGBColor(242, 246, 250);
    countDetailLabel.layer.cornerRadius = 10;
    countDetailLabel.layer.masksToBounds = YES;
    [goodInfoView addSubview:countDetailLabel];
    self.countDetailLabel = countDetailLabel;
    
    UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [plusBtn setTouchAreaInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [plusBtn addTarget:self action:@selector(plusBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [plusBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/btn_increase"]]  forState:UIControlStateNormal];
    [goodInfoView addSubview:plusBtn];
    
    plusBtn.sd_layout.rightSpaceToView(goodInfoView,10).centerYEqualToView(countLabel).heightIs(20).widthIs(20);
    countDetailLabel.sd_layout.rightSpaceToView(plusBtn,5).centerYEqualToView(plusBtn).widthIs(60).heightIs(20);
    minusBtn.sd_layout.rightSpaceToView(countDetailLabel,5).centerYEqualToView(plusBtn).widthIs(20).heightIs(20);
    
    [goodInfoView setupAutoHeightWithBottomView:countLabel bottomMargin:10];
    
    UIView *costInfoView = [[UIView alloc] init];
    costInfoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:costInfoView];
    
    UIView *costLabelView = [[UIView alloc] init];
    costLabelView.backgroundColor = HEX_COLOR(@"#f6f6f6");
    [costInfoView addSubview:costLabelView];
    costLabelView.sd_layout.topEqualToView(costInfoView).leftEqualToView(costInfoView).rightEqualToView(costInfoView).heightIs(25);
    UILabel *costLabel = [[UILabel alloc] init];
    costLabel.text = @"消费信息";
    costLabel.font = [UIFont systemFontOfSize:15];
    costLabel.textColor = EF_TextColor_TextColorSecondary;
    [costLabelView addSubview:costLabel];
    costLabel.sd_layout.centerYEqualToView(costLabelView).leftSpaceToView(costLabelView,10).heightIs(20).widthIs(100);
    
    UILabel *mobileLabel = [[UILabel alloc] init];
    mobileLabel.text = @"手机号";
    [costInfoView addSubview:mobileLabel];
    mobileLabel.sd_layout.topSpaceToView(costLabelView,10).leftSpaceToView(costInfoView,10).widthIs(100).heightIs(25);
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/Disclosure Indicator"]]];
    [costInfoView addSubview:arrowImageView];
    arrowImageView.sd_layout.centerYEqualToView(mobileLabel).rightSpaceToView(costInfoView,10).heightIs(15).widthIs(10);
    
    UILabel *mobileNumLabel = [[UILabel alloc] init];
    mobileNumLabel.textAlignment = NSTextAlignmentRight;
    [costInfoView addSubview:mobileNumLabel];
    mobileNumLabel.sd_layout.centerYEqualToView(mobileLabel).rightSpaceToView(arrowImageView,10).widthIs(150).heightIs(25);
    
    UIView *separateLine1 = [[UIView alloc] init];
    separateLine1.backgroundColor = EF_BGColor_Primary;
    [costInfoView addSubview:separateLine1];
    separateLine1.sd_layout.topSpaceToView(mobileLabel,10).leftSpaceToView(costInfoView,10).rightSpaceToView(costInfoView,10).heightIs(2);
    
    UILabel *balanceLabel = [[UILabel alloc] init];
    balanceLabel.text = @"钱包余额";
    [costInfoView addSubview:balanceLabel];
    balanceLabel.sd_layout.topSpaceToView(separateLine,10).leftSpaceToView(costInfoView,10).widthIs(100).heightIs(25);
    
    if (self.isNeedConsigneeInfo == YES) {
        mobileLabel.sd_resetLayout.widthIs(0).heightIs(0);
        mobileNumLabel.sd_resetLayout.widthIs(0).heightIs(0);
        arrowImageView.sd_resetLayout.heightIs(0).widthIs(0);
        balanceLabel.sd_resetLayout.topSpaceToView(costLabelView,10).leftSpaceToView(costInfoView,10).widthIs(100).heightIs(25);
        separateLine1.sd_resetLayout.widthIs(0).heightIs(0);
    }
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/ic_pass"]] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/ic_pass"]] forState:UIControlStateHighlighted];
    [selectBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/ic_select"]] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [costInfoView addSubview:selectBtn];
    self.selectBtn = selectBtn;
    selectBtn.sd_layout.rightSpaceToView(costInfoView,10).centerYEqualToView(balanceLabel).widthIs(20).heightIs(20);
    
    UILabel *balanceDetailLabel = [[UILabel alloc] init];
    balanceDetailLabel.textAlignment = NSTextAlignmentRight;
    [costInfoView addSubview:balanceDetailLabel];
    balanceDetailLabel.sd_layout.centerYEqualToView(balanceLabel).rightSpaceToView(selectBtn,10).widthIs(150).heightIs(25);
    self.balanceDetailLabel = balanceDetailLabel;

    if (self.isNeedConsigneeInfo == YES) {
        UIView *consigneeInfoView = [[UIView alloc] init];
        consigneeInfoView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:consigneeInfoView];
        consigneeInfoView.sd_layout.topSpaceToView(goodInfoView,10).leftEqualToView(self.view).rightEqualToView(self.view);
        UIView *consigneeLabelView = [[UIView alloc] init];
        consigneeLabelView.backgroundColor = HEX_COLOR(@"#f6f6f6");
        [consigneeInfoView addSubview:consigneeLabelView];
        consigneeLabelView.sd_layout.topEqualToView(consigneeInfoView).leftEqualToView(consigneeInfoView).rightEqualToView(consigneeInfoView).heightIs(25);
        UILabel *infoLabel = [[UILabel alloc] init];
        infoLabel.text = @"收货信息";
        infoLabel.font = [UIFont systemFontOfSize:15];
        infoLabel.textColor = EF_TextColor_TextColorSecondary;
        [consigneeLabelView addSubview:infoLabel];
        infoLabel.sd_layout.centerYEqualToView(consigneeLabelView).leftSpaceToView(consigneeLabelView,10).heightIs(20).widthIs(100);
        
        UIView *userContainerView = [[UIView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choseConsignee)];
        [userContainerView addGestureRecognizer:tap];
        
        [consigneeInfoView addSubview:userContainerView];
        userContainerView.sd_layout.topSpaceToView(consigneeLabelView,10).leftEqualToView(consigneeInfoView).rightEqualToView(consigneeInfoView);
        
        UILabel *userNameLabel = [[UILabel alloc] init];
        if (self.efMallConsigneeModel.consignee == nil) {
            userNameLabel.text = @"请点击选择收货地址";
        }else{
            userNameLabel.text =[NSString stringWithFormat:@"%@ %@",self.efMallConsigneeModel.consignee,self.efMallConsigneeModel.phone];
        }
        [userContainerView addSubview:userNameLabel];
        userNameLabel.sd_layout.topSpaceToView(userContainerView,0).leftSpaceToView(userContainerView,10).rightSpaceToView(userContainerView,35).autoHeightRatio(0);
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/Disclosure Indicator"]]];
        [userContainerView addSubview:arrowImageView];
        arrowImageView.sd_layout.centerYEqualToView(userContainerView).rightSpaceToView(userContainerView,10).heightIs(15).widthIs(10);
        
        UILabel *userAddressLabel = [[UILabel alloc] init];
        if (self.efMallConsigneeModel.consignee == nil) {
            userAddressLabel.text = @"";
        }else{
            userAddressLabel.text = [NSString stringWithFormat:@"%@%@",self.efMallConsigneeModel.areaName,self.efMallConsigneeModel.address];
        }
        userAddressLabel.font = [UIFont systemFontOfSize:15];
        userAddressLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [userContainerView addSubview:userAddressLabel];
        userAddressLabel.sd_layout.topSpaceToView(userNameLabel,10).rightSpaceToView(userContainerView,35).leftSpaceToView(userContainerView,10).heightIs(15);
        
        [userContainerView setupAutoHeightWithBottomView:userAddressLabel bottomMargin:0];
        
        [consigneeInfoView setupAutoHeightWithBottomView:userContainerView bottomMargin:10];
        
        costInfoView.sd_layout.topSpaceToView(consigneeInfoView,10).leftEqualToView(self.view).rightEqualToView(self.view);
        [costInfoView setupAutoHeightWithBottomView:balanceLabel bottomMargin:10];
        
    }else{
        costInfoView.sd_layout.topSpaceToView(goodInfoView,10).leftEqualToView(self.view).rightEqualToView(self.view);
        [costInfoView setupAutoHeightWithBottomView:balanceLabel bottomMargin:10];
    }
    
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    bottomView.sd_layout.bottomEqualToView(self.view).leftEqualToView(self.view).rightEqualToView(self.view).heightIs(44);
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  待支付 ¥%zd",self.productDetail.price]];
    [attributeStr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(0, 5)];
    moneyLabel.attributedText = attributeStr;
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    sureBtn.backgroundColor = RGBColor(216, 166, 77);
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    bottomView.sd_equalWidthSubviews = @[moneyLabel,sureBtn];
    [bottomView addSubview:moneyLabel];
    [bottomView addSubview:sureBtn];

    moneyLabel.sd_layout.topSpaceToView(bottomView,0).leftSpaceToView(bottomView,0).heightIs(44);
    
    sureBtn.sd_layout.topEqualToView(moneyLabel).rightSpaceToView(bottomView,0).leftSpaceToView(moneyLabel,0).heightIs(44);
    
    self.moneyLabel = moneyLabel;
    
    //更新数据
    goodNameLabel.text = self.productDetail.name;
    balanceDetailLabel.text = [NSString stringWithFormat:@"¥%.2f",self.balance];
   goodPriceLabel.text = [NSString stringWithFormat:@"¥%ld",(long)self.productDetail.price];
    
}

- (void)minusBtnClick{
    self.tempCount --;
    if (self.tempCount < 1) {
        self.tempCount = 1;
    }
    WS(weakSelf)
    //修改商品数量
    [self.viewModel UpdateItemQuantityWithProductId:_productDetail.objectId Quantity:self.tempCount callBackBlock:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeSuccess) {
            
            weakSelf.count = weakSelf.tempCount;
            [weakSelf updateTotalPrices];
        }else if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeInputError ) {
            [UIUtil alert:result.message];
        }
    }];
}

- (void)plusBtnClick{
    self.tempCount ++;
    if (self.tempCount < 1) {
        self.tempCount = 1;
    }
    WS(weakSelf)
    //修改商品数量
    [self.viewModel UpdateItemQuantityWithProductId:_productDetail.objectId Quantity:self.tempCount callBackBlock:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeSuccess) {
            
            weakSelf.count = weakSelf.tempCount;
            [weakSelf updateTotalPrices];
        }else if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeInputError ) {
            [UIUtil alert:result.message];
        }
    }];
}

#pragma mark --- event response
-(void)selectBtnClick :(UIButton *)sender{
    self.selectBtn.selected = !sender.isSelected;
}
- (void)sureBtnClick{
    if (self.efMallConsigneeModel.objectId == nil) {
        [UIUtil alert:@"请选择收货地址!"];
        return;
    }
    NSString *orderProductIdString = [NSString stringWithFormat:@"%ld",(long)_productDetail.objectId];
    NSString *orderProductCountString = [NSString stringWithFormat:@"%ld",(long)_count];
    
    WS(weakSelf)
    if (self.selectBtn.isSelected == YES) {
        BOOL isSetPayPassword = [[EFUserDefault objectForKey:EFIsSetPayPassWord] boolValue];
        if (isSetPayPassword == NO) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您还未设置支付密码？" message:@"使用钱包支付需要先设置支付密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置支付密码", nil];
            [alertView show];
            return ;
        }
        DCPaymentView *paymentView = [[DCPaymentView alloc] init];
        paymentView.title = @"钱包零钱";
        paymentView.detail = @"钱包零钱";
        [paymentView EFMailcompleteHandle:^(NSString *inputPwd) {
            [weakSelf.viewModel createOrder:_efMallConsigneeModel.objectId ConsigneeName:_efMallConsigneeModel.consignee ConsigneeMobile:_efMallConsigneeModel.phone ConsigneeAddress:_efMallConsigneeModel.address ConsigneeZipCode:_efMallConsigneeModel.zipCode isInvoice:YES invoiceTitle:_productDetail.name orderProductId:orderProductIdString orderProductCount:orderProductCountString shippingMethodId:0 notes:@"" andIsWalletPay:YES andPayPassword:inputPwd];
            [SVProgressHUD setMinimumDismissTimeInterval:1.0];
            [SVProgressHUD showWithStatus:@"正在下单，请稍候！"];
        }];
        [paymentView show];
        
    }else{
        [self.viewModel createOrder:_efMallConsigneeModel.objectId ConsigneeName:_efMallConsigneeModel.consignee ConsigneeMobile:_efMallConsigneeModel.phone ConsigneeAddress:_efMallConsigneeModel.address ConsigneeZipCode:_efMallConsigneeModel.zipCode isInvoice:YES invoiceTitle:_productDetail.name orderProductId:orderProductIdString orderProductCount:orderProductCountString shippingMethodId:0 notes:@"" andIsWalletPay:NO andPayPassword:@""];
        [SVProgressHUD setMinimumDismissTimeInterval:1.0];
        [SVProgressHUD showWithStatus:@"正在下单，请稍候！"];
    }
}

- (void)payOrder:(NSString *)orderIdString {
    WS(weakSelf)
    
    EFPayAlertView *payView = [[EFPayAlertView alloc] initWithType:[NSString stringWithFormat:@"待支付金额:%zd",self.count * self.productDetail.price] andIsShowWalletPay:NO CallBack:^(NSString *Type) {
        self.orderIdString = orderIdString;
        if ([Type isEqualToString:@"我的钱包"]) {
            DCPaymentView *paymentView = [[DCPaymentView alloc] init];
            paymentView.title = @"钱包零钱";
            paymentView.detail = @"钱包零钱";
            [paymentView EFMailcompleteHandle:^(NSString *inputPwd) {
                
                
                [weakSelf.viewModel BalancePay:orderIdString callBackBlock:^(CallBackStatus callBackStatus, NetworkModel *result) {
                    
                    if ([result.jsonDict[@"status"] intValue] == 200)  {
                        [self PaySuccess];
                    }else{
                        NSDictionary *dic = result.inputError.fieldErrors;
                        for (NSString *key in [dic allKeys]) {
                            NSArray * arr = dic[key];
                            [UIUtil alert:arr[0]];
                            return;
                        }
                        NSDictionary *dic1 = result.inputError.objectErrors;
                        for (NSString *key in [dic1 allKeys]) {
                            NSArray * arr = dic1[key];
                            [UIUtil alert:arr[0]];
                            return;
                        }
                    }
                }];
            }];
            [paymentView show];
        }else if ([Type isEqualToString:@"支付宝"]) {
            NSURL * myURL_APP_A = [NSURL URLWithString:@"alipay:"];
            if (![[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
                [UIUtil alert:@"请先安装支付宝客户端"];
                return;
            }
            [self.viewModel AliPay:orderIdString callBackBlock:^(CallBackStatus callBackStatus, NetworkModel *result) {
                
                if ([result.jsonDict[@"status"] intValue] == 200)  {
                    [[NSUserDefaults standardUserDefaults] setObject: result.jsonDict[@"content"] forKey:ALiPay_Info];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    [self AliPay];
                }else{
                    NSDictionary *dic = result.inputError.fieldErrors;
                    for (NSString *key in [dic allKeys]) {
                        NSArray * arr = dic[key];
                        [UIUtil alert:arr[0]];
                        return;
                    }
                    NSDictionary *dic1 = result.inputError.objectErrors;
                    for (NSString *key in [dic1 allKeys]) {
                        NSArray * arr = dic1[key];
                        [UIUtil alert:arr[0]];
                        return;
                    }
                }
            }];
            
        }else if ([Type isEqualToString:@"微信支付"]) {
            if (![WXApi isWXAppInstalled]) {
                [UIUtil alert:@"请先安装微信客户端"];
                return;
            }
            [self.viewModel WeChatPay:orderIdString callBackBlock:^(CallBackStatus callBackStatus, NetworkModel *result) {
                
                if ([result.jsonDict[@"status"] intValue] == 200)  {
                    [[NSUserDefaults standardUserDefaults] setObject: result.jsonDict[@"content"] forKey:WEIXIN_Info];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    [[AppDelegate shareInstance] sendPay];
                }else{
                    NSDictionary *dic = result.inputError.fieldErrors;
                    for (NSString *key in [dic allKeys]) {
                        NSArray * arr = dic[key];
                        [UIUtil alert:arr[0]];
                        return;
                    }
                    NSDictionary *dic1 = result.inputError.objectErrors;
                    for (NSString *key in [dic1 allKeys]) {
                        NSArray * arr = dic1[key];
                        [UIUtil alert:arr[0]];
                        return;
                    }
                }
                
            }];
            
        }
    }];
    
    [payView showPopupViewWithAnimate:YES];
}

- (void)AliPay{
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"Guwang";
    
    NSMutableDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:ALiPay_Info];
    
    NSString *orderSpec = [dic objectForKey:@"parameter"];
    
    NSString *signedString = [dic objectForKey:@"sign"];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            NSLog(@"reslut = %@",resultDic);
            if ([[resultDic objectForKey:@"resultStatus"] intValue]==9000) {
                [self PaySuccess];
            }else{
                [UIUtil alert:resultDic[@"memo"]];
            }
        }];
        
        
    }
    
}

- (void)PaySuccess{
     NSLog(@"付款成功");
    //创建订单的请求参数不包含“,”，则代表只有一个订单
    if ([self.orderIdString rangeOfString:@","].location == NSNotFound) {
        EFOrderDetailVC *next = [[EFOrderDetailVC alloc] init];
        next.orderId = [self.orderIdString integerValue];
        [self.navigationController pushViewController:next animated:YES];
    }else {
        EFMyOrderVC *orderVC = [[EFMyOrderVC alloc] initWithCallBack:^(BOOL isSuccess) {
            if (isSuccess) {
                [self.navigationController popToRootViewControllerAnimated:NO];
            }
        }];
        [self.navigationController pushViewController:orderVC animated:YES];
    }
}


- (void)updateTotalPrices{
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  待支付 ¥%zd",self.count * self.productDetail.price]];
    [attributeStr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(0, 5)];
    self.moneyLabel.attributedText = attributeStr;
    self.countDetailLabel.text = [NSString stringWithFormat:@"%zd",self.count];
    if (self.balance < self.count * self.productDetail.price) {
        self.selectBtn.enabled = NO;
    }else{
        self.selectBtn.enabled = YES;
    }
}

#pragma mark ---UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        EFPaymentPasswordVC *vc = [[EFPaymentPasswordVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark ViewModel 回调
- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    [SVProgressHUD dismiss];
    if (action & EFMailShopCart_CreateOrder) {
        if ([result.jsonDict[@"status"] intValue] == 200) {
            
            if(self.viewModel.orderModelArray.count >0) {
                //拼接订单批量支付请求参数
                NSString *orderString;
                for (int i=0; i<self.viewModel.orderModelArray.count; i++) {
                    OrderModel *model = self.viewModel.orderModelArray[i];
                    if(i != 0) { //多个店铺
                        orderString = [orderString stringByAppendingFormat:@",%ld",(long)model.objectId];
                    }else {
                        orderString = [NSString stringWithFormat:@"%ld",model.objectId];
                    }
                }
                if (self.selectBtn.isSelected == YES) {
                    [self PaySuccess];
                }else{
                    [self payOrder:orderString];
                }
            }
            
        }else{
            [UIUtil alert:result.message];
        }
    }
    
//    if (action & EFMailShopCart_PayOrder) {
//        if ([result.jsonDict[@"status"] intValue] == 200) {
//            EFOrderDetailVC *next = [[EFOrderDetailVC alloc] init];
//            next.orderId = _orderModel.objectId;
//            next.orderModel = _orderModel;
//            next.orderStatus = _orderModel.orderStatus;
//            [self.navigationController pushViewController:next animated:YES];
//        }
//    }
    
    if (action == EFMailShopCart_WalletInfo) {
            if (result.status == NetworkModelStatusTypeSuccess) {
                self.balance = [result.content[@"balance"] integerValue];
                self.balanceDetailLabel.text = [NSString stringWithFormat:@"¥%.2f",self.balance];
                if (self.balance < self.count * self.productDetail.price) {
                    self.selectBtn.enabled = NO;
                }
            }else{
                [UIUtil alert:@"加载钱包余额数据失败！"];
            }
    }
}

- (void)choseConsignee{
    EFConsigneeAddressVC *addressVC = [[EFConsigneeAddressVC alloc] initWithCompleteHandler:^(EFMallConsigneeModel *efMallConsigneeModel) {
        self.efMallConsigneeModel = efMallConsigneeModel;
        [self setupView];
    }];
    
    [self.navigationController pushViewController:addressVC animated:YES];
}

- (void)dealloc{
    [SVProgressHUD dismiss];
    if (self.viewModel) {
        [self.viewModel cancelAndClearAll];
        self.viewModel = nil;
    }
}
@end