//
//  RSVAPatientArchiveVC.m
//  Risk
//
//  Created by ylgwhyh on 16/7/7.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSVAPatientArchiveVC.h"
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
#import "RSVARiskExposeVC.h"
#import "RSVAVisitRecordVC.h"

@interface RSVAPatientArchiveVC ( ) <UITableViewDelegate, UITableViewDataSource, RSCalendarVCDelegate, UITextFieldDelegate, RSVADeleteVCDelegate, RSVADeleteVCDelegate,UIGestureRecognizerDelegate>

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

//日历
@property (nonatomic, strong) UITextField *currentSelectTextField;  //当前选择的日期textfield
@property (nonatomic, strong) UITextField *currentSelectNotIsDataTextField;  //当前选择的非日期textfield

@property (nonatomic, strong)  RSRiskViewModel *viewModel;

@property (nonatomic, strong) FDCalendar *calendarView;
@property (nonatomic, strong) UIView *calendarBGView;

//iphone
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) DXPopover * popver; //弹出视图

@end

@implementation RSVAPatientArchiveVC {
    
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
    UIColor *textFieldBGBorderColor;
    UIColor *buttonNotClickColor;
    UIColor *buttonCanClickColor;
    
    CGFloat cellH;
    UIColor *textColor;
    BOOL isHaveDian;
}

typedef enum : NSUInteger {
    RSVAPatientArchiveVC_ENUM_0,
    RSVAPatientArchiveVC_ENUM_1,
} RSVAPatientArchiveVC_ENUM;

static NSString * const RSVAriskFactorCell_One_ID = @"RSVAriskFactorCell_One_ID";
static NSString * const RSVAVisitRecordCell_One_ID = @"RSVAVisitRecordCell_One_ID";

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
    
    //如果未保存，则清空数据
//    _model = [[RSVisitArchiveModel alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [EFAppManager shareInstance].sideAndTabHome.rootViewController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
    [self updateData];
}

- (void ) updateData {
    _medicalRecordTextField.text = _model.medicalRecordNo;
    if (0 == _saveTypeRSVAPatientArchiveInteger) {  //上个页面点击tableView cell进入此页面
        _medicalRecordTextField.enabled = NO;
        _medicalRecordTextField.textColor = [UIColor grayColor];
    }else {
        _medicalRecordTextField.enabled = YES;
        _medicalRecordTextField.textColor = [UIColor blackColor];
    }
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
        _pregnancyNumInteger = [_model.pregnancyNum integerValue];
    }
    
    if ( [ UIUtil isEmptyStr:_model.bornNum] ) {
        _bornNumLabel.text = @"0";
    }else {
        _bornNumLabel.text = _model.bornNum;
        _bornNumNumInteger = [_model.bornNum integerValue];
    }
    [self initButtonStatus];
}

#pragma mark Init

- (void) initData {
    commonFontSize = RSVisitArchiveCommonFontSize;
    spaceToLeft = 5;
    buttonH = RSVisitArchiveButtonH;
    nameTextFieldW = 90;
    nameToTextFieldSpace= 15;
    textFieldSpaceToName = 40;
    nameLabelW = 75;
    addToLabelSpace = 10;
    _pregnancyNumInteger = 0;
    _bornNumNumInteger = 0;
    topScrollViewH = 320;
    spaceToTopView = 15;
    
    cellH = 44;
    textColor = EF_TextColor_TextColorPrimary;
    
    textFieldBGColor = RSVisitArchiveTextFieldBGColor;
    textFieldBGBorderColor = EF_TextColor_TextColorSecondary;
    buttonNotClickColor = RGBColor(121, 219, 169);
    buttonCanClickColor = RSVisitArchiveButtonColor;
    
    _dataSource = [[NSMutableArray alloc] init];
    _viewModel = [[RSRiskViewModel alloc] initWithViewController:self];
    
    _popver = [[DXPopover alloc]init];
}

