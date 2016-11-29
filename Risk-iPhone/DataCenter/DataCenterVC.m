//
//  DataCenterVC.m
//  Risk-iPhone
//
//  Created by Cherie Jeong on 16/8/24.
//  Copyright © 2016年 Cherie Jeong. All rights reserved.
//

#import "DataCenterVC.h"
#import "SecondCollectionViewCell.h"
#import "RSDataVC.h"
#import "RSMoreDataVC.h"
#import "RSVideoVC.h"
#import "RSRiskViewModel.h"
#import "RSDataSecondCenterVC.h"
#import "SecondSmallToolCell.h"
#import "RSEDCVC.h"
#import "RSDateCenterModel.h"
#import "AppDelegate.h"
#import "MineVC.h"
#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "SecondTableCell.h"

#import "EHHorizontalSelectionView.h"  //顶部标题栏

@interface DataCenterVC ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,EHHorizontalSelectionViewProtocol,UISearchBarDelegate>
@property (nonatomic,strong) UIScrollView * backScrollView;
@property (nonatomic,strong) UICollectionView * mainCollectionView;
@property (nonatomic,assign) CGFloat  secondCellH;
@property (nonatomic,assign) int      cellCount;
@property (nonatomic,assign) CGFloat  lastCellH;

@property (nonatomic,strong) RSRiskViewModel *viewModel;

@property (nonatomic,strong) NSMutableArray *sourceDataArray;
@property (nonatomic,assign) BOOL   isSearch;

@property (nonatomic,strong)UIButton * noDataBtn;

@property (nonatomic,strong) RSDateCenterModel * toolMdoel;
@property (nonatomic,strong) NSArray * tools;

@property (nonatomic,strong) EHHorizontalSelectionView * topTitleView;  //顶部标题栏
@property (nonatomic,strong) NSMutableArray * titlesArray;  //标题组
@property (nonatomic,assign) NSInteger seletedInteger;  //选择的页数
@property (nonatomic,assign) BOOL      isScrolling;    //是否正在滚动

//搜索相关
@property (nonatomic,strong) UIView * searchBackView;
@property (nonatomic,strong) UISearchBar * searchBar;
@property (nonatomic,strong) UIButton * cancelBtn;
@property (nonatomic,strong) UIButton * searchBtn;

@property (nonatomic, strong) UITapGestureRecognizer * hiddenGesture;//收回侧边栏 点击事件

//更多栏目
@property (nonatomic, strong) UIView *pullDownView;
@property (nonatomic, strong) UIView *pullDownBGView; //弹出栏目的rootView
@property (nonatomic, strong) UIButton *topPullButton;
@property (nonatomic, strong) UIView *topPullButtonBGView; //弹出更多栏目的rootView

@end

@implementation DataCenterVC {
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

#define MainCollectionViewCell @"MainCollectionViewCell"
#define SecondCollectionCell @"SecondCollectionCell_files"
#define SecondCollectionCellEND @"SecondCollectionCellEND"
#define SecondCollectionLastCell @"SecondCollectionLastCell"

- (UIScrollView *)backScrollView {
    if (_backScrollView == nil) {
        _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-50)];
        _backScrollView.alwaysBounceHorizontal = NO;
    }
    return _backScrollView;
}

