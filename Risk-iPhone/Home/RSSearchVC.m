//
//  RSSearchVC.m
//  Risk
//
//  Created by ylgwhyh on 16/7/4.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSSearchVC.h"
#import "RSSearchHistoryCell.h"
#import "UIButton+LXMImagePosition.h"
#import "RiskTypeFDARightCell.h"
#import "SVProgressHUD.h"
#import "RSRiskViewModel.h"
#import "RSMethod.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "RSDataVC.h"
#import "RSVideoVC.h"

#import "RiskTypeDetailVC.h"

#define Regex @"[a-zA-Z0-9\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]*"

/// 只能输入数字、字母、汉字
#define DEF_NUMBERCHARCHINA [self specialSymbolsAction]

@interface RSSearchVC () <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate> {
    RSSearchVCClickBlack searchVCClickBlock;
}

@property (nonatomic, strong) NSMutableArray * historyArr;
@property (nonatomic, strong) NSMutableArray * searchArr;
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong)  UIView *footView;
@property (nonatomic, strong)  UIView *headView;
@property (nonatomic, strong)  UITableView *historyTable;

@property (nonatomic,  assign) BOOL isFirstJoin;

@property (nonatomic, strong) RSRiskViewModel * viewModel;

//请求参数
@property (nonatomic, strong) NSString *keywordString;

@property (nonatomic, strong) UIView * submitRiskView;   //提交风险名词view
@property (nonatomic, strong) UITextView * textview;

@property (nonatomic, strong) UILabel * noDataLB;  //无历史记录时显示
@property (nonatomic, strong) UIView * noResultView;  //无搜索返回时显示
@property (nonatomic, strong) UIButton * submitBtn;  //提交按钮


@end

@implementation RSSearchVC {
    
    //尺寸、颜色
    UIColor * _textMainColor;
    UIColor * _textSecondColor;
    
    //搜索栏
    UITextField * _searchBar;
    UIView      * searchView;
    KYMHButton  * cancelBtn;
    
    //cell
    KYMHButton *delBtn;
    UIColor *labelMainColor;
    
    int numberOfTagPage;
    
    
    BOOL  isSearch;
    
    CGRect  keyboardFrameEndRect;
    UIView * backView;
    
}

#define SearchHistory_UserDefault_Key @"SearchHistory_UserDefault_Key"


- (BOOL)willDealloc {
    return NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    searchView.hidden = YES;
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    searchView.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = EF_BGColor_Primary;
    
    self.viewModel = [[RSRiskViewModel alloc]initWithViewController:self];
    
    [self initData];
    [self initUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myNotificationMethod:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)myNotificationMethod:(NSNotification*)notification
{
    NSLog(@"-- keyboard change --");
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    NSValue* keyboardFrameend = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    keyboardFrameEndRect = [keyboardFrameend CGRectValue];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    NSLog(@"键盘开始是 %@",NSStringFromCGRect(keyboardFrameBeginRect));
    NSLog(@"键盘结束是 %@",NSStringFromCGRect(keyboardFrameEndRect));
    NSLog(@"%f",keyboardFrameEndRect.size.height);
    //键盘消失
    if ( keyboardFrameEndRect.origin.y == SCREEN_HEIGHT) {
        [UIView animateWithDuration:0.2 animations:^{
            backView.center = CGPointMake(SCREEN_WIDTH/2, 300);
        }];
    }
    //键盘弹出
    else if ( keyboardFrameEndRect.origin.y == SCREEN_HEIGHT - keyboardFrameEndRect.size.height) {
        [UIView animateWithDuration:0.2 animations:^{
            backView.center = CGPointMake(SCREEN_WIDTH/2, 170);
        }];
    }
}

- (void) initData {
    _isFirstJoin = YES;
    _dataSource = [[NSMutableArray alloc] init];
    _historyArr = [[NSMutableArray alloc] init];
    _searchArr = [[NSMutableArray alloc] init];
    labelMainColor = EF_TextColor_TextColorSecondary; //灰色
    _textMainColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackNormal];
    _textSecondColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary];
    numberOfTagPage = 0;
    
    _viewModel = [[RSRiskViewModel alloc] initWithViewController:self];
}

- (void ) initUI {
    self.navigationItem.hidesBackButton = YES;
    self.view.backgroundColor = EF_BGColor_Primary;
    [self initNavigationRightBack];
    [self initSearchView];
    [self initSearchHistoryView];
}

