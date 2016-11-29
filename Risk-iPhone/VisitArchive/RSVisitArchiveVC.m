//
//  RSVisitArchiveVC.m
//  Risk
//
//  Created by ylgwhyh on 16/6/29.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSVisitArchiveVC.h"
#import "RSVAArchivesModel.h"
#import "RSVAArchivesCell.h"
#import "EFCTTextField.h"
#import "RSVAPatientArchiveVC.h"
#import "RSVAHeadView.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "SVProgressHUD.h"
#import "RSMethod.h"
#import "RSRiskViewModel.h"
#import "RSFollowUpRecordModel.h"
#import "RSSearchVC.h"
#import "UIUtil.h"
#import "UIButton+frame.h"
#import "SCXCreateAlertView.h"
#import "MineVC.h"


@interface RSVisitArchiveVC ( ) <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UITextFieldDelegate, SCXCreatePopViewDelegate> {
}

@property (nonatomic, strong) UIView *firstView;
@property (nonatomic, strong) EFCTTextField *keywordTextField;
@property (nonatomic, strong) EFCTTextField *riskFactorTextField;

@property (nonatomic, strong) KYMHButton *searchButton;
@property (nonatomic, strong) KYMHButton *nBuildButton;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) KYMHButton *oldSelectYearButton;
@property (nonatomic, strong) KYMHButton *oldSelectMonthButton;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) KYTableView *tableView;
@property (nonatomic, strong) RSRiskViewModel *viewModel;
@property (nonatomic, strong) RSFollowUpRecordModel *rsFollowUpRecordModel;

//参数
@property (nonatomic, copy ) NSString *keyWord;
@property (nonatomic, copy ) NSString *risk;
@property (nonatomic, copy ) NSString *year;
@property (nonatomic, copy ) NSString *month;

@property (nonatomic, copy) NSString *riskObjectId;  //跳转到搜索界面回传的风险Id的值

@property (nonatomic, assign) BOOL isSearch; //是否是搜索


//iphone 改版本

@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, assign) NSInteger selected;

@property (nonatomic,strong) UIButton *firstButton;
@property (nonatomic,strong) UIButton *twoButton;

@property (nonatomic,strong) UIButton *screenDistanceBtn; //距离筛选
@property (nonatomic,strong) UIButton *screenTimeBtn; //时间筛选


@property (nonatomic,strong) NSArray *titleNameArray; //
@property (nonatomic,strong) NSArray *distanceArray;
@property (nonatomic,strong) NSArray *timerArray;
@property (nonatomic,strong) SCXCreateAlertView *menu;
@property (nonatomic, assign) int distanceInt;
@property (nonatomic, assign) int timerInt;
@property (nonatomic, assign) int sortKindSelectRightTop; //按时间、按距离排序选择
@property (nonatomic, strong) UIView *fatherView;

@property (nonatomic, strong) NSMutableArray *yearArray;
@property (nonatomic, strong) NSMutableArray *monthArray;
@property (nonatomic, strong) NSMutableArray *monthParameterArray; //月份请求参数
@property (nonatomic, strong) NSArray *typeArray; //全部类型 请求参数

@end

@implementation RSVisitArchiveVC {
    CGFloat commonFontSize;
    CGFloat spaceToLeft;
    CGFloat buttonH;
    UIColor *textFieldBGColor;
}

static NSString * const RSVAArchivesCell_One_ID = @"RSVAArchivesCell_One_ID";

- (void )viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.navigationController.viewControllers.lastObject isKindOfClass:[RSVAPatientArchiveVC class]] ) {
        [self requestData];
    }
    
    if (_viewModel == nil) {
        _viewModel = [[RSRiskViewModel alloc]initWithViewController:self];
    }
    [_viewModel getUnReadMsgCount];
    [_viewModel getBirthNum];
    
    [EFAppManager shareInstance].sideAndTabHome.rootViewController.navigationBar.hidden = NO;
}

- (void )viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
    [EFAppManager shareInstance].sideAndTabHome.rootViewController.navigationBar.hidden = YES;
}

- (void ) viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
    [self requestData];
}

