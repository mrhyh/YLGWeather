//
//  RSSRLeftVC.m
//  Risk
//
//  Created by ylgwhyh on 16/7/12.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSSRLeftVC.h"
#import "RiskTypesLeftVC.h"
#import "RiskTypeModel.h"
#import "RiskTypesLeftCell.h"

@interface RSSRLeftVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *riskTypesArray;
@property (nonatomic, strong) NSArray *sectionTitleArray;
@property (nonatomic, strong) NSIndexPath *oldSelectIndexPath;

@end

@implementation RSSRLeftVC {
}

static NSString * const RiskTypesLeftVC_RiskTypesLeftCell_ID = @"RiskTypesLeftVC_RiskTypesLeftCell_ID";

- (void )viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    
    [self initData];
    [self initUI];
}


- (void) initUI {

    [self.tableView registerClass:[RiskTypesLeftCell class] forCellReuseIdentifier:RiskTypesLeftVC_RiskTypesLeftCell_ID];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone; //去掉下划线

}

- (void) initData {
    
    if(_riskTypesArray == nil ) {
        _riskTypesArray = [[NSMutableArray alloc] init];
    }
    
    RiskTypeModel *model00 = [[RiskTypeModel alloc] init];
    RiskTypeModel *model01 = [[RiskTypeModel alloc] init];
    model00.name = @"咨询记录统计";
    model00.isSelect = YES;   //默认选中第一个
    model01.name = @"随访档案统计";
    
    [_riskTypesArray addObject:model00];
    [_riskTypesArray addObject:model01];
    
    //默认选中第一个
    _oldSelectIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _riskTypesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RiskTypesLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:RiskTypesLeftVC_RiskTypesLeftCell_ID];
    RiskTypeModel *model = _riskTypesArray[indexPath.row];
    model.integer = indexPath.row+1;
    cell.riskTypeModel = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_oldSelectIndexPath != nil ) {
        //取消以前选中的
        RiskTypeModel *oldModel = _riskTypesArray[_oldSelectIndexPath.row];
        oldModel.isSelect = NO;
         [_riskTypesArray replaceObjectAtIndex:_oldSelectIndexPath.row withObject:oldModel];
        [self.tableView reloadRowsAtIndexPaths:@[_oldSelectIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic] ;
    }

    //选中当前的
//    RiskTypeModel *model = [_riskTypesArray[indexPath.section] objectAtIndex:indexPath.row];
    RiskTypeModel *model = _riskTypesArray[indexPath.row];
    model.isSelect = YES;
//    [_riskTypesArray[indexPath.section]  replaceObjectAtIndex:indexPath.row withObject:model];
    [_riskTypesArray replaceObjectAtIndex:indexPath.row withObject:model];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic] ;
    _oldSelectIndexPath = indexPath;  //记录当前选中的cell
    
    if ([self.delegate respondsToSelector:@selector(rsSRLeftVC:didSelectedRSSRLeftVC:)] ) {
        RiskTypeModel *model = [[RiskTypeModel alloc] init];
        //model = [_riskTypesArray[indexPath.section] objectAtIndex:indexPath.row];
        model = _riskTypesArray[indexPath.row];
        model.integer -= 1;
        [self.delegate rsSRLeftVC:self didSelectedRSSRLeftVC:model];
    }
}

@end