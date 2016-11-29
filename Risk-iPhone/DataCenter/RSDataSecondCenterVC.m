//
//  RSDataSecondCenterVC.m
//  Risk
//
//  Created by Cherie Jeong on 16/8/10.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSDataSecondCenterVC.h"
#import "SecondCollectionViewCell.h"
#import "RSDataVC.h"
#import "RSMoreDataVC.h"
#import "RSVideoVC.h"
#import "RSRiskViewModel.h"

#import "SecondTableCell.h"
#import "SVProgressHUD.h"

#import "EHHorizontalSelectionView.h"  //顶部标题栏

#define MainCollectionViewCell @"TwoMainCollectionViewCell"
#define SecondCollectionCell @"TwoSecondCollectionCell"
#define SecondCollectionLastCell @"TwoSecondCollectionLastCell"

@interface RSDataSecondCenterVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,EHHorizontalSelectionViewProtocol>

@property (nonatomic,strong) UICollectionView * mainCollectionView;
@property (nonatomic,assign) CGFloat  secondCellH;
@property (nonatomic,assign) int      cellCount;
@property (nonatomic,assign) CGFloat  lastCellH;
@property (nonatomic,strong) UIScrollView * backScrollView;

@property (nonatomic,strong) RSRiskViewModel *viewModel;

@property (nonatomic,strong) NSMutableArray *sourceDataArray;
@property (nonatomic,assign) BOOL   isSearch;

@property (nonatomic,strong)UIButton * noDataBtn;

@property (nonatomic,strong) EHHorizontalSelectionView * topTitleView;  //顶部标题栏
@property (nonatomic,strong) NSMutableArray * titlesArray;  //标题组
@property (nonatomic,assign) NSInteger seletedInteger;  //选择的页数
@property (nonatomic,assign) BOOL      isScrolling;    //是否正在滚动

@property (nonatomic, strong) UIView *pullDownView;
@property (nonatomic, strong) UIView *pullDownBGView;;
@property (nonatomic, strong) UIButton *topPullButton;
@property (nonatomic, strong) UIView *topPullButtonBGView;

@end

@implementation RSDataSecondCenterVC {
    NSInteger buttonCount;  //一行button数量
    CGFloat topTitleViewH;
    CGFloat topTitleButtonW;
    CGFloat topTitleButtonH;
    CGFloat pullButtonW;
    CGFloat pullButtonH;
    CGFloat spacePullButtonLineSpace;  //button行距
    CGFloat spacePullButtonColumnSpace; //button列距
    CGFloat spaceToLeft;
    CGFloat pullButtonFontSize;
    CGFloat pullDownViewH;
    BOOL isHiddePullDownBGView;
}

- (UIScrollView *)backScrollView {
    if (_backScrollView == nil) {
        _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _backScrollView.alwaysBounceHorizontal = NO;
    }
    return _backScrollView;
}

- (EHHorizontalSelectionView *)topTitleView {
    if (_topTitleView == nil) {
        _topTitleView = [[EHHorizontalSelectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MFCommonTopTitleViewH)];
        _topTitleView.delegate = self;
        _topTitleView.backgroundColor = [UIColor whiteColor];

        [_topTitleView registerCellWithClass:[EHHorizontalLineViewCell class]];
        UIColor *color = EF_MainColor;
        [_topTitleView setTintColor:color];
        [EHHorizontalLineViewCell updateColorHeight:2.f];
    }
    
    return _topTitleView;
}

- (NSMutableArray *)titlesArray {
    
    if (_titlesArray == nil) {
        _titlesArray = [NSMutableArray array];
    }
    
     [_titlesArray removeAllObjects];
    
    RSDateCenterModel *dcModel = [RSDateCenterModel new];
    NSString * titleStr = @"";
    for (int i = 0; i < _sourceDataArray.count; i++) {
        dcModel = _sourceDataArray[i];
        titleStr = dcModel.categoryName;
        [_titlesArray addObject:titleStr];
    }
    
    return _titlesArray;
}

#pragma mark - EHHorizontalSelectionViewProtocol

- (NSUInteger)numberOfItemsInHorizontalSelection:(EHHorizontalSelectionView*)hSelView
{
    return [self.titlesArray count];
}

- (NSString *)titleForItemAtIndex:(NSUInteger)index forHorisontalSelection:(EHHorizontalSelectionView*)hSelView
{
    return [[self.titlesArray objectAtIndex:index] uppercaseString];
}

