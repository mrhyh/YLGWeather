//
//  RSVAVisitRecordVC.m
//  Risk-iPhone
//
//  Created by ylgwhyh on 16/9/8.
//  Copyright © 2016年 Cherie Jeong. All rights reserved.
//

#import "RSVAVisitRecordVC.h"
#import "RSVARiskExposeVC.h"
#import "EFCTTextField.h"
#import "RSVAriskFactorCell.h"
#import "RSVAVisitRecordCell.h"
#import "FDCalendar.h"
#import "RSCalendarVC.h"
#import "RSSearchVC.h"
#import "RSFollowUpRecordModel.h"
#import "RSVADeleteVC.h"
#import "SVProgressHUD.h"
#import "RSMethod.h"
#import "UIUtil.h"
#import "RSRiskViewModel.h"
#import "IQKeyboardManager.h"

@interface RSVAVisitRecordVC ( ) <UITableViewDelegate, UITableViewDataSource, RSCalendarVCDelegate, UITextFieldDelegate, RSVADeleteVCDelegate, RSVADeleteVCDelegate,UIGestureRecognizerDelegate>

//顶部模块
@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic, strong) EFCTTextField *medicalRecordTextField; //病历号
@property (nonatomic, strong) EFCTTextField *nameTextField; //
@property (nonatomic, strong) EFCTTextField *phoneNumberTextField;
@property (nonatomic, strong) EFCTTextField *familyAddressTextField;
@property (nonatomic, strong) EFCTTextField *suetsugiMensesTextField; //末次月经
@property (nonatomic, strong) EFCTTextField *expectedBornDataTextField; //预产期

//孕次
@property (nonatomic, strong) KYMHButton *pregnancyNumLeftButton;
@property (nonatomic, strong) KYMHButton *pregnancyNumRightButton;
@property (nonatomic, strong) KYMHLabel *pregnancyNumLabel;
@property (nonatomic, assign) NSInteger pregnancyNumInteger;

//产次
@property (nonatomic, strong) KYMHButton *bornNumLeftButton;
@property (nonatomic, strong) KYMHButton *bornNumRightButton;
@property (nonatomic, strong) KYMHLabel *bornNumLabel;
@property (nonatomic, assign) NSInteger bornNumNumInteger;


@property (nonatomic, strong) KYMHLabel *medicalRecordNumLabel;
@property (nonatomic, strong) KYMHLabel *nameLabel;
@property (nonatomic, strong) KYMHLabel *phoneNumLabel;

@property (nonatomic, strong ) NSMutableArray *dataSource;

@property (nonatomic, strong ) NSMutableArray <PatientrisksModel *>*leftDataSource;
@property (nonatomic, strong ) NSMutableArray <PatientfollowsModel *>*rightDataSource;

//危险因素暴露情况（左下模块）riskObjectId
@property (nonatomic, strong) KYTableView *leftTableView;
@property (nonatomic, strong) EFCTTextField *riskFactorTextField;
@property (nonatomic, strong) EFCTTextField *dosageTextField; //剂量
@property (nonatomic, strong) EFCTTextField *exposureTimeStartDataTextField;
@property (nonatomic, strong) EFCTTextField *exposureTimeEndDataTextField;
@property (nonatomic, strong) KYMHButton *riskAddButton;
@property (nonatomic, strong) UIView *leftHeadView;
@property (nonatomic, strong) KYMHButton *numberButton;

@property (nonatomic, assign) NSInteger riskObjectId;

//随访记录情况（右下模块）
@property (nonatomic, strong) KYTableView *rightTableView;
@property (nonatomic, strong) EFCTTextField *visitDataTextField;
@property (nonatomic, strong) EFCTTextField *visitResultTextField;
@property (nonatomic, strong) KYMHButton *visitAddButton;
@property (nonatomic, strong) UIView *rightHeadView;
@property (nonatomic, strong) KYMHButton *rightTableViewHeadButton;


//日历
@property (nonatomic, strong) UIPopoverController *colorPopover;
@property (nonatomic, strong) UITextField *currentSelectTextField;  //当前选择的日期textfield
@property (nonatomic, strong) UITextField *currentSelectNotIsDataTextField;  //当前选择的非日期textfield
@property (nonatomic, strong) UIPopoverController *fastLookMenuPC; //删除

@property (nonatomic, strong)  RSRiskViewModel *viewModel;


@property (nonatomic, strong) FDCalendar *calendarView;
@property (nonatomic, strong) UIView *calendarBGView;

@end

@implementation RSVAVisitRecordVC {
    
    CGFloat commonFontSize;
    CGFloat spaceToLeft;
    CGFloat buttonH;
    CGFloat nameTextFieldW;
    CGFloat nameToTextFieldSpace;
    CGFloat textFieldSpaceToName;
    CGFloat nameLabelW;
    CGFloat addToLabelSpace;
    CGFloat topScrollViewH;
    CGFloat spaceToTopView;
    
    UIColor *textFieldBGColor;
    UIColor *buttonNotClickColor;
    
    CGFloat cellH;
    UIColor *textColor;
    BOOL isHaveDian;
    
}


