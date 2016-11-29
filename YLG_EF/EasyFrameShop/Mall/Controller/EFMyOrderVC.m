//
//  EF_MyOrderVC.m
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/13.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFMyOrderVC.h"
#import "EFGoodsCell.h"
#import "EFGoodModel.h"
#import "EFGoodsTwoCell.h"
#import "EFOrderDetailVC.h"
#import "EFOrderDetailTwoVC.h"
#import "EFOrderConfirmVC.h"
#import "YFViewPager.h"
#import "EFShopCartViewModel.h"
#import "EFMailNS_Enum.h"
#import "EFOrderCommentVC.h"
#import "EFPayAlertView.h"
#import "DCPaymentView.h"
#import "EFPushCommentVC.h"
#import "EFAfterSaleVC.h"
#import "EFCommentListVC.h"
#import "EFAftermarketStatusVC.h"
#import "AppDelegate+Payment.h"

typedef NS_ENUM(NSInteger, EF_MyOrderVC_NS_ENUM) {
    EF_MyOrderVC_NS_ENUM_All = 0,
    EF_MyOrderVC_NS_ENUM_NoPayment = 1,
    EF_MyOrderVC_NS_ENUM_NoGetGood = 2,
    EF_MyOrderVC_NS_ENUM_NoAppraise = 3
};

@interface EFMyOrderVC()  < UITableViewDataSource, UITableViewDelegate,EFGoodsTwoCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;

//用于记录4个订单状态的数据
@property (nonatomic, strong) NSMutableArray *AllDataArray;
@property (nonatomic, strong) NSMutableArray *TwoDataArray;
@property (nonatomic, strong) NSMutableArray *ThreeDataArray;
@property (nonatomic, strong) NSMutableArray *FourDataArray;

@property (nonatomic, strong) KYTableView *tableView;
@property (nonatomic, strong) KYTableView *twoTableView;
@property (nonatomic, strong) KYTableView *threeTableView;
@property (nonatomic, strong) KYTableView *fourTableView;
@property (nonatomic, strong) YFViewPager *viewPager;

@property (nonatomic, strong) UIColor *mainBGColor;

@property (nonatomic, strong) UIImageView *navBarHairlineImageView;

@property (nonatomic, strong) EFShopCartViewModel *viewModel;
@property (nonatomic, strong) KYMHLabel *noDataLabel;

@property (nonatomic, assign) NSInteger orderButtonClickInteger; //记录点击的哪个选项

@property (nonnull,strong)EFGoodsTwoCell * btCell;

@end

@implementation EFMyOrderVC {
    CGFloat segmentH;
    CGFloat spaceToLeft;
    CGFloat sectionViewH;
    CGFloat sectionImageH;
    CGFloat sectionFontSize;
    
    UIColor *canSelectColor;
    UIColor *noCanSelectColor;
}

static NSString * const OrderCell = @"EFMyOrderVCGoodCell";
static NSString * const OrderCellEFGoodsTwoCell = @"EFGoodsTwoCell";

