//
//  EFOrderConfirmTwoVC.m
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/23.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFOrderConfirmTwoVC.h"

#import "EFGoodModel.h"
#import "EFOrderConfirmCell.h"
#import "EFGoodsTwoCell.h"
#import "EFOrderStatusCell.h"
#import "EFMallDetailsStoreCell.h"
#import "EFOrderDetailTwoCell.h"
#import "EFShopCartViewModel.h"
#import "UIButton+TouchAreaInsets.h"
#import "EFConsigneeAddressVC.h"
#import "EFPaymentPasswordVC.h"
#import "EFPayAlertView.h"
#import "DCPaymentView.h"
#import "EFMyOrderVC.h"
#import "EFOrderDetailVC.h"
#import "EFMyOrderVC.h"
#import "AppDelegate+Payment.h"
#import <AlipaySDK/AlipaySDK.h>
@interface EFOrderConfirmTwoVC () <UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) KYTableView *tableView;
@property (nonatomic, strong) UIColor *mainBGColor;


@property (nonatomic, strong) NSArray *nameArray;
@property (nonatomic, strong) NSArray *orderinfoLeftArray;
@property (nonatomic, strong) NSArray *orderinfoRightArray;

@property (nonatomic, strong) EFShopCartViewModel *viewModel;

@property (nonatomic, strong) EFMallConsigneeModel *efMallConsigneeModel;

@property (nonatomic, weak) KYMHLabel *sumLabel;
@property (nonatomic, assign) double balance;
@property (nonatomic, weak) UIButton *selectBtn;//选择是否采用余额支付
@property (nonatomic,strong) NSString * orderIdString;
@end

@implementation EFOrderConfirmTwoVC {
    
    CGFloat segmentH;
    CGFloat spaceToLeft;
    CGFloat sectionViewH;
    CGFloat sectionImageH;
    CGFloat sectionFontSize;
    CGFloat tabBarH;
}

typedef NS_ENUM(NSInteger, EFOrderDetailVCSectionNS_ENUM) {
    EFOrderDetailVCSectionNS_ENUM_GoodInfo=0,
    EFOrderDetailVCSectionNS_ENUM_Business,
    EFOrderDetailVCSectionNS_ENUM_OrderInfo,
};

static NSString * const OrderCell = @"EFOrderDetailTwoVCGoodCell";
static NSString * const OrderCellEFGoodsTwoCell = @"EFOrderDetailTwoVCEFGoodsTwoCell";
static NSString * const EFOrderDetailTwoVCStatusCellEFGoodsTwoCell = @"EFOrderDetailTwoVCEFOrderStatusCellEFGoodsTwoCell";
static NSString * const EFMallDetailsStoreCellEFGoodsTwoCell = @"EFOrderDetailTwoVCEFMallDetailsStoreCellEFGoodsTwoCell";
static NSString * const OrderInfoCellEFGoodsTwoCell = @"EFOrderDetailTwoVCOrderInfoCellEFGoodsTwoCell";
static NSString * const GoodStatusCellEFGoodsTwoCell = @"EFOrderDetailTwoVCGoodStatusCellEFGoodsTwoCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDataSource];
    [self createUITableView];
    [self createBottomView];
    [self.viewModel getMyWalletInfo];
}

- (void) createBottomView {
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    lineView.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:lineView];
    
    bottomView.sd_layout.bottomEqualToView(self.view).leftEqualToView(self.view).rightEqualToView(self.view).heightIs(tabBarH);
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    NSString *string = [NSString stringWithFormat:@"  待支付￥%@",[self countPrice:_dataSource]];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:string];
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
    
    moneyLabel.sd_layout.topSpaceToView(bottomView,0).leftSpaceToView(bottomView,0).heightIs(tabBarH);
    
    sureBtn.sd_layout.topEqualToView(moneyLabel).rightSpaceToView(bottomView,0).leftSpaceToView(moneyLabel,0).heightIs(tabBarH);
    
}

- (void) initDataSource {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PaySuccess) name:@"PaySuccessNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PaySuccess) name:@"PaySuccessNotificationWX" object:nil];
    self.title = @"确认订单";
    self.view.backgroundColor = RGBColor(239, 244, 248);
    self.automaticallyAdjustsScrollViewInsets = NO;
    _mainBGColor = EF_MainColor;
    
    if(_efMallConsigneeModel == nil) {
        _efMallConsigneeModel = [[EFMallConsigneeModel alloc] init];
        _efMallConsigneeModel = [_efMallConsigneeModel readEFMallConsigneeModel];
    }
    
    segmentH = 40;
    spaceToLeft = 10;
    sectionViewH = 30;
    sectionImageH = 17;
    sectionFontSize = 13;
    tabBarH = 49;
    
    _dataSource = [NSMutableArray array];
    _dataSource = [_shopCartGoodArray mutableCopy];
    
    self.viewModel = [[EFShopCartViewModel alloc]initWithViewController:self];
    
    _nameArray = @[@"商品信息",@"收货信息", @"消费信息", @"订单信息", @" "];
    _orderinfoLeftArray = @[@"联系人"];
    _orderinfoRightArray = @[@"何鸠"];
    
}