- (void) initNavigationRightBack {
    KYMHButton *backButton = [[KYMHButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:Img(@"icon_previous") forState:UIControlStateNormal];
    backButton.titleLabel.font = Font(middleFontSize);
    [backButton horizontalCenterImageAndTitle];
    [backButton addTarget:self action:@selector(backButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

- (void)backButtonClickAction:(UIButton *)backBtn {
    if (YES == _isRSVAPatientArchiveVCBool) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else {
           [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) initSearchHistoryView {
    //获取历史搜索
//    NSArray *array = [[NSUserDefaults standardUserDefaults] arrayForKey:SearchHistory_UserDefault_Key];
//    self.historyArr = [array mutableCopy];
    
    self.historyArr = [RSFDARiskModel readContentsModel];
    [self seaerchHistoryTable];
}

- (void)initNoResultView {
    if (_noResultView == nil) {
        _noResultView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _noResultView.backgroundColor = [UIColor whiteColor];
        [_historyTable addSubview:_noResultView];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackDivider];
        [_noResultView addSubview:line];
        
        UILabel * leftLB = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 150, 20)];
        leftLB.backgroundColor = [UIColor clearColor];
        leftLB.text = @"尚未收录此药品";
        leftLB.font = Font(14);
        leftLB.textColor = [UIColor colorWithHexString:@"#6495ED"];
        [_noResultView addSubview:leftLB];
        
        UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setTitle:@"我来提交" forState:0];
        [addBtn setTitleColor:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackNormal] forState:0];
        addBtn.frame = CGRectMake(CGRectGetWidth(_noResultView.frame)-100, 10, 90, 30);
        addBtn.titleLabel.font = Font(13);
        [addBtn.layer setCornerRadius:5];
        [addBtn.layer setBorderWidth:0.5];
        [addBtn.layer setBorderColor:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackDivider].CGColor];
        [addBtn addTarget:self action:@selector(initSubmitRiskView) forControlEvents:UIControlEventTouchUpInside];
        [_noResultView addSubview:addBtn];
    }
}

- (void)initSubmitRiskView {
    _submitRiskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _submitRiskView.backgroundColor = RGBAColor(0, 0, 0, 0.5);
    [[UIApplication sharedApplication].keyWindow addSubview:_submitRiskView];
    
    backView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, 250)];
    backView.backgroundColor =[UIColor whiteColor];
    [backView.layer setCornerRadius:6];
    [_submitRiskView addSubview:backView];
    backView.center = CGPointMake(SCREEN_WIDTH/2, 170);
    
    UILabel * titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, 30)];
    titleLB.text = @"提交风险药品名称";
    titleLB.textColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackNormal];
    titleLB.font = Font(15);
    titleLB.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:titleLB];
    
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.backgroundColor = [UIColor clearColor];
    [closeBtn addTarget:self action:@selector(closeTheView) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setTitle:@"关闭" forState:0];
    [closeBtn setTitleColor:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary] forState:0];
    closeBtn.frame = CGRectMake(10, 0, 50, 30);
    [backView addSubview:closeBtn];
    
    _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitBtn.backgroundColor = [UIColor clearColor];
    [_submitBtn setTitle:@"提交" forState:0];
    [_submitBtn setTitleColor:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary] forState:0];
    [_submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    _submitBtn.frame = CGRectMake(CGRectGetWidth(backView.frame)-60, 0, 50, 30);
    [backView addSubview:_submitBtn];
    
    if ([UIUtil isNoEmptyStr:_textview.text] ) {
        UIColor *titleColor = EF_MainColor;
        [_submitBtn setTitleColor:titleColor forState:UIControlStateNormal];
    }
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 30, CGRectGetWidth(backView.frame), 0.5)];
    line.backgroundColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackNormal];
    [backView addSubview:line];
    
    _textview = [[UITextView alloc]initWithFrame:CGRectMake(10, 40, CGRectGetWidth(backView.frame)-20, CGRectGetHeight(backView.frame)-50)];
    _textview.backgroundColor = [UIColor whiteColor];
    _textview.scrollEnabled = NO;    //当文字超过视图的边框时是否允许滑动，默认为“YES”
    _textview.editable = YES;        //是否允许编辑内容，默认为“YES”
    _textview.delegate = self;       //设置代理方法的实现类
    _textview.font= Font(15); //设置字体名字和字体大小;
    _textview.returnKeyType = UIReturnKeyDefault;//return键的类型
    _textview.keyboardType = UIKeyboardTypeDefault;//键盘类型
    _textview.textAlignment = NSTextAlignmentLeft; //文本显示的位置默认为居左
    _textview.dataDetectorTypes = UIDataDetectorTypeAll; //显示数据类型的连接模式（如电话号码、网址、地址等）
    _textview.textColor = [UIColor blackColor];
    _textview.text = _keywordString;
    [backView addSubview:_textview];
    [_textview becomeFirstResponder];
    
    UILabel * bottomLB = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetHeight(backView.frame)-20, CGRectGetWidth(backView.frame)-20, 20)];
    bottomLB.backgroundColor= [UIColor clearColor];
    bottomLB.text = @"---请提交准确药品名称，我们将尽快添加！";
    bottomLB.textColor = [UIColor colorWithHexString:@"#6495ED"];
    bottomLB.font = Font(13);
    bottomLB.textAlignment = NSTextAlignmentRight;
    [backView addSubview:bottomLB];
}