-(void)viewWillAppear:(BOOL)animated {
    _navBarHairlineImageView.hidden = YES;

    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillDisappear:(BOOL)animated {
    _navBarHairlineImageView.hidden = NO;
    if (self.completeBlock) {
        self.completeBlock(YES);
        self.completeBlock = nil;
    }
    //还原此页Navigation的设置
    self.navigationController.navigationBar.translucent = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;
}

- (void)viewDidDisappear:(BOOL)animated{
    
}

- (instancetype)initWithCallBack:(EFMyOrderVCBlock)callBack{
    self = [super init];
    if (self) {
        self.completeBlock = callBack;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PaySuccess) name:@"PaySuccessNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PaySuccess) name:@"PaySuccessNotificationWX" object:nil];
    [self initDataSource];
    
    [self.viewModel getMyOrderList:0 Size:20 Status:@"ALL"];
    
    [self initViewPager];
}


-(void)initViewPager {

    if(_tableView == nil) {
         _tableView = [self createUITableView];
    }
    if(_twoTableView == nil) {
         _twoTableView = [self createUITableView];
    }
    if(_threeTableView == nil) {
        _threeTableView = [self createUITableView];
    }
    if(_fourTableView == nil) {
        _fourTableView = [self createUITableView];
    }
    
    NSArray *titles = @[@"全部", @"待支付", @"待收货", @"待评价"];
    
    NSArray *views = [[NSArray alloc] initWithObjects:
                      _tableView,
                      _twoTableView,
                      _threeTableView,
                      _fourTableView, nil];
    
    if(_viewPager == nil ) {
        _viewPager = [[YFViewPager alloc] initWithFrame:CGRectMake(0 , 0, SCREEN_WIDTH ,SCREEN_HEIGHT- segmentH)
                                                 titles:titles
                                                  icons:nil
                                          selectedIcons:nil
                                                  views:views];
        
        [self.view addSubview:_viewPager];
        
#pragma mark - YFViewPager 相关属性 方法
        _viewPager.showVLine = NO;
        _viewPager.tabArrowBgColor = [UIColor whiteColor];
        _viewPager.tabBgColor = _mainBGColor;
        _viewPager.tabSelectedArrowBgColor = [UIColor whiteColor];
        _viewPager.tabSelectedBgColor = _mainBGColor;
        _viewPager.tabSelectedTitleColor = [UIColor whiteColor];
        _viewPager.tabTitleColor = [UIColor whiteColor];
        
        [_viewPager didSelectedBlock:^(id viewPager, NSInteger index) {
            switch (index) {
                case 0:
                {
                    NSLog(@"点击第一个菜单");
                    _orderButtonClickInteger = EF_MyOrderVC_NS_ENUM_All;
//                    if(_AllDataArray.count == 0) {
//                        [self.viewModel getMyOrderList:0 Size:20 Status:@"ALL"];
//                    }
                
                    [self.viewModel getMyOrderList:0 Size:20 Status:@"ALL"];
                    [_dataSource removeAllObjects];
                    //[_dataSource addObjectsFromArray:_AllDataArray];
                    [_tableView reloadData];
                }
                    break;
                case 1:
                {
                    NSLog(@"点击第二个菜单");
                    _orderButtonClickInteger = EF_MyOrderVC_NS_ENUM_NoPayment;
                    
//                    if(_TwoDataArray.count == 0) {
//                        [self.viewModel getMyOrderList:0 Size:20 Status:@"UN_PAYED"];
//                    }
                    [self.viewModel getMyOrderList:0 Size:20 Status:@"UN_PAYED"];
                    [_dataSource removeAllObjects];
                    //[_dataSource addObjectsFromArray:_TwoDataArray];
                     [_twoTableView reloadData];
                }
                    break;
                case 2:
                {
                     NSLog(@"点击第三个菜单");
                    _orderButtonClickInteger = EF_MyOrderVC_NS_ENUM_NoGetGood;
                    
//                    if(_ThreeDataArray.count == 0) {
//                           [self.viewModel getMyOrderList:0 Size:20 Status:@"SHIPPED"];
//                    }
                    [self.viewModel getMyOrderList:0 Size:20 Status:@"SHIPPED"];
                    [_dataSource removeAllObjects];
                    //[_dataSource addObjectsFromArray:_ThreeDataArray];
                    [_threeTableView reloadData];

                }
                    break;
                    
                case 3:
                {
                    NSLog(@"点击第四个菜单");
                    _orderButtonClickInteger = EF_MyOrderVC_NS_ENUM_NoAppraise;
                    
//                    if(_FourDataArray.count == 0) {
//                         [self.viewModel getMyOrderList:0 Size:20 Status:@"UN_COMMENTED"];
//                    }
                    [self.viewModel getMyOrderList:0 Size:20 Status:@"UN_COMMENTED"];
                    [_dataSource removeAllObjects];
                    //[_dataSource addObjectsFromArray:_FourDataArray];
                     [_fourTableView reloadData];
                }
                    break;
                    
                default:
                    break;
            }
        }];
    }

    if(_orderButtonClickInteger == EF_MyOrderVC_NS_ENUM_All) {
        
        [self noDataWithArray:self.dataSource tableView:_tableView];
        
    }else  if (_orderButtonClickInteger == EF_MyOrderVC_NS_ENUM_NoPayment) {
        
        [self noDataWithArray:self.dataSource tableView:_twoTableView];
        
    }else  if (_orderButtonClickInteger == EF_MyOrderVC_NS_ENUM_NoGetGood) {
        
        [self noDataWithArray:self.dataSource tableView:_threeTableView];
        
    }else {
        
        [self noDataWithArray:self.dataSource tableView:_fourTableView];
        
    }
}


- (void) noDataWithArray:(NSArray *)dataArray tableView:(KYTableView *)tableView {
    
    if(dataArray.count <= 0){
        [_noDataLabel removeFromSuperview];
        _noDataLabel = nil;
        _noDataLabel = [[KYMHLabel alloc] initWithTitle:@"暂无数据，下拉刷新" BaseSize:CGRectMake(0,0,SCREEN_WIDTH, SCREEN_H_RATE*15) LabelColor: [UIColor clearColor] LabelFont:16 LabelTitleColor:[UIColor grayColor] TextAlignment:NSTextAlignmentCenter];
        _noDataLabel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/5*2);
        [tableView addSubview:_noDataLabel];
        [tableView reloadData];
    } else {
        if(_noDataLabel != nil) {
            [_noDataLabel removeFromSuperview];
            _noDataLabel = nil;
        }
        [tableView reloadData];
    }
}