- (KYTableView *)createUITableView{
    
    WS(weakSelf)
    if (!_tableView) {
        _tableView = [[KYTableView alloc]initWithFrame:CGRectMake(0, 11+64, SCREEN_WIDTH, SCREEN_HEIGHT-11-64-tabBarH) andUpBlock:^{
            [weakSelf.tableView endLoading];
        } andDownBlock:^{
            [weakSelf.tableView endLoading];
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[EFOrderConfirmCell class] forCellReuseIdentifier:OrderCell];
        [_tableView registerClass:[EFOrderDetailTwoCell class] forCellReuseIdentifier:OrderCellEFGoodsTwoCell];
        [_tableView registerClass:[EFOrderStatusCell class] forCellReuseIdentifier:EFOrderDetailTwoVCStatusCellEFGoodsTwoCell];
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}


- (void) setShopCartGoodArray:(NSMutableArray *)shopCartGoodArray {
    if(_shopCartGoodArray== nil ) {
        _shopCartGoodArray = [NSMutableArray array];
    }
    _shopCartGoodArray = shopCartGoodArray;
}

#pragma mark ---event response
- (void)selectBtnClick :(UIButton *)sender{
    self.selectBtn.selected = !sender.isSelected;
}

- (void)sureBtnClick{
    
    NSString *orderProductIdString;
    NSString *orderProductCountString;
    for (int i=0; i<self.dataSource.count ; i++) {
        ShopCartContentModel *model = self.dataSource[i];
        if(i != 0) { //有多个店铺的产品
            orderProductIdString = [orderProductIdString stringByAppendingFormat:@",%ld",(long)model.productItem.objectId];
            orderProductCountString = [orderProductCountString stringByAppendingFormat:@",%ld",(long)model.quantity];
        }else {
            orderProductIdString = [NSString stringWithFormat:@"%ld",model.productItem.objectId];
            orderProductCountString = [NSString stringWithFormat:@"%ld",model.quantity];
        }
    }
    
    if ([UIUtil isEmptyStr:self.efMallConsigneeModel.consignee]) {
        [UIUtil alert:@"请选择收货地址！"];
        return;
    }
    
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
            [weakSelf.viewModel createOrder:_efMallConsigneeModel.objectId ConsigneeName:_efMallConsigneeModel.consignee ConsigneeMobile:_efMallConsigneeModel.phone ConsigneeAddress:_efMallConsigneeModel.address ConsigneeZipCode:_efMallConsigneeModel.zipCode isInvoice:YES invoiceTitle:@"" orderProductId:orderProductIdString orderProductCount:orderProductCountString shippingMethodId:0 notes:@"" andIsWalletPay:YES andPayPassword:inputPwd];
            [SVProgressHUD setMinimumDismissTimeInterval:1.0];
            [SVProgressHUD showWithStatus:@"正在下单，请稍候！"];
        }];
        [paymentView show];
        
    }else{
        [self.viewModel createOrder:_efMallConsigneeModel.objectId ConsigneeName:_efMallConsigneeModel.consignee ConsigneeMobile:_efMallConsigneeModel.phone ConsigneeAddress:_efMallConsigneeModel.address ConsigneeZipCode:_efMallConsigneeModel.zipCode isInvoice:YES invoiceTitle:@"" orderProductId:orderProductIdString orderProductCount:orderProductCountString shippingMethodId:0 notes:@"" andIsWalletPay:NO andPayPassword:@""];
        [SVProgressHUD setMinimumDismissTimeInterval:1.0];
        [SVProgressHUD showWithStatus:@"正在下单，请稍候！"];
    }
}

