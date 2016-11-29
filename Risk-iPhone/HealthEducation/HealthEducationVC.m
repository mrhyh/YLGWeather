//
//  HealthEducationVC.m
//  Risk-iPhone
//
//  Created by Cherie Jeong on 16/8/24.
//  Copyright © 2016年 Cherie Jeong. All rights reserved.
//

#import "HealthEducationVC.h"
#import "RiskTypeModel.h"
#import "RiskTypesLeftCell.h"
#import "RSHEListVC.h"
#import "RSHERightVC.h"
#import "HealthEducationContent.h"
#import "RSRiskViewModel.h"
#import "AllHealthModel.h"
#import "HealthEducationDetailsModel.h"
#import "RSDataVC.h"
#import "RSVideoVC.h"

@interface HealthEducationVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray *riskTypesArray;
@property (nonatomic, strong) NSIndexPath *oldSelectIndexPath;

@property (nonatomic, strong) RSRiskViewModel * viewModel;
@property (nonatomic, strong) NSString * showSectionInteger;
@property (nonatomic, strong) UIButton * seletBtn;
@property (nonatomic, assign) BOOL  isSeleted;

@property (nonatomic, strong) UITapGestureRecognizer * hiddenGesture;//收回侧边栏 点击事件



//获得所有健康教育资料
@property (nonatomic, strong) UISwitch *switchButton;
@property (nonatomic, assign) BOOL isSwitchButtonStatus; //为YES代表获得所有健康教育资料
@property (nonatomic, strong) NSMutableArray *heDetailsArray;
@property (nonatomic, strong) HealthEducationDetailsModel *healthEducationDetailsModel;

@end

@implementation HealthEducationVC

#define MFHealthEducationVC_Size 30

static NSString * const RiskTypesLeftVC_RiskTypesLeftCell_ID = @"RiskTypesLeftVC_RiskTypesLeftCell_ID";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [RSMethod ylg_SVProgressHUD_showWithSVProgressHUDMaskTypeNone];
    [self initData];
    [self initUI];
    [self requestData];
}

- (void)requestData {
    if (!_isSwitchButtonStatus) {
       [_viewModel findAllHealth];
    }
}

- (void)initData {
    _viewModel = [[RSRiskViewModel alloc]initWithViewController:self];
    _healthEducationDetailsModel = [[HealthEducationDetailsModel alloc] init];
    _heDetailsArray = [[NSMutableArray alloc] init];
    _pageCount = 0;
}

//显示侧边栏
- (void)showLeftVC {
    [[EFAppManager shareInstance].sideAndTabHome showLeftView];
    if (_hiddenGesture == nil) {
        _hiddenGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenLeftVC)];
    }
    
    [self.view addGestureRecognizer:_hiddenGesture];
}

//收回侧边栏
- (void)hiddenLeftVC {
    [[EFAppManager shareInstance].sideAndTabHome hiddenLeftView];
    [self.view removeGestureRecognizer:_hiddenGesture];
}

- (void) initUI {
    [self initTableView];
    [self initNavigateRightView];
    [self initNavigationLeftButton];
}

- (void)initNavigationLeftButton {
    UIButton * moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(0, 0, 44, 44);
    [moreBtn setImage:Img(@"text_menu") forState:0];
    [moreBtn addTarget:self action:@selector(showLeftVC) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithCustomView:moreBtn];
    self.navigationItem.leftBarButtonItem = leftBtn;
}

- (void)initTableView {
    WS(weakSelf)
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-50) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView.backgroundColor = RGBColor(213, 213, 220);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.view addSubview:_tableView];
        [_tableView registerClass:[RiskTypesLeftCell class] forCellReuseIdentifier:RiskTypesLeftVC_RiskTypesLeftCell_ID];
        
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
    
            if (_isSwitchButtonStatus) {
                if(weakSelf.viewModel.healthEducationDetailsModel.first == YES){
                    _pageCount = 0;
                    [_heDetailsArray removeAllObjects];
                }else {
                    if(_pageCount >=1) {
                        _pageCount--;
                    }else {
                        _pageCount = 0;
                    }
                }
                [weakSelf.viewModel getAllHealthFiles:_pageCount size:MFHealthEducationVC_Size];
            }else {
                [weakSelf.viewModel findAllHealth];

            }
        
            
        }];
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            if (_isSwitchButtonStatus) {
                if(weakSelf.viewModel.healthEducationDetailsModel.last == NO){
                    
                    _pageCount++;
                    [weakSelf.viewModel getAllHealthFiles:_pageCount size:MFHealthEducationVC_Size];
                }else {
                    
                    [self.tableView.mj_footer endRefreshing];
                    [UIUtil alert:@"已是最后一页"];
                }
            }

        }];
    }
}

