//
//  RSSRRightVC.m
//  Risk
//
//  Created by ylgwhyh on 16/7/12.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSSRRightVC.h"
#import "RSSRRightCell.h"
#import "RiskTypeModel.h"
#import "RSSRLeftVC.h"
#import "SVProgressHUD.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "RSMethod.h"
#import "RSRiskViewModel.h"
#import "RiskTypeDetailVC.h"
#import "RSSRRightHeadView.h"
#import "TePopList.h"
#import "SCXCreateAlertView.h"
#import "RSSVCHeader.h"
#import "UIButton+frame.h"

@interface RSSRRightVC ( ) <UITableViewDelegate, UITableViewDataSource, RSSRLeftVCDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,SCXCreatePopViewDelegate>

@property (nonatomic, strong) UIView *firstView;

//第一行
@property (nonatomic, strong) KYMHButton *searchButton;
@property (nonatomic, strong) KYMHButton *nBuildButton;
@property (nonatomic, strong) UIView *lineView;

//记录被选中的button
@property (nonatomic, strong) KYMHButton *oldSelectYearButton;
@property (nonatomic, strong) KYMHButton *oldSelectMonthButton;
@property (nonatomic, strong) KYMHButton *oldSelectSearchButton;
@property (nonatomic, strong) KYMHButton *oldSelectTwoRowButton;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *oneDataSource;

@property (nonatomic, strong) KYTableView *tableView;

@property (nonatomic, strong) KYMHButton *myButton;
@property (nonatomic, strong) UIView *lineOneView;

@property (nonatomic, strong) KYMHButton *allTypeButton;  //全部类型
@property (nonatomic, strong) KYMHButton *medicinalButton;
@property (nonatomic, strong) KYMHButton *notIsMedicinalButton;
@property (nonatomic, strong) UIView *lineTwoView;

@property (nonatomic, strong) KYMHButton *staticExposureTimeButton;  //全部时间

@property (nonatomic, strong) reportModel *headViewModelData; //tableView header默认数据
@property (nonatomic, assign) BOOL isAllTime;

//记录button对应的选项
@property (nonatomic, assign) BOOL isMine;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, assign) NSInteger recordsType;

@property (nonatomic, strong)  RSRiskViewModel *viewModel;

//iphone 改版本

@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, assign) NSInteger selected;

@property (nonatomic,strong) UIButton *mapSelectBtn;
@property (nonatomic, strong) UIButton *firstButton;
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

@property (nonatomic, strong) DXPopover * popver; //弹出视图
@property (nonatomic, strong) UITableView * rightTableView;  //顶部右侧tb
@property (nonatomic, strong) UITableView * checkTableView;  //查看
@property (nonatomic, strong) UITableView * typeTableView;   //类型
@property (nonatomic, strong) UITableView * timeTableView;   //月
@property (nonatomic, strong) UITableView * yearTableView;   //年

@end

@implementation RSSRRightVC {
    
    CGFloat RSSRRightVCW;
    CGFloat commonFontSize;
    CGFloat spaceToLeft;
    CGFloat buttonH;
    UIColor *textFieldBGColor;
    UIColor *yellowButtonTitleNormalColor;
    CGFloat screenButtonHeight;
}

#define MFRSSRRightTableViewPageSize 50

static NSString * const RSSRRightCell_One_ID = @"RSSRRightCell_One_ID";

typedef NS_ENUM( NSInteger , NS_ENUM_Medicinal) {
    NS_ENUM_IsMedicinal = 0,
    NS_ENUM_NotIsMedicinal = 1,
};

#define yearOtherButtonTag 100032

- (void )viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    
    [EFAppManager shareInstance].sideAndTabHome.rootViewController.navigationBar.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [EFAppManager shareInstance].sideAndTabHome.rootViewController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [self requestDataAction];  //刚进来时默认请求一次数据
    
    _popver = [[DXPopover alloc]init];
}

#pragma mark Init

