//
//  EFOrderDetailVC.m
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/14.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFOrderDetailVC.h"
#import "EFGoodModel.h"
#import "EFGoodsCell.h"
#import "EFGoodsTwoCell.h"
#import "EFOrderStatusCell.h"
#import "EFMallDetailsStoreCell.h"
#import "EFOrderInfoCell.h"
#import "EFOrderDetailTwoCell.h"
#import "EFShopCartViewModel.h"
#import "EFOrderDetailCell.h"
#import "EFOrderConfirmTwoVC.h"
#import "EFAfterSaleVC.h"
#import "EFAftermarketStatusVC.h"
#import "EFCommentListVC.h"
#import "EFPayAlertView.h"
#import "DCPaymentView.h"
#import "AppDelegate+Payment.h"
@interface EFOrderDetailVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) KYTableView *tableView;
@property (nonatomic, strong) UIColor *mainBGColor;

@property (nonatomic, strong) NSArray *nameArray;
@property (nonatomic, strong) NSArray *orderinfoLeftArray;
@property (nonatomic, strong) NSMutableArray *orderinfoRightArray;

@property (nonatomic, strong) EFShopCartViewModel *viewModel;
@property (nonatomic, strong) KYMHLabel *noDataLabel;

@property (nonatomic, strong) UIView *backgroundView;  //底部View
@property (nonatomic, strong)  KYMHButton *rightButton;
@property (nonatomic, strong)  KYMHButton *leftButton;
@property (nonatomic, strong)  UIView *rowBottomView;


@end

@implementation EFOrderDetailVC {
    
    CGFloat segmentH;
    CGFloat spaceToLeft;
    CGFloat sectionViewH;
    CGFloat sectionImageH;
    CGFloat sectionFontSize;
    CGFloat bottomViewH;
    UIColor *canSelectColor;
    UIColor *noCanSelectColor;
}

typedef NS_ENUM(NSInteger, EFOrderDetailVCSectionNS_ENUM) {
    
    EFOrderDetailVCSectionNS_ENUM_OrderStatus=0,
    EFOrderDetailVCSectionNS_ENUM_GoodInfo,
    EFOrderDetailVCSectionNS_ENUM_Business,
    EFOrderDetailVCSectionNS_ENUM_OrderInfo,
    EFOrderDetailVCSectionNS_ENUM_GoodStatus
};

static NSString * const OrderCell = @"EFMyOrderVCGoodCell";
static NSString * const OrderCellEFGoodsTwoCell = @"EFGoodsTwoCell";
static NSString * const EFGoodsTwoCellEFOrderStatusCell = @"EFOrderDetailVCEFOrderStatusCellEFGoodsTwoCell";
static NSString * const EFMallDetailsStoreCellEFGoodsTwoCell = @"EFMallDetailsStoreCellEFGoodsTwoCell";
static NSString * const OrderInfoCellEFGoodsTwoCell = @"OrderInfoCellEFGoodsTwoCell";
static NSString * const GoodStatusCellEFGoodsTwoCell = @"GoodStatusCellEFGoodsTwoCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PaySuccess) name:@"PaySuccessNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PaySuccess) name:@"PaySuccessNotificationWX" object:nil];
    [self initDataSource];
    
    [self.viewModel GetOrderById:_orderId];
    // Do any additional setup after loading the view.
}

- (void) initDataSource {
    
    self.title = @"订单详情";
    self.view.backgroundColor = RGBColor(239, 244, 248);
    self.automaticallyAdjustsScrollViewInsets = NO;
    _mainBGColor = EF_MainColor;
    
    canSelectColor = RGBColor(25, 182, 23);
    noCanSelectColor = RGBColor(175, 176, 175);
    
     self.viewModel = [[EFShopCartViewModel alloc] initWithViewController:self];
    
    _dataSource = [NSMutableArray array];
#warning TODO 暂时重写返回根控制器，实际应该是从“确认下单”进入的应该返回根控制器，其他界面进入的返回上个控制器
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
//                                             initWithTitle:@"返回" style: UIBarButtonItemStyleBordered
//                                             target:self action:@selector(dismissMyView)];
    
    
    _orderinfoRightArray = [NSMutableArray array];
    segmentH = 40;
    spaceToLeft = 10;
    sectionViewH = 30;
    sectionImageH = 17;
    sectionFontSize = 13;
    bottomViewH = 49;
    
    _nameArray = @[@"订单状态",@"商品信息", @"商家", @"订单信息", @" "];
    _orderinfoLeftArray = @[@"联系人",@"联系电话", @"寄送地址", @"支付方式", @"下单时间 "];
}