static NSString * const RSVAVisitRecordVCCell_One_ID = @"111RSVAVisitRecordVCCell_One_ID";

#define mFRSVAStaticStringmedicalRecord @"[病历号]不能为空!"
#define mFRSVAStaticStringName @"[姓名]不能为空!"
#define mFRSVAStaticStringRiskFactor @"[风险因素]不能为空!"
#define mFRSVAStaticStringDosage @"[剂量]不能为空!"
#define mFRSVAStaticStringStartData @"[开始日期]不能为空!"
#define mFRSVAStaticStringVisiltData @"[随访日期]不能为空!"
#define mFRSVAStaticStringVisiltResult @"[随访结果]不能为空!"

#define mFRiskFactorTextField  @"点击选择风险因素";

- (void )viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
    [self updateData];
}

- (void ) updateData {
    
    _medicalRecordTextField.text = _model.medicalRecordNo;
    _nameTextField.text = _model.name;
    _phoneNumberTextField.text = _model.phoneNum;
    _familyAddressTextField.text = _model.address;
    
    if ( 0 == _model.menstruationTime) {
    }else {
        _suetsugiMensesTextField.text = [RSMethod returnDateStringWithTimestamp:_model.menstruationTime];
    }
    
    if ( 0 == _model.childbirthTime) {
    }else {
        _expectedBornDataTextField.text = [RSMethod returnDateStringWithTimestamp:_model.childbirthTime];
    }
    
    if ( [ UIUtil isEmptyStr:_model.pregnancyNum] ) {
        _pregnancyNumLabel.text = @"0";
    }else {
        _pregnancyNumLabel.text = _model.pregnancyNum;
    }
    
    if ( [ UIUtil isEmptyStr:_model.bornNum] ) {
        _bornNumLabel.text = @"0";
    }else {
        _bornNumLabel.text = _model.bornNum;
    }
    
}

#pragma mark Init

- (void) initData {
    commonFontSize = RSVisitArchiveCommonFontSize;
    spaceToLeft = 7.5;
    buttonH = RSVisitArchiveButtonH;
    nameTextFieldW = 100;
    nameToTextFieldSpace= 15;
    textFieldSpaceToName = 40;
    nameLabelW = 75;
    addToLabelSpace = 10;
    _pregnancyNumInteger = 0;
    _bornNumNumInteger = 0;
    topScrollViewH = 300;
    spaceToTopView = 15;
    
    cellH = 44;
    textColor = EF_TextColor_TextColorPrimary;
    
    textFieldBGColor = RSVisitArchiveTextFieldBGColor;
    buttonNotClickColor = RGBColor(121, 219, 169);
    
    _dataSource = [[NSMutableArray alloc] init];
    _viewModel = [[RSRiskViewModel alloc] initWithViewController:self];
}

- (void) initUI {
    self.title = @"随访记录情况";
    [self initNavigateView];
    [self initLeftAndRightTableView];
}

- (void) initButtonStatus {
    if(_pregnancyNumInteger<=0  ) {
        [self setButtonNoCanClick:_pregnancyNumLeftButton];
    }
    
    if(_bornNumNumInteger<=0  ) {
        [self setButtonNoCanClick:_bornNumLeftButton];
    }
}

- (void ) initLeftAndRightTableView {
    CGFloat tableViewH =  SCREEN_HEIGHT;
    _rightTableView = [self createTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, tableViewH) cellID:RSVAVisitRecordVCCell_One_ID tableViewCell:[RSVAVisitRecordCell class]];
    [self.view addSubview:_rightTableView];
}


- (void)initNavigateView{
    
    UIColor *textColorButtonSelected = EF_TextColor_TextColorButtonSelected;
    UIButton * btn= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 44)];
    [btn addTarget:self action:@selector(navigationRightAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:MFNavigationRightSaveButtonFont];
    [btn setTitleColor:textColorButtonSelected forState:UIControlStateSelected];
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barBtnItem;

}

- (void) initCalendar {
    __weak typeof(self) weakSelf = self;
    
    if (nil == _calendarBGView) {
        _calendarBGView = [[UIView alloc] initWithFrame:self.view.frame];
        _calendarBGView.backgroundColor = RGBA_COLOR(184, 184, 184, 0.5);
        [self.view addSubview:_calendarBGView];
        
        if(_calendarView == nil) {
            _calendarView = [[FDCalendar alloc] initWithFrame:CGRectMake(0, 0, 330, 290) currentDate:[NSDate date] fdCalendarCompleteBlock:^(NSDate *date) {
                [weakSelf setTextfieldData:date];
            } ];
            
            _calendarView.center = self.view.center;
            _calendarView.alpha = 1;
            self.preferredContentSize = self.calendarView.frame.size;
            [_calendarBGView addSubview:_calendarView];
        }
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewGestureAction:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        tapGesture.delegate = self;
        [_calendarBGView addGestureRecognizer:tapGesture];
    }
    _calendarBGView.hidden = NO;
}