- (UIView *)searchBackView {
    if (_searchBackView == nil) {
        _searchBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _searchBackView.backgroundColor = RGBAColor(0, 0, 0, 0.7);
        _searchBackView.userInteractionEnabled = YES;
        _searchBackView.alpha = 0;
        _searchBackView.hidden = YES;
        
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        backView.backgroundColor = EF_MainColor;
        [_searchBackView addSubview:backView];
        
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 25, SCREEN_WIDTH-20-55, 34)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"标题关键字";
        _searchBar.searchBarStyle = UISearchBarStyleDefault;
        _searchBar.keyboardType = UIKeyboardTypeDefault;
        [[[[_searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
        [backView addSubview:_searchBar];
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(CGRectGetMaxX(_searchBar.frame)+5, 25, 50, 34);
        [_cancelBtn setTitle:@"取消" forState:0];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_cancelBtn addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:_cancelBtn];
    }
    return _searchBackView;
}

- (EHHorizontalSelectionView *)topTitleView {
    if (_topTitleView == nil) {
        _topTitleView = [[EHHorizontalSelectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, topTitleViewH)];
        _topTitleView.delegate = self;
        _topTitleView.backgroundColor = [UIColor whiteColor];
        
        [_topTitleView registerCellWithClass:[EHHorizontalLineViewCell class]];
        UIColor *color = EF_MainColor;
        [_topTitleView setTintColor:color];
        [EHHorizontalLineViewCell updateColorHeight:2.f];
        
        [_backScrollView addSubview:self.topTitleView];
    }
    
    return _topTitleView;
}


//创建小工具
- (RSDateCenterModel *)toolMdoel {
    if (_toolMdoel == nil) {
        _toolMdoel = [[RSDateCenterModel alloc]init];
        _toolMdoel.categoryName = @"小工具";
        NSMutableArray * toolArr = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            FilesitemsModel * model = [[FilesitemsModel alloc]init];
            model.title = _tools[i];
            model.isTool = YES;
            [toolArr addObject:model];
        }
        _toolMdoel.filesItems = [toolArr copy];
    }
    
    return _toolMdoel;
}

#pragma mark - EHHorizontalSelectionViewProtocol

- (NSUInteger)numberOfItemsInHorizontalSelection:(EHHorizontalSelectionView*)hSelView
{
    return [_titlesArray count];
}

- (NSString *)titleForItemAtIndex:(NSUInteger)index forHorisontalSelection:(EHHorizontalSelectionView*)hSelView
{
    return [[_titlesArray objectAtIndex:index] uppercaseString];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_viewModel == nil) {
        _viewModel = [[RSRiskViewModel alloc]initWithViewController:self];
    }
    [_viewModel getUnReadMsgCount];
}


#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
    [self requestData];
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
    if (_titlesArray == nil) {
        _titlesArray = [NSMutableArray array];
    }
    
    _secondCellH = MFCommonCellH;
    _tools = @[@"预产期",@"胎儿体重",@"排卵期"];
    if (IS_IPHONE5) {
        _cellCount = 5;
        _lastCellH = (SCREEN_HEIGHT-topTitleViewH - 49) - _cellCount*_secondCellH+24;
    }else if(IS_IPHONE6) {
        _cellCount = 6;
        _lastCellH = (SCREEN_HEIGHT-topTitleViewH - 49) - _cellCount*_secondCellH+24;
    }else if(IS_IPHONE6PS) {
        _cellCount = 7;
        _lastCellH = (SCREEN_HEIGHT-topTitleViewH - 49) - _cellCount*_secondCellH+24;
    }
}

- (void ) initUI {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchBtn.frame = CGRectMake(0, 0, 44, 44);
    _searchBtn.backgroundColor = [UIColor clearColor];
    [_searchBtn setImage:Img(@"nav_search") forState:UIControlStateNormal];
    [_searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:_searchBtn];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
    UIButton * moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(0, 0, 44, 44);
    [moreBtn setImage:Img(@"text_menu") forState:0];
    [moreBtn addTarget:self action:@selector(showLeftVC) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithCustomView:moreBtn];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    WS(weakSelf)
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backScrollView];  //添加下拉刷新底层view
    [[AppDelegate shareInstance].window addSubview:self.searchBackView];  //添加搜索view
    //下拉刷新
    _backScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
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

#pragma mark -- Searchbar -----------
- (void)searchAction:(UIButton *)searchBtn {
    _pullDownBGView.hidden = YES;
    [_topPullButton setImage:Img(@"ic_add_lungu_normal") forState:UIControlStateNormal];
    _topPullButton.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.searchBackView.hidden = NO;
        self.searchBackView.alpha = 1;
    }];
    [_searchBar becomeFirstResponder];
}

- (void)cancelButtonClicked {
    _topPullButtonBGView.hidden = NO;
    _isSearch = NO;
    [_searchBar resignFirstResponder];
    _searchBar.text = @"";
    [UIView animateWithDuration:0.3 animations:^{
        self.searchBackView.alpha = 0;
    } completion:^(BOOL finished) {
        self.searchBackView.hidden = YES;
    }];
}

//显示侧边栏
- (void)showLeftVC {
    [[EFAppManager shareInstance].sideAndTabHome showLeftView];
    if (_hiddenGesture == nil) {
        _hiddenGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenLeftVC)];
    }
    
    [self.view addGestureRecognizer:_hiddenGesture];
}

//收回侧边栏
- (void)hiddenLeftVC {
    [[EFAppManager shareInstance].sideAndTabHome hiddenLeftView];
    [self.view removeGestureRecognizer:_hiddenGesture];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if ([UIUtil isNoEmptyStr:_searchBar.text]) {
        
        [_searchBar resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            self.searchBackView.alpha = 0;
        } completion:^(BOOL finished) {
            self.searchBackView.hidden = YES;
        }];
        
        _isSearch = YES;
        [RSMethod ylg_SVProgressHUD_showWithSVProgressHUDMaskTypeNone];
        
        _topPullButtonBGView.hidden = YES;
        [self.viewModel findRiskFileByTitle:_searchBar.text];
        _searchBar.text = @"";
    }else {
        [UIUtil alert:@"请输入标题关键字"];
    }
}