#pragma mark --- 计算已选中商品金额
-(NSString *)countPrice:(NSMutableArray *)seleceArray {
    NSInteger totlePrice = 0.0;
    for (ShopCartContentModel *model in seleceArray) {
        NSInteger price = model.productItem.price;
        totlePrice += price*model.quantity;
    }
    NSString *string = [NSString stringWithFormat:@"%.2ld",(long)totlePrice];
    return string;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     if (indexPath.section == EFOrderDetailVCSectionNS_ENUM_GoodInfo) {
         
         EFOrderConfirmCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderCell];
         ShopCartContentModel *goodModel = _dataSource[indexPath.row];
         cell.shopCartContentModel = goodModel;
         if(indexPath.row+1 == _dataSource.count) {
             cell.lineView.hidden = YES;
         }else {
             cell.lineView.hidden = NO;
         }
         return cell;
         
    }else if(indexPath.section == EFOrderDetailVCSectionNS_ENUM_Business) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EFMallDetailsStoreCellEFGoodsTwoCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(!cell){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:EFMallDetailsStoreCellEFGoodsTwoCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
        [cell addSubview:bottomView];
        
        CGFloat labelY = 15;
        CGFloat _sumLabelW = SCREEN_WIDTH*0.8;
        KYMHLabel *sumLabel = [[KYMHLabel alloc] initWithTitle:@"" BaseSize:CGRectMake(spaceToLeft, labelY, _sumLabelW, 20) LabelColor:nil LabelFont:17 LabelTitleColor:nil TextAlignment:NSTextAlignmentLeft];
        sumLabel.textColor = EF_TextColor_TextColorPrimary;
        [sumLabel FontWeight:10];
        [bottomView addSubview:sumLabel];
        
        KYMHLabel *staticLabel = [[KYMHLabel alloc] initWithTitle:@"" BaseSize:CGRectMake(spaceToLeft,CGRectGetMaxY(sumLabel.frame)+13 , _sumLabelW, 20) LabelColor:nil LabelFont:15 LabelTitleColor:nil TextAlignment:NSTextAlignmentLeft];
        staticLabel.textColor = EF_TextColor_TextColorPrimary;
        [bottomView addSubview:staticLabel];

        
        //更新售后地址，先从本地读取，没有就从网络读取
        if (self.efMallConsigneeModel == nil) {
            sumLabel.text = @"请点击右边箭头选取收货地址!";
        }else{
            sumLabel.text = [NSString stringWithFormat:@"%@ %@",_efMallConsigneeModel.consignee, _efMallConsigneeModel.phone];
            staticLabel.text = _efMallConsigneeModel.address;
        }
        WS(weakSelf)
        KYMHButton *indicatorButton = [[KYMHButton alloc] initWithbarButtonItem:self Title:nil BaseSize:CGRectMake(SCREEN_WIDTH-spaceToLeft-30, 40, 30, 30) ButtonColor:nil ButtonFont:7 ButtonTitleColor:nil Block:^{
            
            EFConsigneeAddressVC *addressVC = [[EFConsigneeAddressVC alloc] initWithCompleteHandler:^(EFMallConsigneeModel *efMallConsigneeModel) {
//                [_efMallConsigneeModel saveEFMallConsigneeModel:efMallConsigneeModel];
                sumLabel.text = [NSString stringWithFormat:@"%@ %@",efMallConsigneeModel.consignee, efMallConsigneeModel.phone];
                staticLabel.text = [NSString stringWithFormat:@"%@%@",efMallConsigneeModel.areaName,efMallConsigneeModel.address];
                weakSelf.efMallConsigneeModel = efMallConsigneeModel;
            }];
            [self.navigationController pushViewController:addressVC animated:YES];
        }];
        [indicatorButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/Disclosure Indicator"]] forState:UIControlStateNormal];
        [indicatorButton setTouchAreaInsets:UIEdgeInsetsMake(20, 25, 20, 40)];
        [bottomView addSubview:indicatorButton];
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GoodStatusCellEFGoodsTwoCell];
        if(!cell){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:GoodStatusCellEFGoodsTwoCell];
        }
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat bottomViewH = 49;
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, bottomViewH)];
        [cell addSubview:bottomView];
        
        CGFloat fontSize =15;
        CGFloat labelY = 15;
        KYMHLabel *_staticLabel = [[KYMHLabel alloc] initWithTitle:@"钱包余额" BaseSize:CGRectZero LabelColor:nil LabelFont:fontSize LabelTitleColor:nil TextAlignment:NSTextAlignmentLeft];
        _staticLabel.textColor = EF_TextColor_TextColorPrimary;
        [bottomView addSubview:_staticLabel];
        _staticLabel.sd_layout.centerYEqualToView(bottomView).leftSpaceToView(bottomView,10).widthIs(150).autoHeightRatio(0);
        
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/ic_pass"]] forState:UIControlStateNormal];
        [selectBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/ic_pass"]]  forState:UIControlStateHighlighted];
        [selectBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/ic_select"]]  forState:UIControlStateSelected];
        [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:selectBtn];
        selectBtn.sd_layout.centerYEqualToView(bottomView).rightSpaceToView(bottomView,10).widthIs(20).heightIs(20);
        self.selectBtn = selectBtn;
        
        CGFloat _sumLabelW = 100;
        KYMHLabel *sumLabel = [[KYMHLabel alloc] initWithTitle:@"￥928" BaseSize:CGRectMake(SCREEN_WIDTH-spaceToLeft-_sumLabelW, labelY, _sumLabelW, 20) LabelColor:nil LabelFont:fontSize LabelTitleColor:nil TextAlignment:NSTextAlignmentRight];
        sumLabel.textColor = EF_TextColor_TextColorPrimary;
        [sumLabel FontWeight:10];
        [bottomView addSubview:sumLabel];
        sumLabel.sd_layout.centerYEqualToView(bottomView).rightSpaceToView(selectBtn,10).widthIs(150).heightIs(25);
        self.sumLabel = sumLabel;
        
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == EFOrderDetailVCSectionNS_ENUM_GoodInfo) {
        
        return _dataSource.count;
    }else {
        
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     if(indexPath.section == EFOrderDetailVCSectionNS_ENUM_GoodInfo) {
        return 49;
    }else if(indexPath.section == EFOrderDetailVCSectionNS_ENUM_Business) {
        return 90;
    } else {
        return 44;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, sectionViewH)];
    headView.backgroundColor = RGBColor(248, 249, 248);
    
    KYMHLabel *nameLabel = [KYMHLabel new];
    nameLabel.textColor = EF_TextColor_TextColorSecondary;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = Font(sectionFontSize);
    
    
    KYMHLabel *timeLabel = [KYMHLabel new];
    timeLabel.textColor = EF_TextColor_TextColorSecondary;
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.font = Font(sectionFontSize);
    
    [headView addSubview:timeLabel];
    [headView addSubview:nameLabel];
    
    
    //更新数据
    if(section < _nameArray.count){
        nameLabel.text = _nameArray[section];
    }

    //布局
    CGFloat spaceToTop = (sectionViewH-sectionImageH)/2;
    
    nameLabel.sd_layout
    .leftSpaceToView(headView, spaceToLeft)
    .topSpaceToView(headView, spaceToTop)
    .heightIs(sectionImageH);
    [nameLabel setSingleLineAutoResizeWithMaxWidth:70];
    
    timeLabel.sd_layout
    .rightSpaceToView(headView, spaceToLeft)
    .topSpaceToView(headView, spaceToTop)
    .heightIs(sectionImageH);
    [timeLabel setSingleLineAutoResizeWithMaxWidth:(SCREEN_WIDTH-70-2*spaceToLeft)];
    
    return headView;
}