#pragma mark CreateSwitch

- (void ) initNavigateRightView {
    UIView *leftNavigationBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 55, 30)];
    
    UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(5, 0, 50, 20)];
    switchButton.transform = CGAffineTransformMakeScale(MFCommonSwitchZoomProportion, MFCommonSwitchZoomProportion);
    switchButton.layer.cornerRadius = 15;
    [switchButton setOn:NO];
    if(switchButton.on == NO) {
        switchButton.backgroundColor = [UIColor whiteColor];
    }
    [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [leftNavigationBGView addSubview:switchButton];
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavigationBGView];
    self.navigationItem.rightBarButtonItem = barBtnItem;
    
    UIButton * moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(0, 0, 44, 44);
    [moreBtn setImage:Img(@"text_menu") forState:0];
    [moreBtn addTarget:self action:@selector(showLeftVC) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithCustomView:moreBtn];
    self.navigationItem.leftBarButtonItem = leftBtn;
}


#pragma mark CreateUI



#pragma mark buttonAction

- (void)switchAction:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    
    if (isButtonOn) {
        NSLog(@"是"); //项目
        _isSwitchButtonStatus = YES;
        if (_heDetailsArray.count == 0) {
            [self.viewModel getAllHealthFiles:0 size:30];
        }
    }else {
        NSLog(@"否"); //分类
        _isSwitchButtonStatus = NO;
    }
    [self.tableView reloadData];
}


#pragma mark - TableView data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * headView = [[UIView alloc]init];
    headView.backgroundColor = RGBColor(226, 226, 226);
    
    UILabel * titleLB = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 250, 44)];
    titleLB.textColor = RGBColor(46, 83, 111);
    titleLB.font = Font(15);
    [headView addSubview:titleLB];
    
    AllHealthModel *oldModel = _riskTypesArray[section];
    titleLB.text = oldModel.name;
    
//    UIButton * showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    showBtn.backgroundColor = [UIColor clearColor];
//    showBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
//    [showBtn setTitle:@"更多" forState:UIControlStateNormal];
//    [showBtn setTitle:@"收起" forState:UIControlStateSelected];
//    [showBtn setTitleColor:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary] forState:UIControlStateNormal];
//    [showBtn setTitleColor:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary] forState:UIControlStateSelected];
//    [showBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, SCREEN_WIDTH-70, 0, 0)];
//    showBtn.titleLabel.font = Font(13);
//    [headView addSubview:showBtn];
//    showBtn.tag = section + 1120;
//    if (![UIUtil isEmptyStr:_showSectionInteger] && section == [_showSectionInteger integerValue]) {
//        showBtn.selected = YES;
//    }else {
//        showBtn.selected = NO;
//    }
//    
//    [showBtn addTarget:self action:@selector(showList:) forControlEvents:UIControlEventTouchUpInside];
//    
//    if (oldModel.children.count <= 3) {
//        showBtn.userInteractionEnabled = NO;
//        showBtn.hidden = YES;
//    }else {
//        showBtn.userInteractionEnabled = YES;
//        showBtn.hidden = NO;
//    }
    
    
    if (_isSwitchButtonStatus) {
        return  nil;
    }else {
        return headView;
    }
}

