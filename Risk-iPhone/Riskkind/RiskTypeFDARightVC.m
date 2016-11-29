//
//  RSFDARightVC.m
//  Risk
//
//  Created by ylgwhyh on 16/7/5.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RiskTypeFDARightVC.h"
#import "YFViewPager.h"
#import "EFMailNS_Enum.h"
#import "RiskTypeFDARightCell.h"
#import "RiskTypeDetailVC.h"
#import "RiskFactorModel.h"
#import "RiskTypeFDALeftVC.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "SVProgressHUD.h"
#import "RSMethod.h"
#import "RSRiskViewModel.h"

typedef NS_ENUM(NSInteger, EF_MyOrderVC_NS_ENUM) {
    RiskTypeFDARightVC_ENUM_One = 0,
    RiskTypeFDARightVC_ENUM_Two = 1,
    RiskTypeFDARightVC_ENUM_Three = 2,
    RiskTypeFDARightVC_ENUM_Four = 3,
    EF_MyOrderVC_NS_ENUM_Five = 4
};

@interface RiskTypeFDARightVC () < UITableViewDataSource, UITableViewDelegate, RiskTypeFDALeftVCDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *riskArray;

@property (nonatomic, strong) NSMutableArray *AllDataArray;
@property (nonatomic, strong) NSMutableArray *TwoDataArray;
@property (nonatomic, strong) NSMutableArray *ThreeDataArray;
@property (nonatomic, strong) NSMutableArray *FourDataArray;
@property (nonatomic, strong) NSMutableArray *FiveDataArray;

@property (nonatomic, strong) KYTableView *tableView;
@property (nonatomic, strong) KYTableView *twoTableView;
@property (nonatomic, strong) KYTableView *threeTableView;
@property (nonatomic, strong) KYTableView *fourTableView;
@property (nonatomic, strong) KYTableView *fiveTableView;

@property (nonatomic, strong) YFViewPager *viewPager;

@property (nonatomic, strong) UIColor *mainBGColor;

@property (nonatomic, strong) UIImageView *navBarHairlineImageView;

@property (nonatomic, strong) KYMHLabel *noDataLabel;

@property (nonatomic, assign) NSInteger orderButtonClickInteger; //记录点击的哪个选项

@property (nonatomic, strong)  RSRiskViewModel *viewModel;

@property (nonatomic, copy) NSString *fdaType;

@property (nonatomic, strong) NSArray *fdaTypeArray;

@end

@implementation RiskTypeFDARightVC{
    CGFloat segmentH;
    CGFloat spaceToLeft;

    CGFloat sectionImageH;
    CGFloat sectionFontSize;
    
    UIColor *canSelectColor;
    UIColor *noCanSelectColor;
}

static NSString * const RiskTypeFDARightCell_ID = @"RiskTypeFDARightCell_ID";

-(void)viewWillAppear:(BOOL)animated {
    _navBarHairlineImageView.hidden = YES;
    
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [SVProgressHUD dismiss];
}

- (void)viewWillDisappear:(BOOL)animated {
    _navBarHairlineImageView.hidden = NO;
    
    //还原此页Navigation的设置
    self.navigationController.navigationBar.translucent = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
}


- (void) initUI {
    [self initViewPager];
    [self initLineView];
}