#warning TODO 临时位置

- (void)setTextfieldData:(NSDate *)date {
    
    __weak typeof(self) weakSelf = self;
    
    if (weakSelf.exposureTimeStartDataTextField == weakSelf.currentSelectTextField) {
        NSDate *curDate = [NSDate date];//获取当前日期
        int judgeInt = [RSMethod compareOneDay:date withAnotherDay:curDate];
        if  (1== judgeInt ) {
            if (_calendarBGView != nil ) {
                _calendarBGView.hidden = YES;
            }
            [self rsva_presentViewControllerWithMessage:@"[暴露时间-开始日期] 不能大于当前日期!"];
            return;
        }
        
        if (![UIUtil isEmptyStr:_exposureTimeEndDataTextField.text] ) {
            NSDate *exposureTimeEndData = [RSMethod ylg_returnDateWithTime:_exposureTimeEndDataTextField.text];
            int exposureTimeEndDataJudgeInt =  [RSMethod compareOneDay:date withAnotherDay:exposureTimeEndData];
            if (1 == exposureTimeEndDataJudgeInt) {
                if (_calendarBGView != nil ) {
                    _calendarBGView.hidden = YES;
                }
                [self rsva_presentViewControllerWithMessage:@"[暴露时间-开始日期] 不能大于结束日期!"];
                return;
            }
        }
    }
    
    if (_exposureTimeEndDataTextField == _currentSelectTextField)  {
        if (![UIUtil isEmptyStr:_exposureTimeStartDataTextField.text] ) {
            NSDate *exposureTimeStartData = [RSMethod ylg_returnDateWithTime:_exposureTimeStartDataTextField.text];
            int exposureTimeStartDataJudgeInt =  [RSMethod compareOneDay:date withAnotherDay:exposureTimeStartData];
            if (-1 == exposureTimeStartDataJudgeInt) {
                if (_calendarBGView != nil ) {
                    _calendarBGView.hidden = YES;
                }
                [self rsva_presentViewControllerWithMessage:@"[暴露时间-结束日期] 不能小于开始日期!"];
                return;
            }
        }
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    if (_currentSelectTextField ) {
        _currentSelectTextField.text = destDateString;
    }
    if (_calendarBGView != nil ) {
        _calendarBGView.hidden = YES;
    }
}

#pragma mark Create UI

- (KYTableView *) createTableViewWithFrame:(CGRect )frame cellID:(NSString *)cellID tableViewCell: (Class )cellClass {
    
    KYTableView *tableView = [[KYTableView alloc] initWithFrame:frame andUpBlock:^{
        
        [_leftTableView endLoading];
        [_rightTableView endLoading];
    } andDownBlock:^{
        
        [_leftTableView endLoading];
        [_rightTableView endLoading];
    } andStyle:UITableViewStyleGrouped];
    
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [tableView registerClass:cellClass forCellReuseIdentifier:cellID];
    
    return tableView;
}


- (KYMHButton *)createButtonWithTitle: (NSString *)title  action:(SEL)action {
    
    KYMHButton *button = [KYMHButton new];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = Font(smallFontSize);
    [button setBackgroundImage:[UIImage imageWithColor:RSVisitArchiveButtonColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = 5;
    button.titleLabel.font = Font(middleFontSize);
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}


- ( EFCTTextField *)createTextFieldWith: (NSString *)placeholder {
    
    EFCTTextField *textField = [EFCTTextField new];
    textField.placeholder = placeholder;
    textField.textAlignment = NSTextAlignmentLeft;
    textField.backgroundColor = textFieldBGColor;
    textField.layer.cornerRadius = 5;
    textField.delegate = self;
    textField.font = Font(RSVisitArchiveCommonFontSize);
    textField.layer.borderColor = textFieldBGColor.CGColor;
    textField.backgroundColor = textFieldBGColor;
    
    return textField;
}

- ( EFCTTextField *)createTextFieldWithImage: (NSString *)placeholder {
    
    EFCTTextField *textField = [self createTextFieldWithImageName:@"calendar" text:placeholder];
    return textField;
}


- ( EFCTTextField *)createTextFieldWithImageName: (NSString *)imageName text: (NSString *)placeholder {
    
    
    EFCTTextField *textField = [EFCTTextField new];
    textField.placeholder = placeholder;
    textField.textAlignment = NSTextAlignmentLeft;
    textField.backgroundColor = textFieldBGColor;
    textField.layer.cornerRadius = 5;
    textField.font = Font(RSVisitArchiveCommonFontSize);
    textField.layer.borderColor = textFieldBGColor.CGColor;
    textField.backgroundColor = textFieldBGColor;
    textField.delegate = self;
    
    KYMHImageView *imageView = [KYMHImageView new];
    imageView.image = Img(imageName);
    [textField addSubview:imageView];
    
    imageView.sd_layout
    .centerYEqualToView(textField)
    .rightSpaceToView(textField, 5)
    .heightIs(buttonH-10)
    .widthIs(buttonH-10);
    
    return textField;
}


- (KYMHLabel *)createLabelWithTitle:(NSString *)text{
    KYMHLabel  *label = [self createLabelWith:NSTextAlignmentLeft text:text];
    return label;
}

- (KYMHLabel *)createLabelWith:(NSTextAlignment )textAlignment text:(NSString *)text{
    
    KYMHLabel  *label = [KYMHLabel new];
    label.font = Font(RSVisitArchiveCommonFontSize);
    label.textColor = EF_TextColor_TextColorPrimary;
    label.text = text;
    label.textAlignment = textAlignment;
    return label;
}

- (void) createRightHeadView: (UIView *)view{
    
    KYMHLabel *staticRTVOneLabel = [self createLabelWithTitle:@"【随访记录情况】"];
    KYMHLabel *staticRTVTwoLabel = [self createLabelWithTitle:@"*日期: "];
    KYMHLabel *staticRTVFourLabel = [self createLabelWithTitle:@"*结果: "];
    
    _visitDataTextField = [self createTextFieldWith:@"随访日期"];
    _visitResultTextField = [self createTextFieldWith:@"随访结果"];
    
    _visitAddButton = [self createButtonWithTitle:@"+添  加" action:@selector(visitAddButtonAction)];
    _visitAddButton.titleLabel.font = Font(smallFontSize);
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor =RSVisitArchiveTableViewHeadSectionBGColor;
    
    NSArray *views = @[staticRTVOneLabel, staticRTVTwoLabel, staticRTVFourLabel, _visitDataTextField ,  _visitResultTextField, _visitAddButton ];

    [view sd_addSubviews:views];
    UIView *contentView = view;
    
    staticRTVOneLabel.sd_layout
    .leftSpaceToView(contentView, spaceToLeft)
    .topSpaceToView(contentView, spaceToTopView)
    .widthIs(200)
    .heightIs(buttonH);
    
    //日期
    CGFloat staticRTVFourLabelW = 45;
    if (SCREEN_HEIGHT > 568) {
        staticRTVFourLabelW = 70;
    }
    
    staticRTVTwoLabel.sd_layout
    .leftSpaceToView(contentView, spaceToLeft)
    .topSpaceToView(staticRTVOneLabel, spaceToTopView)
    .widthIs(staticRTVFourLabelW)
    .heightIs(buttonH);
    
    _visitDataTextField.sd_layout
    .topEqualToView(staticRTVTwoLabel)
    .leftSpaceToView(staticRTVTwoLabel, spaceToLeft)
    .rightSpaceToView(contentView, spaceToLeft)
    .heightIs(buttonH);
    
    staticRTVFourLabel.sd_layout
    .topSpaceToView(staticRTVTwoLabel, spaceToTopView)
    .leftSpaceToView(contentView, spaceToLeft)
    .widthIs(staticRTVFourLabelW)
    .heightIs(buttonH);
    
    _visitAddButton.sd_layout
    .topEqualToView(staticRTVOneLabel)
    .rightSpaceToView(contentView, 2 *spaceToLeft)
    .widthIs(70)
    .heightIs(buttonH);
    
    _visitResultTextField.sd_layout
    .topEqualToView(staticRTVFourLabel)
    .leftSpaceToView(staticRTVFourLabel, spaceToLeft)
    .rightSpaceToView(contentView, spaceToLeft)
    .heightIs(buttonH);
    
    bottomView.sd_layout
    .topSpaceToView(staticRTVTwoLabel, spaceToTopView)
    .leftSpaceToView(contentView, 0)
    .rightSpaceToView(contentView, 0)
    .heightIs(cellH);
}


- (KYMHLabel *)createLabelWithX:(CGFloat )x width:(CGFloat )width {
    
    KYMHLabel *label = [[KYMHLabel alloc] initWithTitle:nil BaseSize:CGRectMake(x, 0, width, cellH) LabelColor:nil LabelFont:smallFontSize LabelTitleColor:textColor TextAlignment:NSTextAlignmentCenter];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(width, 0, 0.5, cellH-2)];
    lineView.backgroundColor = EF_TextColor_TextColorDisable;
    [label addSubview:lineView];
    
    return label;
}


#pragma mark Lazy Load

- (UIPopoverController *)colorPopover
{
    if (_colorPopover == nil) {
        // 1.创建内容控制器
        RSCalendarVC *cpvc = [[RSCalendarVC alloc] init];
        cpvc.delegate = self;
        
        // 2.创建popover
        self.colorPopover = [[UIPopoverController alloc] initWithContentViewController:cpvc];
    }
    return _colorPopover;
}

- (UIPopoverController *)fastLookMenuPC
{
    if (_fastLookMenuPC == nil) {
        
        RSVADeleteVC *cpvc = [[RSVADeleteVC alloc] init];
        cpvc.delegate = self;
        
        // 2.创建popover
        self.fastLookMenuPC = [[UIPopoverController alloc] initWithContentViewController:cpvc];
        self.fastLookMenuPC.popoverContentSize = CGSizeMake(100, 50);
    }
    return _fastLookMenuPC;
}

#pragma mark Other Action

//让子视图不要响应父视图的手势
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.calendarView]) {
        return NO;
    }
    return YES;
}