- (void)dismissMyView {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (KYTableView *)createUITableView{
    
    //创建底部视图
    [self setupCustomBottomView];
    
    WS(weakSelf)
    if (!_tableView) {
        _tableView = [[KYTableView alloc]initWithFrame:CGRectMake(0, 11+64, SCREEN_WIDTH, SCREEN_HEIGHT-11-64-bottomViewH) andUpBlock:^{
             [self.viewModel GetOrderById:_orderId];
        } andDownBlock:^{
            [weakSelf.tableView endLoading];
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[EFGoodsCell class] forCellReuseIdentifier:OrderCell];
        [_tableView registerClass:[EFOrderDetailTwoCell class] forCellReuseIdentifier:OrderCellEFGoodsTwoCell];
        [_tableView registerClass:[EFOrderStatusCell class] forCellReuseIdentifier:EFGoodsTwoCellEFOrderStatusCell];
        [_tableView registerClass:[EFMallDetailsStoreCell class] forCellReuseIdentifier:EFMallDetailsStoreCellEFGoodsTwoCell];
        [_tableView registerClass:[EFOrderInfoCell class] forCellReuseIdentifier:OrderInfoCellEFGoodsTwoCell];
        [self.view addSubview:_tableView];
        
    }
    
    if(self.viewModel.orderDetailModel.orderProduct.count  <= 0){
        
        if(_noDataLabel == nil){
            _noDataLabel = [[KYMHLabel alloc] initWithTitle:@"暂无数据，下拉刷新" BaseSize:CGRectMake(0,0,SCREEN_WIDTH, SCREEN_H_RATE*15) LabelColor: [UIColor clearColor] LabelFont:16 LabelTitleColor:[UIColor grayColor] TextAlignment:NSTextAlignmentCenter];
            _noDataLabel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/5*2);
            [_tableView addSubview:_noDataLabel];
        }
    }else {
        if(_noDataLabel != nil) {
            [_noDataLabel removeFromSuperview];
            _noDataLabel = nil;
        }
        [_tableView reloadData];
    }
    return _tableView;
}


- (void) setupCustomBottomView {

    if( _backgroundView == nil ) {
        
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-bottomViewH, SCREEN_WIDTH, bottomViewH)];
        _backgroundView.backgroundColor = [UIColor whiteColor];
        [self.view bringSubviewToFront:_backgroundView];
        [self.view addSubview:_backgroundView];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = EF_TextColor_TextColorSecondary;
        [_backgroundView addSubview:lineView];
        
        _leftButton = [KYMHButton new];
        _leftButton.backgroundColor = RGBColor(25, 182, 23);
        _leftButton.layer.cornerRadius = 5;
        _leftButton.titleLabel.font = Font(14);
        [_leftButton setTitle:@"取消订单" forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundView addSubview:_leftButton];
        
        _rightButton = [KYMHButton new];
        _rightButton.backgroundColor = RGBColor(25, 182, 23);
        _rightButton.layer.cornerRadius = 5;
        _rightButton.titleLabel.font = Font(14);
        [_rightButton setTitle:@"确认收货" forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundView addSubview:_rightButton];
        
        
        lineView.sd_layout
        .topSpaceToView(_backgroundView, 0)
        .widthIs(SCREEN_WIDTH)
        .heightIs(1);
        
        CGFloat spaceToTop = (bottomViewH-36)/2;
        _rightButton.sd_layout
        .topSpaceToView (lineView, spaceToTop)
        .rightSpaceToView(_backgroundView, 10)
        .widthIs (95)
        .heightIs(36);
        
        _leftButton.sd_layout
        .topEqualToView(_rightButton)
        .rightSpaceToView (_rightButton, 10)
        .widthIs (95)
        .heightIs(36);
    }
    [self initData];
}