//关闭
- (void)closeTheView {
    if (_submitRiskView != nil) {
        [_submitRiskView removeFromSuperview];
        _submitRiskView = nil;
    }
}

//提交
- (void)submitAction {
    if ([UIUtil isEmptyStr:_textview.text]) {
        [UIUtil alert:@"请输入要提交的名词"];
        return;
    }else {
        [self.viewModel submitRisk:_textview.text];
    }
}

#pragma mark Set 

- (void ) setIsRSVAPatientArchiveVCBool:(BOOL)isRSVAPatientArchiveVCBool {
    _isRSVAPatientArchiveVCBool = isRSVAPatientArchiveVCBool;
}

#pragma mark

- (void )RSSearchVCClickBlack:(RSSearchVCClickBlack )block {
    searchVCClickBlock = block;
}

#pragma mark ---- textview  delegate--------

- (void)textViewDidChange:(UITextView *)textView {
    if ([UIUtil isNoEmptyStr:_textview.text] ) {
        UIColor *titleColor = EF_MainColor;
        [_submitBtn setTitleColor:titleColor forState:UIControlStateNormal];
    }else {
        [_submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([UIUtil isNoEmptyStr:_textview.text] ) {
        UIColor *titleColor = EF_MainColor;
        [_submitBtn setTitleColor:titleColor forState:UIControlStateNormal];
    }else {
        [_submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return YES;
}

#pragma end

- (void) initSearchView {
    
    WS(weakSelf)
    searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-90, 44)];
    searchView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = searchView;
    
    UIView * searchbackView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH-90-50, 34)];
    searchbackView.backgroundColor = [UIColor whiteColor];
    [searchbackView.layer setCornerRadius:5];
    [searchView addSubview:searchbackView];
    
    _searchBar = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH-90-50, 34)];
//    _searchBar.delegate = self;
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.placeholder = @"如: 阿司匹林、ASPL ";
    _searchBar.delegate = self;
    _searchBar.textColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackNormal];
    _searchBar.keyboardType = UIKeyboardTypeDefault;
    [_searchBar becomeFirstResponder];
    [searchbackView addSubview:_searchBar];
    
    [_searchBar addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    cancelBtn = [[KYMHButton alloc]initWithbarButtonItem:self Title:@"取 消" BaseSize:CGRectMake(CGRectGetMaxX(_searchBar.frame)+10, 0, 40, 44) ButtonColor:[UIColor clearColor] ButtonFont:middleFontSize ButtonTitleColor:[UIColor whiteColor] Block:^{
        
        if (YES == _isRSVAPatientArchiveVCBool) {  //从随访档案进来此属性才会为YES
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        
        if ([UIUtil isEmptyStr:_searchBar.text]) {
            return;
        }
        
        isSearch = NO;
        [_searchBar resignFirstResponder];
        _searchBar.text = @"";
        weakSelf.noResultView.hidden = YES;
        [SVProgressHUD dismiss];
        [weakSelf.searchArr removeAllObjects];
        [weakSelf.historyArr removeAllObjects];
        weakSelf.historyArr = [RSFDARiskModel readContentsModel];
        
//        weakSelf.headView.hidden = NO;
//        weakSelf.footView.hidden = NO;
//        weakSelf.historyTable.tableHeaderView = weakSelf.headView;
//        weakSelf.historyTable.tableFooterView = weakSelf.footView;
        
        [weakSelf seaerchHistoryTable];
    }];
    [searchView addSubview:cancelBtn];
}

- (void)resignFirstResponderGesture {
    [_searchBar resignFirstResponder];
}

- (void ) searchRequest {
    [self.viewModel findRiskByKeyWord:_pageCount size:MFDefaultPageSize keyword:_keywordString];
}

- (void)seaerchHistoryTable {

     WS(weakSelf)
    
    if(_headView == nil) {
        
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
        _headView.backgroundColor = [UIColor whiteColor];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = _textSecondColor;
        [_headView addSubview:line];
        
        KYMHLabel * tbLB = [[KYMHLabel alloc]initWithTitle:@"历史搜索" BaseSize:CGRectMake(10, 0, 100, 35) LabelColor:[UIColor clearColor] LabelFont:middleFontSize LabelTitleColor:_textSecondColor TextAlignment:NSTextAlignmentLeft];
        [_headView addSubview:tbLB];
    }
    
    if(_footView == nil) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _footView.backgroundColor = [UIColor whiteColor];
        
        KYMHButton * clearBtn = [[KYMHButton alloc]initWithbarButtonItem:self Title:@"清除搜索记录" BaseSize:CGRectMake(0, 0, SCREEN_WIDTH, 50) ButtonColor:[UIColor clearColor] ButtonFont:middleFontSize ButtonTitleColor:[UIColor redColor] Block:^{
            
            NSLog(@"清除搜索记录");
            [weakSelf.historyArr removeAllObjects];
            
            [RSFDARiskModel saveContentsModel:weakSelf.historyArr];
            
            [weakSelf seaerchHistoryTable];
        }];
        [_footView addSubview:clearBtn];
    }
    
    
    if(_historyTable == nil) {
        UIColor *tableViewBorderColor = EF_TextColor_TextColorDisable;
        _historyTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        [self.view addSubview:_historyTable];
        _historyTable.backgroundColor = [UIColor whiteColor];
        _historyTable.delegate = self;
        _historyTable.dataSource = self;
        _historyTable.showsVerticalScrollIndicator = NO;
        _historyTable.backgroundColor = EF_BGColor_Primary;
        _historyTable.separatorStyle = UITableViewCellAccessoryNone;
        _historyTable.layer.borderColor = tableViewBorderColor.CGColor;
        _historyTable.layer.borderWidth = 0.5;
        [_historyTable registerClass:[RiskTypeFDARightCell class] forCellReuseIdentifier:@"histroyCell"];
        
        _noDataLB = [[KYMHLabel alloc]initWithTitle:@"您还没有历史搜索记录" BaseSize:CGRectMake(0, 50, SCREEN_WIDTH, 50) LabelColor:[UIColor clearColor] LabelFont:17 LabelTitleColor:[UIColor blackColor] TextAlignment:NSTextAlignmentCenter];
        [_historyTable addSubview:_noDataLB];
        _noDataLB.hidden = YES;
    }
    
    if (_searchArr.count <= 0) {
        if(self.historyArr.count <= 0) {
            _noDataLB.hidden = NO;
            
            _headView.hidden = YES;
            _footView.hidden = YES;
            _historyTable.tableHeaderView = nil;
            _historyTable.tableFooterView = nil;
        }else {
            _noDataLB.hidden = YES;
            
            _headView.hidden = NO;
            _footView.hidden = NO;
            _historyTable.tableHeaderView = _headView;
            _historyTable.tableFooterView = _footView;
        }
    }else {
        
    }
    
    [_historyTable reloadData];
}