- (void) initUI {
    self.title = @"患者档案";
    [self initNavigateView];
    [self initTopScrollView];
    [self initLeftAndRightTableView];
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

- (void) initTopScrollView {
    
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, topScrollViewH)];
    _topScrollView.bounces = YES;
    _topScrollView.scrollEnabled = YES;
    _topScrollView.backgroundColor = RSVisitArchiveTableViewHeadSectionBGColor;
     _topScrollView.showsVerticalScrollIndicator = NO;
    [_topScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, 220)];
    [self.view addSubview:_topScrollView];

     KYMHLabel  *staticOneLabel = [self createLabelWith:NSTextAlignmentLeft text:@"*病历号: "];
     KYMHLabel  *staticNameLabel = [self createLabelWith:NSTextAlignmentLeft text:@"*姓  名: "];
     KYMHLabel  *staticPhoneNumberLabel = [self createLabelWith:NSTextAlignmentLeft text:@"联系电话: "];
     KYMHLabel  *staticFamilyAddressLabel = [self createLabelWith:NSTextAlignmentLeft text:@"家庭住址: "];
     KYMHLabel  *staticFourLabel = [self createLabelWith:NSTextAlignmentLeft text:@"末次月经: "];
     KYMHLabel  *staticFiveLabel = [self createLabelWith:NSTextAlignmentLeft text:@"预产期: "];
     KYMHLabel  *staticSixLabel = [self createLabelWith:NSTextAlignmentRight text:@"孕次: "];
     KYMHLabel  *staticSevenLabel = [self createLabelWith:NSTextAlignmentRight text:@"产次: "];
    _pregnancyNumLabel = [self createLabelWith:NSTextAlignmentCenter text:@"0"];
    _bornNumLabel = [self createLabelWith:NSTextAlignmentCenter text:@"0"];
    
     _medicalRecordTextField = [self createTextFieldWith:@"病历号"];
     _medicalRecordTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
     _nameTextField = [self createTextFieldWith:@"患者姓名"];
     _phoneNumberTextField = [self createTextFieldWith:@"联系电话"];
     _phoneNumberTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
     _familyAddressTextField = [self createTextFieldWith:@"家庭住址"];
     _suetsugiMensesTextField = [self createTextFieldWith:@"末次月经日期"];
     _expectedBornDataTextField = [self createTextFieldWith:@"预产期"];
    
     _pregnancyNumLeftButton = [self createButtonWithTitle:@"-" action:@selector(pregnancyNumLeftButtonAction)];
     _pregnancyNumRightButton = [self createButtonWithTitle:@"+" action:@selector(pregnancyNumRightButtonAction)];
     _bornNumLeftButton = [self createButtonWithTitle:@"-" action:@selector(bornNumLeftButtonAction)];
     _bornNumRightButton = [self createButtonWithTitle:@"+" action:@selector(bornNumRightButtonAction)];
    
     NSArray *views = @[staticOneLabel, staticNameLabel, staticPhoneNumberLabel,
                       staticFamilyAddressLabel, staticFourLabel, staticFiveLabel,
                       staticSixLabel, staticSevenLabel, _medicalRecordTextField,
                        _nameTextField, _phoneNumberTextField,_familyAddressTextField,
                       _suetsugiMensesTextField, _expectedBornDataTextField,_pregnancyNumLeftButton,
                       _pregnancyNumRightButton, _bornNumLeftButton,_bornNumRightButton,
                        _pregnancyNumLabel, _bornNumLabel
                       ];
    
     [_topScrollView sd_addSubviews:views];
     UIView *contentView = _topScrollView;

    //第一行第一个
    
    CGFloat spaceToTop = 10;
    
    //患者姓名
    staticNameLabel.sd_layout
    .topSpaceToView(contentView, 10)
    .leftSpaceToView(contentView, spaceToLeft)
    .widthIs(nameLabelW)
    .heightIs(buttonH);
    
    
    _nameTextField.sd_layout
    .topEqualToView(staticNameLabel)
    .leftSpaceToView(staticNameLabel, spaceToLeft)
    .rightSpaceToView(contentView,spaceToLeft)
    .heightIs(buttonH);
    
    //病历号
    staticOneLabel.sd_layout
    .topSpaceToView(staticNameLabel, spaceToTop)
    .leftSpaceToView(contentView, spaceToLeft)
    .widthIs(nameLabelW)
    .heightIs(buttonH);
    
    _medicalRecordTextField.sd_layout
    .topEqualToView(staticOneLabel)
    .leftSpaceToView(staticOneLabel, spaceToLeft)
    .rightSpaceToView(contentView, spaceToLeft)
    .heightIs(buttonH);
    
    
    //联系电话

    staticPhoneNumberLabel.sd_layout
    .topSpaceToView(staticOneLabel, spaceToTop)
    .leftSpaceToView(contentView, spaceToLeft)
    .widthIs(nameLabelW)
    .heightIs(buttonH);
    
    _phoneNumberTextField.sd_layout
    .topEqualToView(staticPhoneNumberLabel)
    .leftSpaceToView (staticPhoneNumberLabel, spaceToLeft)
    .rightSpaceToView(contentView, spaceToLeft)
    .heightIs(buttonH);
    

    
    //第二行第二个
    staticFamilyAddressLabel.sd_layout
    .topSpaceToView(staticPhoneNumberLabel, spaceToTop)
    .leftSpaceToView(contentView, spaceToLeft)
    .widthIs(nameLabelW)
    .heightIs(buttonH);
    
    _familyAddressTextField.sd_layout
    .topEqualToView(staticFamilyAddressLabel)
    .leftSpaceToView(staticFamilyAddressLabel, spaceToLeft)
    .rightSpaceToView(contentView, spaceToLeft)
    .heightIs(buttonH);

     //第三行第三个
    
    //末次月经
    staticFourLabel.sd_layout
    .topSpaceToView(staticFamilyAddressLabel, spaceToTop)
    .leftSpaceToView(contentView, spaceToLeft)
    .widthIs(nameLabelW-5)
    .heightIs(buttonH);
    
    CGFloat suetsugiMensesTextFieldW = 120;
    if (SCREEN_HEIGHT <= 568)  {
        suetsugiMensesTextFieldW = 90;
    }
    _suetsugiMensesTextField.sd_layout
    .topEqualToView(staticFourLabel)
    .leftSpaceToView(staticFourLabel, spaceToLeft)
    .widthIs(suetsugiMensesTextFieldW)
    .heightIs(buttonH);
    
    CGFloat staticFiveLabelW = 50;
    if (SCREEN_HEIGHT > 568) {
        staticFiveLabelW = 60;
    }
    //预产期
    staticFiveLabel.sd_layout
    .topEqualToView(staticFourLabel)
    .leftSpaceToView(_suetsugiMensesTextField, spaceToLeft)
    .widthIs(staticFiveLabelW)
    .heightIs(buttonH);
    
    _expectedBornDataTextField.sd_layout
    .topEqualToView(staticFourLabel)
    .leftSpaceToView(staticFiveLabel, spaceToLeft)
    .rightSpaceToView(contentView,spaceToLeft)
    .heightIs(buttonH);
    
    //孕次
    staticSixLabel.sd_layout
    .topSpaceToView(staticFourLabel,spaceToTop)
    .leftSpaceToView(contentView, spaceToLeft)
    .widthIs(40)
    .heightIs(buttonH);
    
    _pregnancyNumLeftButton.sd_layout
    .topEqualToView(staticSixLabel)
    .leftSpaceToView(staticSixLabel,spaceToLeft)
    .widthIs(buttonH)
    .heightIs(buttonH);
    
    _pregnancyNumLabel.sd_layout
    .topEqualToView(staticSixLabel)
    .leftSpaceToView(_pregnancyNumLeftButton, 5)
    .widthIs(20)
    .heightIs(buttonH);
    
    _pregnancyNumRightButton.sd_layout
    .topEqualToView(staticSixLabel)
    .leftSpaceToView(_pregnancyNumLabel,5)
    .widthIs(buttonH)
    .heightIs(buttonH);
    
    
    //产次
    _bornNumRightButton.sd_layout
    .topSpaceToView(staticFourLabel,spaceToTop)
    .rightSpaceToView(contentView, 5)
    .widthIs(buttonH)
    .heightIs(buttonH);
    
    _bornNumLabel.sd_layout
    .topEqualToView(_bornNumRightButton)
    .rightSpaceToView(_bornNumRightButton, 5)
    .widthIs(20)
    .heightIs(buttonH);
    
    _bornNumLeftButton.sd_layout
    .topEqualToView(_bornNumRightButton)
    .rightSpaceToView(_bornNumLabel, 5)
    .widthIs(buttonH)
    .heightIs(buttonH);
    
    staticSevenLabel.sd_layout
    .topEqualToView(_bornNumRightButton)
    .rightSpaceToView(_bornNumLeftButton, nameToTextFieldSpace)
    .widthIs(nameLabelW)
    .heightIs(buttonH);
}