- (void ) initLineView {
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, segmentH+2, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = EF_TextColor_TextColorSecondary;
    [self.view addSubview:lineView];
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
    if(_fiveTableView == nil) {
        _fiveTableView = [self createUITableView];
    }
    
    
    NSArray *titles = @[@"A", @"B", @"C", @"D", @"X"];
    NSArray *views = [[NSArray alloc] initWithObjects:
                      _tableView,
                      _twoTableView,
                      _threeTableView,
                      _fourTableView,
                      _fiveTableView, nil];
    
    if(_viewPager == nil ) {
        _viewPager = [[YFViewPager alloc] initWithFrame:CGRectMake(0 , 0, SCREEN_WIDTH ,SCREEN_HEIGHT-64)
                                                 titles:titles
                                                  icons:nil
                                          selectedIcons:nil
                                                  views:views];
        
        [self.view addSubview:_viewPager];
        
#pragma mark - YFViewPager 相关属性 方法
        _viewPager.showVLine = NO;
        _viewPager.tabArrowBgColor = [UIColor whiteColor];
        _viewPager.tabBgColor = [UIColor whiteColor];
        _viewPager.tabSelectedArrowBgColor = [UIColor redColor];
        _viewPager.tabSelectedBgColor = [UIColor whiteColor];
        _viewPager.tabSelectedTitleColor = RiskTypeTitleColor;
        _viewPager.tabTitleColor = RiskTypeTitleColor;
        _viewPager.bottomLineToBottomSpace = 1;
        _viewPager.showAnimation = NO;  //使用动画，cpu占有率非常高，这是这个三方库的bug，有时间了修改.
        
        WS(weakSelf)
        
        [_viewPager didSelectedBlock:^(id viewPager, NSInteger index) {
            
            switch (index) {
                case RiskTypeFDARightVC_ENUM_One:
                {
                    NSLog(@"点击第一个菜单");
                    weakSelf.orderButtonClickInteger = RiskTypeFDARightVC_ENUM_One;
                    weakSelf.fdaType = weakSelf.fdaTypeArray[RiskTypeFDARightVC_ENUM_One];
                    if(weakSelf.AllDataArray.count == 0) {
                        [weakSelf requestNetData];
                    }else {
                       // [weakSelf.dataSource removeAllObjects];
                        //weakSelf.dataSource = [weakSelf.AllDataArray mutableCopy];
                        weakSelf.dataSource =  weakSelf.AllDataArray;
                         [weakSelf.tableView reloadData];
                    }
                   
                }
                    break;
                case 1:
                {
                    NSLog(@"点击第二个菜单");
                    weakSelf.orderButtonClickInteger = RiskTypeFDARightVC_ENUM_Two;
                    weakSelf.fdaType = weakSelf.fdaTypeArray[RiskTypeFDARightVC_ENUM_Two];
                    if(weakSelf.TwoDataArray.count == 0) {
                        [weakSelf requestNetData];
                    }else {
                        //[weakSelf.dataSource removeAllObjects];
                        //weakSelf.dataSource = [weakSelf.TwoDataArray mutableCopy];
                         weakSelf.dataSource = weakSelf.TwoDataArray;
                        [weakSelf.twoTableView reloadData];
                    }
                }
                    break;
                case 2:
                {
                    NSLog(@"点击第三个菜单");
                    weakSelf.orderButtonClickInteger = RiskTypeFDARightVC_ENUM_Three;
                    weakSelf.fdaType = weakSelf.fdaTypeArray[RiskTypeFDARightVC_ENUM_Three];
                    if(weakSelf.ThreeDataArray.count == 0) {
                        [weakSelf requestNetData];
                    }else {
                        //[weakSelf.dataSource removeAllObjects];
                        //weakSelf.dataSource = [weakSelf.ThreeDataArray mutableCopy];
                        weakSelf.dataSource = weakSelf.ThreeDataArray;
                        [weakSelf.threeTableView reloadData];
                    }
                }
                    break;
                    
                case 3:
                {
                    NSLog(@"点击第四个菜单");
                    weakSelf.orderButtonClickInteger = RiskTypeFDARightVC_ENUM_Four;
                    weakSelf.fdaType = weakSelf.fdaTypeArray[RiskTypeFDARightVC_ENUM_Four];
                    if(weakSelf.FourDataArray.count == 0) {
                        [weakSelf requestNetData];
                    }else {
                        //[weakSelf.dataSource removeAllObjects];
                        //weakSelf.dataSource = [weakSelf.FourDataArray mutableCopy];
                        weakSelf.dataSource = weakSelf.FourDataArray;
                        [weakSelf.fourTableView reloadData];
                    }
                }
                    break;
                
                case EF_MyOrderVC_NS_ENUM_Five:
                {
                    NSLog(@"点击第四个菜单");
                    weakSelf.orderButtonClickInteger = EF_MyOrderVC_NS_ENUM_Five;
                    weakSelf.fdaType = weakSelf.fdaTypeArray[EF_MyOrderVC_NS_ENUM_Five];
                    if(weakSelf.FiveDataArray.count == 0) {
                        [weakSelf requestNetData];
                    }else {
                        //[weakSelf.dataSource removeAllObjects];
                        //weakSelf.dataSource = [weakSelf.FiveDataArray mutableCopy];
                        weakSelf.dataSource = weakSelf.FiveDataArray;
                        [weakSelf.fiveTableView reloadData];
                    }
                }
                default:
                    break;
            }
        }];
    }
    
    if(_orderButtonClickInteger == RiskTypeFDARightVC_ENUM_One) {
        
        [self noDataWithArray:self.dataSource tableView:_tableView];
        
    }else  if (_orderButtonClickInteger == RiskTypeFDARightVC_ENUM_Two) {
        
        [self noDataWithArray:self.dataSource tableView:_twoTableView];
        
    }else  if (_orderButtonClickInteger == RiskTypeFDARightVC_ENUM_Three) {
        
        [self noDataWithArray:self.dataSource tableView:_threeTableView];
        
    }else if ( _orderButtonClickInteger == RiskTypeFDARightVC_ENUM_Four) {
        
        [self noDataWithArray:self.dataSource tableView:_fourTableView];
        
    }else {
    }
}

