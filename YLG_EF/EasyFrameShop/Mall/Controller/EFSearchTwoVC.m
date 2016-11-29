//
//  EFSearchTwoVC.m
//  Dentist
//
//  Created by HqLee on 16/7/15.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "EFSearchTwoVC.h"
#import "UIButton+LXMImagePosition.h"
#import "SVProgressHUD.h"
#import "EFMallSearchVC.h"
#import "EFMallViewModel.h"
#import "EFMallModel.h"
#import "EFSearchHistroyCell.h"

static NSString *const Search_History = @"Search_History";
static NSString *const CellIdentifier = @"histroyCell";

static CGFloat const tagMargin = 10;
static NSInteger const maxColum = 4;

@interface EFSearchTwoVC()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray * historyArr;
@property (nonatomic, strong) NSArray *hotTags;
@property (nonatomic, strong) EFMallViewModel *viewModel;

@end
@implementation EFSearchTwoVC
{
    //尺寸、颜色
    NSNumber * _normal;
    NSNumber * _middle;
    NSNumber * _small;
    UIColor * _textMainColor;
    UIColor * _textSecondColor;
    
    //搜索栏
    UISearchBar * _searchBar;
    UIView      * searchView;
    KYMHButton  * cancelBtn;
    
    //大家都在搜View
    UIView      * topBackView;
    
    //tableview
    UITableView *historyTable;
    
    //cell
    KYMHButton *delBtn;
    UIColor *labelMainColor;
    
    int numberOfTagPage;
}

#pragma mark --- lazy load
- (EFMallViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[EFMallViewModel alloc] initWithViewController:self];
    }
    return _viewModel;
}
#pragma mark --- life cycle
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    searchView.hidden = YES;
    _searchBar.text = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    searchView.hidden = NO;
    [_searchBar becomeFirstResponder];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    [self setupView];
}

- (void)setupNavi{
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)setupView{
    numberOfTagPage = 0;
    
    labelMainColor = EF_TextColor_TextColorSecondary; //灰色
    self.view.backgroundColor = EF_BGColor_Primary;
    
    
    _normal = [EFSkinThemeManager getFontSizeWithKey:SkinThemeKey_FontSizeNormal];//17
    _middle = [EFSkinThemeManager getFontSizeWithKey:SkinThemeKey_FontSizeMiddle];//15
    _small = [EFSkinThemeManager getFontSizeWithKey:SkinThemeKey_FontSizeSmall];//13
    
    _textMainColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackNormal];
    _textSecondColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary];
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 44)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜索";
    _searchBar.searchBarStyle = UISearchBarStyleDefault;
    _searchBar.keyboardType = UIKeyboardTypeDefault;
    self.navigationItem.titleView = _searchBar;
    
    KYMHLabel * noteLB = [[KYMHLabel alloc]initWithTitle:@"您还没有搜索历史记录" BaseSize:CGRectMake(0, 10, SCREEN_WIDTH, 50) LabelColor:[UIColor clearColor] LabelFont:17 LabelTitleColor:[UIColor blackColor] TextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:noteLB];
    
    //获取历史搜索
    self.historyArr = [NSMutableArray array];
    NSArray *array = [[NSUserDefaults standardUserDefaults] arrayForKey:Search_History];
    self.historyArr = [self arrayToMutableArray:array];
    if (self.historyArr.count > 0) {
        [self seaerchHistoryTable];
    }
}

- (void)setupHotTagView{
    CGFloat width = (SCREEN_WIDTH - ((maxColum +1 ) * tagMargin)) / (maxColum);
    CGFloat height = 20;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat row = 0;
    CGFloat col = 0;
    NSInteger count = self.hotTags.count;
    for (NSInteger i = 0; i < count; i ++) {
        row = i / maxColum;
        col = i % maxColum;
        x = tagMargin + (tagMargin + width) * col;
        y = 45 + (tagMargin + height) * row;
        HotTagModel *tagModel = self.hotTags[i];
        UIButton *tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tagButton.titleLabel.font = [UIFont systemFontOfSize:15];
        tagButton.tag = i;
        tagButton.backgroundColor = EF_MainColor;
        [tagButton addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [tagButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tagButton setTitle:tagModel.name forState:UIControlStateNormal];
        tagButton.frame = CGRectMake(x, y, width, height);
        [topBackView addSubview:tagButton];
    }
}

- (void)resignFirstResponderGesture {
    [_searchBar resignFirstResponder];
}

- (void)seaerchHistoryTable {
    //tableview-headerview
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = _textSecondColor;
    [headView addSubview:line];
    
    KYMHLabel * tbLB = [[KYMHLabel alloc]initWithTitle:@"历史搜索" BaseSize:CGRectMake(10, 0, 100, 35) LabelColor:[UIColor clearColor] LabelFont:[_middle floatValue] LabelTitleColor:_textSecondColor TextAlignment:NSTextAlignmentLeft];
    [headView addSubview:tbLB];
    
    //tableview-footerview
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    footView.backgroundColor = [UIColor whiteColor];
    WS(weakSelf)
    KYMHButton * clearBtn = [[KYMHButton alloc]initWithbarButtonItem:self Title:@"清除搜索记录" BaseSize:CGRectMake(0, 0, SCREEN_WIDTH, 50) ButtonColor:[UIColor clearColor] ButtonFont:[_middle floatValue] ButtonTitleColor:[UIColor redColor] Block:^{
        //清除搜索记录
        NSLog(@"清除搜索记录");
        [weakSelf.historyArr removeAllObjects];
        historyTable.hidden = YES;
        
        [[NSUserDefaults standardUserDefaults] setObject:[self mugtableArrayToArray:self.historyArr] forKey:Search_History];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    [footView addSubview:clearBtn];
    
    //tableview
    UIColor *tableViewBorderColor = EF_TextColor_TextColorDisable;
    historyTable = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topBackView.frame)+10, SCREEN_WIDTH, SCREEN_HEIGHT-175-10-44-50-20)];
    [self.view addSubview:historyTable];
    historyTable.delegate = self;
    historyTable.dataSource = self;
    historyTable.showsVerticalScrollIndicator = NO;
    historyTable.backgroundColor = EF_BGColor_Primary;
    historyTable.separatorStyle = UITableViewCellAccessoryNone;
    historyTable.tableHeaderView = headView;
    historyTable.tableFooterView = footView;
    historyTable.layer.borderColor = tableViewBorderColor.CGColor;
    historyTable.layer.borderWidth = 0.5;
    
    if (IS_IPHONE4 || IS_IPHONE5) {
        historyTable.scrollEnabled = YES;
    }else {
        //historyTable.scrollEnabled = NO;
        historyTable.scrollEnabled = YES; //hyh
    }
}