#pragma mark TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!isSearch) {
        return self.historyArr.count;
    }else {
        return self.searchArr.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id model;
    if (!isSearch) {
        model = _historyArr[indexPath.row];
        
//        return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[RiskTypeFDARightCell class] contentViewWidth:[self cellContentViewWith]];
        
    }else {
        model = _searchArr[indexPath.row];
        
//        return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[RiskTypeFDARightCell class] contentViewWidth:[self cellContentViewWith]];
    }
    
    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[RiskTypeFDARightCell class] contentViewWidth:[self cellContentViewWith]];
    
}

- (CGFloat)cellContentViewWith {
    
    CGFloat width = SCREEN_WIDTH;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = SCREEN_HEIGHT;
    }
    
    return width;
}


#pragma mark TableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier_ID = @"histroyCell";
    RiskTypeFDARightCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_ID];
    if (!cell) {
        cell = [[RiskTypeFDARightCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier_ID];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    
    if (!isSearch) {
        RSFDARiskModel *model = _historyArr[indexPath.row];
        cell.keyWord = @"";
        cell.model = model;
    }else {
        RSFDARiskModel *model = _searchArr[indexPath.row];
        cell.keyWord = _keywordString;
        cell.model = model;
    }
    
    return cell;
    
//    if (!isSearch) {
//        NSString *cellIdentifier_ID = @"histroyCell";
//        RSFDARiskModel *model = _historyArr[indexPath.row];
//        RiskTypeFDARightCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_ID];
//        if (!cell) {
//            cell = [[RiskTypeFDARightCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier_ID];
//        }
//        
//        cell.keyWord = @"";
//        if ([model.stype isEqualToString:@"file"]) {
//            cell.fileModel = model;
//        }else {
//            cell.histroyModel = model;
//        }
//        
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
//        
//        return cell;
//    }else {
//        NSString *cellIdentifier_ID = @"histroyCell_1";
//        RSFDARiskModel *model = _searchArr[indexPath.row];
//        RiskTypeFDARightCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_ID];
//        if (!cell) {
//            cell = [[RiskTypeFDARightCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier_ID];
//        }
//        
//        cell.keyWord = _keywordString;
//        
//        if ([model.stype isEqualToString:@"file"]) {
//            cell.fileModel = model;
//        }else {
//            cell.model = model;
//        }
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
//        
//        return cell;
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!isSearch) {
        NSLog(@"搜索该项");
        [_searchBar becomeFirstResponder];
        
        RSFDARiskModel * model = self.historyArr[indexPath.row];
        
        if (_isRSVAPatientArchiveVCBool && [model.stype isEqualToString:@"risk"]) {
            searchVCClickBlock(model.name, model.objectId); //用于随访档案block回调
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        
        if ([model.stype isEqualToString:@"file"]) {
            if(model.isVideo ) {
                RSVideoVC *next= [[RSVideoVC alloc]initWithCallBack:^(BOOL isSuccess) {
                }];
                next.title = @"视频";
                next.objectId = model.objectId;
                [self.navigationController pushViewController:next animated:YES];
            }else {
                RSDataVC *vc = [[RSDataVC alloc]initWithCallBack:^(BOOL isSuccess) {
                    
                    
                }];
                vc.objectId = (int)model.objectId;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else {
            RiskTypeDetailVC * vc = [[RiskTypeDetailVC alloc]init];
            vc.objectId = (int)model.objectId;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        
    }else {
        RSFDARiskModel *model = self.searchArr[indexPath.row];

        NSMutableArray * mutableArray = [NSMutableArray array];
        mutableArray = [RSFDARiskModel readContentsModel];
        
        if (mutableArray.count > 0) {
            if ([self hasObject:model InArray:mutableArray]) {
                for (int i = 0; i<mutableArray.count; i++) {
                    RSFDARiskModel * oldModel = mutableArray[i];
                    if ([oldModel.name isEqualToString:model.name]) {
                        [mutableArray removeObjectAtIndex:i];
                        [mutableArray insertObject:model atIndex:0];
                    }
                }
            }else {
                [mutableArray insertObject:model atIndex:0];
            }
        }else {
            [mutableArray addObject:model];
        }
        
        [RSFDARiskModel saveContentsModel:mutableArray];
        
        //从随访档案进入搜索并回调待会数据
        if (_isRSVAPatientArchiveVCBool && [model.stype isEqualToString:@"risk"]) {
            searchVCClickBlock(model.name, model.objectId); //用于随访档案block回调
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        
        
        if ([model.stype isEqualToString:@"file"]) {
            if(model.isVideo ) {
                RSVideoVC *next= [[RSVideoVC alloc]initWithCallBack:^(BOOL isSuccess) {
                    
                    
                }];
                next.title = @"视频";
                next.objectId = model.objectId;
                [self.navigationController pushViewController:next animated:YES];
            }else {
                RSDataVC *vc = [[RSDataVC alloc]initWithCallBack:^(BOOL isSuccess) {
                    
                    
                }];
                vc.objectId = (int)model.objectId;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else {
            RiskTypeDetailVC * vc = [[RiskTypeDetailVC alloc]init];
            vc.objectId = (int)model.objectId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (BOOL)hasObject:(RSFDARiskModel *)_model InArray:(NSMutableArray *)array {
    
    for (int i = 0; i<array.count; i++) {
        RSFDARiskModel * oldModel = array[i];
        if ([oldModel.name isEqualToString:_model.name]) {
            return YES;
        }
    }
    return NO;
}

- (void)deleteHistroy:(NSInteger)sender {
    
    NSLog(@"删除单项%ld-->刷新数据",(long)sender);
    [self.historyArr removeObjectAtIndex:sender];
    [[NSUserDefaults standardUserDefaults] setValue:self.historyArr forKey:SearchHistory_UserDefault_Key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self seaerchHistoryTable];
}

#pragma mark - TextFiledDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
//    if (![pred evaluateWithObject:string] && ![UIUtil isEmptyStr:string]) {
//        return NO;
//    }
//    return YES;
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:DEF_NUMBERCHARCHINA]invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if(basicTest){
        if([string isEqualToString:@""]){
            return YES;
        }
        return NO;
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)notification
{
    UITextField *textField = notification;
    
    if (![UIUtil isEmptyStr:textField.text]) {
        NSLog(@"%@",textField.text);
        isSearch = YES;
        _keywordString = textField.text;
        [self searchRequest];
    }else {
        isSearch = NO;
        _keywordString = @"";
        [_searchArr removeAllObjects];
        [self initSearchHistoryView];
    }
}

- (NSArray *)mugtableArrayToArray:(NSMutableArray *)mutableArray {
    NSArray *array = [[NSArray alloc] init];
    array = [mutableArray mutableCopy];
    return array;
}

- (NSMutableArray *)arrayToMutableArray:(NSArray *)array {
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
    return mutableArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ViewModel回调

- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    
    [SVProgressHUD dismiss];
    if (action & RSRisk_NS_ENUM_findRiskByKeyWord) {
        if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeSuccess) {
            _searchArr = [self.viewModel.rsSearchResultArr mutableCopy];
            if (self.viewModel.rsSearchResultArr.count > 0) {
                
                if (_noResultView != nil) {
                    _noResultView.hidden = YES;
                    [_noResultView removeFromSuperview];
                    _noResultView = nil;
                }
                _noDataLB.hidden = YES;
                _headView.hidden = YES;
                _footView.hidden = YES;
                _historyTable.tableHeaderView = nil;
                _historyTable.tableFooterView = nil;
                [self.historyTable reloadData];
            }else if (self.viewModel.rsSearchResultArr.count <= 0) {
                [self.historyTable reloadData];
                [self initNoResultView];
            }
        }
    }
    
    if (action == RSRisk_NS_ENUM_submitRisk) {
        if (result.status == 200) {
            [UIUtil alert:@"提交成功"];
            _submitRiskView.hidden = YES;
            [_submitRiskView removeFromSuperview];
            _submitRiskView = nil;
        }else {
            [UIUtil alert:result.message];
        }
    }
}


//特殊符号处理
/// 特殊符号
- (NSString *)specialSymbolsAction{
    //数学符号
    NSString *matSym = @" ﹢﹣×÷±/=≌∽≦≧≒﹤﹥≈≡≠=≤≥<>≮≯∷∶∫∮∝∞∧∨∑∏∪∩∈∵∴⊥∥∠⌒⊙√∟⊿㏒㏑%‰⅟½⅓⅕⅙⅛⅔⅖⅚⅜¾⅗⅝⅞⅘≂≃≄≅≆≇≈≉≊≋≌≍≎≏≐≑≒≓≔≕≖≗≘≙≚≛≜≝≞≟≠≡≢≣≤≥≦≧≨≩⊰⊱⋛⋚∫∬∭∮∯∰∱∲∳%℅‰‱øØπ";
    
    //标点符号
    NSString *punSym = @"。，、＇：∶；?‘’“”〝〞ˆˇ﹕︰﹔﹖﹑·¨….¸;！´？！～—ˉ｜‖＂〃｀@﹫¡¿﹏﹋﹌︴々﹟#﹩$﹠&﹪%*﹡﹢﹦﹤‐￣¯―﹨ˆ˜﹍﹎+=<＿_-ˇ~﹉﹊（）〈〉‹›﹛﹜『』〖〗［］《》〔〕{}「」【】︵︷︿︹︽_﹁﹃︻︶︸﹀︺︾ˉ﹂﹄︼❝❞!():,'[]｛｝^・.·．•＃＾＊＋＝＼＜＞＆§⋯`－–／—|\"\\";
    
    //单位符号＊·
    NSString *unitSym = @"°′″＄￥〒￠￡％＠℃℉﹩﹪‰﹫㎡㏕㎜㎝㎞㏎㎎㎏㏄º○¤%$º¹²³";  //
    
    //货币符号
    NSString *curSym = @"₽€£Ұ₴$₰¢₤¥₳₲₪₵元₣₱฿¤₡₮₭₩ރ円₢₥₫₦ł﷼₠₧₯₨Kčर₹ƒ₸￠";
    
    //制表符
    NSString *tabSym = @"─ ━│┃╌╍╎╏┄ ┅┆┇┈ ┉┊┋┌┍┎┏┐┑┒┓└ ┕┖┗ ┘┙┚┛├┝┞┟┠┡┢┣ ┤┥┦┧┨┩┪┫┬ ┭ ┮ ┯ ┰ ┱ ┲ ┳ ┴ ┵ ┶ ┷ ┸ ┹ ┺ ┻┼ ┽ ┾ ┿ ╀ ╁ ╂ ╃ ╄ ╅ ╆ ╇ ╈ ╉ ╊ ╋ ╪ ╫ ╬═║╒╓╔ ╕╖╗╘╙╚ ╛╜╝╞╟╠ ╡╢╣╤ ╥ ╦ ╧ ╨ ╩ ╳╔ ╗╝╚ ╬ ═ ╓ ╩ ┠ ┨┯ ┷┏ ┓┗ ┛┳ ⊥ ﹃ ﹄┌ ╮ ╭ ╯╰";
    
    return [NSString stringWithFormat:@"%@%@%@%@%@",matSym,punSym,unitSym,curSym,tabSym];
}

/*
 *常用符号大全
 *特殊符号 编号序号 数学符号 爱心符号 标点符号 单位符号 货币符号 箭头符号 符号图案 希腊字母 俄语字母
 *汉语拼音 中文字符 日语字符 制表符 皇冠符号
 */

/*
 //特殊符号
 ♠♣♧♡♥❤❥❣♂♀✲☀☼☾☽◐◑☺☻☎☏✿❀№↑↓←→√×÷★℃℉°◆◇⊙■□△▽¿½☯✡㍿卍卐♂♀✚〓㎡♪♫♩♬㊚㊛囍㊒㊖Φ♀♂‖$@*&#※卍卐Ψ♫♬♭♩♪♯♮⌒¶∮‖€￡¥$
 
 //编号序号
 ①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑰⑱⑲⑳⓪❶❷❸❹❺❻❼❽❾❿⓫⓬⓭⓮⓯⓰⓱⓲⓳⓴㊀㊁㊂㊃㊄㊅㊆㊇㊈㊉㈠㈡㈢㈣㈤㈥㈦㈧㈨㈩⑴⑵⑶⑷⑸⑹⑺⑻⑼⑽⑾⑿⒀⒁⒂⒃⒄⒅⒆⒇⒈⒉⒊⒋⒌⒍⒎⒏⒐⒑⒒⒓⒔⒕⒖⒗⒘⒙⒚⒛ⅠⅡⅢⅣⅤⅥⅦⅧⅨⅩⅪⅫⅰⅱⅲⅳⅴⅵⅶⅷⅸⅹⒶⒷⒸⒹⒺⒻⒼⒽⒾⒿⓀⓁⓂⓃⓄⓅⓆⓇⓈⓉⓊⓋⓌⓍⓎⓏⓐⓑⓒⓓⓔⓕⓖⓗⓘⓙⓚⓛⓜⓝⓞⓟⓠⓡⓢⓣⓤⓥⓦⓧⓨⓩ⒜⒝⒞⒟⒠⒡⒢⒣⒤⒥⒦⒧⒨⒩⒪⒫⒬⒭⒮⒯⒰⒱⒲⒳⒴⒵
 
 //数学符号
 ﹢﹣×÷±/=≌∽≦≧≒﹤﹥≈≡≠=≤≥<>≮≯∷∶∫∮∝∞∧∨∑∏∪∩∈∵∴⊥∥∠⌒⊙√∟⊿㏒㏑%‰⅟½⅓⅕⅙⅛⅔⅖⅚⅜¾⅗⅝⅞⅘≂≃≄≅≆≇≈≉≊≋≌≍≎≏≐≑≒≓≔≕≖≗≘≙≚≛≜≝≞≟≠≡≢≣≤≥≦≧≨≩⊰⊱⋛⋚∫∬∭∮∯∰∱∲∳%℅‰‱øØπ
 
 //爱心符号
 ♥❣ღ♠♡♤❤❥
 
 //标点符号
 。，、＇：∶；?‘’“”〝〞ˆˇ﹕︰﹔﹖﹑·¨….¸;！´？！～—ˉ｜‖＂〃｀@﹫¡¿﹏﹋﹌︴々﹟#﹩$﹠&﹪%*﹡﹢﹦﹤‐￣¯―﹨ˆ˜﹍﹎+=<＿_-ˇ~﹉﹊（）〈〉‹›﹛﹜『』〖〗［］《》〔〕{}「」【】︵︷︿︹︽_﹁﹃︻︶︸﹀︺︾ˉ﹂﹄︼❝❞!():,'[]｛｝^・.·．•＃＾＊＋＝＼＜＞＆§⋯`－–／—|\"\\
 
 //单位符号
 °′″＄￥〒￠￡％＠℃℉﹩﹪‰﹫㎡㏕㎜㎝㎞㏎m³㎎㎏㏄º○¤%$º¹²³
 
 //货币符号
 ₽€£Ұ₴$₰¢₤¥₳₲₪₵元₣₱฿¤₡₮₭₩ރ円₢₥₫₦zł﷼₠₧₯₨Kčर₹ƒ₸￠
 
 //箭头符号
 ↑↓←→↖↗↘↙↔↕➻➼➽➸➳➺➻➴➵➶➷➹▶►▷◁◀◄«»➩➪➫➬➭➮➯➱⏎➲➾➔➘➙➚➛➜➝➞➟➠➡➢➣➤➥➦➧➨↚↛↜↝↞↟↠↠↡↢↣↤↤↥↦↧↨⇄⇅⇆⇇⇈⇉⇊⇋⇌⇍⇎⇏⇐⇑⇒⇓⇔⇖⇗⇘⇙⇜↩↪↫↬↭↮↯↰↱↲↳↴↵↶↷↸↹☇☈↼↽↾↿⇀⇁⇂⇃⇞⇟⇠⇡⇢⇣⇤⇥⇦⇧⇨⇩⇪↺↻⇚⇛♐
 
 //符号图案
 ✐✎✏✑✒✍✉✁✂✃✄✆✉☎☏☑✓✔√☐☒✗✘ㄨ✕✖✖☢☠☣✈★☆✡囍㍿☯☰☲☱☴☵☶☳☷☜☞☝✍☚☛☟✌♤♧♡♢♠♣♥♦☀☁☂❄☃♨웃유❖☽☾☪✿♂♀✪✯☭➳卍卐√×■◆●○◐◑✙☺☻❀⚘♔♕♖♗♘♙♚♛♜♝♞♟♧♡♂♀♠♣♥❤☜☞☎☏⊙◎☺☻☼▧▨♨◐◑↔↕▪▒◊◦▣▤▥▦▩◘◈◇♬♪♩♭♪の★☆→あぃ￡Ю〓§♤♥▶¤✲❈✿✲❈➹☀☂☁【】┱┲❣✚✪✣✤✥✦❉❥❦❧❃❂❁❀✄☪☣☢☠☭ღ▶▷◀◁☀☁☂☃☄★☆☇☈⊙☊☋☌☍ⓛⓞⓥⓔ╬『』∴☀♫♬♩♭♪☆∷﹌の★◎▶☺☻►◄▧▨♨◐◑↔↕↘▀▄█▌◦☼♪の☆→♧ぃ￡❤▒▬♦◊◦♠♣▣۰•❤•۰►◄▧▨♨◐◑↔↕▪▫☼♦⊙●○①⊕◎Θ⊙¤㊣★☆♀◆◇◣◢◥▲▼△▽⊿◤◥✐✌✍✡✓✔✕✖♂♀♥♡☜☞☎☏⊙◎☺☻►◄▧▨♨◐◑↔↕♥♡▪▫☼♦▀▄█▌▐░▒▬♦◊◘◙◦☼♠♣▣▤▥▦▩◘◙◈♫♬♪♩♭♪✄☪☣☢☠♯♩♪♫♬♭♮☎☏☪♈ºº₪¤큐«»™♂✿♥　◕‿-｡　｡◕‿◕｡
 
 //希腊字母
 ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζνξοπρσηθικλμτυφχψω
 
 //俄语字母
 АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюя
 
 //汉语拼音
 āáǎàōóǒòēéěèīíǐìūúǔùǖǘǚǜüêɑńňɡㄅㄆㄇㄈㄉㄊㄋㄌㄍㄎㄏㄐㄑㄒㄓㄔㄕㄖㄗㄘㄙㄚㄛㄜㄝㄞㄟㄠㄡㄢㄣㄤㄥㄦㄧㄨㄩ
 
 //中文字符
 零壹贰叁肆伍陆柒捌玖拾佰仟万亿吉太拍艾分厘毫微卍卐卄巜弍弎弐朤氺曱甴囍兀々〆のぁ〡〢〣〤〥〦〧〨〩㊎㊍㊌㊋㊏㊚㊛㊐㊊㊣㊤㊥㊦㊧㊨㊒㊫㊑㊓㊔㊕㊖㊗㊘㊜㊝㊞㊟㊠㊡㊢㊩㊪㊬㊭㊮㊯㊰㊀㊁㊂㊃㊄㊅㊆㊇㊈㊉
 
 //日文平假名片假名
 ぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎわゐゑをんゔゕゖァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶヷヸヹヺ・ーヽヾヿ゠ㇰㇱㇲㇳㇴㇵㇶㇷㇸㇹㇺㇻㇼㇽㇾㇿ
 
 //制表符
 ─ ━│┃╌╍╎╏┄ ┅┆┇┈ ┉┊┋┌┍┎┏┐┑┒┓└ ┕┖┗ ┘┙┚┛├┝┞┟┠┡┢┣ ┤┥┦┧┨┩┪┫┬ ┭ ┮ ┯ ┰ ┱ ┲ ┳ ┴ ┵ ┶ ┷ ┸ ┹ ┺ ┻┼ ┽ ┾ ┿ ╀ ╁ ╂ ╃ ╄ ╅ ╆ ╇ ╈ ╉ ╊ ╋ ╪ ╫ ╬═║╒╓╔ ╕╖╗╘╙╚ ╛╜╝╞╟╠ ╡╢╣╤ ╥ ╦ ╧ ╨ ╩ ╳╔ ╗╝╚ ╬ ═ ╓ ╩ ┠ ┨┯ ┷┏ ┓┗ ┛┳ ⊥ ﹃ ﹄┌ ╮ ╭ ╯╰
 
 //皇冠符号
 ♚　♛　♝　♞　♜　♟　♔　♕　♗　♘　♖　♟
 */


#pragma mark dealloc

- (void)dealloc{
    if (self.viewModel) {
        [self.viewModel cancelAndClearAll];
        self.viewModel = nil;
    }
}


@end