//通过一个方法来找到这个黑线(findHairlineImageViewUnder):
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void) initDataSource {
    
    self.viewModel = [[EFShopCartViewModel alloc] initWithViewController:self];
    
    _orderButtonClickInteger = EF_MyOrderVC_NS_ENUM_All;
    segmentH = 60;
    spaceToLeft = 10;
    sectionViewH = 30;
    sectionImageH = 17;
    sectionFontSize = 13;
    
    canSelectColor = RGBColor(25, 182, 23);
    noCanSelectColor = RGBColor(175, 176, 175);
    
    _AllDataArray = [NSMutableArray array];
    _ThreeDataArray = [NSMutableArray array];
    _TwoDataArray = [NSMutableArray array];
    _FourDataArray = [NSMutableArray array];
    
    self.title = @"我的订单";
    _mainBGColor = EF_MainColor;
    
    //再定义一个imageview来等同于这个黑线（去掉Navigation下面的黑线）
    _navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    _navBarHairlineImageView.image = [UIImage imageWithColor:_mainBGColor];
    
    
    _dataSource = [NSMutableArray array];

}


- (KYTableView *)createUITableView{
    
    WS(weakSelf)
    KYTableView *tableView;
    tableView = [[KYTableView alloc]initWithFrame:CGRectMake(0, 0+segmentH, SCREEN_WIDTH, SCREEN_HEIGHT-segmentH-64) andUpBlock:^{
        [weakSelf.tableView endLoading];
        [weakSelf.twoTableView endLoading];
        [weakSelf.threeTableView endLoading];
        [weakSelf.fourTableView endLoading];

        if(_orderButtonClickInteger == EF_MyOrderVC_NS_ENUM_All) {
             [self.viewModel getMyOrderList:0 Size:20 Status:@"ALL"];
        }else  if (_orderButtonClickInteger == EF_MyOrderVC_NS_ENUM_NoPayment) {
             [self.viewModel getMyOrderList:0 Size:20 Status:@"UN_PAYED"];
        }else  if (_orderButtonClickInteger == EF_MyOrderVC_NS_ENUM_NoGetGood) {
           _orderButtonClickInteger = EF_MyOrderVC_NS_ENUM_NoAppraise;
             [self.viewModel getMyOrderList:0 Size:20 Status:@"SHIPPED"];
        }else {
            [self.viewModel getMyOrderList:0 Size:20 Status:@"UN_COMMENTED"];
        }
        
    } andDownBlock:^{
        
        [weakSelf.tableView endLoading];
        [weakSelf.twoTableView endLoading];
        [weakSelf.threeTableView endLoading];
        [weakSelf.fourTableView endLoading];
    }];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[EFGoodsCell class] forCellReuseIdentifier:OrderCell];
    [tableView registerClass:[EFGoodsTwoCell class] forCellReuseIdentifier:OrderCellEFGoodsTwoCell];
    return tableView;
}