- (void) initData {
    _viewModel = [[RSRiskViewModel alloc] initWithViewController:self];
    
    RSSRRightVCW = SCREEN_WIDTH;
    commonFontSize = RSVisitArchiveCommonFontSize;
    spaceToLeft = 5;
    buttonH = RSVisitArchiveButtonH;
    textFieldBGColor = RSVisitArchiveTextFieldBGColor;
    yellowButtonTitleNormalColor = EF_TextColor_TextColorPrimary;
    
    _dataSource = [[NSMutableArray alloc] init];
    _oneDataSource = [[NSMutableArray alloc] init];
    
    _oldSelectYearButton = [KYMHButton new];
    _oldSelectMonthButton = [KYMHButton new];
    _oldSelectSearchButton = [KYMHButton new];
    _oldSelectTwoRowButton = [KYMHButton new];
    
    
    _yearArray = [[NSMutableArray alloc] init];
    _monthArray = [[NSMutableArray alloc] init];
    _monthParameterArray = [[NSMutableArray alloc] init];
    
    NSInteger yellowInteger = [RSMethod returnCurrentYear];
    for (int i=0; i<9; i++) {
        if( 8 == i ) {
            [_yearArray addObject:@"其他"];
        }else if ( 0 == i ){
            [_yearArray addObject:@"全部时间"];
        }else {
            [_yearArray addObject:[NSString stringWithFormat:@"%ld",(long)yellowInteger+1]];
        }
        yellowInteger--;
    }
    
    for (int i=0; i<=12; i++) {
        if (0 == i) {
            [_monthArray addObject:[NSString stringWithFormat:@"全部"]];
            [_monthParameterArray addObject:@"-1"];
        }else {
            [_monthArray addObject:[NSString stringWithFormat:@"%d月",(int)i]];
            [_monthParameterArray addObject:[NSString stringWithFormat:@"%d",(int)i]];
        }
    }
    
    _typeArray = @[@"-1",@"0", @"1"];
}

//这个要在UI初始化只有调用
- (void ) initRequestData {
    
    _isMine = NO;
    _year = @"-1";
    _month = @"-1";
    _type = -1;
    _recordsType = 0;
    
    //默认选中的按钮
    
    _oldSelectYearButton = _staticExposureTimeButton;
    _oldSelectYearButton.selected = YES;
    
    _oldSelectMonthButton.selected = YES;
    
    _oldSelectSearchButton = _searchButton;
    _oldSelectSearchButton.selected = YES;
    
    _oldSelectTwoRowButton = _allTypeButton;
    _oldSelectTwoRowButton.selected = YES;
}

- (void) initUI {
    //顺序不能随意换
    self.title = @"统计报表";
    [self initRequestData]; //这个要在UI初始化只有调用
    [self initNavigationRightButton];
    [self createScreenView];
    [self initTableView];
}


