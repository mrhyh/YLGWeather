//
//  MyCollecVC.m
//  Risk-iPhone
//
//  Created by Cherie Jeong on 16/9/7.
//  Copyright © 2016年 Cherie Jeong. All rights reserved.
//

#import "MyCollecVC.h"
#import "RSMyCollectionLeftCell.h"
#import "RSMyCollectionRightCell.h"
#import "RiskDataModel.h"

#import "RSRiskViewModel.h"
#import "RSMyCollectRiskModel.h"
#import "RSMyCollectFilesModel.h"
#import "RSVideoVC.h"
#import "RSDataVC.h"
#import "RiskTypeDetailVC.h"
#import "EHHorizontalSelectionView.h"  //顶部标题栏



@interface MyCollecVC ()<UITableViewDelegate, UITableViewDataSource,EHHorizontalSelectionViewProtocol,UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *leftDateSource;
@property (nonatomic, strong) NSMutableArray *RightDateSource;

@property (nonatomic, strong) KYTableView *leftTableView;
@property (nonatomic, strong) KYTableView *rightTableView;


@property (nonatomic, strong) UIView *leftHeadView;
@property (nonatomic, strong) UIView *rightHeadView;

//没数据时的提示
@property (nonatomic, strong) KYMHLabel * leftNoDataLB;
@property (nonatomic, strong) KYMHLabel * rightNoDataLB;
@property (nonatomic, strong) UIImageView *noDataLeftImageView;
@property (nonatomic, strong) UIImageView *noDataRightImageView;

@property (nonatomic, assign) int leftPage;
@property (nonatomic, assign) int rightPage;

@property (nonatomic, strong) RSRiskViewModel * viewModel;

@property (nonatomic, strong) UIScrollView * backScrollView;
@property (nonatomic,strong) EHHorizontalSelectionView * topTitleView;  //顶部标题栏
@property (nonatomic,assign) NSInteger seletedInteger;  //选择的页数
@property (nonatomic,assign) BOOL      isScrolling;    //是否正在滚动
@property (nonatomic, assign) BOOL isPulldown; //是否下拉刷新

@end

@implementation MyCollecVC {
    //记录scrollView位置
    CGFloat contentOffsetY;
    CGFloat oldContentOffsetY;
    CGFloat newContentOffsetY;
}

static NSString * const RiskTypeFDARightCell_One_ID = @"RiskTypeFDARightCell_One_ID";
static NSString * const RiskTypeFDARightCell_Two_ID = @"RiskTypeFDARightCell_Two_ID";

- (UIScrollView *)backScrollView {
    if (_backScrollView == nil) {
        _backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+MFCommonTopTitleViewH, SCREEN_WIDTH, SCREEN_HEIGHT-64-30)];
        _backScrollView.backgroundColor = EF_BGColor_Primary;
        _backScrollView.alwaysBounceHorizontal = NO;
        _backScrollView.showsHorizontalScrollIndicator = NO;
        _backScrollView.bounces = NO;
        _backScrollView.delegate = self;
        _backScrollView.pagingEnabled = YES;
        [_backScrollView setContentSize:CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT-64-30)];
    }
    return _backScrollView;
}