- (void ) requestData {
    [RSMethod ylg_SVProgressHUD_showWithSVProgressHUDMaskTypeNone];
    [_viewModel getBirthNum];
#warning TODO 16-8-23注释（因为不需要单独区分搜索和点击年月），超过一周后可以删除
//    if (_isSearch ) {
//        
//        if ( [UIUtil isEmptyStr:_riskFactorTextField.text] ) {
//            _riskObjectId = @"-1";
//        }
//        
//        [self.viewModel findFollowRecord:_keyWord risk:_riskObjectId year:_year month:_month page:_pageCount size:MFDefaultPageSize];
//    }else {
//        [self.viewModel findFollowRecord:@"-1" risk:@"-1" year:_year month:_month page:_pageCount size:MFDefaultPageSize];
//    }
    
    if ( [UIUtil isEmptyStr:_riskFactorTextField.text] ) {
        _riskObjectId = @"-1";
    }
    
    if ( [UIUtil isEmptyStr:_keyWord]  ) {
        _riskObjectId = @"-1";
    }
    
#warning TODO 测试，临时添加
    //_year = @"-1";
    [self.viewModel findFollowRecord:_keyWord risk:_riskObjectId year:_year month:_month page:_pageCount size:MFDefaultPageSize];
    
    //获取预产期在10日内的记录数量
//    [self.viewModel findFollowRecord:@"-1" risk:@"-1" year:@"-1" month:@"-1" page:_pageCount size:MFDefaultPageSize];
}

- (void) initData {
    
    commonFontSize = RSVisitArchiveCommonFontSize;
    spaceToLeft = 20;
    buttonH = RSVisitArchiveButtonH;
    textFieldBGColor = RSVisitArchiveTextFieldBGColor;
    
    _viewModel = [[RSRiskViewModel alloc] initWithViewController:self];

    
    _oldSelectYearButton = [KYMHButton new];
    _oldSelectMonthButton = [KYMHButton new];
    
    //初始化请求参数
    _keyWord = @"-1";
    _risk = @"-1";
    _year = [NSString stringWithFormat:@"%ld", (long)[RSMethod returnCurrentYear]];
    _month = @"-1";
    
    _yearArray = [[NSMutableArray alloc] init];
    _monthArray = [[NSMutableArray alloc] init];
    _monthParameterArray = [[NSMutableArray alloc] init];
    
    NSInteger yellowInteger = [RSMethod returnCurrentYear];
    for (int i=1; i<=11; i++) {
        if( 11 == i ) {
            [_yearArray addObject:@"全部"];
        }else {
            [_yearArray addObject:[NSString stringWithFormat:@"%ld",(long)yellowInteger]];
        }
        yellowInteger--;
    }
    
    for (int i=1; i<=12; i++) {
        [_monthArray addObject:[NSString stringWithFormat:@"%d月",(int)i]];
        [_monthParameterArray addObject:[NSString stringWithFormat:@"%d",(int)i]];
    }
}

- (void) initUI {
    
    self.title = @"随访档案";
    
    [self initOneView];
    [self initTwoView];
    [self initThreeView];
    _firstView.backgroundColor = RSVisitArchiveTableViewHeadSectionBGColor;
}