#pragma mark requestData

- (void) requestData {
    [RSMethod ylg_SVProgressHUD_showWithSVProgressHUDMaskTypeNone];
    [self.viewModel findRiskfiles]; //获取资料中心内容
}


//资料中心主UI
- (void)initMainView {
    
    if (_mainCollectionView == nil) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64-40-50);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-64-50-40) collectionViewLayout:flowLayout];
        [_mainCollectionView setBackgroundColor:[UIColor clearColor]];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.pagingEnabled = YES;
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        _mainCollectionView.alwaysBounceVertical = NO;
        _mainCollectionView.alwaysBounceHorizontal = YES;
        _mainCollectionView.bounces = NO;
        
        //注册cell
        [_mainCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:MainCollectionViewCell];
        
        
        [_backScrollView addSubview:_mainCollectionView];
        
        [self setUpBtn];
    }
    
    if (_sourceDataArray.count > 0) {
        _noDataBtn.hidden = YES;
    }else {
        _noDataBtn.hidden = NO;
    }
    
    [self initPullDownButtonWhenRequestSuccess];
    
    [_mainCollectionView reloadData];
}

- (void)setUpBtn {
    _noDataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _noDataBtn.backgroundColor = [UIColor clearColor];
    [_noDataBtn setImage:Img(@"ic_nodata") forState:0];
    _noDataBtn.titleLabel.lineBreakMode = 0;
    [_noDataBtn setTitle:@"暂无搜索结果\n  下拉返回" forState:0];
    [_noDataBtn setTitleColor:[UIColor blackColor] forState:0];
    [_noDataBtn setImageAndTitleCenterImageTopWithpadding:5.0];
    _noDataBtn.titleLabel.font = Font(15);
    
    _noDataBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, _mainCollectionView.frame.size.height);
    [_mainCollectionView addSubview:_noDataBtn];
    _noDataBtn.hidden = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_searchBar resignFirstResponder];
    
    if (scrollView == _mainCollectionView) {
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

- (void)dc_bringSubViewToFront {
    [self.view bringSubviewToFront:_topPullButtonBGView];
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
    UITableView * _secondTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-40-50) style:UITableViewStylePlain];
    /**
     tableView
     */
    [_cell addSubview:_secondTableView];
    _secondTableView.dataSource = self;
    _secondTableView.delegate = self;
    _secondTableView.scrollEnabled =NO;
    _secondTableView.tag = indexPath.row+700;
    _secondTableView.backgroundColor = [UIColor whiteColor];
    _secondTableView.separatorStyle = UITableViewCellAccessoryNone;
    _secondTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _secondTableView.layer.borderWidth = 0.25;
    _secondTableView.layer.borderColor = [EFSkinThemeManager  getTextColorWithKey:SkinThemeKey_BlackDivider].CGColor;
}

#pragma mark Gesture

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.pullDownView]) {
        return NO;
    }
    return YES;
}

#pragma mark  UICollectionViewDataSource

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:MainCollectionViewCell forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark UIScrollView


#pragma mark -- tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger index = tableView.tag-700;
    RSDateCenterModel *dcModel = _sourceDataArray[index];
    if (dcModel.filesItems.count <= _cellCount) {
        return dcModel.filesItems.count;
    }else {
        return _cellCount;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == (_cellCount-1))  {
        return _lastCellH;
    }else {
        return _secondCellH;
    }
}

