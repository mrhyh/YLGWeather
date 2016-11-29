//
//  EFPushCommentVC.m
//  EF_MallDemo
//
//  Created by HqLee on 16/6/21.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFPushCommentVC.h"
#import "EFPushCommentCell.h"
#import "EFMallViewModel.h"

static NSString *const cellID = @"pushComment";

@interface EFPushCommentVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) KYTableView *tableView;
@property (nonatomic, strong) EFMallViewModel *viewModel;
@property (nonatomic, strong) OrderproductModel *orderProduct;
@end

@implementation EFPushCommentVC
#pragma mark --- lazy load
- (EFMallViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[EFMallViewModel alloc] initWithViewController:self];
    }
    return _viewModel;
}
#pragma mark --- life cycle
- (instancetype)initWithOrderProduct:(OrderproductModel *)orderProduct{
    if (self = [super init]) {
        _orderProduct = orderProduct;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    [self setupTableView];
    [self setupBottomView];
}


- (void)setupNavi{
    self.title = @"写评价";
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)setupTableView{
    WS(weakSelf)
    KYTableView *tableView = [[KYTableView alloc] initWithFrame:CGRectZero andUpBlock:^{
        [weakSelf.tableView endLoading];
    } andDownBlock:^{
        [weakSelf.tableView endLoading];
    } andStyle:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.sectionHeaderHeight = 10;
    tableView.sectionFooterHeight = 0;
    tableView.contentInset = UIEdgeInsetsMake(-30, 0, 0, 0);
    [tableView registerClass:[EFPushCommentCell class] forCellReuseIdentifier:cellID];
    [self.view addSubview:tableView];
    tableView.sd_layout.topEqualToView(self.view).leftEqualToView(self.view).rightEqualToView(self.view).heightIs(self.view.height - 104);
    self.tableView = tableView;
}

- (void)setupBottomView{
    UIView *bottomView = [[UIView alloc] init];
    [self.view addSubview:bottomView];
    bottomView.sd_layout.bottomEqualToView(self.view).leftEqualToView(self.view).rightEqualToView(self.view).heightIs(40);
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn setTitle:@"发表评价" forState:UIControlStateNormal];
    [commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    commentBtn.backgroundColor = RGBColor(247, 124, 27);
    [bottomView addSubview:commentBtn];
    commentBtn.sd_layout.rightEqualToView(bottomView).centerYEqualToView(bottomView).heightIs(40).widthIs(SCREEN_WIDTH * 0.5);
}

#pragma mark --- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EFPushCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.orderProduct = self.orderProduct;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 270;
}

#pragma mark --- event response
- (void)commentBtnClick{
    if (self.orderProduct.content.length == 0) {
        [UIUtil alert:@"请说点什么吧！"];
        return;
    }
    
    NSLog(@"%@  %f",self.orderProduct.content,self.orderProduct.score);
    
    [self.viewModel commentProductWithProductId:self.orderProduct.objectId orderItemId:self.orderProduct.orderItemId score:self.orderProduct.score content:self.orderProduct.content anonymous:NO];
}

#pragma mark --- 网络请求回调
- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    if (action == EFMallViewModelCallBackActionCommentProduct) {
        if (result.status == NetworkModelStatusTypeSuccess) {
            [UIUtil alert:@"评价成功!"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [UIUtil alert:@"评价失败!"];
        }
    }
}
@end