- (void ) initTwoView {
    
    UIColor *screenButtonColor = [UIColor whiteColor];
    UIColor *buttonTitleColor = [UIColor blackColor];
    CGFloat screenButtonHeight = 40*SCREEN_H_RATE;
    CGFloat fontSize = smallFontSize;
    
    //初始化年Button
    KYMHLabel *staticExposureTimeLabel = [KYMHLabel new];
    staticExposureTimeLabel.font = Font(smallFontSize);
    staticExposureTimeLabel.textColor = EF_TextColor_TextColorPrimary;
    staticExposureTimeLabel.textAlignment = NSTextAlignmentLeft;
    staticExposureTimeLabel.text = @"暴露时间: ";
    [_firstView addSubview:staticExposureTimeLabel];
    
    staticExposureTimeLabel.sd_layout
    .topSpaceToView(_lineView, 50)
    .leftSpaceToView(_firstView, spaceToLeft)
    .widthIs(80)
    .heightIs(28);
    
    _firstButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/4, screenButtonHeight)];
    _firstButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    _firstButton.backgroundColor = screenButtonColor;
    [_firstButton setTitleColor:buttonTitleColor forState:UIControlStateNormal];
    [_firstButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_firstButton setTitle:@"2016" forState:UIControlStateNormal];
    
    [_firstButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_firstButton addTarget:self action:@selector(showDownList:) forControlEvents:UIControlEventTouchUpInside];
    [_firstButton setImage:[UIImage imageNamed:@"ic_filterbar_loc"] forState:UIControlStateNormal];
    [_firstButton imageLeft];
    [_firstView addSubview:_firstButton];
    
    _twoButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4, screenButtonHeight) ];
    _twoButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [_twoButton setTitle:@"--" forState:UIControlStateNormal];
    _twoButton.backgroundColor = screenButtonColor;
    [_twoButton setTitleColor:buttonTitleColor forState:UIControlStateNormal];
    [_twoButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_twoButton addTarget:self action:@selector(showDownList:) forControlEvents:UIControlEventTouchUpInside];
    [_twoButton setImage:[UIImage imageNamed:@"ic_filterbar_loc"] forState:UIControlStateNormal];
    [_twoButton imageLeft];
    [_firstView addSubview:_twoButton];
    
    _firstButton.sd_layout
    .topEqualToView(staticExposureTimeLabel)
    .leftSpaceToView(staticExposureTimeLabel, 10)
    .widthIs(74)
    .heightIs(buttonH);
    
    _twoButton.sd_layout
    .topEqualToView(staticExposureTimeLabel)
    .rightSpaceToView(_firstView, spaceToLeft)
    .widthIs(74)
    .heightIs(buttonH);
}

