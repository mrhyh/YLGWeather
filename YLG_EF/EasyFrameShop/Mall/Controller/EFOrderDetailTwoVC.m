//
//  EFOrderDetailVC.m
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/14.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFOrderDetailTwoVC.h"
#import "EFGoodModel.h"
#import "EFGoodsCell.h"
#import "EFGoodsTwoCell.h"
#import "EFOrderStatusCell.h"
#import "EFMallDetailsStoreCell.h"
#import "EFOrderInfoCell.h"
#import "EFOrderDetailTwoCell.h"
#import "EFShopCartViewModel.h"
#import "EFAftermarketStatusVC.h"
#import "EFAfterSaleVC.h"
#import "EFPayAlertView.h"
#import "DCPaymentView.h"
#import "EFCommentListVC.h"

@interface EFOrderDetailTwoVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) KYTableView *tableView;
@property (nonatomic, strong) UIColor *mainBGColor;


@property (nonatomic, strong) NSArray *nameArray;
@property (nonatomic, strong) NSArray *orderinfoLeftArray;
@property (nonatomic, strong) NSMutableArray *orderinfoRightArray;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, copy) NSString *orderStatus;

@property (nonatomic, strong) EFShopCartViewModel *viewModel;
@property (nonatomic, strong) EFOrderDetailModel *orderDetailModel;

@property (nonatomic, strong) UIView *backgroundView;  //底部View
@property (nonatomic, strong)  KYMHButton *rightButton;
@property (nonatomic, strong)  KYMHButton *leftButton;
@property (nonatomic, strong)  UIView *rowBottomView;
@property (nonatomic, strong) OrderModel *orderModel;
@end

@implementation EFOrderDetailTwoVC {
    
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
    EFOrderDetailVCSectionNS_ENUM_GoodInfo = 1,
    EFOrderDetailVCSectionNS_ENUM_Business = 2,
    EFOrderDetailVCSectionNS_ENUM_OrderInfo = 3,
};

static NSString * const OrderCell = @"EFOrderDetailTwoVCGoodCell";
static NSString * const OrderCellEFGoodsTwoCell = @"EFOrderDetailTwoVCEFGoodsTwoCell";
static NSString * const EFOrderDetailTwoVCStatusCellEFGoodsTwoCell = @"EFOrderDetailTwoVCEFOrderStatusCellEFGoodsTwoCell";
static NSString * const EFMallDetailsStoreCellEFGoodsTwoCell = @"EFOrderDetailTwoVCEFMallDetailsStoreCellEFGoodsTwoCell";
static NSString * const OrderInfoCellEFGoodsTwoCell = @"EFOrderDetailTwoVCOrderInfoCellEFGoodsTwoCell";
static NSString * const GoodStatusCellEFGoodsTwoCell = @"EFOrderDetailTwoVCGoodStatusCellEFGoodsTwoCell";
#pragma mark --- lazy load
- (EFShopCartViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[EFShopCartViewModel alloc] initWithViewController:self];
    }
    return _viewModel;
}

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)orderinfoRightArray{
    if (_orderinfoRightArray == nil) {
        _orderinfoRightArray = [NSMutableArray array];
    }
    return _orderinfoRightArray;
}
#pragma mark --- life cycle
- (instancetype)initWithProductId:(NSInteger)orderId andOrderStatus:(NSString *)orderStatus andOrderModel:(OrderModel *)orderModel{
    if (self = [super init]) {
        self.orderId = orderId;
        self.orderStatus = orderStatus;
        self.orderModel = orderModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDataSource];
    [self.viewModel GetOrderById:self.orderId];
}

- (void) initDataSource {
    
    self.title = @"订单详情";
    self.view.backgroundColor = RGBColor(239, 244, 248);
    self.automaticallyAdjustsScrollViewInsets = NO;
    _mainBGColor = EF_MainColor;
    
    segmentH = 40;
    spaceToLeft = 10;
    sectionViewH = 30;
    sectionImageH = 17;
    sectionFontSize = 13;
    bottomViewH = 49;
    

    _nameArray = @[@"消费码",@"商品信息", @"商家", @"订单信息", @" "];
    _orderinfoLeftArray = @[@"联系人",@"联系电话", @"寄送地址", @"支付方式", @"下单时间 "];

}

