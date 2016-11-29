//
//  RSMessageVC.m
//  Risk
//
//  Created by Cherie Jeong on 16/7/15.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSMessageVC.h"
#import "RSMineMsgCell.h"

#import "RSRiskViewModel.h"

#define MSGTableviewCell @"MSGTableviewCell"

@interface RSMessageVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)KYTableView * table;

@property (nonatomic,strong) RSRiskViewModel * viewModel;

@property (nonatomic,strong) NSMutableArray * msgsArray;
@property (nonatomic,strong) UILabel * nodataLB;
@property (nonatomic,assign) int currentPage;

@end

@implementation RSMessageVC

- (instancetype)initWithCallBack:(MSGVCCallBack)_callBack{
    if (self = [super init]) {
        callBack = _callBack;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"消息通知";
    _currentPage = 0;
    
    _msgsArray = [NSMutableArray array];
    
    _viewModel = [[RSRiskViewModel alloc]initWithViewController:self];
    [_viewModel getMyMessagesWithPage:0 Size:150];
    
    
}

- (void)initTableView {
     WS(weakSelf);
    if (_table == nil) {
        self.table = [[KYTableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) andUpBlock:^{
            [weakSelf.msgsArray removeAllObjects];
            weakSelf.currentPage = 0;
            [weakSelf.viewModel getMyMessagesWithPage:0 Size:150];
        } andDownBlock:^{
            if (weakSelf.viewModel.msgModel.last) {
                [UIUtil alert:@"已是最后一页"];
                [weakSelf.table endLoading];
            }else {
                weakSelf.currentPage++;
                [weakSelf.viewModel getMyMessagesWithPage:weakSelf.currentPage Size:150];
            }
        }];
        [self.view addSubview:self.table];
        self.table.dataSource = self;
        self.table.delegate = self;
        self.table.backgroundColor = EF_BGColor_Primary;
        self.table.separatorStyle = UITableViewCellAccessoryNone;
        [self.table registerClass:[RSMineMsgCell class] forCellReuseIdentifier:MSGTableviewCell];
        
        _nodataLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, 20)];
        _nodataLB.text = @"暂无消息";
        _nodataLB.textAlignment = NSTextAlignmentCenter;
        _nodataLB.textColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackNormal];
        _nodataLB.font = Font(15);
        [_table addSubview:_nodataLB];
        _nodataLB.hidden = YES;
    }
    
    if (_msgsArray.count > 0 ) {
        _nodataLB.hidden = YES;
    }else {
        _nodataLB.hidden = NO;
    }
    
    [_table reloadData];
}

#pragma mark TableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MSGContent * model = _msgsArray[indexPath.section];
    
    RSMineMsgCell * cell = [tableView dequeueReusableCellWithIdentifier:MSGTableviewCell];
    if (!cell) {
        cell = [[RSMineMsgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MSGTableviewCell];
    }
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _msgsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

//自适应高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id model;
    if (_msgsArray.count>0) {
        model = [_msgsArray objectAtIndex:indexPath.section];
    }
    return [_table cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[RSMineMsgCell class] contentViewWidth:[self cellContentViewWith]];
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = SCREEN_WIDTH;

    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPath.section);
    
}


- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result {
    if (action == RSRisk_NS_ENUM_getMyMessages) {
        if (result.status == 200) {
            [_msgsArray  addObjectsFromArray:self.viewModel.msgModel.content];
            
            [self initTableView];
            [self.table endLoading];
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