- (void ) initOneView {
    UIColor *textFieldBorder = EF_TextColor_TextColorSecondary;
    
    _firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 140)];
    _firstView.backgroundColor= [UIColor clearColor];
    [self.view addSubview:_firstView];
    
    KYMHLabel *staticKeywordLabel = [KYMHLabel new];
    staticKeywordLabel.font = Font(smallFontSize);
    staticKeywordLabel.textColor = EF_TextColor_TextColorPrimary;
    staticKeywordLabel.textAlignment = NSTextAlignmentLeft;
    staticKeywordLabel.text = @"关 键 字: ";
    
    _keywordTextField = [EFCTTextField new];
    _keywordTextField.placeholder = @"  姓名、电话";
    _keywordTextField.clearsOnBeginEditing = YES;
    _keywordTextField.clearButtonMode = UITextFieldViewModeAlways;
    _keywordTextField.delegate = self;
    _keywordTextField.textAlignment = NSTextAlignmentLeft;
    _keywordTextField.layer.cornerRadius = 5;
    _keywordTextField.font = Font(smallFontSize+1);
    _keywordTextField.layer.borderColor = textFieldBorder.CGColor;
    _keywordTextField.backgroundColor = textFieldBGColor;
    
    
    KYMHLabel *staticRiskFactorTextField = [KYMHLabel new];
    staticRiskFactorTextField.font = Font(smallFontSize);
    staticRiskFactorTextField.textColor = EF_TextColor_TextColorPrimary;
    staticRiskFactorTextField.textAlignment = NSTextAlignmentLeft;
    staticRiskFactorTextField.text = @"风险因素: ";
    
    _riskFactorTextField = [EFCTTextField new];
    _riskFactorTextField.placeholder = @" 通用名、英文名、其他名、拼音码";
    _riskFactorTextField.clearsOnBeginEditing = YES;
    _riskFactorTextField.clearButtonMode = UITextFieldViewModeAlways;
    _riskFactorTextField.delegate = self;
    _riskFactorTextField.textAlignment = NSTextAlignmentLeft;
    _riskFactorTextField.layer.cornerRadius = 5;
    _riskFactorTextField.font = Font(smallFontSize+1);
    _riskFactorTextField.layer.borderColor = textFieldBorder.CGColor;
    _riskFactorTextField.backgroundColor = textFieldBGColor;
    
    _searchButton = [KYMHButton new];
    [_searchButton setTitle:@"搜  索" forState:UIControlStateNormal];
    [_searchButton setBackgroundImage:[UIImage imageWithColor:RSVisitArchiveButtonColor] forState:UIControlStateNormal];
    _searchButton.titleLabel.font = Font(smallFontSize);
    _searchButton.layer.cornerRadius = 5;
    _searchButton.layer.masksToBounds = 5;
    [_searchButton addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _nBuildButton = [KYMHButton new];
    [_nBuildButton setTitle:@"+新  建" forState:UIControlStateNormal];
    _nBuildButton.titleLabel.font = Font(smallFontSize);
    [_nBuildButton setBackgroundImage:[UIImage imageWithColor:RSVisitArchiveButtonColor] forState:UIControlStateNormal];
    _nBuildButton.layer.cornerRadius = 5;
    _nBuildButton.layer.masksToBounds = 5;
    [_nBuildButton addTarget:self action:@selector(nBuildButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = EF_TextColor_TextColorSecondary;
    
    NSArray *views = @[staticKeywordLabel, _keywordTextField, staticRiskFactorTextField, _riskFactorTextField, _searchButton, _nBuildButton, _lineView];
    
    [_firstView sd_addSubviews:views];
    UIView *contentView = _firstView;
    
    staticKeywordLabel.sd_layout
    .topSpaceToView(contentView, 10)
    .leftSpaceToView(contentView, spaceToLeft)
    .widthIs(80)
    .heightIs(buttonH);
    
    _searchButton.sd_layout
    .topEqualToView(staticKeywordLabel)
    .rightSpaceToView(contentView, spaceToLeft)
    .widthIs(74)
    .heightIs(buttonH);
    
    _keywordTextField.sd_layout
    .topEqualToView(staticKeywordLabel)
    .leftSpaceToView(staticKeywordLabel, 10)
    .rightSpaceToView(_searchButton, 10)
    .heightIs(buttonH);
    
    _lineView.sd_layout
    .topSpaceToView(staticKeywordLabel, 10)
    .leftSpaceToView (contentView, spaceToLeft)
    .rightSpaceToView (contentView, spaceToLeft)
    .heightIs(0.5);
    
    staticRiskFactorTextField.sd_layout
    .topSpaceToView(_lineView, 10)
    .leftSpaceToView(_firstView, spaceToLeft)
    .widthIs(80)
    .heightIs(buttonH);
    
    _nBuildButton.sd_layout
    .topEqualToView(staticRiskFactorTextField)
    .rightSpaceToView(contentView, spaceToLeft)
    .widthIs(74)
    .heightIs(buttonH);
    
    _riskFactorTextField.sd_layout
    .topEqualToView(staticRiskFactorTextField)
    .leftSpaceToView(staticRiskFactorTextField, 10)
    .rightSpaceToView(_nBuildButton, 10)
    .heightIs(buttonH);
}

- (void ) initThreeView {
    
    WS(weakSelf)
    
   _tableView = [[KYTableView alloc] initWithFrame:CGRectMake(0 , CGRectGetMaxY(_firstView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-64-140) andUpBlock:^{
       
       if(weakSelf.viewModel.sreportModel.first == YES){
           _pageCount = 0;
       }else {
           if(_pageCount >=1) {
               _pageCount--;
           }else {
               _pageCount = 0;
           }
       }
       [self requestData];
       
    } andDownBlock:^{
        BOOL isBool = weakSelf.viewModel.sreportModel;
        
        if ( nil != weakSelf.viewModel.sreportModel) {
            NSLog(@"测试...");
        }
        
        BOOL isCe = weakSelf.viewModel.sreportModel.last;
#warning TODO 暂时注释，第二个weakSelf.viewModel.sreportModel不知道是什么意思
//        if( (NO == weakSelf.viewModel.sreportModel.last ) && (nil != weakSelf.viewModel.sreportModel ) ){
//            _pageCount++;
//            [self requestData];
//            
//        }else {
//            
//            [self.tableView endLoading];
//            [UIUtil alert:@"已是最后一条"];
//        }
        
        [self.tableView endLoading];
        
//        if( NO == weakSelf.viewModel.sreportModel.last ){
//            _pageCount++;
//            [self requestData];
//        }else {
//            [self.tableView endLoading];
//            [UIUtil alert:@"已是最后一条"];
//        }

    } andStyle:UITableViewStyleGrouped];
    
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone; //去掉下划线
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView registerClass:[RSVAArchivesCell class] forCellReuseIdentifier:RSVAArchivesCell_One_ID];
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    
    [_tableView reloadData];
}

#pragma mark Set

- (NSMutableArray *)dataSource {
    
    if (nil == _dataSource ) {
        
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

#pragma mark - TableView data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    RSVisitArchiveModel *model = _rsFollowUpRecordModel.content[indexPath.row];
    RSVAArchivesCell *cell = [tableView dequeueReusableCellWithIdentifier:RSVAArchivesCell_One_ID];
    cell.numberInteger = indexPath.row+1;
    cell.model = model;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _rsFollowUpRecordModel.content.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id model = _rsFollowUpRecordModel.content[indexPath.row];

    CGFloat height = [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[RSVAArchivesCell class] contentViewWidth:[RSMethod cellContentViewWith]];
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.000001;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf)
    RSVisitArchiveModel *model = _rsFollowUpRecordModel.content[indexPath.row];
    RSVAPatientArchiveVC *next = [[RSVAPatientArchiveVC alloc] init];
    next.hidesBottomBarWhenPushed = NO;
    next.saveTypeRSVAPatientArchiveInteger = 0;
    next.rsVAPatientArchiveVCBlock = ^(BOOL isRefresh) {
        if (YES == isRefresh) {
            [weakSelf requestData];
        }
    };
    next.model = model;
    [self.navigationController pushViewController:next animated:YES];
}


#pragma mark DZNEmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无数据";
    UIColor *textColor = EF_TextColor_TextColorSecondary;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: textColor};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

#pragma mark 筛选Delegate
-(void)tableViewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath andPopType:(popType)popViewType clickButton:(UIButton *)button{
    //改变导航栏文字
    if (popViewType==kNavigationPop) {
        
        if(button == _twoButton){ //月
            [_twoButton setimageToTitleRight];
            _month = _monthParameterArray[indexPath.row];
            
            if ([_year isEqualToString:@"-1"]) {
                _month = @"-1";
                [_twoButton setTitle:@"--" forState:UIControlStateNormal];
            }else {
                [_twoButton setTitle:_titleNameArray[indexPath.row] forState:UIControlStateNormal];
            }
            
        }else if(button == _firstButton){  //年
            [_firstButton setTitle:_titleNameArray[indexPath.row] forState:UIControlStateNormal];
            [_firstButton setimageToTitleRight];
            
            NSString *str = _titleNameArray[indexPath.row];
            if ([str isEqualToString:@"全部"]) {
                _year = @"-1";
                _month = @"-1";
                [_twoButton setTitle:@"--" forState:UIControlStateNormal];
            }else {
                _year = _titleNameArray[indexPath.row];
            }
        }
        [self requestData];
        NSLog(@"%@",_titleNameArray[indexPath.row]);
    }
    if (popViewType==ksortPop) {
        NSLog(@"点击排序后要做的事情");
    }
    [_menu dismissWithCompletion:nil];//点击完成后视图消失;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_keywordTextField resignFirstResponder];
    [_riskFactorTextField resignFirstResponder];//点击空白处也要隐藏键盘
}

#pragma mark TextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == _keywordTextField ) {
        
        if ([textField.text isEqualToString:@""]) {
             _keyWord = @"-1";
        }else {
            _keyWord = textField.text;
        }
        
    }else if (textField == _riskFactorTextField ) {
        
        if ([textField.text isEqualToString:@""] ) {
            _risk = @"-1";
        }else {
            _risk = textField.text;
        }
    }
}