- (void)showList:(UIButton *)button {
    
    if (_seletBtn.tag == button.tag) {
        if (!_seletBtn.selected) {
            _seletBtn.selected = YES;
            
            _showSectionInteger = [NSString stringWithFormat:@"%d",(int)_seletBtn.tag - 1120];
        }else {
            _seletBtn.selected = NO;
            
            _showSectionInteger = @"";
        }
    }else {
        _seletBtn.selected = NO;
        _seletBtn = button;
        _seletBtn.selected = YES;
        _showSectionInteger = [NSString stringWithFormat:@"%d",(int)_seletBtn.tag - 1120];
    }
    
    [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isSwitchButtonStatus) {
        return 1;
    }else {
         return _riskTypesArray.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (_isSwitchButtonStatus) {
        return _heDetailsArray.count;
    }else {
        AllHealthModel * model = _riskTypesArray[section];
        
        //    if (![UIUtil isEmptyStr:_showSectionInteger]) {
        //        if (section == [_showSectionInteger integerValue]) {
        //
        //            return [model.children count];
        //        }
        //    }
        //
        //    if (model.children.count >= 3) {
        //        return 3;
        //    }
        return [model.children count];
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isSwitchButtonStatus) {
        
        RiskTypesLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:RiskTypesLeftVC_RiskTypesLeftCell_ID];
        AllHealthModel *model = _riskTypesArray[indexPath.section];
        Children * children = model.children[indexPath.row];
        children.integer = (int)indexPath.row+1;
        cell.riskTypeModel = children;
        
        return cell;
        
    }else {
        
        static NSString *ID = @"RiskTypesRightVC_Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        HealthEducationContent *model = self.heDetailsArray[indexPath.row];
        cell.textLabel.text = model.fileName;
        cell.textLabel.font = [UIFont systemFontOfSize:MFRiskTypeNoFDAFontSize];
        
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_isSwitchButtonStatus) {
        HealthEducationContent *model = _heDetailsArray[indexPath.row];

        if (!model.isVideo) {
            RSDataVC *vc = [[RSDataVC alloc]initWithCallBack:^(BOOL isSuccess) {
            }];
            vc.objectId = (int)model.objectId;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else {
            RSVideoVC *next= [[RSVideoVC alloc]initWithCallBack:^(BOOL isSuccess) {
            }];
            
            next.objectId = (int)model.objectId;
            [self.navigationController pushViewController:next animated:YES];
        }
        
        
    }else {
        if(_oldSelectIndexPath != nil ) {
            //取消以前选中的
            AllHealthModel *oldModel = _riskTypesArray[_oldSelectIndexPath.section];
            Children * children = oldModel.children[_oldSelectIndexPath.row];
            children.isSelect = NO;
            [self.tableView reloadRowsAtIndexPaths:@[_oldSelectIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic] ;
        }
        
        //选中当前的
        AllHealthModel *oldModel = _riskTypesArray[indexPath.section];
        Children * children = oldModel.children[indexPath.row];
        children.isSelect = YES;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        _oldSelectIndexPath = indexPath;  //记录当前选中的cell
        
        if (!children.nextPage) {
            RSHEListVC *next = [[RSHEListVC alloc] init];
            next.model = children;
            [self.navigationController pushViewController:next animated:YES];
        }else {
            RSHERightVC * next = [[RSHERightVC alloc]init];
            next.typeModel = children;
            next.lastNC = self.navigationController;
            [self.navigationController pushViewController:next animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_isSwitchButtonStatus) {
        return 0.00001;
    }else {
        return 44;
    }
}


#pragma mark 网络回调
- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result {
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    if (action == RSRisk_NS_ENUM_findAllHealth) {
        if (result.status == 200) {
            _riskTypesArray = [NSMutableArray array];
            _riskTypesArray  = self.viewModel.healthArrayModel.mutableCopy;
            
            if (_riskTypesArray.count > 0) {
                AllHealthModel *oldModel = _riskTypesArray[0];
                Children * children = oldModel.children[0];
                children.isSelect = YES;
                
                _oldSelectIndexPath = IndexZero;
                [_tableView reloadData];
            }else {
                [UIUtil alert:@"暂无数据，请检查网络后再试"];
            }
            
        }
    }
    
    if (action == RSRisk_NS_ENUM_getAllHealthFiles) {
        if (result.status == 200) {
            _healthEducationDetailsModel = self.viewModel.healthEducationDetailsModel;
            if (_healthEducationDetailsModel.first) {
                [_heDetailsArray removeAllObjects];
            }
            [_heDetailsArray addObjectsFromArray:_healthEducationDetailsModel.content];
            [self.tableView reloadData];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