- (KYTableView *)createUITableView{
    WS(weakSelf)
    if (!_tableView) {
        _tableView = [[KYTableView alloc]initWithFrame:CGRectMake(0, 11+64, SCREEN_WIDTH, SCREEN_HEIGHT-11-64) andUpBlock:^{
            [weakSelf.tableView endLoading];
        } andDownBlock:^{
            [weakSelf.tableView endLoading];
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[EFGoodsCell class] forCellReuseIdentifier:OrderCell];
        [_tableView registerClass:[EFOrderDetailTwoCell class] forCellReuseIdentifier:OrderCellEFGoodsTwoCell];
        [_tableView registerClass:[EFMallDetailsStoreCell class] forCellReuseIdentifier:EFMallDetailsStoreCellEFGoodsTwoCell];
        [_tableView registerClass:[EFOrderInfoCell class] forCellReuseIdentifier:OrderInfoCellEFGoodsTwoCell];
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == EFOrderDetailVCSectionNS_ENUM_OrderStatus) {
    static NSString * const sectionOneCell = @"EFOrderDetailTwoVCEFO15234rderStatusCellEFGoodsTwoCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sectionOneCell];
        if(!cell){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:sectionOneCell];
        }
        
        CGFloat topViewH = 60;
        if(_topView== nil) {
            _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, topViewH)];
            [cell addSubview:_topView];
            
            KYMHLabel *consumeCodeLabel = [KYMHLabel new];
            consumeCodeLabel.textColor = EF_MainColor;
            consumeCodeLabel.textAlignment = NSTextAlignmentLeft;
            consumeCodeLabel.font = Font(14);
            [_topView addSubview:consumeCodeLabel];
            
            KYMHLabel *useStatusLabel = [KYMHLabel new];
            useStatusLabel.textColor = EF_TextColor_TextColorSecondary;
            useStatusLabel.font = Font(14);
            useStatusLabel.textAlignment = NSTextAlignmentRight;
            [_topView addSubview:useStatusLabel];
            
            UIView *bottomView = [UIView new];
            bottomView.backgroundColor = RGBColor(239, 244, 248);
            [_topView addSubview:bottomView];
            
            //更新数据
            consumeCodeLabel.text = @"6000201608091019";
            useStatusLabel.text = @"未使用";
            
            //布局
            CGFloat labelH = 20;
            CGFloat LabelViewH = 10;
            CGFloat topSpace = (topViewH-labelH-LabelViewH)/2;
            consumeCodeLabel.sd_layout
            .leftSpaceToView (_topView, spaceToLeft)
            .topSpaceToView (_topView, topSpace)
            .heightIs(labelH);
            [consumeCodeLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/3*2];
            
            useStatusLabel.sd_layout
            .rightSpaceToView (_topView, spaceToLeft)
            .topSpaceToView (_topView, topSpace)
            .heightIs(labelH)
            .widthIs(70);
            
            bottomView.sd_layout
            .bottomSpaceToView (_topView, 0)
            .widthIs(SCREEN_WIDTH)
            .heightIs(LabelViewH);
        }
        
         return cell;
        
    }else if (indexPath.section == EFOrderDetailVCSectionNS_ENUM_GoodInfo) {
        if(indexPath.row+1 != self.dataSource.count) {
            EFGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderCell];
            EFGoodModel *goodModel = _dataSource[indexPath.row];
            cell.goodModel = goodModel;
            return cell;
        }else {
            EFOrderDetailTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderCellEFGoodsTwoCell];
            EFGoodModel *goodModel = _dataSource[indexPath.row];
            cell.goodModel = goodModel;
            return cell;
        }
    }else if(indexPath.section == EFOrderDetailVCSectionNS_ENUM_Business) {
        EFMallDetailsStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:EFMallDetailsStoreCellEFGoodsTwoCell];
        cell.orderShop = self.orderDetailModel.shop;
        cell.indexPath = indexPath;
        if (!cell.phoneButtonClickedBlock) {
            [cell setPhoneButtonClickedBlock:^(NSIndexPath *indexPath) {
                
            }];
        }
        return cell;
    }else if(indexPath.section == EFOrderDetailVCSectionNS_ENUM_OrderInfo) {
        EFOrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderInfoCellEFGoodsTwoCell];
        cell.leftLabel.text = _orderinfoLeftArray[indexPath.row];
        cell.rightLabel.text = _orderinfoRightArray[indexPath.row];
        
        if(indexPath.row+1 == _orderinfoLeftArray.count) {
            cell.lineView.hidden = YES;
        }else {
            cell.lineView.hidden = NO;
        }
        return cell;
    }else{
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == EFOrderDetailVCSectionNS_ENUM_OrderStatus ||
       section == EFOrderDetailVCSectionNS_ENUM_Business ) {
        return 1;
    }else if (section == EFOrderDetailVCSectionNS_ENUM_GoodInfo) {
        NSMutableArray *sectionArray = _dataSource;
        return sectionArray.count;
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
        return 50+10;
    }else if(indexPath.section == EFOrderDetailVCSectionNS_ENUM_GoodInfo) {
        if(indexPath.row+1 != self.dataSource.count) {
            return 81;
        }
        return 131;
    }else if(indexPath.section == EFOrderDetailVCSectionNS_ENUM_Business) {
        return 71;
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
    if(section == EFOrderDetailVCSectionNS_ENUM_OrderStatus){
        timeLabel.text = @"有效期: 2016-10-31 23:59";
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

- (void) setupCustomBottomView {
    
    if( _backgroundView == nil ) {
        
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-bottomViewH, SCREEN_WIDTH, bottomViewH)];
        _backgroundView.backgroundColor = [UIColor whiteColor];
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
                self.orderStatus = @"CANCELD";
                
            }
        }];
    }else if ( [self.orderStatus isEqualToString: @"UN_COMMENTED"] ) {
        
        EFAfterSaleVC *next = [[EFAfterSaleVC alloc] initWithObjectId:self.orderDetailModel.objectId];
        [self.navigationController pushViewController:next animated:YES];
        
    } else if ( [self.orderStatus isEqualToString: @"APPLY_AFTER_SALE"] ) { //申请售后
        
        EFAftermarketStatusVC *next = [[EFAftermarketStatusVC alloc] init];
        next.orderId = self.orderDetailModel.objectId;
        next.name = self.orderDetailModel.shop.name;
        [self.navigationController pushViewController:next animated:YES];
    }
    
}

