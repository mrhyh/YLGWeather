//
//  RSRKQuickViewMenuVC.m
//  Risk
//
//  Created by ylgwhyh on 16/7/13.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSRKQuickViewMenuVC.h"
#import "RSRiskDetailModel.h"

@interface RSRKQuickViewMenuVC () <UITableViewDelegate , UITableViewDataSource>

@property (nonatomic, strong) KYTableView *tableView;
@property (nonatomic, strong) KYMHLabel *headLabel;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *skipJSMutableArray;

@end

@implementation RSRKQuickViewMenuVC {
    
    CGFloat tableViewW;
    CGFloat cellW;
    CGFloat cellH;
    CGFloat spaceToLeft;
    CGFloat tableViewH;
    
    UIColor *labelTextColor;
}

static NSString * const RiskTypeDetailLeftCell_One_ID = @"RiskTypeDetailLeftCell_One_ID";

- (BOOL)willDealloc {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
}

- (void) initData {
    
    tableViewW = 140;
    cellW = 100;
    cellH = 35;
    spaceToLeft = 20;
    tableViewH = SCREEN_HEIGHT-49;
    
    labelTextColor = EF_TextColor_TextColorPrimary;
  
}

- (void) initUI {

    //获取数组中最长的字符串的宽度
    NSString *str;
    NSInteger strLength = 0;
    NSInteger index = 0;
    menuLsModel *tempmlModel = [[menuLsModel alloc] init];
    for (int i=0; i<_dataSource.count; i++ ) {
        tempmlModel = _dataSource[i];
        str = tempmlModel.meunName;
        size_t length = strlen([str cStringUsingEncoding:NSUTF8StringEncoding]);
        if ( length > strLength ) {
            strLength = length;
            index = i;
        }
    }
    
    if (_dataSource.count > 0) {
        tableViewH = (_dataSource.count+1 ) * cellH;
        tempmlModel = _dataSource[index];
        str =tempmlModel.meunName;
        
        CGSize maximumLabelSize = CGSizeMake(SCREEN_WIDTH-60, MAXFLOAT);
        
        NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine |
        NSStringDrawingUsesLineFragmentOrigin;
        
        NSDictionary *attr = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
        CGRect rect = [str boundingRectWithSize:maximumLabelSize
                                                  options:options
                                               attributes:attr
                                                  context:nil];

        if (rect.size.width+40 > tableViewW ) {
            tableViewW = rect.size.width+40;
            cellW = rect.size.width;
        }

    }
    
    if(_tableView == nil) {
        _tableView = [[KYTableView alloc] initWithFrame:CGRectMake(0, 0, tableViewW, tableViewH) style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.rowHeight = cellH;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        // 设置控制器在popover中显示的尺寸跟图片 一样
        self.preferredContentSize = self.tableView.frame.size;
        _tableView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tableView];
        
    }
}

- (instancetype)initWithArray:(NSArray *)array {
    if (self = [super init]) {
        
        _dataSource = [[NSMutableArray alloc] init];
        _dataSource = [array mutableCopy];

    }
    return self;
}

#pragma mark TableView data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"RSRKQuickViewMenuVC_ID%ld",(long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil)  {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    UIView *view = [[UIView alloc]init];
    view.backgroundColor=[UIColor grayColor];
    cell.selectedBackgroundView=view;
    
    menuLsModel *model = _dataSource[indexPath.row];
    
    NSString *firstStr = [model.meunName substringToIndex:1];
    if( ![firstStr isEqualToString:@"【"] ) {
        model.meunName = [NSString stringWithFormat:@"  %@",model.meunName];
    }

    KYMHLabel *label = [[KYMHLabel alloc] initWithTitle:model.meunName BaseSize:CGRectMake(spaceToLeft, 0, cellW, cellH) LabelColor:nil LabelFont:middleFontSize LabelTitleColor:labelTextColor TextAlignment:NSTextAlignmentLeft];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(spaceToLeft-5, 0, cellW+10, 0.5)];
    lineView.backgroundColor = EF_TextColor_TextColorDisable;
    
    [cell addSubview:lineView];
    [cell addSubview:label];
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataSource.count;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    menuLsModel *model = _dataSource[indexPath.row];
    if (_dataSource.count > indexPath.row ){
        if ([self.delegate respondsToSelector:@selector(menuSelected:)]) {
            [self.delegate menuSelected:model.id];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return cellH;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellW, cellH)];
    
    KYMHLabel *label = [[KYMHLabel alloc] initWithTitle:@" 快速查看菜单" BaseSize:CGRectMake(spaceToLeft, 0, cellW, cellH) LabelColor:nil LabelFont:middleFontSize LabelTitleColor:RiskTypeTitleColor TextAlignment:NSTextAlignmentLeft];
    [headView addSubview:label];
    
    return headView;
}

#pragma mark RSRKQuickViewMenuVCDelegate

- (void)menuSelected:(NSString *)string {

    NSLog(@"menuSelected");
}

- (void )dealloc {
    NSLog(@"RSCalendarVC-Dealloc");
}

@end