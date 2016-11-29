//
//  GoodsCommentVC.m
//  hujinrong
//
//  Created by HqLee on 16/5/17.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFGoodsCommentVC.h"
#import "EFGoodsCommentCell.h"
#import "EFMallViewModel.h"
#import "EFMallModel.h"

static NSString *const SDEFGoodsCommentCell = @"EFGoodsCommentCell";

@interface EFGoodsCommentVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)KYTableView * table;
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, strong) EFMallViewModel *viewModel;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *commentLists;
@end
@implementation EFGoodsCommentVC
- (EFMallViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[EFMallViewModel alloc] initWithViewController:self];
    }
    return _viewModel;
}

- (NSMutableArray *)commentLists{
    if (_commentLists == nil) {
        _commentLists = [NSMutableArray array];
    }
    return _commentLists;
}
#pragma mark --- life cycle
- (instancetype)initWithProductId:(NSString *)productId{
    if (self = [super init]) {
        _productId = [productId copy];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavi];
    [self layoutViewController];
    [self.viewModel getCommentList:self.page andProductId:self.productId];
}

- (void)setupNavi{
    self.title = @"评价详情";
}

- (void)layoutViewController{
    WS(weakSelf)
    _table = [[KYTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) andUpBlock:^{
        weakSelf.page = 0;
        [weakSelf.viewModel getCommentList:weakSelf.page andProductId:weakSelf.productId];
    } andDownBlock:^{
        weakSelf.page += 1;
        [weakSelf.viewModel getCommentList:weakSelf.page andProductId:weakSelf.productId];
    }];
    [self.view addSubview:_table];
    _table.dataSource = self;
    _table.delegate = self;
    _table.backgroundColor = EF_BGColor_Primary;
    _table.separatorStyle = UITableViewCellAccessoryNone;
    [_table registerClass:[EFGoodsCommentCell class] forCellReuseIdentifier:SDEFGoodsCommentCell];
    [_table reloadData];
}
#pragma mark ---<UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EFGoodsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:SDEFGoodsCommentCell];
    ProductCommentModel *commentModel = self.commentLists[indexPath.row];
    cell.commentModel = commentModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

#pragma mark --- 网络请求回调
- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    if (action == EFMallViewModelCallBackActionCommentList) {
        if (result.status == NetworkModelStatusTypeSuccess) {
            [self.table endLoading];
            NSArray *commentLists = [NSArray yy_modelArrayWithClass:[ProductCommentModel class] json:result.content[@"content"]];
            if (commentLists.count == 0) {
                [UIUtil alert:@"暂无任何评价!"];
            }
            if (self.page == 0) {
                [self.commentLists removeAllObjects];
                [self.commentLists addObjectsFromArray:commentLists];
            }else{
                if (commentLists.count > 0) {
                    [self.commentLists addObjectsFromArray:commentLists];
                }else{
                    [UIUtil alert:@"数据加载完毕"];
                }
            }
            [self.table reloadData];
        }else{
            [UIUtil alert:@"评论列表加载失败"];
            if (self.page != 0) {
                self.page -= 1;
            }
        }
    }
}
@end