- (void) noDataWithArray:(NSArray *)dataArray tableView:(KYTableView *)tableView {
//    if(dataArray.count <= 0){
//        if(_noDataLabel == nil){
//            _noDataLabel = [[KYMHLabel alloc] initWithTitle:@"暂无数据，下拉刷新" BaseSize:CGRectMake(0,0,SCREEN_WIDTH/2, SCREEN_H_RATE*15) LabelColor: [UIColor clearColor] LabelFont:16 LabelTitleColor:[UIColor grayColor] TextAlignment:NSTextAlignmentCenter];
//            _noDataLabel.center = CGPointMake(SCREEN_WIDTH/4*3, SCREEN_HEIGHT/5*2);
//            [tableView addSubview:_noDataLabel];
//        }
//    } else {
//        if(_noDataLabel != nil) {
//            [_noDataLabel removeFromSuperview];
//            _noDataLabel = nil;
//        }
//        [tableView reloadData];
//    }
}

#pragma mark RequestData

- (void ) requestNetData {
    [RSMethod ylg_SVProgressHUD_showWithSVProgressHUDMaskTypeNone];
    [self.viewModel findFDARisk:_fdaType riskId:_model.objectId];
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

- (void) initData {
    
    //初始化请求参数
    _fdaType = @"A";
    
    _fdaTypeArray = @[@"A", @"B", @"C", @"D", @"X"]; //第一个参数不用
    
    _dataSource = [[NSMutableArray alloc] init];
    _riskArray = [[NSMutableArray alloc] init];

    _viewModel = [[RSRiskViewModel alloc] initWithViewController:self];
    
    _orderButtonClickInteger = RiskTypeFDARightVC_ENUM_One;
    segmentH = 40;
    spaceToLeft = 10;

    sectionImageH = 17;
    sectionFontSize = 13;
    
    canSelectColor = RGBColor(25, 182, 23);
    noCanSelectColor = RGBColor(175, 176, 175);
    
    _AllDataArray = [[NSMutableArray alloc] init];
    _ThreeDataArray =  [[NSMutableArray alloc] init];
    _TwoDataArray = [[NSMutableArray alloc] init];
    _FourDataArray = [[NSMutableArray alloc] init];
    _FiveDataArray =  [[NSMutableArray alloc] init];
    
    self.title = @"风险分类";
    _mainBGColor = EF_MainColor;
    //再定义一个imageview来等同于这个黑线（去掉Navigation下面的黑线）
    _navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    _navBarHairlineImageView.image = [UIImage imageWithColor:_mainBGColor];

}


- (KYTableView *)createUITableView{
    
    WS(weakSelf)
    KYTableView *tableView = [[KYTableView alloc]initWithFrame:CGRectMake(0, segmentH+1, SCREEN_WIDTH, SCREEN_HEIGHT-segmentH-64-49) andUpBlock:^{
        [weakSelf.tableView endLoading];
        [weakSelf.twoTableView endLoading];
        [weakSelf.threeTableView endLoading];
        [weakSelf.fourTableView endLoading];
        [weakSelf.fiveTableView endLoading];

        if(_orderButtonClickInteger == RiskTypeFDARightVC_ENUM_One) {
            //[self.viewModel getMyOrderList:0 Size:20 Status:@"ALL"];
        }else  if (_orderButtonClickInteger == RiskTypeFDARightVC_ENUM_Two) {
            //[self.viewModel getMyOrderList:0 Size:20 Status:@"UN_PAYED"];
        }else  if (_orderButtonClickInteger == RiskTypeFDARightVC_ENUM_Three) {
            _orderButtonClickInteger = RiskTypeFDARightVC_ENUM_Four;
            //[self.viewModel getMyOrderList:0 Size:20 Status:@"SHIPPED"];
        }else if (_orderButtonClickInteger == EF_MyOrderVC_NS_ENUM_Five) {
           // [self.viewModel getMyOrderList:0 Size:20 Status:@"UN_COMMENTED"];
        }else {
             // [self.viewModel getMyOrderList:0 Size:20 Status:@"UN_COMMENTED"];
        }
        
    } andDownBlock:^{
        
        [weakSelf.tableView endLoading];
        [weakSelf.twoTableView endLoading];
        [weakSelf.threeTableView endLoading];
        [weakSelf.fourTableView endLoading];
        [weakSelf.fiveTableView endLoading];
        
    }];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[RiskTypeFDARightCell class] forCellReuseIdentifier:RiskTypeFDARightCell_ID];
    tableView.emptyDataSetSource = self;
    tableView.emptyDataSetDelegate = self;
    tableView.tableFooterView = [UIView new];
    
    [tableView reloadData];
    
    return tableView;
}