//创建筛选界面
- (void)createScreenView{
    
    UIColor *screenButtonColor = [UIColor whiteColor];
    UIColor *buttonTitleColor = [UIColor blackColor];
    screenButtonHeight = 44;
    CGFloat fontSize = smallFontSize;
    
    _fatherView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, screenButtonHeight)];
    _fatherView.userInteractionEnabled = YES;
    [self.view addSubview:_fatherView];

    _firstButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/4, screenButtonHeight)];
    _firstButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    _firstButton.backgroundColor = screenButtonColor;
    [_firstButton setTitleColor:buttonTitleColor forState:UIControlStateNormal];
    [_firstButton setTitle:@"全部查看" forState:UIControlStateNormal];
    [_firstButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_firstButton addTarget:self action:@selector(showDownList:) forControlEvents:UIControlEventTouchUpInside];
    [_firstButton setImage:[UIImage imageNamed:@"ic_arrow_down"] forState:UIControlStateNormal];
    [_firstButton setimageToTitleRight];
    [_fatherView addSubview:_firstButton];

    _mapSelectBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4, screenButtonHeight) ];
    _mapSelectBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [_mapSelectBtn setTitle:@"全部类型" forState:UIControlStateNormal];
    _mapSelectBtn.backgroundColor = screenButtonColor;
    [_mapSelectBtn setTitleColor:buttonTitleColor forState:UIControlStateNormal];
    [_mapSelectBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_mapSelectBtn addTarget:self action:@selector(showDownList:) forControlEvents:UIControlEventTouchUpInside];
    [_mapSelectBtn setImage:[UIImage imageNamed:@"ic_arrow_down"] forState:UIControlStateNormal];
    [_mapSelectBtn setimageToTitleRight];
    [_fatherView addSubview:_mapSelectBtn];
    
    //筛选距离
    _screenDistanceBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_mapSelectBtn.frame), 0, SCREEN_WIDTH/4, screenButtonHeight)];
    _screenDistanceBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [_screenDistanceBtn setTitle:@"全部时间" forState:UIControlStateNormal];
    [_screenDistanceBtn setTitleColor:buttonTitleColor forState:UIControlStateNormal];
    [_screenDistanceBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    _screenDistanceBtn.backgroundColor = screenButtonColor;
    [_screenDistanceBtn setImage:[UIImage imageNamed:@"ic_arrow_down"] forState:UIControlStateNormal];
    [_screenDistanceBtn setimageToTitleRight];
    
    [_screenDistanceBtn addTarget:self action:@selector(showDownList:) forControlEvents:UIControlEventTouchUpInside];
    [_fatherView addSubview:_screenDistanceBtn];
    
    //筛选时间
    _screenTimeBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_screenDistanceBtn.frame) , 0, SCREEN_WIDTH/4, screenButtonHeight) ];
    _screenTimeBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    _screenTimeBtn.backgroundColor = screenButtonColor;
    [_screenTimeBtn setTitle:@"1月" forState:UIControlStateNormal];
    [_screenTimeBtn setTitleColor:buttonTitleColor forState:UIControlStateNormal];
    [_screenTimeBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_screenTimeBtn setImage:[UIImage imageNamed:@"ic_arrow_down"] forState:UIControlStateNormal];
    [_screenTimeBtn setimageToTitleRight];
    [_screenTimeBtn addTarget:self action:@selector(showDownList:) forControlEvents:UIControlEventTouchUpInside];
    [_fatherView addSubview:_screenTimeBtn];
    
    //线(四条竖线，请勿删除)
    //    UIView *lineOneView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, 1, screenButtonHeight)];
    //    lineOneView.backgroundColor = EF_TextColor_BlackDivider;
    //    [_fatherView addSubview:lineOneView];
    //    
    //    UIView *lineTwoView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4*3, 0, 1, screenButtonHeight)];
    //    lineTwoView.backgroundColor = EF_TextColor_BlackDivider;
    //    [_fatherView addSubview:lineTwoView];
    //    
    //    UIView *lineThreeView = [[UIView alloc] initWithFrame:CGRectMake(0, screenButtonHeight-1, SCREEN_WIDTH, 0.5)];
    //    lineThreeView.backgroundColor = EF_TextColor_BlackDivider;
    //    [_fatherView addSubview:lineThreeView];
    //    
    //    UIView *lineFourView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4, 0, 1, screenButtonHeight)];
    //    lineFourView.backgroundColor = EF_TextColor_BlackDivider;
    //    [_fatherView addSubview:lineFourView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, screenButtonHeight-2, SCREEN_WIDTH, 2)];
    lineView.backgroundColor = EF_MainColor;
    [_fatherView addSubview:lineView];
    
}


