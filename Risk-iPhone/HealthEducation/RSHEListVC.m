//
//  RSHEListVC.m
//  Risk
//
//  Created by ylgwhyh on 16/7/14.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSHEListVC.h"
#import "MoreDataCollectionViewCell.h"
#import "RSHEDetailVC.h"
#import "RSVideoVC.h"
#import "AppDelegate.h"
#import "RSDataVC.h"
#import "RSRiskViewModel.h"

@interface RSHEListVC ()<UICollectionViewDelegate,UICollectionViewDataSource, UISearchBarDelegate, UITextFieldDelegate>

@property (nonatomic,strong) UICollectionView * moreCollectionView;
@property (nonatomic,assign) CGFloat  moreCellH;

@property (nonatomic,strong) NSMutableArray * sourceDataArray;

@property (nonatomic, strong) RSRiskViewModel * viewModel;

@property (nonatomic, strong) UIView * noDataBackView;

@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) BOOL isSearch;

//搜索相关
@property (nonatomic,strong) UIView * searchBackView;
@property (nonatomic,strong) UISearchBar * searchBar;
@property (nonatomic,strong) UIButton * cancelBtn;
@property (nonatomic,strong) UIButton * searchBtn;

@end

@implementation RSHEListVC {
    
}

#define MoreDataCollectionCell @"MoreDataCollectionCell"

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sourceDataArray = [NSMutableArray array];
    [[AppDelegate shareInstance].window addSubview:self.searchBackView];  //添加搜索view
    
    _viewModel = [[RSRiskViewModel alloc]initWithViewController:self];
    [_viewModel findHealthByCategory:0 size:150 riskId:_model.objectId];
    [SVProgressHUD show];
    [self initData];
    [self initUI];
    
}


- (void) initData {
    _moreCellH = MFCommonCellH;
}

- (void) initUI {
    self.title = _model.name;
    
    _currentPage = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

//右侧搜索view
- (void)initNavigationView {
    
    if (!_isSearch) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBtn.frame = CGRectMake(0, 0, 44, 44);
        _searchBtn.backgroundColor = [UIColor clearColor];
        [_searchBtn setImage:Img(@"nav_search") forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    }else {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBtn.frame = CGRectMake(0, 0, 80, 44);
        _searchBtn.backgroundColor = [UIColor clearColor];
        [_searchBtn setTitle:@"退出搜索" forState:0];
        _searchBtn.titleLabel.font = Font(15);
        [_searchBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:_searchBtn];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

#pragma mark -- searchbar -----------
- (void)searchAction:(UIButton *)searchBtn {
    if (!_isSearch) {
        [UIView animateWithDuration:0.3 animations:^{
            self.searchBackView.hidden = NO;
            self.searchBackView.alpha = 1;
        }];
        [_searchBar becomeFirstResponder];
    }else {
        [SVProgressHUD show];
        _isSearch = NO;
        _searchBar.text = @"";
        
        [_sourceDataArray removeAllObjects];
        [_viewModel findHealthByCategory:0 size:150 riskId:_model.objectId];
    }
    
}

- (void)cancelButtonClicked {
    _isSearch = NO;
    [_searchBar resignFirstResponder];
    _searchBar.text = @"";
    [UIView animateWithDuration:0.3 animations:^{
        self.searchBackView.alpha = 0;
    } completion:^(BOOL finished) {
        self.searchBackView.hidden = YES;
    }];
}

#pragma mark searchBtnAction
//查询标题关键字
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_searchBar resignFirstResponder];
    
    if ([UIUtil isNoEmptyStr:_searchBar.text]) {
        
        [_searchBar resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            self.searchBackView.alpha = 0;
        } completion:^(BOOL finished) {
            self.searchBackView.hidden = YES;
        }];
        
        _isSearch = YES;
        _currentPage = 0;
        [self.viewModel findMoreRiskFileByTitleTwo:0 size:150 riskId:_model.objectId keyWord:_searchBar.text];
        [SVProgressHUD show];
    }else {
        [UIUtil alert:@"请输入标题关键字"];
    }
}


