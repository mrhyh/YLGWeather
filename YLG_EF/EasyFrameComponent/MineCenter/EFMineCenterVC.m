//
//  EFMineCenterVC.m
//  EasyFrame
//
//  Created by Cherie Jeong on 16/4/21.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFMineCenterVC.h"
#import "EFMineCenterCell.h"
#import "EFSettingViewController.h"
#import "UIScrollView+PullBig.h"

static NSString *CellIdentifier = @"MineCenterCell";

@interface EFMineCenterVC ()
/**列表内容,只读，初始化从plist文件中加载*/
@property (nonatomic, strong ,readwrite) NSArray * mineCenterArray;
@property (nonatomic, assign) BOOL isHidden;
@end

@implementation EFMineCenterVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isHidden) {
        self.navigationController.navigationBarHidden = YES;
    }else{
        self.navigationController.navigationBarHidden = NO;
    }
    
    
}

- (instancetype)init {
    if (self = [super init]) {
        NSString *plistPath = nil;
        plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame_" ofType:@"plist"];
        //如果没有创建EasyFrame_.plist文件，那么直接加载框架内部自带的
        if (plistPath == nil) {
            plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame" ofType:@"plist"];
        }
        NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        self.mineCenterArray = [dictionary objectForKey:@"MineCenter"];
        [self setupTableView];
        [self setupNavi];
        self.isHidden = [[[NSDictionary alloc] initWithContentsOfFile:plistPath][@"MainLayout"][@"isMineCenterNaviHidden"] boolValue];
        if (self.isHidden) {
            [self hiddenNavigationControllerView];
        }else{
            [self noHiddenNavigationControllerView];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //监听换肤操作
    [self setupObserver];
    
    [self skinChange];
}

- (void)hiddenNavigationControllerView{
    self.headImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200*SCREEN_H_RATE);
    self.headImageView.image = Img(@"resource.bundle/test1.jpg");
    self.automaticallyAdjustsScrollViewInsets  = NO;
    self.AvatarView.frame = CGRectMake(20, 120*SCREEN_H_RATE, 50*SCREEN_W_RATE, 50*SCREEN_H_RATE);
    [self.AvatarView RectSize:25*SCREEN_W_RATE SideWidth:2 SideColor:[UIColor whiteColor]];
    self.nicknameLB.frame = CGRectMake(CGRectGetMaxX(self.AvatarView.frame)+20, CGRectGetMidY(self.AvatarView.frame)-10, 160*SCREEN_W_RATE, 20);
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
    settingBtn.frame = CGRectMake(SCREEN_WIDTH-70, 20, 60, 30);
    [settingBtn setImage:Img(@"resource.bundle/nav_settings") forState:0];
    [settingBtn addTarget:self action:@selector(settingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.headImageView addSubview:settingBtn];
    self.tableview.tableHeaderView = self.headImageView;
}

- (void)noHiddenNavigationControllerView{
    self.headImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 120*SCREEN_H_RATE);
    self.headImageView.backgroundColor = [UIColor whiteColor];
    self.tableview.tableHeaderView = self.headImageView;
    
}

- (void)setupTableView{
    [self.headImageView removeFromSuperview];
    self.headImageView = [[KYMHImageView alloc] init];
    self.headImageView.userInteractionEnabled = YES;
        self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0 ,SCREEN_WIDTH , SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableview];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.scrollEnabled =YES;
    self.tableview.sectionFooterHeight = 0;
    self.tableview.sectionHeaderHeight = 0;
    self.tableview.separatorStyle = UITableViewCellAccessoryCheckmark;

    [self.tableview registerClass:[EFMineCenterCell class] forCellReuseIdentifier:CellIdentifier];
   self.tableview.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    
    self.AvatarView = [[KYMHImageView alloc] initWithImage:Img(@"") BaseSize:CGRectMake(20, 25*SCREEN_H_RATE, 70*SCREEN_W_RATE, 70*SCREEN_H_RATE) ImageViewColor:[UIColor grayColor]];
    [self.AvatarView RectSize:35*SCREEN_W_RATE SideWidth:1 SideColor:[UIColor whiteColor]];
    [self.headImageView addSubview:self.AvatarView];
    NSString * url = @"";
    if ([UserModel ShareUserModel].head.url) {
        url = [UserModel ShareUserModel].head.url;
    }
    [self.AvatarView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:Img(@"resource.bundle/defaultavtar.png") options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            self.AvatarView.image = image;
        }else{
            self.AvatarView.image = Img(@"resource.bundle/defaultavtar.png");
        }
        
    }];

    NSString * nickname = @"点击登录";
    if ([UserModel ShareUserModel].nickname) {
        nickname = [UserModel ShareUserModel].nickname;
    }
    self.nicknameLB = [[KYMHLabel alloc] initWithTitle:nickname BaseSize:CGRectMake(CGRectGetMaxX(self.AvatarView.frame)+20, CGRectGetMidY(self.AvatarView.frame)-10, 160*SCREEN_W_RATE, 20) LabelColor:[UIColor clearColor] LabelFont:17 LabelTitleColor:[UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
    [self.headImageView addSubview:self.nicknameLB];
}

- (void)setupNavi{
     _settingBtn = [KYMHButton buttonWithType:UIButtonTypeCustom];
    _settingBtn.bounds = CGRectMake(0, 0, 60, 30);
    [_settingBtn setImage:Img(@"resource.bundle/nav_settings") forState:0];
    [_settingBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
//    [settingBtn setTitle:@"设置" forState:UIControlStateNormal];
//    [settingBtn setTitleColor:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_TextColorNavigation] forState:UIControlStateNormal];
    [_settingBtn addTarget:self action:@selector(settingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_settingBtn];
    //self.navigationItem.rightBarButtonItem = settingBarBtnItem;
    self.settingBarBtnItem = settingBarBtnItem;
}

- (void)setSettingBtn:(KYMHButton *)settingBtn {
    _settingBtn = settingBtn;
    _settingBtn.hidden = YES;
    _settingBtn.contentHorizontalAlignment = settingBtn.contentHorizontalAlignment;
}

- (void)setupObserver{
    //监听是否启用一键换肤的操作
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(skinChange) name:EFSkinThemeViewChange object:nil];
}


- (void)skinChange{
    self.tableview.backgroundColor = EF_BGColor_Primary;
    [self setupNavi];
//    self.navigationController.navigationBar.barTintColor = EF_MainColor;
}
#pragma mark ----<UITableViewDataSource,UITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.mineCenterArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mineCenterArray[section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EFMineCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSArray *mineCenterArray = self.mineCenterArray[indexPath.section];
    cell.mineCenterDict = mineCenterArray[indexPath.row];
    return cell;
}
#pragma mark --- event response
- (void)settingBtnClick{
    EFSettingViewController *vc = [[EFSettingViewController alloc] initWithCompleteBlock:^(BOOL isSussces) {
        if (isSussces) {
            NSString * url = @"";
            if ([UserModel ShareUserModel].head.url) {
                url = [UserModel ShareUserModel].head.url;
            }
            [self.AvatarView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:Img(@"resource.bundle/defaultavtar.png") options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    self.AvatarView.image = image;
                }else{
                    self.AvatarView.image = Img(@"resource.bundle/defaultavtar.png");
                }
                
            }];
            
            NSString * nickname = @"点击登录";
            if ([UserModel ShareUserModel].nickname) {
                nickname = [UserModel ShareUserModel].nickname;
            }
            self.nicknameLB.text = nickname;
        }
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