- (void) textFieldDidChange:(UITextField *) textField {
    NSLog(@"textField%@",textField.text);
    
    if (textField == _keywordTextField ) {
        
        if ([textField.text isEqualToString:@""]) {
            _keyWord = @"-1";
        }else {
            _keyWord = textField.text;
        }
        
    }else if (textField == _riskFactorTextField ) {
        
        if ([textField.text isEqualToString:@""] ) {
            _risk = @"-1";
        }else {
            _risk = textField.text;
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField  {
    if (textField == _riskFactorTextField) {
        
        RSSearchVC *next = [[RSSearchVC alloc] init];
        next.isRSVAPatientArchiveVCBool = YES;
        UINavigationController *searchNC = [[UINavigationController alloc] initWithRootViewController: next];
        WS(weakSelf)
        [next RSSearchVCClickBlack:^(NSString *selectString, NSInteger objectId) {
            weakSelf.riskFactorTextField.text  = selectString;
            weakSelf.riskObjectId = [NSString stringWithFormat:@"%ld", (long)objectId];
        }];
        
        [self.navigationController presentViewController:searchNC animated:YES completion:nil];
        [textField resignFirstResponder];
    }
}

-(BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField == _riskFactorTextField) {
        _riskFactorTextField.text = @"";
    }
    return YES;
}

#pragma mark Button Action

#pragma mark--展示下拉菜单
-(void)showDownList:(UIButton *)button{
    __weak typeof(self)weakSelf=self;
    if (!_menu) {
        
        UIColor *menuColor = [UIColor whiteColor];
        
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        if(button == _twoButton){
            _titleNameArray= [_monthArray mutableCopy];
        }else if (button == _firstButton){
            _titleNameArray= [_yearArray mutableCopy];
        }
        _menu=[[SCXCreateAlertView alloc]initWithNameArray:_titleNameArray andMenuOrigin:CGRectMake(button.frame.origin.x-70, CGRectGetMaxY(button.frame)+64, 0, 0) andMenuWidth:button.frame.size.width andHeight:30 andLayer:4 andTableViewBackGroundColor:menuColor andIsSharp:YES andType:kNavigationPop clickButton:button];
        NSLog(@"rect:%@",NSStringFromCGRect([_menu frame]));
        
        _menu.delegate = self;
        _menu.tableViewDelegate=self;
        _menu.dismiss=^(){
            [weakSelf.menu removeFromSuperview];
            _menu=nil;
        };
        [self.view addSubview:_menu];
    }
    else{
        
        [_menu dismissWithCompletion:^(SCXCreateAlertView *create) {
            [weakSelf.menu removeFromSuperview];
            weakSelf.menu=nil;
        }];
    }
}

- (void ) searchButtonAction:(KYMHButton *)button {
    _isSearch = YES;
    [_keywordTextField resignFirstResponder];
    [_riskFactorTextField resignFirstResponder];
    [self requestData];
}

- (void ) nBuildButtonAction:(KYMHButton *)button {
    WS(weakSelf)
    RSVAPatientArchiveVC *next = [[RSVAPatientArchiveVC alloc] init];
    next.hidesBottomBarWhenPushed = NO;
    next.saveTypeRSVAPatientArchiveInteger = 1;
    next.rsVAPatientArchiveVCBlock = ^(BOOL isRefresh) {
        if (YES == isRefresh) {
            [weakSelf requestData];
        }
    };
    [self.navigationController pushViewController:next animated:YES];
}

- (void ) yearButtonAction:(KYMHButton *)button {

    _isSearch = NO;
    NSInteger yellowInteger =  [RSMethod returnCurrentYear];
    
    if (button != _oldSelectYearButton ) {
        //将原来选中的Button去掉选择
        _oldSelectYearButton.selected = NO;
        //记录当前选中的Button
        button.selected = !button.selected;
        _oldSelectYearButton = button;
    }
    
    if (button.tag >= yellowInteger-9 ) {
        _year = [NSString stringWithFormat:@"%ld",(long)button.tag];
    }else {
        _year = @"-1";
         _oldSelectMonthButton.selected = NO;
        _month = @"-1";
    }
    [self requestData];
}

- (void ) monthButtonAction:(KYMHButton *)button {
    _isSearch = NO;
    if (button != _oldSelectMonthButton ) {
        
        //将原来选中的Button去掉选择
        _oldSelectMonthButton.selected = NO;
        //记录当前选中的Button
        button.selected = !button.selected;
        _oldSelectMonthButton = button;
    }
    
    _month = [NSString stringWithFormat:@"%ld", (long)button.tag];
    [self requestData];
}

#pragma mark ViewModel回调

- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    
    [SVProgressHUD dismiss];
    [self.tableView endLoading];
    if (action == RSRisk_NS_ENUM_findFollowRecord) {
        if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeSuccess) {
            _rsFollowUpRecordModel = self.viewModel.rsFollowUpRecordModel;
            [self.tableView reloadData];
        }else {
            [UIUtil alert:result.message];
        }
    }
    
    if(action == RSRisk_NS_ENUM_getBirthNum) {
        if (result.status == 200) {
            int redPointNum = [result.content intValue];
            [RSMethod rs_refreshTrackPoint:redPointNum];
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

@end