//下拉刷新,上拉加载
- (void)Refreshing:(NSInteger )type{
    
    //上拉刷新
//    _ta.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        self.number = 0;
//        [self RequestData:type];
//        NSLog(@"=== 点击 “%@” ", type);
//        [_listView.mj_header endRefreshing];
//    }];
//    [_listView.mj_header beginRefreshing];
    
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WS(weakSelf)
    OrderModel *orderModel = _dataSource[indexPath.section];
    NSMutableArray *rowArray = [NSMutableArray array];
    rowArray = [orderModel.orderProduct copy];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
    
    if(indexPath.row+1 != rowArray.count) {
        EFGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderCell];
        OrderproductModel *orderproductModel = [OrderproductModel yy_modelWithJSON:rowArray[indexPath.row]];
        cell.orderproductModel = orderproductModel;

        return cell;
    }else {
       
        EFGoodsTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderCellEFGoodsTwoCell];
        OrderproductModel *orderproductModel = [OrderproductModel yy_modelWithJSON:rowArray[indexPath.row]];
        cell.orderproductModel = orderproductModel;
        cell.sumPrice = orderModel.price;
        cell.orderStatus = orderModel.orderStatus;

        //左边按钮点击
        [cell EFGoodsTwoCellLeftButton:^(NSInteger number) {
            
            NSLog(@"EFGoodsTwoCellLeftButton");
            
            if ( [orderModel.orderStatus isEqualToString: @"UN_PAYED"] ) {
                
                [weakSelf.viewModel cancelOrder:orderModel.objectId Caulse:@"测试" callBackBlock:^(CallBackStatus callBackStatus, NetworkModel *result) {
                    if ([result.jsonDict[@"status"] intValue] == 200)  {
                        NSLog(@"取消成功");
                        cell.leftButton.hidden = YES;
                        cell.rightButton.hidden = NO;
                        [cell.rightButton setTitle:@"已经取消" forState:UIControlStateNormal];
                        cell.rightButton.backgroundColor = noCanSelectColor;
                        cell.rightButton.enabled = NO;
                        orderModel.orderStatus = @"CANCELD";
                        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                }];
            }else if ( [orderModel.orderStatus isEqualToString: @"UN_COMMENTED"] ) {
                
                EFAfterSaleVC *next = [[EFAfterSaleVC alloc] initWithObjectId:orderModel.objectId];
                [self.navigationController pushViewController:next animated:YES];
                
            } else if ( [orderModel.orderStatus isEqualToString: @"APPLY_AFTER_SALE"] ) { //申请售后
                
                EFAftermarketStatusVC *next = [[EFAftermarketStatusVC alloc] init];
                next.orderId = orderModel.objectId;
                next.name = orderModel.shop.name;
                [self.navigationController pushViewController:next animated:YES];
            }

        }];
        
        //右边按钮点击
        [cell EFGoodsTwoCellRightButton:^(NSInteger number) {
            
            NSLog(@"EFGoodsTwoCellRightButton");
            
            if( [orderModel.orderStatus isEqualToString: @"UN_PAYED"] ) {
    
                [self payOrder:orderModel tableViewCell:cell tableView:tableView indexPath:indexPath]; //去支付
                
            } else if ( [orderModel.orderStatus isEqualToString: @"SHIPPED"] ) { //待收货
                
                [self.viewModel ReceivedOrder:orderModel.objectId callBackBlock:^(CallBackStatus callBackStatus, NetworkModel *result) {
                    
                    if ([result.jsonDict[@"status"] intValue] == 200)  {
                        NSLog(@"收货成功");
                        cell.leftButton.hidden = NO;
                        cell.rightButton.hidden = NO;
                        [cell.rightButton setTitle:@"评价" forState:UIControlStateNormal];
                        [cell.leftButton setTitle:@"申请售后" forState:UIControlStateNormal];
                        cell.leftButton.enabled = YES;
                        cell.leftButton.backgroundColor = RGBColor(25, 182, 23);
                        orderModel.orderStatus = @"UN_COMMENTED";
                        [_dataSource replaceObjectAtIndex:indexPath.section withObject:orderModel];
                        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                }];
            }else if ( [orderModel.orderStatus isEqualToString: @"UN_COMMENTED"] || [orderModel.orderStatus isEqualToString: @"APPLY_AFTER_SALE"]  ) {
                
                //跳转评价界面
                EFCommentListVC *next = [[EFCommentListVC alloc] init];
                next.orderModel = orderModel;
                [self.navigationController pushViewController:next animated:YES];
            }
        }];
        
        if(indexPath.section+1 == self.dataSource.count) {  //最后一条，用于底部分割的lineView要隐藏.
            cell.bottomLineView.hidden = YES;
        }else {
            cell.bottomLineView.hidden = NO;
        }

        return cell;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    OrderModel *orderModel = _dataSource[section];
    NSMutableArray *rowArray = [NSMutableArray array];
    rowArray = [orderModel.orderProduct copy];
    return rowArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderModel *orderModel = _dataSource[indexPath.section];
    NSArray *rowArray = [orderModel.orderProduct copy];
    if(indexPath.row+1 != rowArray.count) {
        return 81;
    }
    
    return 174;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, sectionViewH)];
    headView.backgroundColor = RGBColor(248, 249, 248);
    
    KYMHImageView *imageView = [KYMHImageView new];
    
    KYMHLabel *nameLabel = [KYMHLabel new];
    nameLabel.textColor = EF_TextColor_TextColorPrimary;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = Font(sectionFontSize);
    
    
    KYMHImageView *indicatorImageView = [KYMHImageView new];
    
    KYMHLabel *tradeStateLabel = [KYMHLabel new];
    tradeStateLabel.textColor = EF_TextColor_TextColorSecondary;
    tradeStateLabel.textAlignment = NSTextAlignmentRight;
    tradeStateLabel.font = Font(sectionFontSize);
    
    [headView addSubview:imageView];
    [headView addSubview:nameLabel];
    [headView addSubview:indicatorImageView];
    [headView addSubview:tradeStateLabel];
    
    //更新数据
    OrderModel *orderModel = _dataSource[section];
    imageView.image = Img(@"");
    imageView.backgroundColor = [UIColor grayColor];
    nameLabel.text = orderModel.shop.name;
    indicatorImageView.image = Img(@"");
    indicatorImageView.backgroundColor = [UIColor grayColor];
    tradeStateLabel.text = [self getOrderStatusWithString:orderModel.orderStatus];
    
    //布局
    CGFloat spaceToTop = (sectionViewH-sectionImageH)/2;
    imageView.sd_layout
    .leftSpaceToView(headView, spaceToLeft)
    .topSpaceToView(headView, spaceToTop)
    .widthIs(sectionImageH)
    .heightIs(sectionImageH);
    
    nameLabel.sd_layout
    .leftSpaceToView(imageView, spaceToLeft)
    .topSpaceToView(headView, spaceToTop)
    .heightIs(sectionImageH);
     [nameLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    indicatorImageView.sd_layout
    .leftSpaceToView(nameLabel, spaceToLeft)
    .topSpaceToView(headView, spaceToTop)
    .widthIs(sectionImageH)
    .heightIs(sectionImageH);

    tradeStateLabel.sd_layout
    .rightSpaceToView(headView, spaceToLeft)
    .topSpaceToView(headView, spaceToTop)
    .heightIs(sectionImageH);
    [tradeStateLabel setSingleLineAutoResizeWithMaxWidth:70];

    return headView;
}

