//
//  RSMoreDataVC.m
//  Risk
//
//  Created by Cherie Jeong on 16/7/7.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSMoreDataVC.h"
#import "MoreDataCollectionViewCell.h"
#import "RSDataVC.h"
#import "MJRefreshComponent.h"
#import "SVProgressHUD.h"
#import "RSRiskViewModel.h"
#import "RSVideoVC.h"

@interface RSMoreDataVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView * moreCollectionView;
@property (nonatomic,assign) CGFloat  moreCellH;

@property (nonatomic, strong)  RSRiskViewModel *viewModel;

@property (nonatomic, strong) NSMutableArray *sourceDataArray;

@end

@implementation RSMoreDataVC

#define MoreDataCollectionCell @"MoreDataCollectionCell"

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
    
}


- (void) initData {
    
    //_moreCellH = (SCREEN_HEIGHT-64)/8;
    _moreCellH = MFCommonCellH;
    _viewModel = [[RSRiskViewModel alloc] initWithViewController:self];
    _pageCount = 0;
    
    _sourceDataArray = [[NSMutableArray alloc ] init];
}

- (void) initUI {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = _categoryName;
    
    [self initCollectionView];
    
    [self requestData];
}

- (void ) requestData {
    
    if ([UIUtil isEmptyStr:_keyWord]) {
        [self.viewModel moreRiskfilesTwo:_pageCount size:150 riskId:_categoryId];
    }else {
        [self.viewModel findMoreRiskFileByTitleTwo:_pageCount size:150 riskId:_categoryId keyWord:_keyWord];
    }
    
}

- (void)initCollectionView {
    
    WS(weakSelf)
    
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
    
    //注册cell
    [_moreCollectionView registerClass:[MoreDataCollectionViewCell class] forCellWithReuseIdentifier:MoreDataCollectionCell];
    
    _moreCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if(weakSelf.viewModel.sreportModel.first == YES){
            weakSelf.pageCount = 0;
        }else {
            if(weakSelf.pageCount >=1) {
                weakSelf.pageCount--;
            }else {
                weakSelf.pageCount = 0;
            }
        }
        [weakSelf.viewModel moreRiskfilesTwo:weakSelf.pageCount size:150 riskId:weakSelf.categoryId];
        
    }];
    _moreCollectionView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
        
        
        if(weakSelf.viewModel.sreportModel.last == NO){
            
            weakSelf.pageCount++;
            [weakSelf.viewModel moreRiskfilesTwo:weakSelf.pageCount size:150 riskId:weakSelf.categoryId];
            
        }else {
            
            [weakSelf.moreCollectionView.mj_footer endRefreshing];
            [UIUtil alert:@"已是最后一条"];
        }
        
    }];
    

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
    MoreDataCollectionViewCell * cell = (MoreDataCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:MoreDataCollectionCell forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.model = _sourceDataArray[indexPath.row];
    
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
    NSLog(@"item======%ld",(long)indexPath.item);
    NSLog(@"row=======%ld",(long)indexPath.row);
    NSLog(@"section===%ld",(long)indexPath.section);
    
    FilesitemsModel *fiModel = _sourceDataArray[indexPath.row];
    
    if(fiModel.isVideo ) {
        RSVideoVC *next= [[RSVideoVC alloc] init ];
        next.title = @"视频";
        next.objectId = fiModel.objectId;
        [self.navigationController pushViewController:next animated:YES];
    }else {
        RSDataVC *vc = [[RSDataVC alloc]initWithCallBack:^(BOOL isSuccess) {
            fiModel.contentSocail.readCount += 1;
            [collectionView reloadData];
        }];
        vc.objectId = (int)fiModel.objectId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ViewModel回调

- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    
    [SVProgressHUD dismiss];
    [_moreCollectionView.mj_header endRefreshing];
    [_moreCollectionView.mj_footer endRefreshing];
    if (action == RSRisk_NS_ENUM_riskfilesTwo) {
        if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeSuccess) {
            _sourceDataArray = [self.viewModel.rsDateCenterMoreModel.content mutableCopy];

            [self.moreCollectionView reloadData];
        }
    }
    
    if (action == RSRisk_NS_ENUM_findMoreRiskFileByTitleTwo) {
        if (result.status == NetworkModelStatusTypeSuccess) {
            _sourceDataArray = [self.viewModel.rsDateCenterMoreModel.content mutableCopy];
            
            [self.moreCollectionView reloadData];
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