#pragma mark--展示下拉菜单
-(void)showDownList:(UIButton *)button{
        if(button == _screenDistanceBtn){
           
             _titleNameArray= [_yearArray mutableCopy];
            if (_yearTableView == nil) {
                _yearTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 100, 270) style:UITableViewStylePlain];
                _yearTableView.delegate = self;
                _yearTableView.dataSource = self;
            }
            
            CGPoint starPoint = CGPointMake(CGRectGetMidX(_screenDistanceBtn.frame), 44+screenButtonHeight);//弹出的点
            [_popver showAtPoint:starPoint popoverPostion:DXPopoverPositionDown withContentView:_yearTableView inView:[UIApplication sharedApplication].keyWindow];
            
        }else if (button == _screenTimeBtn){ //月
            _titleNameArray= [_monthArray mutableCopy];
            
            if (_timeTableView == nil) {
                _timeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 100, 390) style:UITableViewStylePlain];
                _timeTableView.delegate = self;
                _timeTableView.dataSource = self;
            }
            
            CGPoint starPoint = CGPointMake(CGRectGetMidX(_screenTimeBtn.frame), 44+screenButtonHeight);//弹出的点
            [_popver showAtPoint:starPoint popoverPostion:DXPopoverPositionDown withContentView:_timeTableView inView:[UIApplication sharedApplication].keyWindow];
            
        }else if (button == _firstButton){
            _titleNameArray=[NSArray arrayWithObjects:@"全部查看",@"只看我的", nil];
            
            if (_checkTableView == nil) {
                _checkTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 100, 60) style:UITableViewStylePlain];
                _checkTableView.delegate = self;
                _checkTableView.dataSource = self;
            }
            
            CGPoint starPoint = CGPointMake(CGRectGetMidX(_firstButton.frame), 44+screenButtonHeight);//弹出的点
            [_popver showAtPoint:starPoint popoverPostion:DXPopoverPositionDown withContentView:_checkTableView inView:[UIApplication sharedApplication].keyWindow];
            
        }else if (button == _mapSelectBtn){
            _titleNameArray=[NSArray arrayWithObjects:@"全部类型",@"药物",@"非药物", nil];
            
            if (_typeTableView == nil) {
                _typeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 100, 90) style:UITableViewStylePlain];
                _typeTableView.delegate = self;
                _typeTableView.dataSource = self;
            }
            
            CGPoint starPoint = CGPointMake(CGRectGetMidX(_mapSelectBtn.frame), 44+screenButtonHeight);//弹出的点
            [_popver showAtPoint:starPoint popoverPostion:DXPopoverPositionDown withContentView:_typeTableView inView:[UIApplication sharedApplication].keyWindow];
        }
}


- (void) selectMapButtonAction {
    NSLog(@"selectMapButtonAction");
}

- (void ) initTableView {
    WS(weakSelf)
    _tableView = [[KYTableView alloc]initWithFrame:CGRectMake(0 ,CGRectGetMaxY(_fatherView.frame)-0.5, RSSRRightVCW, SCREEN_HEIGHT-screenButtonHeight-64) andUpBlock:^{
        if(weakSelf.viewModel.sreportModel.first == YES){
            _pageCount = 0;
        }else {
            if(_pageCount >=1) {
                _pageCount--;
            }else {
                _pageCount = 0;
            }
        }
        [self requestDataAction];
    } andDownBlock:^{
        
        if(weakSelf.viewModel.sreportModel.last == NO){
            
            _pageCount++;
            [self requestDataAction];
        }else {
            
            [weakSelf.tableView endLoading];
            [UIUtil alert:@"已是最后一条"];
        }
    }];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView registerClass:[RSSRRightCell class] forCellReuseIdentifier:RSSRRightCell_One_ID];
    [self.view addSubview:_tableView];
    
    [_tableView reloadData];
}

#pragma mark - requestDataAction

//MFDefaultPageSize

- (void ) requestDataAction {
    [RSMethod ylg_SVProgressHUD_showWithSVProgressHUDMaskTypeNone];
    if (YES == _isAllTime ) {
                    [self.viewModel findFollowUpRecords:_pageCount size:MFRSSRRightTableViewPageSize recordsType:_recordsType isMine:_isMine year:_year month:@"-1" type:_type];
    }else {
            [self.viewModel findFollowUpRecords:_pageCount size:MFRSSRRightTableViewPageSize recordsType:_recordsType isMine:_isMine year:_year month:_month type:_type];
    }
}

#pragma mark - CreateUI