- (void)rsva_dismissPopoverAndPopViewController{
    if (_fastLookMenuPC != nil ) {
        [_fastLookMenuPC dismissPopoverAnimated:YES];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Button Action

- (void ) rightTableViewHeadButtonAction: (KYMHButton *)button{
    button.selected = !button.selected;
    _rightTableView.editing = !_rightTableView.isEditing;
    
    NSLog(@"rightTableViewHeadButtonAction");
}


- (void ) numberButtonAction: (KYMHButton *)button{
    button.selected = !button.selected;
    _leftTableView.editing = !_leftTableView.isEditing;
    
    NSLog(@"numberButtonAction");
}

- (void ) visitAddButtonAction {
    //提示
    NSMutableArray *promptArray = [[NSMutableArray alloc] init];
    
    if ( [ UIUtil isEmptyStr:_visitDataTextField.text ] ) {
        [promptArray addObject:mFRSVAStaticStringVisiltData];
    }
    if ( [ UIUtil isEmptyStr:_visitResultTextField.text ] ) {
        [promptArray addObject:mFRSVAStaticStringVisiltResult];
    }
    
    NSString *promptString = @"";
    
    if (1 == promptArray.count ) {
        promptString = promptArray[0];
    }else if  (promptArray.count > 1) {
        promptString = promptArray[0];
        for (int i=1; i<promptArray.count; i++ ) {
            promptString = [promptString stringByAppendingString:[NSString stringWithFormat:@"\n%@",promptArray[i]]]; //正确
        }
    }
    
    if (promptArray.count > 0) {
        [self rsva_presentViewControllerWithMessage:promptString];
        return;
    }
    
    PatientfollowsModel *pfModel = [[PatientfollowsModel alloc] init];
    pfModel.flowTime = [self rsva_returnTimeString:_visitDataTextField.text];
    pfModel.flowResult = _visitResultTextField.text;
    
    [ self initModelWhenSaveTypeRSVAPatientArchiveInteger];  //在新建页面初始化Model
    
    [self.rightDataSource addObject:pfModel];
    
    _model.patientFollows = [_rightDataSource mutableCopy];
    [self clearAddVisitTextField];
    [_rightTableView reloadData];
}

- (NSString *)rsva_returnTimeString:(NSString *)textFieldText {
    
    if ( [UIUtil isEmptyStr:textFieldText] ) {
        return @"";
    }else {
        return    [NSString stringWithFormat:@"%lld",[RSMethod ylg_returnTimeStampWithDateString:textFieldText]];
    }
}

- (void ) riskAddButtonAction {
    //提示
    NSMutableArray *promptArray = [[NSMutableArray alloc] init];
    
    if ( [ UIUtil isEmptyStr:_riskFactorTextField.text ] ) {
        [promptArray addObject:mFRSVAStaticStringRiskFactor];
    }
    if ( [ UIUtil isEmptyStr:_dosageTextField.text ] ) {
        [promptArray addObject:mFRSVAStaticStringDosage];
    }
    if ( [ UIUtil isEmptyStr:_exposureTimeStartDataTextField.text ] ) {
        [promptArray addObject:mFRSVAStaticStringStartData];
    }
    NSString *promptString = @"";
    
    if (1 == promptArray.count ) {
        promptString = promptArray[0];
    }else if ( promptArray.count > 1 ) {
        promptString = promptArray[0];
        for (int i=1; i<promptArray.count; i++ ) {
            promptString = [promptString stringByAppendingString:[NSString stringWithFormat:@"\n%@",promptArray[i]]]; //正确
        }
    }
    
    if (promptArray.count > 0) {
        [self rsva_presentViewControllerWithMessage:promptString];
        return;
    }
    
    PatientrisksModel *ptModel = [[PatientrisksModel alloc] init];
    ptModel.dosage = _dosageTextField.text;
    
    if ( [UIUtil isEmptyStr:_exposureTimeStartDataTextField.text ]) {
        ptModel.startTime = @"";
    }else {
        ptModel.startTime = [self rsva_returnTimeString:_exposureTimeStartDataTextField.text];
    }
    
    if ( [UIUtil isEmptyStr:_exposureTimeEndDataTextField.text ]) {
        ptModel.endTime = @"";
    }else {
        ptModel.endTime = [self rsva_returnTimeString:_exposureTimeEndDataTextField.text];
    }
    
    ptModel.riskName = _riskFactorTextField.text;
    ptModel.riskId = [NSString stringWithFormat:@"%ld", (long)_riskObjectId];
    
    [ self initModelWhenSaveTypeRSVAPatientArchiveInteger];  //在新建页面初始化Model
    
    [self.leftDataSource addObject:ptModel];
    _model.patientRisks = [_leftDataSource mutableCopy];
    [self clearAddRiskTextField];
    [_leftTableView reloadData];
}

- (void)clearAddRiskTextField {
    _riskFactorTextField.text = @"";
    _dosageTextField.text = @"";
    _exposureTimeStartDataTextField.text = @"";
    _exposureTimeEndDataTextField.text = @"";
}

- (void)clearAddVisitTextField {
    _visitDataTextField.text = @"";
    _visitResultTextField.text = @"";
}

//- (void ) navigationCenterButtonAction : (KYMHButton *) button{
//    [self.fastLookMenuPC presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//}

- (void ) navigationRightAction {
    if (self.rightDataSource.count > 0) {
        self.rsVAPatientArchiveVCPatientfollowsModelBlock(self.rightDataSource);
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self visitAddButtonAction];
    }
}

- (void )rsva_presentViewControllerWithMessage:(NSString *)message {
    
    UIAlertController *alertController = [RSMethod ylg_presentAlertControllerWithTitle:@"提示" message:message];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void ) pregnancyNumLeftButtonAction {
    _pregnancyNumInteger--;
    if(_pregnancyNumInteger<=0  ) {
        _pregnancyNumInteger = 0;
        
        [self setButtonNoCanClick:_pregnancyNumLeftButton];
    }
    
    _pregnancyNumLabel.text = [NSString stringWithFormat:@"%ld",(long)_pregnancyNumInteger];
}

- (void ) pregnancyNumRightButtonAction {
    _pregnancyNumInteger++;
    
    if(_pregnancyNumInteger > 0) {
        [self setButtonCanClick:_pregnancyNumLeftButton];
    }
    
    _pregnancyNumLabel.text = [NSString stringWithFormat:@"%ld",(long)_pregnancyNumInteger];
}


- (void ) bornNumLeftButtonAction {
    _bornNumNumInteger--;
    if(_bornNumNumInteger<=0  ) {
        _bornNumNumInteger = 0;
        
        [self setButtonNoCanClick:_bornNumLeftButton];
        
    }
    
    _bornNumLabel.text = [NSString stringWithFormat:@"%ld",(long)_pregnancyNumInteger];
}

- (void ) bornNumRightButtonAction {
    _bornNumNumInteger++;
    
    if(_bornNumNumInteger > 0  ) {
        [self setButtonCanClick:_bornNumLeftButton];
    }
    
    _bornNumLabel.text = [NSString stringWithFormat:@"%ld",(long)_bornNumNumInteger];
}

- (void ) initModelWhenSaveTypeRSVAPatientArchiveInteger {
    
    //    if (1 == _saveTypeRSVAPatientArchiveInteger ) {
    //        if (nil == _model ) {
    //            _model = [[ RSVisitArchiveModel alloc ] init];
    //        }
    //    }
}

- (void )textFieldResignFirstResponder {
    
    [_medicalRecordTextField resignFirstResponder];
    [_nameTextField resignFirstResponder];
    [_phoneNumberTextField resignFirstResponder];
    [_familyAddressTextField resignFirstResponder];
    [_suetsugiMensesTextField resignFirstResponder];
    [_expectedBornDataTextField resignFirstResponder];
    [_riskFactorTextField resignFirstResponder];
    [_dosageTextField resignFirstResponder];
    [_exposureTimeStartDataTextField resignFirstResponder];
    [_exposureTimeEndDataTextField resignFirstResponder];
    [_visitDataTextField resignFirstResponder];
}

#pragma mark Set

- (void ) setModel:(RSVisitArchiveModel *)model {
    
    _model = model;
    _leftDataSource = [model.patientRisks mutableCopy];
    _rightDataSource = [model.patientFollows mutableCopy];
    
#warning TODO 移除服务端产生的无用数据(服务端暂时无法优化)
    if (_leftDataSource.count > 0) {
        PatientrisksModel *model = _leftDataSource[0];
        if ([UIUtil isEmptyStr:model.riskId] ) {
            [_leftDataSource removeObject:model];
        }
    }
}

- (NSMutableArray *) leftDataSource {
    
    if (nil == _leftDataSource ) {
        _leftDataSource = [[NSMutableArray alloc] init];
    }
    return _leftDataSource;
}

- (NSMutableArray *) rightDataSource {
    
    if (nil == _rightDataSource ) {
        _rightDataSource = [[NSMutableArray alloc] init];
    }
    return _rightDataSource;
}

- (void)viewGestureAction:(UITapGestureRecognizer *)gesture {
    _calendarBGView.hidden = YES;
}

#pragma mark setButtonIsCanClick

- (void) setButtonCanClick:(KYMHButton *)button  {
    button.enabled = YES;
    [button setBackgroundImage:[UIImage imageWithColor:RSVisitArchiveButtonColor] forState:UIControlStateNormal];
}

- (void) setButtonNoCanClick:(KYMHButton *)button  {
    button.enabled = NO;
    [button setBackgroundImage:[UIImage imageWithColor:buttonNotClickColor] forState:UIControlStateNormal];
}


#pragma mark TableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf)
    RSVAVisitRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:RSVAVisitRecordVCCell_One_ID];
    if (cell == nil) {
        cell = [[RSVAVisitRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RSVAVisitRecordVCCell_One_ID];
    }
    
    if(_rightDataSource.count > 0) {
        PatientfollowsModel *model = _rightDataSource[indexPath.row];
        cell.numberInteger = indexPath.row + 1;
        cell.model = model;
    }
    __block typeof(cell)wsCell = cell;
    [wsCell RSVAVisitRecordCellHeadSelectBlock:^(BOOL isSelected) {
        if(indexPath.row == 0) { //全选
            [weakSelf.rightTableView setEditing:YES animated:YES];   //启动表格的编辑模式
        }
    }];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return _rightDataSource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark TableView Delegate

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_rightDataSource removeObjectAtIndex:indexPath.row];
        _model.patientFollows = [_rightDataSource mutableCopy];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_rightHeadView == nil ) {
        _rightHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        _rightHeadView.backgroundColor = RSVisitArchiveTableViewHeadSectionBGColor;
        [self  createRightHeadView:_rightHeadView];
    }
    return _rightHeadView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 140;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id model = _rightDataSource[indexPath.row];
    CGFloat height = [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[RSVAVisitRecordCell class] contentViewWidth:[RSMethod cellContentViewWith]];
    return height;
}

