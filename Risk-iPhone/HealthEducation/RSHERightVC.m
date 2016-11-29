//
//  RSHERightVC.m
//  Risk
//
//  Created by ylgwhyh on 16/7/13.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSHERightVC.h"
#import "RSHEListVC.h"


@interface RSHERightVC ( )<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray *riskArray;
@property (nonatomic, strong) NSMutableArray *sourceDataArray;


@property (nonatomic, strong) UIColor *oldNavigationBGColor;
@property (nonatomic, strong) UIColor *oldNavigationTitleColor;
@property (nonatomic, strong)  UILabel *navigationTitleLabel;


@end

@implementation RSHERightVC {
    
}

- (NSMutableArray *)sourceDataArray {
    if (_sourceDataArray == nil) {
        _sourceDataArray = [NSMutableArray array];
    }
    return _sourceDataArray;
}


- (void)viewWillDisappear:(BOOL)animated {
    //还原此页Navigation的设置
    //[self.navigationController.navigationBar setBarTintColor:_oldNavigationBGColor];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
//    _oldNavigationBGColor = self.navigationController.navigationBar.tintColor; //记录Navigation原来的颜色
//    _oldNavigationTitleColor = self.navigationController.navigationBar.titleTextAttributes[NSForegroundColorAttributeName]; //记录Navigation原来的文字颜色
//    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
//    
//    NSDictionary *textAttributes=[NSDictionary dictionaryWithObjectsAndKeys:RGBColor(110, 133, 152),NSForegroundColorAttributeName,nil];
//    [self.navigationController.navigationBar setTitleTextAttributes:textAttributes];
//    
//    //更改返回按钮文字和颜色
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationItem.backBarButtonItem = item;
//    self.navigationController.navigationBar.tintColor = RGBColor(110, 133, 152);
//    
//    if(_isHideNavigationTitleLabelBOOL) {
//        _navigationTitleLabel.hidden = YES;
//    }else {
//        if(_navigationTitleLabel == nil ) {
//            _navigationTitleLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
//            _navigationTitleLabel.textAlignment = NSTextAlignmentLeft;
//            _navigationTitleLabel.textColor = RGBColor(110, 133, 152);
//            _navigationTitleLabel.font = Font(middleFontSize);
//            _navigationTitleLabel.text = @"";
//            UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_navigationTitleLabel];
//            self.navigationItem.leftBarButtonItem = barBtnItem;
//        }
//        _navigationTitleLabel.hidden = NO;
//        
//    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _riskArray = [[NSMutableArray alloc] init];
    

    [self initUI];
}

- (void )initUI {
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
}


- (void) setTypeModel:(Children *)typeModel {
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    _typeModel = typeModel;
    //在此控制器第一次在左边显示title
    
    
   self.title = typeModel.name;
    
    _sourceDataArray = [NSMutableArray array];
    
    [_sourceDataArray addObjectsFromArray:_typeModel.children];
    [self.tableView reloadData];
    
}


- (void)setSplitViewController:(UISplitViewController *)splitViewController {
    _splitViewController = splitViewController;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _sourceDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Children * model = _sourceDataArray[indexPath.row];
    
    static NSString *ID = @"RiskTypesRightVC_Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = model.name;
    //如果下页还有数据
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Children * model = _sourceDataArray[indexPath.row];
    
    if (!model.nextPage) {
        RSHEListVC *next = [[RSHEListVC alloc] init];
        next.model = model;
        [self.lastNC pushViewController:next animated:YES];
    }else {
        RSHERightVC * next = [[RSHERightVC alloc]init];
        next.typeModel = model;
        next.isHideNavigationTitleLabelBOOL = YES;
        next.lastNC = _lastNC;
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:model.name style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:next animated:YES];
    }
}

@end