-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return sectionViewH;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderModel *orderModel = _dataSource[indexPath.section];
    if(indexPath.section == 0) {
        EFOrderDetailTwoVC *next = [[EFOrderDetailTwoVC alloc] initWithProductId:orderModel.objectId andOrderStatus:orderModel.orderStatus andOrderModel:orderModel];
        [self.navigationController pushViewController:next animated:YES];
    }else {
        EFOrderDetailVC *next = [[EFOrderDetailVC alloc] init];
        next.orderId = orderModel.objectId;
        next.orderStatus = orderModel.orderStatus;
        next.orderModel = orderModel;
        [self.navigationController pushViewController:next animated:YES];
    }
}

#pragma mark 支付
- (void)payOrder :(OrderModel *)orderModel tableViewCell:(EFGoodsTwoCell *)cell tableView:(UITableView *)tableView  indexPath:(NSIndexPath *)indexPath{
    self.btCell = cell;
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
                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
                        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
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
     self.btCell.leftButton.backgroundColor = RGBColor(175, 176, 175);
     self.btCell.leftButton.enabled = NO;
    [ self.btCell.rightButton setTitle:@"确认收货" forState:UIControlStateNormal];
}


#pragma mark --- EFGoodsTwoCellDelegate
- (void)rightPayment:(NSInteger) orderStatusIngeter {
    
    if(orderStatusIngeter == EFMailOrderStatus_UN_PAYED) {
        EFOrderConfirmVC *confirmVC = [[EFOrderConfirmVC alloc] init];
        [self.navigationController pushViewController:confirmVC animated:YES];
    }else if( orderStatusIngeter == EFMailOrderStatus_SHIPPED) {
        NSLog(@"确认收货");
    }else if(orderStatusIngeter == EFMailOrderStatus_UN_COMMENTED) {
        
        EFOrderCommentVC *next = [[EFOrderCommentVC alloc] init];
        [self.navigationController pushViewController:next animated:YES];
    }

}