#pragma mark TextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if( textField  == _visitDataTextField  ){
        
        WS(weakSelf)
        _currentSelectTextField = (UITextField *)textField;
        [_currentSelectNotIsDataTextField resignFirstResponder];
        
        [self initCalendar];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.000000001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.currentSelectNotIsDataTextField resignFirstResponder];
            [textField resignFirstResponder];
        });
        
    }else if (textField == _riskFactorTextField ) {
        
        RSSearchVC *next = [[RSSearchVC alloc] init];
        next.isRSVAPatientArchiveVCBool = YES;
        UINavigationController *searchNC = [[UINavigationController alloc] initWithRootViewController: next];
        WS(weakSelf)
        [next RSSearchVCClickBlack:^(NSString *selectString, NSInteger objectId) {
            weakSelf.riskFactorTextField.text  = selectString;
            weakSelf.riskObjectId = objectId;
        }];
        
        [self.navigationController presentViewController:searchNC animated:YES completion:nil];
        [self textFieldResignFirstResponder];
    }else {
        NSLog(@"测试");
        _currentSelectNotIsDataTextField = (UITextField *)textField;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ( textField == _medicalRecordTextField) {
        return [self validateNumber:string];
    }
    
    if (textField == _dosageTextField )  {
        /*
        if ([textField.text rangeOfString:@"."].location == NSNotFound) {
            isHaveDian = NO;
        }
        if ([string length] > 0) {
            unichar single = [string characterAtIndex:0];//当前输入的字符
            if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
                //首字母不能为0和小数点
                if([textField.text length] == 0){
                    if(single == '.') {
                        [self showError:@"亲，第一个数字不能为小数点"];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                    if (single == '0') {
                        [self showError:@"亲，第一个数字不能为0"];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                
                //输入的字符是否是小数点
                if (single == '.') {
                    if(!isHaveDian)//text中还没有小数点
                    {
                        isHaveDian = YES;
                        return YES;
                        
                    }else{
                        [self showError:@"亲，您已经输入过小数点了"];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }else{
                    if (isHaveDian) {//存在小数点
                        
                        //判断小数点的位数
                        NSRange ran = [textField.text rangeOfString:@"."];
                        if (range.location - ran.location <= 10) {
                            return YES;
                        }else{
                            [self showError:@"亲，您最多输入两位小数"];
                            return NO;
                        }
                    }else{
                        return YES;
                    }
                }
            }else{//输入的数据格式不正确
                [self showError:@"亲，您输入的格式不正确"];
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        else
        {
            return YES;
        }
         */
        return YES;
    }
    return YES;
}