- (void) initButtonStatus {
    
    if(_pregnancyNumInteger<=0  ) {
        [self setButtonNoCanClick:_pregnancyNumLeftButton];
    }else {
        [self setButtonCanClick:_pregnancyNumLeftButton];
    }
    
    if(_bornNumNumInteger<=0  ) {
        [self setButtonNoCanClick:_bornNumLeftButton];
    }else {
        [self setButtonCanClick:_bornNumLeftButton];
    }
}

- (void ) initLeftAndRightTableView {
    
    CGFloat tableViewH =  SCREEN_HEIGHT-topScrollViewH;
    CGFloat tableViewY = topScrollViewH+1;
    
    _leftTableView = [self createTableViewWithFrame:CGRectMake(0, tableViewY, SCREEN_WIDTH,tableViewH) cellID:RSVAriskFactorCell_One_ID tableViewCell:[RSVAriskFactorCell class]];
    [self.view addSubview:_leftTableView];
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
    
    KYMHButton * centerBtn= [[KYMHButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, 132, 44)];
    [centerBtn addTarget:self action:@selector(navigationCenterButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [centerBtn setTitle:@"患者档案" forState:UIControlStateNormal];
    [centerBtn setTitleColor:textColorButtonSelected forState:UIControlStateSelected];
    [centerBtn setImage:Img(@"right_menu") forState:UIControlStateNormal];
    [centerBtn horizontalCenterTitleAndImage];

    self.navigationItem.titleView = centerBtn;
}


#pragma mark Create UI

- (KYTableView *) createTableViewWithFrame:(CGRect )frame cellID:(NSString *)cellID tableViewCell: (Class )cellClass {
    
    KYTableView *tableView = [[KYTableView alloc] initWithFrame:frame andUpBlock:^{
        
        [_leftTableView endLoading];
        [_rightTableView endLoading];
    } andDownBlock:^{
        
        [_leftTableView endLoading];
        [_rightTableView endLoading];
    } andStyle:UITableViewStylePlain];
    
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
    [button setBackgroundImage:[UIImage imageWithColor:buttonCanClickColor] forState:UIControlStateNormal];
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
    textField.layer.cornerRadius = 5;
    textField.delegate = self;
    textField.font = Font(RSVisitArchiveCommonFontSize);
    textField.layer.borderColor = textFieldBGBorderColor.CGColor;
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
    textField.layer.borderColor = textFieldBGBorderColor.CGColor;
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

- (void) createLeftHeadView: (UIView *)view{
    
    KYMHLabel *staticLTVOneLabel = [self createLabelWithTitle:@"危险因素暴露情况"];
    _riskAddButton = [self createButtonWithTitle:@"+添  加" action:@selector(hazardsExposeAction)];
    _riskAddButton.titleLabel.font = Font(smallFontSize);

    view.backgroundColor = RSVisitArchiveTableViewHeadSectionBGColor;
    
    NSArray *views = @[staticLTVOneLabel , _riskAddButton];
    [view sd_addSubviews:views];
    
    UIView *contentView = view;
    
    staticLTVOneLabel.sd_layout
    .leftSpaceToView(contentView, spaceToLeft)
    .topSpaceToView(contentView, spaceToTopView)
    .bottomSpaceToView(contentView,spaceToTopView)
    .widthIs(200);
    //.heightIs(buttonH);

    //添加
    _riskAddButton.sd_layout
    .rightSpaceToView(contentView, 2*spaceToLeft)
    .centerYEqualToView(staticLTVOneLabel)
    //.topEqualToView(staticLTVOneLabel)
    .widthIs(70)
    .heightIs(buttonH-2);

    UIView *_topLineView;
    UIView *_bottomLineView;
    
    _topLineView = [UIView new];
    _topLineView.backgroundColor = EF_TextColor_TextColorDisable;
    _topLineView.hidden = NO; //默认隐藏
    
    _bottomLineView = [UIView new];
    _bottomLineView.backgroundColor = EF_TextColor_TextColorDisable;
}

- (void) createRightHeadView: (UIView *)view{
    
    KYMHLabel *staticRTVOneLabel = [self createLabelWithTitle:@"随访记录情况"];
     _visitAddButton = [self createButtonWithTitle:@"+添  加" action:@selector(visitRecordAction)];
     _visitAddButton.titleLabel.font = Font(smallFontSize);
    
    view.backgroundColor = RSVisitArchiveTableViewHeadSectionBGColor;
    //view.backgroundColor = [UIColor yellowColor];

    NSArray *views = @[staticRTVOneLabel, _visitAddButton ];
    
    [view sd_addSubviews:views];
    UIView *contentView = view;
    
    staticRTVOneLabel.sd_layout
    .leftSpaceToView(contentView, spaceToLeft)
    .topSpaceToView(contentView, spaceToTopView)
    .bottomSpaceToView(contentView, spaceToTopView)
    .widthIs(200);
    
    _visitAddButton.sd_layout
    .centerYEqualToView(staticRTVOneLabel)
    .rightSpaceToView(contentView, 2*spaceToLeft)
    .widthIs(70)
    .heightIs(buttonH-2);

    UIView *_topLineView;
    UIView *_bottomLineView;
    
    _topLineView = [UIView new];
    _topLineView.backgroundColor = EF_TextColor_TextColorDisable;
    
    _bottomLineView = [UIView new];
    _bottomLineView.backgroundColor = EF_TextColor_TextColorDisable;
}

- (KYMHLabel *)createLabelWithX:(CGFloat )x width:(CGFloat )width {
    
    KYMHLabel *label = [[KYMHLabel alloc] initWithTitle:nil BaseSize:CGRectMake(x, 0, width, cellH) LabelColor:nil LabelFont:smallFontSize LabelTitleColor:textColor TextAlignment:NSTextAlignmentCenter];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(width, 0, 0.5, cellH-2)];
    lineView.backgroundColor = EF_TextColor_TextColorDisable;
    [label addSubview:lineView];
    
    return label;
}

#pragma mark Button Action

- (void)hazardsExposeAction {
    WS(weakSelf)
    RSVARiskExposeVC *next = [[RSVARiskExposeVC alloc] init];
    next.rsVAPatientArchiveVCPatientrisksModelBlock = ^(NSMutableArray *modelArray) {
        [ weakSelf initModelWhenSaveTypeRSVAPatientArchiveInteger];  //在新建页面初始化Model
        [weakSelf.leftDataSource addObjectsFromArray:modelArray];
        weakSelf.model.patientRisks = [weakSelf.leftDataSource mutableCopy];
        [weakSelf clearAddRiskTextField];
        [_leftTableView reloadData];
    };
    [self.navigationController  pushViewController:next animated:YES];
}

- (void)visitRecordAction {
    WS(weakSelf)
    RSVAVisitRecordVC *next = [[RSVAVisitRecordVC alloc] init];
    next.rsVAPatientArchiveVCPatientfollowsModelBlock = ^(NSMutableArray * modelArray){
        [weakSelf initModelWhenSaveTypeRSVAPatientArchiveInteger];
        [weakSelf.rightDataSource addObjectsFromArray:modelArray];
        weakSelf.model.patientFollows = [weakSelf.rightDataSource mutableCopy];
        [weakSelf clearAddVisitTextField];
        [weakSelf.leftTableView reloadData];
    };
    [self.navigationController  pushViewController:next animated:YES];
}

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

- (void ) navigationCenterButtonAction : (KYMHButton *) button{
    if (_deleteButton == nil) {
        _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
        _deleteButton.backgroundColor = [UIColor redColor];
        _deleteButton.layer.cornerRadius = 5;
        _deleteButton.layer.masksToBounds = 5;
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [_deleteButton addTarget:self action:@selector(testButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    CGPoint starPoint = CGPointMake(SCREEN_WIDTH/2, 64);//弹出的点
    [_popver showAtPoint:starPoint popoverPostion:DXPopoverPositionDown withContentView:_deleteButton inView:[UIApplication sharedApplication].keyWindow];
}

- (void)testButtonAction {
    WS(weakSelf)
    if (0 == _saveTypeRSVAPatientArchiveInteger) {
        
        if (_popver != nil ) {
            [_popver dismiss];
        }
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"message:@"确定要删除当前患者的档案资料吗？"preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (_popver != nil ) {
                [_popver dismiss];
            }
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.viewModel deleteFollowRecord:_model.patientId];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    }else {
        if (_popver != nil ) {
            [_popver dismiss];
        }
    }
}

- (void ) navigationRightAction {
    
    NSLog(@"navigationRightAction");

     [self initModelWhenSaveTypeRSVAPatientArchiveInteger];
    
    //提示
    NSMutableArray *promptArray = [[NSMutableArray alloc] init];
    
    if ( [ UIUtil isEmptyStr:_medicalRecordTextField.text ] ) {
        [promptArray addObject:mFRSVAStaticStringmedicalRecord];
    }
    if ( [ UIUtil isEmptyStr:_nameTextField.text ] ) {
        [promptArray addObject:mFRSVAStaticStringName];
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
    _model.menstruationTime = [self rsva_returnTimeString:_suetsugiMensesTextField.text];

    _model.childbirthTime = [self rsva_returnTimeString:_expectedBornDataTextField.text];
    
    _model.medicalRecordNo =  _medicalRecordTextField.text ;
    _model.name = _nameTextField.text;
    _model.phoneNum = _phoneNumberTextField.text;
    _model.address = _familyAddressTextField.text;
    _model.pregnancyNum = _pregnancyNumLabel.text;
    _model.bornNum = _bornNumLabel.text;
    
    [RSMethod ylg_SVProgressHUD_showWithSVProgressHUDMaskTypeNone];
    if (1 == _saveTypeRSVAPatientArchiveInteger ) {
        NSString *json = [_model yy_modelToJSONString];
        _medicalRecordTextField.enabled = YES;
        [self.viewModel saveFollowRecord:json];
    } else {
        NSString *json = [_model yy_modelToJSONString];
        _medicalRecordTextField.enabled = NO;
        [self.viewModel updateFollowRecord:json];
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
    _bornNumLabel.text = [NSString stringWithFormat:@"%ld",(long)_bornNumNumInteger];
}

- (void ) bornNumRightButtonAction {
    _bornNumNumInteger++;
    
    if(_bornNumNumInteger > 0  ) {
        [self setButtonCanClick:_bornNumLeftButton];
    }
    
    _bornNumLabel.text = [NSString stringWithFormat:@"%ld",(long)_bornNumNumInteger];
}

- (void ) initModelWhenSaveTypeRSVAPatientArchiveInteger {
    
    if (1 == _saveTypeRSVAPatientArchiveInteger ) {
        if (nil == _model ) {
            _model = [[ RSVisitArchiveModel alloc ] init];
        }
    }
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
    
    if (nil == _model) {
        _model = [[RSVisitArchiveModel alloc] init];
    }
    
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

#pragma mark setButtonIsCanClick

- (void) setButtonCanClick:(KYMHButton *)button  {
    button.enabled = YES;
    [button setBackgroundImage:[UIImage imageWithColor:buttonCanClickColor] forState:UIControlStateNormal];
}

- (void) setButtonNoCanClick:(KYMHButton *)button  {
    button.enabled = NO;
    [button setBackgroundImage:[UIImage imageWithColor:buttonNotClickColor] forState:UIControlStateNormal];
}


#pragma mark TableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf)
    if(indexPath.section == RSVAPatientArchiveVC_ENUM_0 ) {
        RSVAriskFactorCell *cell = [tableView dequeueReusableCellWithIdentifier:RSVAriskFactorCell_One_ID];
        if(_leftDataSource.count > 0) {
            PatientrisksModel *model = _leftDataSource[indexPath.row];
            cell.numberInteger = indexPath.row+1;
            cell.model = model;
        }
        
        __block typeof(cell)wsCell = cell;
        [wsCell RSVAriskFactorCellHeadSelectBlock:^(BOOL isSelected) {
            if(indexPath.row == 0) { //全选
                [weakSelf.leftTableView setEditing:YES animated:NO];  //启动表格的编辑模式
            }
        }];
        return cell;
        
    } else {
        
        RSVAVisitRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:RSVAVisitRecordCell_One_ID];
        if (!cell) {
            cell = [[RSVAVisitRecordCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:RSVAVisitRecordCell_One_ID];
        }
        
        if(_rightDataSource.count > 0) {
            PatientfollowsModel *model = _rightDataSource[indexPath.row];
            cell.numberInteger = indexPath.row + 1;
            cell.model = model;
        }        
        __block typeof(cell)wsCell = cell;
        [wsCell RSVAVisitRecordCellHeadSelectBlock:^(BOOL isSelected) {
            if(indexPath.row == 0) { //全选
                [weakSelf.leftTableView setEditing:YES animated:YES];   //启动表格的编辑模式
            }
        }];
        return cell;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == RSVAPatientArchiveVC_ENUM_0 ) {
        return _leftDataSource.count;
    } else {
        return _rightDataSource.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

#pragma mark TableView Delegate

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == RSVAPatientArchiveVC_ENUM_0 ) {
            
            [_leftDataSource removeObjectAtIndex:indexPath.row];
            _model.patientRisks = [_leftDataSource mutableCopy];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        } else {
            
            [_rightDataSource removeObjectAtIndex:indexPath.row];
             _model.patientFollows = [_rightDataSource mutableCopy];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(section == RSVAPatientArchiveVC_ENUM_0) {
        if (_leftHeadView == nil ) {
            _leftHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 184)];
            [self createLeftHeadView:_leftHeadView];
        }
        return _leftHeadView;
    }else {
        
        if (_rightHeadView == nil ) {
            _rightHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 140)];
            [self  createRightHeadView:_rightHeadView];
        }
        return _rightHeadView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if ( indexPath.section == RSVAPatientArchiveVC_ENUM_0) {
        id model = _leftDataSource[indexPath.row];
        
        CGFloat height = [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[RSVAriskFactorCell class] contentViewWidth:[RSMethod cellContentViewWith]];
        return height;
    }else {
        id model = _rightDataSource[indexPath.row];
        
        CGFloat height = [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[RSVAVisitRecordCell class] contentViewWidth:[RSMethod cellContentViewWith]];
        return height;
    }
}


#pragma mark TextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if( textField == _suetsugiMensesTextField ||
       textField == _expectedBornDataTextField ||
       textField  == _exposureTimeStartDataTextField ||
       textField  == _exposureTimeEndDataTextField ||
       textField  == _visitDataTextField  ){
    
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

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.calendarView]) {
        return NO;
    }
    return YES;
}

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