#pragma mark Refresh Data

- (void ) refreshData {
    
    if(_orderButtonClickInteger == RiskTypeFDARightVC_ENUM_One) {
        
        [_AllDataArray removeAllObjects];
        _AllDataArray = [_dataSource mutableCopy];
        [_tableView reloadData];
        [self noDataWithArray:self.dataSource tableView:_tableView];
        
    }else  if (_orderButtonClickInteger == RiskTypeFDARightVC_ENUM_Two) {
        
        [_TwoDataArray removeAllObjects];
        _TwoDataArray = [_dataSource mutableCopy];
         [_twoTableView reloadData];
        [self noDataWithArray:self.dataSource tableView:_twoTableView];
        
    }else  if (_orderButtonClickInteger == RiskTypeFDARightVC_ENUM_Three) {
        
        [_ThreeDataArray removeAllObjects];
        _ThreeDataArray = [_dataSource mutableCopy];
         [_threeTableView reloadData];
        [self noDataWithArray:self.dataSource tableView:_threeTableView];
        
    }else if ( _orderButtonClickInteger == RiskTypeFDARightVC_ENUM_Four) {
        
        [_FourDataArray removeAllObjects];
        _FourDataArray = [_dataSource mutableCopy];
        [_fourTableView reloadData];
        [self noDataWithArray:self.dataSource tableView:_fourTableView];
        
    }else {
        
        [_FiveDataArray removeAllObjects];
        _FiveDataArray = [_dataSource mutableCopy];
        [_fiveTableView reloadData];
        [self noDataWithArray:self.dataSource tableView:_fourTableView];
    }
    
}

#pragma mark - TableView data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    RSFDARiskModel *model = _dataSource[indexPath.row];
    RiskTypeFDARightCell *cell = [tableView dequeueReusableCellWithIdentifier:RiskTypeFDARightCell_ID];
    cell.model = model;
    cell.indicatorImageView.hidden = NO;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataSource.count;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RiskTypeDetailVC *next = [[RiskTypeDetailVC alloc] init];
    ChildrensModel *model = [[ChildrensModel alloc] init];
    RSRFDAModel *rsRFDAModel = _dataSource[indexPath.row];
    model.objectId = rsRFDAModel.objectId;
    next.objectId = (int)model.objectId;
    [self.navigationController pushViewController:next animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id model = _dataSource[indexPath.row];

    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[RiskTypeFDARightCell class] contentViewWidth:[self cellContentViewWith]];
}

- (CGFloat)cellContentViewWith {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width/2;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    
    return width;
}

#pragma mark Set

- (void ) setModel:(RSRFDAModel *)model {
    _model = model;
}

- (void ) setRsRiskKindVC:(RSRiskKindVC *)rsRiskKindVC {
    
     _rsRiskKindVC = rsRiskKindVC;

}

#pragma mark 开启了FDA  RiskTypeFDALeftVCDelegate

- (void ) RiskTypeFDALeftVC:(RiskTypeFDALeftVC *)RiskTypeFDALeftVC didSelectedRiskTypeFDALeftVC:(RSRFDAModel *)model {
    _model = model;
    [self.viewModel findFDARisk:_fdaType riskId:_model.objectId];
}

#pragma mark DZNEmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = MFNoDataPromptString;
    UIColor *textColor = EF_TextColor_TextColorSecondary;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: textColor};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}


#pragma mark ViewModel回调

- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    
    [SVProgressHUD dismiss];
    [self.tableView endLoading];
    if (action & RSRisk_NS_ENUM_findFDARisk) {
        if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeSuccess) {
            [_dataSource removeAllObjects];
            _dataSource = [self.viewModel.rsFDARiskModelArray mutableCopy];
            [self refreshData];
        }
    }
}

#pragma mark dealloc

- (void)dealloc{
    if (self.viewModel) {
        [self.viewModel cancelAndClearAll];
        self.viewModel = nil;
    }
}

@end