- (void) leftButtonAction {
    
    NSLog(@"EFGoodsTwoCellLeftButton");
    
    if ( [_orderStatus isEqualToString: @"UN_PAYED"] ) {
        
        [self.viewModel cancelOrder:_orderId Caulse:@"测试" callBackBlock:^(CallBackStatus callBackStatus, NetworkModel *result) {
            if ([result.jsonDict[@"status"] intValue] == 200)  {
                NSLog(@"取消成功");
                _leftButton.hidden = YES;
                _rightButton.hidden = NO;
                [_rightButton setTitle:@"已经取消" forState:UIControlStateNormal];
                _rightButton.backgroundColor = noCanSelectColor;
                _rightButton.enabled = NO;
                _orderModel.orderStatus = @"CANCELD";

            }
        }];
    }else if ( [_orderModel.orderStatus isEqualToString: @"UN_COMMENTED"] ) {
        
        EFAfterSaleVC *next = [[EFAfterSaleVC alloc] initWithObjectId:_orderModel.objectId];
        [self.navigationController pushViewController:next animated:YES];
        
    } else if ( [_orderModel.orderStatus isEqualToString: @"APPLY_AFTER_SALE"] ) { //申请售后
        
        EFAftermarketStatusVC *next = [[EFAftermarketStatusVC alloc] init];
        next.orderId = _orderModel.objectId;
        next.name = _orderModel.shop.name;
        [self.navigationController pushViewController:next animated:YES];
    }

}

- (void) rightButtonAction {
    
    NSLog(@"EFGoodsTwoCellRightButton");
    
    WS(weakSelf)
    
    if( [_orderModel.orderStatus isEqualToString: @"UN_PAYED"] ) {
        
        [self payOrder:_orderModel ]; //去支付
        
    } else if ( [_orderModel.orderStatus isEqualToString: @"SHIPPED"] ) { //待收货
        
        [self.viewModel ReceivedOrder:_orderModel.objectId callBackBlock:^(CallBackStatus callBackStatus, NetworkModel *result) {
            
            if ([result.jsonDict[@"status"] intValue] == 200)  {
                NSLog(@"收货成功");
                weakSelf.leftButton.hidden = NO;
                weakSelf.rightButton.hidden = NO;
                [weakSelf.rightButton setTitle:@"评价" forState:UIControlStateNormal];
                [_leftButton setTitle:@"申请售后" forState:UIControlStateNormal];
                weakSelf.leftButton.enabled = YES;
                weakSelf.leftButton.backgroundColor = RGBColor(25, 182, 23);
                _orderModel.orderStatus = @"UN_COMMENTED";

            }
        }];
    }else if ( [_orderModel.orderStatus isEqualToString: @"UN_COMMENTED"] || [_orderModel.orderStatus isEqualToString: @"APPLY_AFTER_SALE"]  ) {
        
        //跳转评价界面
        EFCommentListVC *next = [[EFCommentListVC alloc] init];
        next.orderModel = _orderModel;
        [self.navigationController pushViewController:next animated:YES];
    }

}