- (void)viewGestureAction:(UITapGestureRecognizer *)gesture {
    _calendarBGView.hidden = YES;
}

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
    if (0 == _saveTypeRSVAPatientArchiveInteger) {
        [self.viewModel deleteFollowRecord:_model.patientId];
    }else {
        //[self rsva_dismissPopoverAndPopViewController];
    }
}

#pragma mark RSCalendarVCDelegate

- (void)datePicker:(RSCalendarVC *)rsCalendarVC didSelectDate:(NSDate *)date {
    if (_exposureTimeStartDataTextField == _currentSelectTextField) {
        NSDate *curDate = [NSDate date];//获取当前日期
        int judgeInt = [RSMethod compareOneDay:date withAnotherDay:curDate];
        if  (1== judgeInt ) {
            [self rsva_presentViewControllerWithMessage:@"[暴露时间-开始日期] 不能大于当前日期!"];
            return;
        }
        
        if (![UIUtil isEmptyStr:_exposureTimeEndDataTextField.text] ) {
            NSDate *exposureTimeEndData = [RSMethod ylg_returnDateWithTime:_exposureTimeEndDataTextField.text];
            int exposureTimeEndDataJudgeInt =  [RSMethod compareOneDay:date withAnotherDay:exposureTimeEndData];
            if (1 == exposureTimeEndDataJudgeInt) {
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
}


#pragma mark ViewModel回调

- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    
    //[SVProgressHUD dismiss];
    if (action == RSRisk_NS_ENUM_updateFollowRecord) {
        if ( result.status == NetworkModelStatusTypeSuccess ) {
            self.rsVAPatientArchiveVCBlock(YES);
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [RSMethod ylg_showErrorWithStatus:result.message];
        }
    }
    
    if (action == RSRisk_NS_ENUM_deleteFollowRecord) {
        if (result.status == NetworkModelStatusTypeSuccess) {
            self.rsVAPatientArchiveVCBlock(YES);
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [RSMethod ylg_showErrorWithStatus:result.message];
        }
    }
    
    if (action == RSRisk_NS_ENUM_saveFollowRecord) {
        if (result.status == NetworkModelStatusTypeSuccess ) {
            self.rsVAPatientArchiveVCBlock(YES);
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [RSMethod ylg_showErrorWithStatus:result.message];
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