-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return sectionViewH;
}

#pragma mark scrollViewDelegate
- (void)dealloc{
    
    [SVProgressHUD dismiss];
    if (self.viewModel) {
        [self.viewModel cancelAndClearAll];
        self.viewModel = nil;
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
                self.orderIdString = orderString;
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
    

    
    if (action == EFMailShopCart_WalletInfo) {
        if (result.status == NetworkModelStatusTypeSuccess) {
            self.balance = [result.content[@"balance"] integerValue];
            self.sumLabel.text = [NSString stringWithFormat:@"¥%.2f",self.balance];
            if (self.balance < [[self countPrice:_dataSource] doubleValue]) {
                self.selectBtn.enabled = NO;
            }
        }else{
            [UIUtil alert:@"加载钱包数据失败！"];
        }
    }
}

#pragma mark ---UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        EFPaymentPasswordVC *vc = [[EFPaymentPasswordVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)payOrder:(NSString *)orderIdString  {
    WS(weakSelf)
    
    
    EFPayAlertView *payView = [[EFPayAlertView alloc] initWithType:@"" andIsShowWalletPay:NO  CallBack:^(NSString *Type) {
        self.orderIdString = orderIdString;
        if ([Type isEqualToString:@"我的钱包"]) {
            DCPaymentView *paymentView = [[DCPaymentView alloc] init];
            paymentView.title = @"钱包零钱";
            paymentView.detail = @"钱包零钱";
            [paymentView EFMailcompleteHandle:^(NSString *inputPwd) {
                
                [weakSelf.viewModel BalancePay:orderIdString callBackBlock:^(CallBackStatus callBackStatus, NetworkModel *result) {
                    if ([result.jsonDict[@"status"] intValue] == 200) {
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

@end