#pragma mark 支付
- (void)payOrder :(OrderModel *)orderModel {
    WS(weakSelf)
    BOOL isShow = NO;
     NSString *orderIdString = [NSString stringWithFormat:@"%ld",(long)orderModel.objectId];
    EFPayAlertView *payView = [[EFPayAlertView alloc] initWithType:@"" andIsShowWalletPay:isShow CallBack:^(NSString *Type) {
        if ([Type isEqualToString:@"我的钱包"]) {
            DCPaymentView *paymentView = [[DCPaymentView alloc] init];
            paymentView.title = @"钱包零钱";
            paymentView.detail = @"钱包零钱";
            [paymentView EFMailcompleteHandle:^(NSString *inputPwd) {
                

                [weakSelf.viewModel BalancePay:orderIdString callBackBlock:^(CallBackStatus callBackStatus, NetworkModel *result) {
                    
                    if ([result.jsonDict[@"status"] intValue] == 200)  {
                        [self PaySuccess];
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
    self.leftButton.backgroundColor = RGBColor(175, 176, 175);
    self.leftButton.enabled = NO;
    [self.rightButton setTitle:@"确认收货" forState:UIControlStateNormal];
}

- (void) initData {
    
    if([_orderStatus isEqualToString:@"UN_PAYED"]) {
        
        [_rightButton setTitle:@"立即支付" forState:UIControlStateNormal];
        [_leftButton setTitle:@"取消订单" forState:UIControlStateNormal];
        _leftButton.backgroundColor = canSelectColor;
        _rightButton.hidden = NO;
        _leftButton.hidden = NO;
        _rightButton.enabled = YES;
        _rightButton.enabled = YES;
        
    }else if ([_orderStatus isEqualToString:@"SHIPPED"]) {
        
        [_rightButton setTitle:@"确认收货" forState:UIControlStateNormal];
        _rightButton.hidden = NO;
        _rightButton.enabled = YES;
        _leftButton.hidden = YES;
        
    } else if ([_orderStatus isEqualToString:@"UN_COMMENTED"] || [_orderStatus isEqualToString:@"APPLY_AFTER_SALE"]) {
        
        [_rightButton setTitle:@"评价" forState:UIControlStateNormal];
        [_leftButton setTitle:@"申请售后" forState:UIControlStateNormal];
        _leftButton.backgroundColor = RGBColor(25, 182, 23);
        _rightButton.hidden = NO;
        _leftButton.hidden = NO;
        _rightButton.enabled = YES;
        _leftButton.enabled = YES;
        
    }else if([_orderStatus isEqualToString:@"CANCELD"]) {
        _rightButton.hidden = NO;
        [_rightButton setTitle:@"已取消" forState:UIControlStateNormal];
        _rightButton.backgroundColor = noCanSelectColor;
        _rightButton.enabled = NO;
        _leftButton.hidden = YES;
        
        
    }else if( [_orderStatus isEqualToString:@"UN_SHIP"] ) {
        _rightButton.hidden = NO;
        _leftButton.hidden = YES;
        [_rightButton setTitle:@"待发货" forState:UIControlStateNormal];
        _rightButton.enabled = NO;
        _rightButton.backgroundColor = noCanSelectColor;
        
    }else if( [_orderStatus isEqualToString:@"FINISHED"] ) {
        _rightButton.hidden = NO;
        _leftButton.hidden = YES;
        
        _rightButton.enabled = YES;
        [_rightButton setTitle:@"已完成" forState:UIControlStateNormal];
        _rightButton.backgroundColor = noCanSelectColor;
    }

}

- (void) setOrderStatus:(NSString *)orderStatus {
    _orderStatus = orderStatus;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == EFOrderDetailVCSectionNS_ENUM_OrderStatus) {
        
        EFOrderStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:EFGoodsTwoCellEFOrderStatusCell];
        cell.orderStatus = self.viewModel.orderDetailModel.orderStatus;
        
        return cell;
        
    }else if (indexPath.section == EFOrderDetailVCSectionNS_ENUM_GoodInfo) {
        
        OrderproductModel *orderProduct = _dataSource[indexPath.row] ;
        
        EFOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderCell];
        cell.orderproductModel = orderProduct;
        
        if(indexPath.row+1 == _dataSource.count) { //最后一行添加一个View
            
            
            NSString *sumString = [NSString stringWithFormat:@"￥%ld",self.viewModel.orderDetailModel.price];
            CGFloat rowBottomViewH = 49;
            
            UIColor *lableColor = EF_TextColor_TextColorPrimary;
            UIView *rowBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, rowBottomViewH)];
            [cell addSubview:rowBottomView];
            
            CGFloat labelY = 45;
            KYMHLabel *leftLabel = [[KYMHLabel alloc] initWithTitle:@"实付款" BaseSize:CGRectMake(spaceToLeft, labelY, 70, 20) LabelColor:nil LabelFont:15 LabelTitleColor:lableColor TextAlignment:NSTextAlignmentLeft];
            [rowBottomView addSubview:leftLabel];
            
            CGFloat rightLabelW = SCREEN_WIDTH/2;
            KYMHLabel *rightLabel = [[KYMHLabel alloc] initWithTitle:sumString BaseSize:CGRectMake(SCREEN_WIDTH -rightLabelW-spaceToLeft , labelY, rightLabelW, 20) LabelColor:nil LabelFont:16 LabelTitleColor:lableColor TextAlignment:NSTextAlignmentRight];
            [rightLabel FontWeight:20];
            [rowBottomView addSubview:rightLabel];
        }
        
        return cell;
        
    }else if(indexPath.section == EFOrderDetailVCSectionNS_ENUM_Business) {
        
        EFMallDetailsStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:EFMallDetailsStoreCellEFGoodsTwoCell];
        OrderShop *orderShop  = self.viewModel.orderDetailModel.shop;
        cell.orderShop = orderShop;
        cell.indexPath = indexPath;
        if (!cell.phoneButtonClickedBlock) {
            [cell setPhoneButtonClickedBlock:^(NSIndexPath *indexPath) {
                
            }];
        }
        return cell;
        
    } else { //EFOrderDetailVCSectionNS_ENUM_OrderInfo
        
        EFOrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderInfoCellEFGoodsTwoCell];
        cell.leftLabel.text = _orderinfoLeftArray[indexPath.row];
        cell.rightLabel.text = _orderinfoRightArray[indexPath.row];
        
        if(indexPath.row+1 == _orderinfoLeftArray.count) {
            cell.lineView.hidden = YES;
        }else {
            cell.lineView.hidden = NO;
        }
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == EFOrderDetailVCSectionNS_ENUM_OrderStatus ||
       section == EFOrderDetailVCSectionNS_ENUM_GoodStatus ) {
        return 1;
    }else if (section == EFOrderDetailVCSectionNS_ENUM_GoodInfo) {
        return _dataSource.count;
    }else  if(section == EFOrderDetailVCSectionNS_ENUM_OrderInfo) {
        return _orderinfoLeftArray.count;
    }else {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == EFOrderDetailVCSectionNS_ENUM_OrderStatus) {
        return 79;
    }else if(indexPath.section == EFOrderDetailVCSectionNS_ENUM_GoodInfo) {
        if(indexPath.row+1 != _dataSource.count) {
            return 81;
        } else {
            return 120;
        }
        
    }else if(indexPath.section == EFOrderDetailVCSectionNS_ENUM_Business) {
        
        return 91;
    }else if(indexPath.section == EFOrderDetailVCSectionNS_ENUM_OrderInfo) {
        
        return 44;
        
    }else {
        return 49;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, sectionViewH)];
    headView.backgroundColor = RGBColor(248, 249, 248);
    
    KYMHLabel *nameLabel = [KYMHLabel new];
    nameLabel.textColor = EF_TextColor_TextColorPrimary;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = Font(sectionFontSize);
    
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
    [nameLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    return headView;
}

-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return sectionViewH;
}