#pragma mark --- event response
- (void)tagButtonClick:(UIButton *)sender{
    _searchBar.text = sender.currentTitle;
    [self search];
}

#pragma mark -- tableview设置
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.historyArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark ------------------ TableViewCell的创建 -----------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WS(weakSelf);
    EFSearchHistroyCell *cell = nil/*[tableView dequeueReusableCellWithIdentifier:CellIdentifier]*/;
    
    if (!cell ) {
        NSString *cellStr = [NSString stringWithFormat:@"%@",self.historyArr[indexPath.row]];
        cell = [[EFSearchHistroyCell alloc]initWithHistroy:cellStr];
        
        delBtn = [[KYMHButton alloc]initWithbarButtonItem:self Title:@"" BaseSize:CGRectMake(SCREEN_WIDTH-30, 15, 20, 20) ButtonColor:[UIColor clearColor] ButtonFont:0 ButtonTitleColor:nil Block:^{
            [weakSelf deleteHistroy:indexPath.row];
        }];
        [delBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/btn_nointerest"]] forState:UIControlStateNormal];
        [cell addSubview:delBtn];
    }
    
    if (indexPath.row == self.historyArr.count-1) {
        cell.line.frame = CGRectMake(0, 49.5, SCREEN_WIDTH, 0.5);
        cell.line.backgroundColor = EF_TextColor_TextColorDisable;
    }else{
    }
    
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"搜索该项");
    [_searchBar becomeFirstResponder];
    _searchBar.text = self.historyArr[indexPath.row];
    
}

- (void)deleteHistroy:(NSInteger)sender {
    NSLog(@"删除单项%ld-->刷新数据",(long)sender);
    
    [self.historyArr removeObjectAtIndex:sender];
    [[NSUserDefaults standardUserDefaults] setValue:self.historyArr forKey:Search_History];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (self.historyArr.count > 0) {
        historyTable.hidden = NO;
        [historyTable reloadData];
    }else {
        historyTable.hidden = YES;
    }
}

#pragma mark -- searchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [UIView animateWithDuration:0.1f animations:^{
        _searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH-50-20, 44);
        cancelBtn.frame = CGRectMake(CGRectGetMaxX(_searchBar.frame)+10, 0, 40, 44);
    }];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [UIView animateWithDuration:0.1f animations:^{
        _searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH-20, 44);
        cancelBtn.frame = CGRectMake(CGRectGetMaxX(_searchBar.frame)+10, 0, 40, 44);
    }];
    _searchBar.text = nil;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if ([UIUtil isEmptyStr:_searchBar.text]) {
        [UIUtil alert:@"请输入搜素内容"];
        return;
    }
    NSLog(@"搜索内容；；%@",_searchBar.text);
    NSLog(@"搜索内容；；%@",searchBar.text);
    for (int i = 0; i<self.historyArr.count; i++) {
        if ([self.historyArr[i] isEqualToString:_searchBar.text]) {
            [self.historyArr removeObjectAtIndex:i];
            [self.historyArr insertObject:_searchBar.text atIndex:0];
            [self search];
            return;
        }
    }
    if (self.historyArr.count== 5) {
        [self.historyArr removeObjectAtIndex:4];
        [self.historyArr insertObject:_searchBar.text atIndex:0];
    }else {
        [self.historyArr insertObject:_searchBar.text atIndex:0];
    }
    
    [self search];
    
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)search {
    NSString *keyWord = _searchBar.text;
    [_searchBar resignFirstResponder];
    [[NSUserDefaults standardUserDefaults] setObject:[self mugtableArrayToArray:self.historyArr] forKey:Search_History];
    [[NSUserDefaults standardUserDefaults] synchronize];
    historyTable.hidden = NO;
    [historyTable reloadData];
    EFMallSearchVC *searchVC = [[EFMallSearchVC alloc] initWithKeyWords:keyWord];
    [self.navigationController pushViewController:searchVC animated:NO];
}


- (NSArray *)mugtableArrayToArray:(NSMutableArray *)mutableArray {
    NSArray *array = [NSArray array];
    array = mutableArray;
    return array;
}

- (NSMutableArray *)arrayToMutableArray:(NSArray *)array {
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
    return mutableArray;
}
@end