- (KYMHButton *)createButtonWithTitle: (NSString *)title  action:(SEL)action {
    KYMHButton *yearButton = [[KYMHButton alloc] initWithFrame:CGRectMake(0, 0, 70, buttonH )];
    
    [yearButton setTitle:title forState:UIControlStateNormal];
    yearButton.titleLabel.font = Font(smallFontSize);
    [yearButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    yearButton.adjustsImageWhenHighlighted = NO;
    [yearButton setBackgroundImage:[UIImage imageWithColor:RSVisitArchiveButtonColor] forState:UIControlStateSelected];
    [yearButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    yearButton.layer.cornerRadius = 7;
    yearButton.layer.masksToBounds = 7;
    [yearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [yearButton setTitleColor:yellowButtonTitleNormalColor forState:UIControlStateNormal];
    
    return yearButton;
}

#pragma mark - TableView data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _rightTableView) {
        NSArray * array = @[@"咨询记录",@"随访档案"];
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rightCell"];
        cell.textLabel.text = array[indexPath.row];
        
        return cell;
    }else if(tableView == _timeTableView){ //月
        
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mouthCell"];
        cell.textLabel.text = _titleNameArray[indexPath.row];
        
        return cell;
        
    }else if(tableView == _yearTableView){  //年
        
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"yearCell"];
        cell.textLabel.text = _titleNameArray[indexPath.row];
        
        return cell;
    }else if(tableView == _typeTableView){ //类型
        
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"typeCell"];
        cell.textLabel.text = _titleNameArray[indexPath.row];
        
        return cell;
        
    }else if(tableView == _checkTableView){
        
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"typeCell"];
        cell.textLabel.text = _titleNameArray[indexPath.row];
        
        return cell;
    }
    
    reportModel *model = _dataSource[indexPath.row];
    RSSRRightCell *cell = [tableView dequeueReusableCellWithIdentifier:RSSRRightCell_One_ID];
    model.index = indexPath.row+1;
    cell.model = model;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _rightTableView) {
        return 2;
    }else if(tableView == _timeTableView){ //月
        
        return 13;
        
    }else if(tableView == _yearTableView){  //年
        
        return 9;
    }else if(tableView == _typeTableView){ //类型
    
        return 3;
        
    }else if(tableView == _checkTableView){
        
        return 2;
    }
    return _dataSource.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
        id model = _dataSource[indexPath.row];
        
        return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[RSSRRightCell class] contentViewWidth:[RSMethod cellContentViewWith]];
    }
    return 30;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [_popver dismiss];
    
    _pageCount = 0;
    if(tableView == _timeTableView){ //月
        [_screenTimeBtn setTitle:_titleNameArray[indexPath.row] forState:UIControlStateNormal];
        [_screenTimeBtn setimageToTitleRight];
        
        _month = _monthParameterArray[indexPath.row];
        
        if ([_year isEqualToString:@"-1"]) {
            _month = @"-1";
        }
        
        [self requestDataAction];
        return;
        
    }else if(tableView == _yearTableView){  //年
        [_screenDistanceBtn setTitle:_titleNameArray[indexPath.row] forState:UIControlStateNormal];
        [_screenDistanceBtn setimageToTitleRight];
        
        NSString *str = _titleNameArray[indexPath.row];
        if ([str isEqualToString:@"全部时间"] || [str isEqualToString:@"其他"] ) {
            _year = @"-1";
            _month = @"-1";
        }else {
            _year = _titleNameArray[indexPath.row];
        }
        
        [self requestDataAction];
        return;
        
    }else if(tableView == _typeTableView){ //类型
        [_mapSelectBtn setTitle:_titleNameArray[indexPath.row] forState:UIControlStateNormal];
        [_mapSelectBtn setimageToTitleRight];
        
        _type = [_typeArray[indexPath.row] intValue];
        
        [self requestDataAction];
        return;
        
    }else if(tableView == _checkTableView){
        
        [_firstButton setTitle:_titleNameArray[indexPath.row] forState:UIControlStateNormal];
        [_firstButton setimageToTitleRight];
        
        if (0 == indexPath.row) {
            _isMine = NO;
        }else {
            _isMine = YES;
        }
        
        [self requestDataAction];
        return;
    }
    
    if (tableView == _rightTableView) {
        NSArray * array = @[@"咨询记录",@"随访档案"];
        [_rightBtn setTitle:array[indexPath.row] forState:UIControlStateNormal];
        
        _sortKindSelectRightTop = (int)indexPath.row;
        _recordsType = (int)indexPath.row;
        [self requestDataAction];
        return;
    }

    reportModel *model = _dataSource[indexPath.row];
    RiskTypeDetailVC *next = [[RiskTypeDetailVC alloc] init];
    next.objectId = (int)model.objectId;
    next.showNavigationView = YES;
    [self.navigationController pushViewController:next animated:YES];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section  {
    
    if (tableView == _tableView) {
        RSSRRightHeadView *headView = [[RSSRRightHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, screenButtonHeight)];
        return headView;
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == _tableView) {
        return 44;
    }
    return 0;
}