- (EHHorizontalSelectionView *)topTitleView {
    if (_topTitleView == nil) {
        _topTitleView = [[EHHorizontalSelectionView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        _topTitleView.delegate = self;
        _topTitleView.backgroundColor = [UIColor whiteColor];
        [_topTitleView registerCellWithClass:[EHHorizontalLineViewCell class]];
        UIColor *color = EF_MainColor;
        [_topTitleView setTintColor:color];
        [EHHorizontalLineViewCell updateColorHeight:2.f];
        _topTitleView.collectionView.scrollEnabled = NO;
    }
    return _topTitleView;
}

#pragma mark - EHHorizontalSelectionViewProtocol

- (NSUInteger)numberOfItemsInHorizontalSelection:(EHHorizontalSelectionView*)hSelView
{
    return 2;
}

- (NSString *)titleForItemAtIndex:(NSUInteger)index forHorisontalSelection:(EHHorizontalSelectionView*)hSelView
{
    return [[@[@"风险收藏",@"资料收藏"] objectAtIndex:index] uppercaseString];
}

//选择
- (void)horizontalSelection:(EHHorizontalSelectionView *)hSelView didSelectObjectAtIndex:(NSUInteger)index {
    
    if (_seletedInteger != index && !_isScrolling) {
        _isScrolling = YES;
        _seletedInteger = index;
        CGRect  rect = CGRectMake(SCREEN_WIDTH*_seletedInteger, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        [_backScrollView scrollRectToVisible:rect animated:YES];
    }
    
//    if (YES == _isPulldown) {
//        
//    }else {
//        if (_seletedInteger != index && !_isScrolling) {
//            _isScrolling = YES;
//            _seletedInteger = index;
//            CGRect  rect = CGRectMake(SCREEN_WIDTH*_seletedInteger, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
//            [_backScrollView scrollRectToVisible:rect animated:YES];
//        }
//    }
//     _isPulldown = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self initData];

    [self requestAction];
}

- (void)requestAction {
    [self requestMyFavourateData];
    [self requestMyFavourateRiskData];
}

- (void) initData {
    _leftDateSource = [NSMutableArray array];
    _RightDateSource = [NSMutableArray array];
    _leftPage = 0;
    _rightPage = 0;
    _viewModel = [[RSRiskViewModel alloc]initWithViewController:self];
}

- (void)requestMyFavourateData {
    [_viewModel findMyFavourateTargetsWithPage:self.leftPage Size:150];   //我的收藏--资料
}

- (void)requestMyFavourateRiskData {
    [_viewModel findMyFavourateTargetsRISKWithPage:self.rightPage Size:150];   //我的收藏--风险
}

- (void) initUI {
    
    WS(weakSelf)
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"我的收藏";
    
    [self.view addSubview:self.backScrollView];
    [self.view addSubview:self.topTitleView];
    
    _leftTableView = [self createTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-64-30) cellID:RiskTypeFDARightCell_One_ID tableViewCell:[RSMyCollectionLeftCell class]];
    
    UIColor *borderColor = EF_TextColor_TextColorDisable;
    _leftTableView.layer.borderColor =borderColor.CGColor;
    _leftTableView.layer.borderWidth = 1.0;
    
    [_backScrollView addSubview:_leftTableView];
    
    _leftTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.leftDateSource.count > 0) {
            weakSelf.leftPage = 0;
            [weakSelf.leftDateSource removeAllObjects];
            [weakSelf requestMyFavourateRiskData];
        }else {
            [_leftTableView.mj_header endRefreshing];
        }
        weakSelf.isPulldown = YES;
    }];
    _leftTableView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
        weakSelf.leftPage++;
        [self requestMyFavourateRiskData];
        weakSelf.isPulldown = YES;
    }];
    

    _rightTableView = [self createTableViewWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-30) cellID:RiskTypeFDARightCell_Two_ID tableViewCell:[RSMyCollectionRightCell class]];
    [_backScrollView addSubview:_rightTableView];
    _rightTableView.layer.borderColor =borderColor.CGColor;
    _rightTableView.layer.borderWidth = 1.0;
    
    _rightTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.RightDateSource.count > 0) {
            weakSelf.rightPage = 0;
            [weakSelf.RightDateSource removeAllObjects];
            [weakSelf requestMyFavourateData];
        }else {
            [_rightTableView.mj_header endRefreshing];
        }
        weakSelf.isPulldown = YES;
    }];
    _rightTableView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
        weakSelf.rightPage++;
        [weakSelf requestMyFavourateData];
        weakSelf.isPulldown = YES;
    }];
    
    //Left
    _noDataLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80, 233, 133)];
    _noDataLeftImageView.centerX = _leftTableView.centerX;
    _noDataLeftImageView.image = Img(@"tu");
    _noDataLeftImageView.contentMode = UIViewContentModeScaleAspectFill;
    _noDataLeftImageView.clipsToBounds = YES;
    [_leftTableView addSubview:_noDataLeftImageView];
    _noDataLeftImageView.hidden = YES;
    
    CGFloat leftLabelY = CGRectGetMaxY(_noDataLeftImageView.frame)+10;
    
    _leftNoDataLB = [[KYMHLabel alloc]initWithTitle:@"暂无收藏" BaseSize:CGRectMake(0, leftLabelY, SCREEN_WIDTH, 30) LabelColor:[UIColor clearColor] LabelFont:15 LabelTitleColor:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary] TextAlignment:NSTextAlignmentCenter];
    [_leftTableView addSubview:_leftNoDataLB];
    _leftNoDataLB.hidden = YES;
    
    //Right
    _noDataRightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80, 233, 133)];
    _noDataRightImageView.centerX = self.view.centerX;
    _noDataRightImageView.image = Img(@"tu");
    _noDataRightImageView.contentMode = UIViewContentModeScaleAspectFill;
    _noDataRightImageView.clipsToBounds = YES;
    [_rightTableView addSubview:_noDataRightImageView];
    _noDataRightImageView.hidden = YES;
    
    _rightNoDataLB = [[KYMHLabel alloc]initWithTitle:@"暂无收藏" BaseSize:CGRectMake(0, leftLabelY, SCREEN_WIDTH, 30) LabelColor:[UIColor clearColor] LabelFont:15 LabelTitleColor:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary] TextAlignment:NSTextAlignmentCenter];
    [_rightTableView addSubview:_rightNoDataLB];
    _rightNoDataLB.hidden = YES;
}

