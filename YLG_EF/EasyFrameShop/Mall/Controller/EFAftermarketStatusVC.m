//
//  EFAftermarketStatusVC.m
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/24.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFAftermarketStatusVC.h"
#import "EFShopCartViewModel.h"
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

@interface EFAftermarketStatusVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) KYTableView *tableView;
@property (nonatomic, strong) UIColor *mainBGColor;


@property (nonatomic, strong) NSArray *nameArray;
@property (nonatomic, strong) NSArray *orderinfoLeftArray;
@property (nonatomic, strong) NSMutableArray *orderinfoRightArray;

@property (nonatomic, strong) EFShopCartViewModel *viewModel;
@property (nonatomic, strong) KYMHLabel *noDataLabel;

@property (strong, nonatomic) UIView *backgroundView;  //底部View
@property (strong, nonatomic)  KYMHButton *rightButton;

@end

@implementation EFAftermarketStatusVC {
    
    CGFloat segmentH;
    CGFloat spaceToLeft;
    CGFloat sectionViewH;
    CGFloat sectionImageH;
    CGFloat sectionFontSize;
    CGFloat bottomViewH;
}

typedef NS_ENUM(NSInteger, EFOrderDetailVCSectionNS_ENUM) {
    
    EFOrderDetailVCSectionNS_ENUM_OrderStatus=0,
    EFOrderDetailVCSectionNS_ENUM_GoodInfo,
    EFOrderDetailVCSectionNS_ENUM_Business,
};

static NSString * const OrderCell = @"EFMyOrderVCGoodCell";
static NSString * const OrderCellEFGoodsTwoCell = @"EFGoodsTwoCell";
static NSString * const EFGoodsTwoCellEFOrderStatusCell = @"EFOrderDetailVCEFOrderStatusCellEFGoodsTwoCell";
static NSString * const EFMallDetailsStoreCellEFGoodsTwoCell = @"EFMallDetailsStoreCellEFGoodsTwoCell";
static NSString * const OrderInfoCellEFGoodsTwoCell = @"OrderInfoCellEFGoodsTwoCell";
static NSString * const GoodStatusCellEFGoodsTwoCell = @"GoodStatusCellEFGoodsTwoCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];

    [self.viewModel FindByOrder:self.orderId];
    
    // Do any additional setup after loading the view.
}

- (void) initDataSource {
    
    self.title = @"售后状态查询";
    self.view.backgroundColor = RGBColor(239, 244, 248);
    self.automaticallyAdjustsScrollViewInsets = NO;
    _mainBGColor = EF_MainColor;
    

    self.viewModel = [[EFShopCartViewModel alloc]initWithViewController:self];
    
    _orderinfoRightArray = [NSMutableArray array];
    segmentH = 40;
    spaceToLeft = 10;
    sectionViewH = 30;
    sectionImageH = 17;
    sectionFontSize = 13;
    bottomViewH = 49;
    
    _nameArray = @[@"售后状态",@"仁恒美光牙科", @" "];
    _orderinfoLeftArray = @[@"商品信息",@"商品价格", @"数量", @"申请时间"];
    _orderinfoRightArray = @[@"Lebond 电动牙刷三合一",@"￥599", @"1", @"2016-06-07 10:28"];
    
}



- (KYTableView *)createUITableView{
    
    //创建底部视图
    [self setupCustomBottomView];
    
    WS(weakSelf)
    if (!_tableView) {
        _tableView = [[KYTableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) andUpBlock:^{
             [self.viewModel FindByOrder:self.orderId];
            
        } andDownBlock:^{
            [weakSelf.tableView endLoading];
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[EFGoodsCell class] forCellReuseIdentifier:OrderCell];
        [_tableView registerClass:[EFOrderDetailTwoCell class] forCellReuseIdentifier:OrderCellEFGoodsTwoCell];
        [_tableView registerClass:[EFOrderStatusCell class] forCellReuseIdentifier:EFGoodsTwoCellEFOrderStatusCell];
        [_tableView registerClass:[EFOrderInfoCell class] forCellReuseIdentifier:OrderInfoCellEFGoodsTwoCell];
        [self.view addSubview:_tableView];
        
    }
    
    if(self.viewModel.returnOfGoodsModel == nil){
        
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
        
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, bottomViewH)];
        _backgroundView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_backgroundView];
        
        UIView *lineView = [UIView new];
        _rightButton = [KYMHButton new];
        lineView.backgroundColor = EF_TextColor_TextColorSecondary;
        [_backgroundView addSubview:lineView];
        
        _rightButton.backgroundColor = RGBColor(25, 182, 23);
        _rightButton.layer.cornerRadius = 5;
        _rightButton.titleLabel.font = Font(14);
        [_rightButton setTitle:@"确认收货" forState:UIControlStateNormal];
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
    }
    
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == EFOrderDetailVCSectionNS_ENUM_OrderStatus) {
        
        EFOrderStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:EFGoodsTwoCellEFOrderStatusCell];
        cell.orderStatus = self.viewModel.returnOfGoodsModel.returnsStatus;
        
        return cell;
        
    }else {
        
        static NSString *cellIdentifier=@"UITableViewCellIdentifierKey1";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(!cell){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        
        UIColor *staticLabelTitleColor = EF_TextColor_TextColorSecondary;
        KYMHLabel *staticLabel = [[KYMHLabel alloc] initWithTitle:@"商家回复" BaseSize:CGRectMake( spaceToLeft, spaceToLeft, 80, 20) LabelColor:nil LabelFont:sectionFontSize LabelTitleColor:staticLabelTitleColor TextAlignment:NSTextAlignmentLeft];
        [cell addSubview:staticLabel];
        
        UIColor *businessReplyLabelTitleColor = EF_TextColor_TextColorPrimary;
        KYMHLabel *businessReplyLabel = [[KYMHLabel alloc] initWithTitle:@"商家回复商家回复商家回复商家回复商家回复商家回复商家回复商家回复商家回复商家回复商家回复商家回复商家回复商家回复商家回复商家回复" BaseSize:CGRectMake( spaceToLeft, spaceToLeft+ CGRectGetMaxY(staticLabel.frame), SCREEN_WIDTH-2*spaceToLeft, 50) LabelColor:nil LabelFont:sectionFontSize LabelTitleColor:businessReplyLabelTitleColor TextAlignment:NSTextAlignmentLeft];
        [cell addSubview:businessReplyLabel];
        
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == EFOrderDetailVCSectionNS_ENUM_OrderStatus) {
        return 79;
    }else {
        return 120;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if(section == 1) {
        
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
        nameLabel.text = self.name;
        indicatorImageView.image = Img(@"");
        indicatorImageView.backgroundColor = [UIColor grayColor];
       // tradeStateLabel.text = [self getOrderStatusWithString:orderModel.orderStatus];
        
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
    }else {
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
    
}

-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return sectionViewH;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if(section == EFOrderDetailVCSectionNS_ENUM_OrderStatus) {
        UIView *sectionFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
        sectionFootView.backgroundColor = RGBColor(238, 244, 249);
        return sectionFootView;
    }else {
        return nil;
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


#pragma mark ViewModel 回调
- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    
    [self.tableView endLoading];

    if (action & EFMailShopCart_FindByOrder) {
        [self.tableView endLoading];
        if ([result.jsonDict[@"status"] intValue] == 200) {
               [_dataSource removeAllObjects];
        }
         [self createUITableView];
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