#pragma mark Button Action

- (void)rightBtnClick{
    if (_rightTableView == nil) {
        _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 100, 60) style:UITableViewStylePlain];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
    }
    CGPoint starPoint = CGPointMake(SCREEN_WIDTH-60, 60);//弹出的点
    [_popver showAtPoint:starPoint popoverPostion:DXPopoverPositionDown withContentView:_rightTableView inView:[UIApplication sharedApplication].keyWindow];
}

- (void)initNavigationRightButton {
    _rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    [_rightBtn setTitle:@"咨询记录" forState:UIControlStateNormal];
    [_rightBtn setImage:[UIImage imageNamed:@"xialabai"] forState:UIControlStateNormal];
    [_rightBtn setimageToTitleRight];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:normalFontSize];
    [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
}


#pragma mark 筛选Delegate
-(void)tableViewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath andPopType:(popType)popViewType clickButton:(UIButton *)button{
    //改变导航栏文字
    if (popViewType==kNavigationPop) {
        
        if(button == _screenDistanceBtn){ //月
            [_screenDistanceBtn setTitle:_titleNameArray[indexPath.row] forState:UIControlStateNormal];
            [_screenDistanceBtn setimageToTitleRight];
            _month = _monthParameterArray[indexPath.row];
            
            if ([_year isEqualToString:@"-1"]) {
                _month = @"-1";
            }
            
        }else if(button == _screenTimeBtn){  //年
            [_screenTimeBtn setTitle:_titleNameArray[indexPath.row] forState:UIControlStateNormal];
            [_screenTimeBtn setimageToTitleRight];
            
            NSString *str = _titleNameArray[indexPath.row];
            if ([str isEqualToString:@"全部时间"] || [str isEqualToString:@"其他"] ) {
                _year = @"-1";
                _month = @"-1";
            }else {
                _year = _titleNameArray[indexPath.row];
            }
        }else if(button == _mapSelectBtn){ //类型
            [_mapSelectBtn setTitle:_titleNameArray[indexPath.row] forState:UIControlStateNormal];
            [_mapSelectBtn setimageToTitleRight];
            
            _type = [_typeArray[indexPath.row] intValue];
            
        }else if(button == _firstButton){
            [_firstButton setTitle:_titleNameArray[indexPath.row] forState:UIControlStateNormal];
            [_firstButton setimageToTitleRight];
            
            if (0 == indexPath.row) {
                _isMine = NO;
            }else {
                _isMine = YES;
            }
        }
        [self requestDataAction];
        NSLog(@"%@",_titleNameArray[indexPath.row]);
    }
    if (popViewType==ksortPop) {
        NSLog(@"点击排序后要做的事情");
    }
    [_menu dismissWithCompletion:nil];//点击完成后视图消失;
}


#pragma mark RSSRLeftVCDelegate
- (void)rsSRLeftVC:(RSSRLeftVC *)RSSRLeftVC didSelectedRSSRLeftVC:(RiskTypeModel *)model {
    _recordsType = model.integer;
    _pageCount = 0;
    [self requestDataAction];
}

#pragma mark DZNEmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = MFNoDataPromptString;
    UIColor *textColor = EF_TextColor_TextColorSecondary;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: textColor};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

#pragma mark ViewModel回调

- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    [SVProgressHUD dismiss];
    [self.tableView endLoading];
    
    if (action & RSRisk_NS_ENUM_findFollowUpRecords) {
     
        if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeSuccess) {
            
            if (self.viewModel.sreportModel.first == YES) {
                [_dataSource removeAllObjects];
            }
            [_dataSource addObjectsFromArray:self.viewModel.sreportModel.content];
        }else {
            [RSMethod ylg_showSuccessWithStatus:result.message];
        }
         [_tableView reloadData];
        
        if (self.viewModel.sreportModel.first == YES && _dataSource.count > 0)  {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
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