#pragma mark Create UI

- (KYTableView *) createTableViewWithFrame:(CGRect )frame cellID:(NSString *)cellID tableViewCell: (Class )cellClass {
    
    KYTableView *tableView = [[KYTableView alloc] initWithFrame:frame andUpBlock:^{
    } andDownBlock:^{
    } andStyle:UITableViewStylePlain];
    
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [tableView registerClass:cellClass forCellReuseIdentifier:cellID];
    
    return tableView;
}

#pragma mark TableView data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _leftTableView ) {
       
        RSMyCollectionLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:RiskTypeFDARightCell_One_ID];
        if (!cell) {
            cell = [[RSMyCollectionLeftCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:RiskTypeFDARightCell_One_ID];
        }
        
        if (_leftDateSource.count > indexPath.row) {
            Risks *model = _leftDateSource[indexPath.row];
            cell.model = model;
        }
        return cell;
        
    }else {
       
        RSMyCollectionRightCell *cell = [tableView dequeueReusableCellWithIdentifier:RiskTypeFDARightCell_Two_ID];
        if (!cell) {
            cell = [[RSMyCollectionRightCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:RiskTypeFDARightCell_Two_ID];
        }
        
        if (_RightDateSource.count > indexPath.row) {
            Riskfiles *model = _RightDateSource[indexPath.row];
            cell.model = model;
        }
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _leftTableView ) {
        return _leftDateSource.count;
    }else {
        return _RightDateSource.count;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf)
    if (tableView == _leftTableView) {
        Risks *model = _leftDateSource[indexPath.row];
        
        RiskTypeDetailVC * next = [[RiskTypeDetailVC alloc]init];
        next.riskTypeDetailVCRefreshBlock = ^(BOOL isRefresh) {
            if (isRefresh) {
                //刷新网络
                [weakSelf requestMyFavourateRiskData];
            }
        };
        next.objectId = (int)model.objectId;
        [self.navigationController pushViewController:next animated:YES];
    }else {
        
        Riskfiles *model = _RightDateSource[indexPath.row];
        
        if(model.isVideo ) {
            RSVideoVC *next= [[RSVideoVC alloc]initWithCallBack:^(BOOL isSuccess) {
                model.contentSocail.readCount += 1;
                [tableView reloadData];
            }];
            next.rsVideoVCRefreshBlock = ^ (BOOL isRefresh) {
                if (isRefresh) {
                    [weakSelf requestMyFavourateData];
                }
            };
            
            next.title = @"视频";
            next.objectId = model.objectId;
            [self.navigationController pushViewController:next animated:YES];
        }else {
            RSDataVC *vc = [[RSDataVC alloc]initWithCallBack:^(BOOL isSuccess) {
                model.contentSocail.readCount += 1;
                [tableView reloadData];
            }];
            vc.objectId = (int)model.objectId;
            
            vc.rsDataVCRefreshBlock = ^ (BOOL isRefresh ) {
                if (isRefresh) {
                    [weakSelf requestMyFavourateData];
                }
            };
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _leftTableView ) {
        
        if(_leftDateSource.count > 0) {
            id model = _leftDateSource[indexPath.row];
            
            return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[RSMyCollectionLeftCell class] contentViewWidth:[RSMethod cellContentViewWith]];
        }else {
            return  0;
        }
        
    }else {
        
        if(_RightDateSource.count > 0) {
        //            id model = _RightDateSource[indexPath.row];
        //            return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[RSMyCollectionRightCell class] contentViewWidth:[RSMethod cellContentViewWith]];
            NSLog(@"MFCommonCellH=%f",MFCommonCellH);
            
            return MFCommonCellH;
        }else {
            return  0;
        }
    }
}