#pragma mark ------------------ TableViewCell的创建 -----------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int i = (int)tableView.tag-700;
    
    if (indexPath.row == (_cellCount-1)) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SecondCollectionCellEND];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SecondCollectionCellEND];
            
            KYMHLabel * moreLB = [[KYMHLabel alloc]initWithTitle:@"查看更多..." BaseSize:CGRectMake(0, (_lastCellH-_lastCellH)/2, SCREEN_WIDTH, _lastCellH) LabelColor:[UIColor clearColor] LabelFont:15 LabelTitleColor:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary] TextAlignment:NSTextAlignmentCenter];
            [cell addSubview:moreLB];
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    RSDateCenterModel *dcModel = _sourceDataArray[i];
    FilesitemsModel *fiModel  = [FilesitemsModel new];
    if (dcModel.filesItems.count > 0 ) {
        fiModel = dcModel.filesItems[indexPath.row];
    }
    
    if (fiModel.isTool) {
        SecondSmallToolCell * cell = [tableView dequeueReusableCellWithIdentifier:SecondCollectionCell];
        if (!cell) {
            cell = [[SecondSmallToolCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SecondCollectionCell];
        }
        cell.model = fiModel;
        cell.indexPath = indexPath;
        
        return cell;
    }else {
        SecondTableCell *cell = [tableView dequeueReusableCellWithIdentifier:SecondCollectionCell];
        
        if (!cell ) {
            cell = [[SecondTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SecondCollectionCell];
        }
        cell.model = fiModel;
        cell.indexPath = indexPath;
        
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int i = (int)tableView.tag-700;
    
    RSDateCenterModel *dcModel = _sourceDataArray[i];
    FilesitemsModel *fiModel = dcModel.filesItems[indexPath.row];
    
    if (indexPath.row  == (_cellCount-1)) {
        
        if (!dcModel.hasChild) {
            RSMoreDataVC *vc = [[RSMoreDataVC alloc]init];
            vc.categoryId = (int)dcModel.categoryId;
            vc.categoryName = dcModel.categoryName;
            
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            RSDataSecondCenterVC *vc = [[RSDataSecondCenterVC alloc]init];
            vc.categoryId = (int)dcModel.categoryId;
            vc.categoryName = dcModel.categoryName;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        return;
    }
    
    if (fiModel.isTool) {
        int index = (int)indexPath.row;
        switch (index) {
            case 0:{
                RSEDCVC * vc = [[RSEDCVC alloc]init];
                vc.titleStr = @"预产期";
                vc.webURL = @"/tools/predicted.jsp";
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:{
                RSEDCVC * vc = [[RSEDCVC alloc]init];
                vc.titleStr = @"胎儿体重";
                vc.webURL = @"/tools/weight.html";
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:{
                RSEDCVC * vc = [[RSEDCVC alloc]init];
                vc.titleStr = @"排卵期";
                vc.webURL = @"/tools/ovulation.jsp";
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }
    }else {
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
                fiModel.contentSocail.readCount +=1;
                [tableView reloadData];
            }];
            vc.objectId = (int)fiModel.objectId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    
}

#pragma mark ViewModel回调

- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    
    [SVProgressHUD dismiss];
    [_backScrollView.mj_header endRefreshing];
    [_mainCollectionView.mj_header endRefreshing];
    if (action == RSRisk_NS_ENUM_findRiskfiles) {
        if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeSuccess) {
            
            _sourceDataArray = [self.viewModel.rsDateCenterModelArray mutableCopy];
            [_sourceDataArray addObject:self.toolMdoel];
            [_titlesArray removeAllObjects];
            RSDateCenterModel *dcModel = [RSDateCenterModel new];
            NSString * titleStr = @"";
            for (int i = 0; i < _sourceDataArray.count; i++) {
                dcModel = _sourceDataArray[i];
                titleStr = dcModel.categoryName;
                [_titlesArray addObject:titleStr];
            }
            
            _topPullButtonBGView.hidden = NO;
            _topPullButton.hidden = NO;
            self.topTitleView.hidden = NO;
            
            [self.topTitleView reloadData];
            [self initMainView];
        }
    }
    
    if (action == RSRisk_NS_ENUM_findRiskFileByTitle) {
        if (result.status == NetworkModelStatusTypeSuccess) {
            [_sourceDataArray removeAllObjects];
            _sourceDataArray = [self.viewModel.searchResultArray mutableCopy];
            [self initMainView];
            
            if (_sourceDataArray.count > 0) {
                _noDataBtn.hidden = YES;
                _topTitleView.hidden = NO;
                
                [_titlesArray removeAllObjects];
                RSDateCenterModel *dcModel = [RSDateCenterModel new];
                NSString * titleStr = @"";
                for (int i = 0; i < _sourceDataArray.count; i++) {
                    dcModel = _sourceDataArray[i];
                    titleStr = dcModel.categoryName;
                    [_titlesArray addObject:titleStr];
                }
            }else {
                _noDataBtn.hidden = NO;
                _topTitleView.hidden = YES;
            }
            [_topTitleView reloadData];
        }
    }
    
    if (action == RSRisk_NS_ENUM_getUnReadMsgCount) {
        if (result.status == 200) {
            [[MineVC shareInstance] changeMsgNum:_viewModel.unReadMsgCount];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