- (void)showError:(NSString *)errorString {
    [self rsva_presentViewControllerWithMessage:errorString];
}

- (BOOL)checkDecimalDotPlaces:(NSRange)range dotPlaces:(NSNumber *)dotPlaces decimal:(NSString *)decimal{
    BOOL bHaveDot = false;
    
    if (dotPlaces.integerValue < 0) {
        dotPlaces = @0;
    }
    
    if ([decimal rangeOfString:@"."].location == NSNotFound){
        bHaveDot = false;
    }else{
        bHaveDot = true;
    }
    
    if (bHaveDot) {
        //判断小数点的位数
        NSRange ran = [decimal rangeOfString:@"."];
        if (range.location - ran.location > dotPlaces.integerValue) {
            return NO;
        }
    }
    return YES;
}

#pragma mark Other Method

- (BOOL)validateNumber:(NSString*)number {
    
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

#pragma mark Method About TextField

- (void ) evaluationTextField:(UITextField * )textField replacementString: (NSString *)string {
    
    if (textField == _medicalRecordTextField) {
        _medicalRecordTextField.text = string;
    }else if ( textField == _nameTextField ) {
        _nameTextField.text = string;
    }else if ( textField == _phoneNumberTextField ) {
        _phoneNumberTextField.text = string;
    }else if ( textField == _familyAddressTextField ) {
        _familyAddressTextField.text = string;
    }else if ( textField == _dosageTextField ) {
        _dosageTextField.text = string;
    }else if ( textField == _visitResultTextField ) {
        _visitResultTextField.text = string;
    }
}

#pragma mark RSVADeleteVCDelegate
- (void)archiveDelete {
    //    if (0 == _saveTypeRSVAPatientArchiveInteger) {
    //        [self.viewModel deleteFollowRecord:_model.patientId];
    //    }else {
    //        [self rsva_dismissPopoverAndPopViewController];
    //    }
}

- (void)rsva_dismissSelf {
    if (_fastLookMenuPC != nil ) {
        [_fastLookMenuPC dismissPopoverAnimated:YES];
    }
}

#pragma mark RSCalendarVCDelegate

- (void)datePicker:(RSCalendarVC *)rsCalendarVC didSelectDate:(NSDate *)date {
    if (_exposureTimeStartDataTextField == _currentSelectTextField) {
        NSDate *curDate = [NSDate date];//获取当前日期
        int judgeInt = [RSMethod compareOneDay:date withAnotherDay:curDate];
        if  (1== judgeInt ) {
            if (_colorPopover != nil ) {
                [_colorPopover dismissPopoverAnimated:YES];
            }
            [self rsva_presentViewControllerWithMessage:@"[暴露时间-开始日期] 不能大于当前日期!"];
            return;
        }
        
        if (![UIUtil isEmptyStr:_exposureTimeEndDataTextField.text] ) {
            NSDate *exposureTimeEndData = [RSMethod ylg_returnDateWithTime:_exposureTimeEndDataTextField.text];
            int exposureTimeEndDataJudgeInt =  [RSMethod compareOneDay:date withAnotherDay:exposureTimeEndData];
            if (1 == exposureTimeEndDataJudgeInt) {
                if (_colorPopover != nil ) {
                    [_colorPopover dismissPopoverAnimated:YES];
                }
                [self rsva_presentViewControllerWithMessage:@"[暴露时间-开始日期] 不能大于结束日期!"];
                return;
            }
        }
    }
    
    if (_exposureTimeEndDataTextField == _currentSelectTextField)  {
        if (![UIUtil isEmptyStr:_exposureTimeStartDataTextField.text] ) {
            NSDate *exposureTimeStartData = [RSMethod ylg_returnDateWithTime:_exposureTimeStartDataTextField.text];
            int exposureTimeStartDataJudgeInt =  [RSMethod compareOneDay:date withAnotherDay:exposureTimeStartData];
            if (-1 == exposureTimeStartDataJudgeInt) {
                if (_colorPopover != nil ) {
                    [_colorPopover dismissPopoverAnimated:YES];
                }
                [self rsva_presentViewControllerWithMessage:@"[暴露时间-结束日期] 不能小于开始日期!"];
                return;
            }
        }
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    if (_currentSelectTextField ) {
        _currentSelectTextField.text = destDateString;
    }
    
    if (_colorPopover != nil ) {
        [_colorPopover dismissPopoverAnimated:YES];
    }
}


#pragma mark ViewModel回调

- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    
    //[SVProgressHUD dismiss];
    if (action == RSRisk_NS_ENUM_updateFollowRecord) {
        if ( result.status == NetworkModelStatusTypeSuccess ) {
            self.rsVAPatientArchiveVCBlock(YES);
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [RSMethod ylg_showSuccessWithStatus:result.message];
        }
    }
    
    if (action == RSRisk_NS_ENUM_deleteFollowRecord) {
        if (result.status == NetworkModelStatusTypeSuccess) {
            self.rsVAPatientArchiveVCBlock(YES);
            [self rsva_dismissPopoverAndPopViewController];
        }else {
            [RSMethod ylg_showSuccessWithStatus:result.message];
        }
    }
    
    if (action == RSRisk_NS_ENUM_saveFollowRecord) {
        if (result.status == NetworkModelStatusTypeSuccess ) {
            self.rsVAPatientArchiveVCBlock(YES);
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [RSMethod ylg_showSuccessWithStatus:result.message];
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