//选择
- (void)horizontalSelection:(EHHorizontalSelectionView *)hSelView didSelectObjectAtIndex:(NSUInteger)index {
    
    if (_seletedInteger != index && !_isScrolling) {
        _isScrolling = YES;
        _seletedInteger = index;
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [_mainCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
#warning TODO 暂时这样，规避下划线不是唯一存在的bug
        [_topTitleView reloadData];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _categoryName;
    self.automaticallyAdjustsScrollViewInsets = NO;
    WS(weakSelf)
    
    [self.view addSubview:self.backScrollView];
    _backScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
    
    if (IS_IPHONE5) {
        _secondCellH = (SCREEN_HEIGHT-64-40-50)/7;
        _cellCount = 5;
        _lastCellH = 20;
    }else if(IS_IPHONE6) {
        _secondCellH = (SCREEN_HEIGHT-64-40-50)/8;
        _cellCount = 5;
        _lastCellH = 110;
    }else {
        _secondCellH = (SCREEN_HEIGHT-64-40-50)/8;
        _cellCount = 6;
        _lastCellH = 90;
    }
    _secondCellH = MFCommonCellH;
    
    [self initData];
    [self requestData];
}


- (void)refershData {
    
    [SVProgressHUD show];
    if ([UIUtil isEmptyStr:_keyWord]) {
        [self.viewModel moreRiskfilesOne:0 size:15 riskId:_categoryId];
    }else {
        [self.viewModel findMoreRiskFileByTitleOne:0 size:15 riskId:_categoryId keyWord:_keyWord];
    }
    
}

- (void ) initData {
    topTitleViewH = MFCommonTopTitleViewH;
    topTitleButtonW = topTitleViewH*1.25;
    topTitleButtonH = topTitleViewH*0.75;
    isHiddePullDownBGView = YES;
    buttonCount = 4;
    pullButtonW = 70;
    pullButtonH = 30;
    spacePullButtonLineSpace = 20;
    spaceToLeft = 10;
    spacePullButtonColumnSpace = (SCREEN_WIDTH-(buttonCount)*pullButtonW-2*spaceToLeft)/(buttonCount-1);
    pullButtonFontSize = 13;
    
    _sourceDataArray = [[NSMutableArray alloc] init];
    _viewModel = [[RSRiskViewModel alloc] initWithViewController:self];
}

- (void ) requestData {
    
    [SVProgressHUD show];
    if ([UIUtil isEmptyStr:_keyWord]) {
        [self.viewModel moreRiskfilesOne:0 size:15 riskId:_categoryId];
    }else {
        [self.viewModel findMoreRiskFileByTitleOne:0 size:15 riskId:_categoryId keyWord:_keyWord];
    }
    
}



//资料中心主UI
- (void)initMainView {
    if (_mainCollectionView == nil) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal]; 
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64-40);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-64-40) collectionViewLayout:flowLayout];
        [_mainCollectionView setBackgroundColor:[UIColor clearColor]];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.pagingEnabled = YES;
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        _mainCollectionView.alwaysBounceVertical = NO;
        _mainCollectionView.bounces = NO;

        //注册cell
        [_mainCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:MainCollectionViewCell];
        [_backScrollView addSubview:_mainCollectionView];

        [self setUpBtn];
    }
     [self initPullDownButtonWhenRequestSuccess];
    [_mainCollectionView reloadData];
}

- (void)initPullDownButtonWhenRequestSuccess {
    
    pullDownViewH = topTitleViewH+10+(pullButtonH+spacePullButtonLineSpace) *(_titlesArray.count/buttonCount+1);
    
    if (nil == _topPullButtonBGView) {
        _topPullButtonBGView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-topTitleButtonW, 64, topTitleButtonW, topTitleButtonH)];
        _topPullButtonBGView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.0];
        [self.view addSubview:_topPullButtonBGView];
        
        _topPullButton = [[UIButton alloc] initWithFrame:CGRectMake(0, (topTitleViewH-topTitleButtonH)/2, topTitleButtonW, topTitleButtonH)];
        [_topPullButton setImage:Img(@"ic_add_lungu_normal") forState:UIControlStateNormal];
        [_topPullButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_topPullButtonBGView addSubview:_topPullButton];
    }
}

