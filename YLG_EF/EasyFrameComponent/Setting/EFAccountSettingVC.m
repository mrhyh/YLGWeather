//
//  EFAccountSettingVC.m
//  demo
//
//  Created by MH on 16/5/24.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "EFAccountSettingVC.h"
#import "EFEditMineProfileVC.h"
#import "EFSettingCell.h"

static NSString *cellId = @"accountSettingCell";

@interface EFAccountSettingVC()
/**列表内容,只读，初始化从plist文件中加载*/
@property (nonatomic, strong ,readwrite) NSArray *settingArray;
@end
@implementation EFAccountSettingVC
- (instancetype)init {
    
    if (self = [super init]) {
        
        NSString *plistPath = nil;
        plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame_" ofType:@"plist"];
        //如果没有创建EasyFrame_.plist文件，那么直接加载框架内部自带的
        if (plistPath == nil) {
            plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame" ofType:@"plist"];
        }
        NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        
        self.settingArray = [dictionary objectForKey:@"AccountSetting"];
    }
    return self;
}

#pragma mark --- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavi];
    [self setupTableView];
}

- (void)setupNavi{
    self.title = @"账号设置";
}

- (void)setupTableView{
    self.tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableview];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.sectionFooterHeight = 0;
    self.tableview.scrollEnabled =YES;
    self.tableview.backgroundColor = EF_BGColor_Primary;
    self.tableview.separatorStyle = UITableViewCellAccessoryNone;
    self.tableview.contentInset = UIEdgeInsetsMake(-25, 0, 44, 0);
    [self.tableview registerClass:[EFSettingCell class] forCellReuseIdentifier:cellId];
}


#pragma mark ---<UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.settingArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EFSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    NSDictionary *settingDict = self.settingArray[indexPath.row];
    cell.settingDict = settingDict;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *settingDict = self.settingArray[indexPath.row];
    NSString *title = settingDict[@"title"];
    if ([title isEqualToString:@"编辑资料"]) {
        EFEditMineProfileVC *vc = [[EFEditMineProfileVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