#pragma mark ViewModel 回调
- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    if (action & EFMailShopCart_MyOrderList) {
        if ([result.jsonDict[@"status"] intValue] == 200) {
            
            [_dataSource removeAllObjects];
            _dataSource = _viewModel.orderModelArray;
            
            if(_orderButtonClickInteger == EF_MyOrderVC_NS_ENUM_All) {
                _AllDataArray = [_dataSource copy];
            }else  if (_orderButtonClickInteger == EF_MyOrderVC_NS_ENUM_NoPayment) {
                _TwoDataArray = [_dataSource copy];
            }else  if (_orderButtonClickInteger == EF_MyOrderVC_NS_ENUM_NoGetGood) {
                _ThreeDataArray = [_dataSource copy];
            }else {
                _FourDataArray = [_dataSource copy];
            }
    
            [self initViewPager];
        }
    }
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

- (NSString *)getOrderStatusWithString:(NSString *)string {
    if([string isEqualToString:@"SHIPPED"]) {
        return @"已发货";
    }else  if([string isEqualToString:@"UN_PAYED"]) {
        return @"待支付";
    }else  if([string isEqualToString:@"CANCELD"]) {
        return @"已取消";
    }else  if([string isEqualToString:@"FINISHED"]) {
        return @"已完成";
    }else  if([string isEqualToString:@"UN_COMMENTED"]) {
        return @"待评价";
    }else if([string isEqualToString:@"UN_SHIP"]) { //SHIPPED
        return @"待发货";
    }else {
        return @"";
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