#pragma mark -- scrollview
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _backScrollView ) {
        if (fabs(scrollView.contentSize.width - _backScrollView.size.width ) >= 0.001) {
            float scrollFloat = (float)scrollView.contentOffset.x / scrollView.frame.size.width * 1.0;
            NSInteger scrollInteger = (NSInteger)scrollView.contentOffset.x / scrollView.frame.size.width;
            float f = scrollFloat - ((int)scrollFloat+1);
            f = fabsf(f);
            if (f <= 0.5) return;
            
            if (scrollInteger != _seletedInteger && !_isScrolling) {
                _seletedInteger = scrollInteger;
                _isScrolling = YES;
                [_topTitleView selectIndex:_seletedInteger];
            }
        }
    }
}

//PushListView.m
//开始拖拽视图
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    contentOffsetY = scrollView.contentOffset.y;
}

//完成拖拽(滚动停止时调用此方法，手指离开屏幕前)
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // NSLog(@"scrollViewDidEndDragging");
    oldContentOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"滚动结束");
    _isScrolling = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"滚动结束");
    if (scrollView == _backScrollView) {
        _isScrolling = NO;
        if (fabs(scrollView.contentSize.width - _backScrollView.size.width ) >= 0.001) //横向滚动
        {
            NSInteger scrollInteger = (NSInteger)scrollView.contentOffset.x / scrollView.frame.size.width;
            if (scrollInteger != _seletedInteger ) {
                _seletedInteger = scrollInteger;
                [_topTitleView selectIndex:_seletedInteger];
            }
        }
        else
        {
            //NSLog(@"上下移动");
        }
    }
}


#pragma mark 网络回调
- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result {
    if (action == RSRisk_NS_ENUM_findMyFavourateTargets) {
        if (result.status == 200) {
            _RightDateSource = (NSMutableArray *)[_viewModel.collecttionFilesModel.riskFiles mutableCopy];
        }
        if (_RightDateSource.count <= 0) {
            _rightNoDataLB.hidden = NO;
            _noDataRightImageView.hidden = NO;
        }else {
            _rightNoDataLB.hidden = YES;
            _noDataRightImageView.hidden = YES;
        }
         [_rightTableView reloadData];
        [_rightTableView.mj_header endRefreshing];
        [_rightTableView.mj_footer endRefreshing];
    }
    
    if (action == RSRisk_NS_ENUM_findMyFavourateTargets_RISK) {
        if (result.status == 200) {
            _leftDateSource =(NSMutableArray *) [_viewModel.riskModel.risks mutableCopy];
        }
        if (_leftDateSource.count <= 0) {
            _leftNoDataLB.hidden = NO;
            _noDataLeftImageView.hidden = NO;
        }else {
            _leftNoDataLB.hidden = YES;
            _noDataLeftImageView.hidden = YES;
        }
        [_leftTableView reloadData];
        [_leftTableView.mj_header endRefreshing];
        [_leftTableView.mj_footer endRefreshing];
    }
}

- (void)dealloc {
    if (_viewModel) {
        [_viewModel cancelAndClearAll];
        _viewModel = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