- (void) rightButtonAction {
    
    NSLog(@"EFGoodsTwoCellRightButton");
    
    WS(weakSelf)
    
    if( [self.orderStatus isEqualToString: @"UN_PAYED"] ) {
        
//        [self payOrder:_orderModel ]; //去支付
        
    } else if ( [self.orderStatus isEqualToString: @"SHIPPED"] ) { //待收货
        
        [self.viewModel ReceivedOrder:self.orderDetailModel.objectId callBackBlock:^(CallBackStatus callBackStatus, NetworkModel *result) {
            
            if ([result.jsonDict[@"status"] intValue] == 200)  {
                NSLog(@"收货成功");
                weakSelf.leftButton.hidden = NO;
                weakSelf.rightButton.hidden = NO;
                [weakSelf.rightButton setTitle:@"评价" forState:UIControlStateNormal];
                [_leftButton setTitle:@"申请售后" forState:UIControlStateNormal];
                weakSelf.leftButton.enabled = YES;
                weakSelf.leftButton.backgroundColor = RGBColor(25, 182, 23);
                self.orderDetailModel.orderStatus = @"UN_COMMENTED";
                
            }
        }];
    }else if ( [self.orderDetailModel.orderStatus isEqualToString: @"UN_COMMENTED"] || [self.orderDetailModel.orderStatus isEqualToString: @"APPLY_AFTER_SALE"]  ) {
        
        //跳转评价界面
        EFCommentListVC *next = [[EFCommentListVC alloc] init];
        next.orderModel = self.orderModel;
        [self.navigationController pushViewController:next animated:YES];
    }
    
}

#pragma mark 支付
- (void)payOrder :(OrderModel *)orderModel {
    WS(weakSelf)
    BOOL isShow = NO;
    EFPayAlertView *payView = [[EFPayAlertView alloc] initWithType:@"" andIsShowWalletPay:isShow CallBack:^(NSString *Type) {
        if ([Type isEqualToString:@"我的钱包"]) {
            DCPaymentView *paymentView = [[DCPaymentView alloc] init];
            paymentView.title = @"钱包零钱";
            paymentView.detail = @"钱包零钱";
            [paymentView EFMailcompleteHandle:^(NSString *inputPwd) {
                
                NSString *orderIdString = [NSString stringWithFormat:@"%ld",(long)orderModel.objectId];
                [weakSelf.viewModel BalancePay:orderIdString callBackBlock:^(CallBackStatus callBackStatus, NetworkModel *result) {
                    
                    if ([result.jsonDict[@"status"] intValue] == 200)  {
                        
                        NSLog(@"付款成功");
                        weakSelf.leftButton.backgroundColor = RGBColor(175, 176, 175);
                        weakSelf.leftButton.enabled = NO;
                        [weakSelf.rightButton setTitle:@"确认收货" forState:UIControlStateNormal];
                    }
                }];
            }];
            [paymentView show];
        }
    }];
    
    [payView showPopupViewWithAnimate:YES];
}


#pragma mark ViewModel 回调
- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    
    if (action & EFMailShopCart_GetOrderById) {
        [self.tableView endLoading];
        if (result.status == NetworkModelStatusTypeSuccess) {
            
            self.orderDetailModel = [EFOrderDetailModel yy_modelWithJSON:result.content];
            
            [self.dataSource removeAllObjects];
            for (int i=0; i<self.orderDetailModel.orderProduct.count; i++) {
                OrderproductModel  *model = self.orderDetailModel.orderProduct[i];
                [self.dataSource addObject:model];
            }
            
            long long time = self.orderDetailModel.createTime;
            NSDate * data = [NSDate dateWithTimeIntervalSince1970:time/1000.0];
            NSString *timeString = [UIUtil prettyDateNoChangeWithReference:data];
            
            [self.orderinfoRightArray addObject: [self returnString:self.orderDetailModel.consignee]];
            [self.orderinfoRightArray addObject: [self returnString:self.orderDetailModel.phone]];
            [self.orderinfoRightArray addObject: [self returnString:self.orderDetailModel.address]];
            [self.orderinfoRightArray addObject: @"我的钱包"];
            [self.orderinfoRightArray addObject: [self returnString:timeString]];
        }
        [self createUITableView];
        [self setupCustomBottomView];
    }else{
        [UIUtil alert:@"数据加载失败！"];
    }
}

- (NSString *) returnString: (NSString *)string {
    if([string isEqualToString:@""] || string == nil) {
        return @"--";
    }else {
        return string;
    }
}
@end