#pragma mark ButtonAction
- (void)rightAction :(UIButton *)button{
    
    if (nil == _pullDownBGView) {
        CGFloat pullSpaceToLeft = 0;
        _pullDownBGView = [UIView new];
        _pullDownBGView.backgroundColor = [UIColor whiteColor];
        [UIColor colorWithWhite:1.0 alpha:0.0];
        _pullDownBGView.hidden = NO;
        [self.view addSubview:_pullDownBGView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        tapGesture.delegate = self;
        [_pullDownBGView addGestureRecognizer:tapGesture];
        
        _pullDownBGView.sd_layout
        .topSpaceToView(self.view, 64)
        .leftSpaceToView(self.view, pullSpaceToLeft)
        .rightSpaceToView(self.view, pullSpaceToLeft)
        .heightIs(SCREEN_HEIGHT-64);
        
        _pullDownView = [UIView new];
        _pullDownView.backgroundColor = [UIColor whiteColor];
        [_pullDownBGView addSubview:_pullDownView];
        
        KYMHLabel *explainLabel = [[KYMHLabel alloc] initWithTitle:@"所有栏目:" BaseSize:CGRectZero LabelColor:[UIColor clearColor] LabelFont:pullButtonFontSize LabelTitleColor:[UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
        [_pullDownView addSubview:explainLabel];
        
        _pullDownView.sd_layout
        .topEqualToView(_pullDownBGView)
        .leftSpaceToView(_pullDownBGView, pullSpaceToLeft)
        .rightSpaceToView(_pullDownBGView, pullSpaceToLeft)
        .heightIs(pullDownViewH);
        
        explainLabel.sd_layout
        .topEqualToView(_pullDownView)
        .leftSpaceToView(_pullDownView, 10)
        .widthIs(200)
        .heightIs(topTitleViewH);
        
        for (NSInteger i=0; i<_titlesArray.count; i++) {
            UIButton *button = [self createButtonWithTitle:_titlesArray[i] tag:i rect:CGRectMake(spaceToLeft+(i%buttonCount)*(spacePullButtonColumnSpace+pullButtonW), topTitleViewH+10+(pullButtonH+spacePullButtonLineSpace)*(i/buttonCount) , pullButtonW, pullButtonH)];
            [_pullDownView addSubview:button];
        }
    }
    
    isHiddePullDownBGView = !isHiddePullDownBGView;
    
    if (YES == isHiddePullDownBGView) {
        _pullDownBGView.hidden = YES;
        [_topPullButton setImage:Img(@"ic_add_lungu_normal") forState:UIControlStateNormal];
    }else {
        _pullDownBGView.hidden = NO;
        [_topPullButton setImage:Img(@"ic_add_lungu_select") forState:UIControlStateNormal];
    }
    
    [self dc_bringSubViewToFront];
}

- (void)dc_bringSubViewToFront {
    [self.view bringSubviewToFront:_topPullButtonBGView];
}

- (void)tapGestureClick:(UITapGestureRecognizer *)gesture {
    _pullDownBGView.hidden = YES;
    isHiddePullDownBGView = YES;
    [_topPullButton setImage:Img(@"ic_add_lungu_normal") forState:UIControlStateNormal];
}

- (void)pullDownButtonClicked:(UIButton *)button {
    NSLog(@"button.tag=%ld",button.tag);
    [_topTitleView selectIndex:button.tag];
    _pullDownBGView.hidden = YES;
    isHiddePullDownBGView = YES;
    [_topPullButton setImage:Img(@"ic_add_lungu_normal") forState:UIControlStateNormal];
    [_topTitleView reloadData];
}

- (void)setUpBtn {
    _noDataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _noDataBtn.backgroundColor = [UIColor clearColor];
    [_noDataBtn setImage:Img(@"ic_nodata") forState:0];
    [_noDataBtn setTitle:@"点击刷新" forState:0];
    [_noDataBtn setTitleColor:[UIColor blackColor] forState:0];
    [_noDataBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 70, 0, 0)];
    [_noDataBtn setTitleEdgeInsets:UIEdgeInsetsMake(160, 0,0, 260)];
    
    _noDataBtn.frame = CGRectMake(0, 0, _mainCollectionView.frame.size.width, _mainCollectionView.frame.size.height);
    [_noDataBtn addTarget:self action:@selector(requestData) forControlEvents:UIControlEventTouchUpInside];
    [_mainCollectionView addSubview:_noDataBtn];
    _noDataBtn.hidden = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _mainCollectionView) {
        float scrollInteger = (float)scrollView.contentOffset.x / scrollView.frame.size.width * 1.0;
        float f = scrollInteger - ((int)scrollInteger+1);
        f = fabsf(f);
        if (f <= 0.5) return;
        
        if (scrollInteger != _seletedInteger && !_isScrolling) {
            _seletedInteger = (int)scrollInteger;
            _isScrolling = YES;
            
            [_topTitleView selectIndex:_seletedInteger];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"滚动结束");
    _isScrolling = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"滚动结束");
    _isScrolling = NO;
    
    NSInteger scrollInteger = (NSInteger)scrollView.contentOffset.x / scrollView.frame.size.width;
    if (scrollInteger != _seletedInteger ) {
        _seletedInteger = scrollInteger;
        
        [_topTitleView selectIndex:_seletedInteger];
    }
}

#pragma mark CreateButton

- (UIButton *)createButtonWithTitle: (NSString *)title tag:(NSInteger)tag rect:(CGRect )frame {
    UIColor *buttonBorderColor = RGBColor(203, 203, 203);
    
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    button.backgroundColor = RGBColor(244, 243, 244);
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = 5;
    button.layer.borderColor = buttonBorderColor.CGColor;
    button.layer.borderWidth = 1;
    button.titleLabel.font = [UIFont systemFontOfSize: pullButtonFontSize];
    [button addTarget:self action:@selector(pullDownButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//创建子collectionview
- (void)initSecondCollectionViewToView:(UICollectionViewCell *)_cell indexPath:(NSIndexPath *)indexPath {
    
    UITableView *_secondTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-40) style:UITableViewStylePlain];
    [_cell addSubview:_secondTableView];
    _secondTableView.dataSource = self;
    _secondTableView.delegate = self;
    _secondTableView.scrollEnabled =NO;
    _secondTableView.tag = indexPath.row+1200;
    _secondTableView.backgroundColor = [UIColor whiteColor];
    _secondTableView.separatorStyle = UITableViewCellAccessoryNone;
    _secondTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark  UICollectionViewDataSource

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:MainCollectionViewCell forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.borderWidth = 0.25;
    cell.layer.borderColor = [EFSkinThemeManager  getTextColorWithKey:SkinThemeKey_BlackDivider].CGColor;

    [self initSecondCollectionViewToView:cell indexPath:indexPath];

    return cell;
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _sourceDataArray.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark --UICollectionViewDelegate

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark -- tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger index = tableView.tag-1200;
    RSDateCenterModel *dcModel = _sourceDataArray[index];
    if (dcModel.filesItems.count <= _cellCount) {
        return dcModel.filesItems.count;
    }else {
        return _cellCount;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _cellCount-1) {
        return _lastCellH;
    }
    return _secondCellH;
}

#pragma mark ------------------ TableViewCell的创建 -----------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int i = (int)tableView.tag-1200;
    
    if (indexPath.row == (_cellCount-1)) {
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SecondCollectionCell];
        cell.backgroundColor = [UIColor whiteColor];
        
        KYMHLabel * moreLB = [[KYMHLabel alloc]initWithTitle:@"查看更多..." BaseSize:CGRectMake(0, 0, SCREEN_WIDTH, _lastCellH) LabelColor:[UIColor clearColor] LabelFont:15 LabelTitleColor:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary] TextAlignment:NSTextAlignmentCenter];
        [cell addSubview:moreLB];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    RSDateCenterModel *dcModel = _sourceDataArray[i];
    FilesitemsModel *fiModel  = [FilesitemsModel new];
    if (dcModel.filesItems.count > 0 ) {
        fiModel = dcModel.filesItems[indexPath.row];
    }
    SecondTableCell *cell = [tableView dequeueReusableCellWithIdentifier:SecondCollectionCell];
    
    if (!cell ) {
        cell = [[SecondTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SecondCollectionCell];
    }
    cell.model = fiModel;
    
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int i = (int)tableView.tag-1200;
    
    RSDateCenterModel *dcModel = _sourceDataArray[i];
    FilesitemsModel *fiModel = dcModel.filesItems[indexPath.row];
    
    if (indexPath.row == (_cellCount-1)) {
        
        RSMoreDataVC *vc = [[RSMoreDataVC alloc]init];
        vc.categoryId = (int)dcModel.categoryId;
        vc.categoryName = dcModel.categoryName;
        
        [self.navigationController pushViewController:vc animated:YES];
        
        
        return;
    }
    
    if(fiModel.isVideo ) {
        RSVideoVC *next= [[RSVideoVC alloc]initWithCallBack:^(BOOL isSuccess) {
            fiModel.contentSocail.readCount += 1;
            [tableView reloadData];
        }];
        next.title = @"视频";
        next.objectId = fiModel.objectId;
        [self.navigationController pushViewController:next animated:YES];
    }else {
        RSDataVC *vc = [[RSDataVC alloc]initWithCallBack:^(BOOL isSuccess) {
            fiModel.contentSocail.readCount += 1;
            [tableView reloadData];
        }];
        vc.objectId = (int)fiModel.objectId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark ViewModel回调

- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    
    [SVProgressHUD dismiss];
    [_backScrollView.mj_header endRefreshing];
    if (action == RSRisk_NS_ENUM_riskfilesOne) {
        if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeSuccess) {
            _sourceDataArray = [self.viewModel.rsDateCenterMoreSecondArray mutableCopy];
            [_backScrollView addSubview:self.topTitleView];
            
            
            
            
            [self initMainView];
        }
    }
    
    if (action == RSRisk_NS_ENUM_findMoreRiskFileByTitleOne) {
        if (result.status == NetworkModelStatusTypeSuccess) {
            _sourceDataArray = [self.viewModel.searchResultSecondArray mutableCopy];
            
            [self initMainView];
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