#pragma mark scrollViewDelegate
/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.tableView) {
        CGFloat sectionHeaderHeight = sectionViewH;
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
            
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
            
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
            
        }
    }
}
 */


#pragma mark ViewModel 回调
- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    
    if (action & EFMailShopCart_GetOrderById) {
        [self.tableView endLoading];
        if ([result.jsonDict[@"status"] intValue] == 200) {
            
            [_dataSource removeAllObjects];
            for (int i=0; i<self.viewModel.orderDetailModel.orderProduct.count; i++) {
            OrderproductModel  *model = self.viewModel.orderDetailModel.orderProduct[i];
                [_dataSource addObject:model];
            }
            
            long long time = self.viewModel.orderDetailModel.createTime;
            NSDate * data = [NSDate dateWithTimeIntervalSince1970:time/1000.0];
            NSString *timeString = [UIUtil prettyDateNoChangeWithReference:data];
            
            [_orderinfoRightArray addObject: [self returnString:self.viewModel.orderDetailModel.consignee]];
            [_orderinfoRightArray addObject: [self returnString:self.viewModel.orderDetailModel.phone]];
            [_orderinfoRightArray addObject: [self returnString:self.viewModel.orderDetailModel.address]];
            [_orderinfoRightArray addObject: @"我的钱包"];
            [_orderinfoRightArray addObject: [self returnString:timeString]];
        }
        [self createUITableView];
    }
}

- (NSString *) returnString: (NSString *)string {
    if([string isEqualToString:@""] || string == nil) {
        return @"--";
    }else {
        return string;
    }
}

- (void)dealloc
{
    if (self.viewModel) {
        [self.viewModel cancelAndClearAll];
        self.viewModel = nil;
    }
}
@end