- (void)initCollectionView {
    
    WS(weakSelf)
    
    if (_moreCollectionView == nil) {
        //确定是水平滚动，还是垂直滚动
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, _moreCellH);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        
        _moreCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:flowLayout];
        [_moreCollectionView setBackgroundColor:[UIColor whiteColor]];
        _moreCollectionView.delegate = self;
        _moreCollectionView.dataSource = self;
        _moreCollectionView.pagingEnabled = YES;
        _moreCollectionView.showsVerticalScrollIndicator = NO;
        _moreCollectionView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_moreCollectionView];
        
        _moreCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf.sourceDataArray removeAllObjects];
            weakSelf.currentPage = 0;
            
            if (_isSearch) {
                [self.viewModel findMoreRiskFileByTitleTwo:0 size:150 riskId:_model.objectId keyWord:_searchBar.text];
                [SVProgressHUD show];
            }else {
                [SVProgressHUD show];
                [weakSelf.viewModel findHealthByCategory:0 size:150 riskId:weakSelf.model.objectId];
            }
            
           
        }];
        
        _moreCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (weakSelf.viewModel.healthModel.last) {
                [UIUtil alert:@"已是最后一页"];
                
            }else {
                weakSelf.currentPage += 1;
                
                if (_isSearch) {
                    [self.viewModel findMoreRiskFileByTitleTwo:weakSelf.currentPage size:150 riskId:_model.objectId keyWord:_searchBar.text];
                    [SVProgressHUD show];
                }else {
                    [SVProgressHUD show];
                    [weakSelf.viewModel findHealthByCategory: weakSelf.currentPage size:150 riskId:weakSelf.model.objectId];
                }
                
                
            }
        }];
        
        _noDataBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 230)];
        _noDataBackView.backgroundColor = [UIColor clearColor];
        [_moreCollectionView addSubview:_noDataBackView];
        _noDataBackView.hidden = YES;
        _noDataBackView.center = CGPointMake(CGRectGetMidX(_moreCollectionView.frame), CGRectGetMidY(_moreCollectionView.frame)-150);
        
        KYMHImageView * imageView = [[KYMHImageView alloc]initWithImage:Img(@"ic_nodata") BaseSize:CGRectMake(0, 0, 300, 200) ImageViewColor:[UIColor clearColor]];
        [_noDataBackView addSubview:imageView];
        
        NSString *text = @"暂无数据,下拉刷新";
        
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                     NSForegroundColorAttributeName: [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary]};
        NSAttributedString * string = [[NSAttributedString alloc] initWithString:text attributes:attributes];
        
        KYMHLabel * nodataLB = [[KYMHLabel alloc]initWithTitle:@"" BaseSize:CGRectMake(0, 200, 300, 30) LabelColor:[UIColor clearColor] LabelFont:15 LabelTitleColor:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary] TextAlignment:NSTextAlignmentCenter];
        [_noDataBackView addSubview:nodataLB];
        
        nodataLB.attributedText = string;
        
        //注册cell
        [_moreCollectionView registerClass:[MoreDataCollectionViewCell class] forCellWithReuseIdentifier:MoreDataCollectionCell];
    }
    
    if (_sourceDataArray.count <= 0) {
        _noDataBackView.hidden = NO;
    }else {
        _noDataBackView.hidden = YES;
    }
    
    [_moreCollectionView reloadData];
}

#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _sourceDataArray.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Content * model = _sourceDataArray[indexPath.row];
    
    MoreDataCollectionViewCell * cell = (MoreDataCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:MoreDataCollectionCell forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.healthModel = model;
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

////定义每个Item 的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(60, 60);
//}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Content * model = _sourceDataArray[indexPath.row];
    WS(weakSelf)
    
    if (!model.isVideo) {
//        RSHEDetailVC *next = [[RSHEDetailVC alloc] initWithCallBack:^(BOOL isSuccess) {
//            model.contentSocail.readCount += 1;
//            [weakSelf.moreCollectionView reloadData];
//        }];
//        next.objectId = (int)model.objectId;
//        [self.navigationController pushViewController:next animated:YES];
        
        RSDataVC *vc = [[RSDataVC alloc]initWithCallBack:^(BOOL isSuccess) {
            model.contentSocail.readCount += 1;
            [weakSelf.moreCollectionView reloadData];
        }];
        vc.objectId = (int)model.objectId;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        RSVideoVC *next= [[RSVideoVC alloc]initWithCallBack:^(BOOL isSuccess) {
            model.contentSocail.readCount += 1;
            [weakSelf.moreCollectionView reloadData];
        }];
        
        next.objectId = (int)model.objectId;
        [self.navigationController pushViewController:next animated:YES];
    }
   
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark 网络回调
- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result {
    
    [SVProgressHUD dismiss];
    [_moreCollectionView.mj_header endRefreshing];
    [_moreCollectionView.mj_footer endRefreshing];
    if (action == RSRisk_NS_ENUM_findHealthByCategory) {
        if (result.status == 200) {
            [_sourceDataArray addObjectsFromArray:_viewModel.healthModel.content];
            [self initCollectionView];
            [self initNavigationView];
        }
    }
    
    if (action == RSRisk_NS_ENUM_findMoreRiskFileByTitleTwo) {
        if (result.status == NetworkModelStatusTypeSuccess) {
            _sourceDataArray = [self.viewModel.rsDateCenterMoreModel.content mutableCopy];
            [self initCollectionView];
            [self initNavigationView];
        }
    }
}

- (void)dealloc {
    if (_viewModel) {
        [_viewModel cancelAndClearAll];
        _viewModel = nil;
    }
}

@end
