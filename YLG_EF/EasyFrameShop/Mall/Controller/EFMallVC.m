//
//  EFMallVC.m
//  EF_MallDemo
//
//  Created by MH on 16/6/13.
//  Copyright © 2016年 MH. All rights reserved.
//
#import "EFMallVC.h"
#import "EFMyOrderVC.h"
#import "EFMallCell.h"
#import "EFCarousel.h"
#import "EFCarouselObject.h"
#import "EFSelectView.h"
#import "EFMallDetailsVC.h"
#import "EFSearchTwoVC.h"
#import "EFShopCartVC.h"
#import "EFMallViewModel.h"
#import "EFConsigneeAddressVC.h"
#import "EFMallModel.h"
#import "EFAfterSaleVC.h"
#import "EFSelectCityVC.h"
#import "EFShopCartViewModel.h"
static NSString *const SDEFMallCell = @"EFMallCell";

static NSString *const kCategoryCacheKey = @"kCategoryCacheKey";
static NSString *const kRegionCacheKey = @"kRegionCacheKey";
static NSString *const kSortCacheKey = @"kSortCacheKey";

@interface EFMallVC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic)KYTableView * table;
@property (nonatomic,strong)KYMHButton * orderBT;
@property (nonatomic,strong)KYMHButton * shoppingCartBT;
@property (nonatomic,assign)BOOL isLocation;
@property (nonatomic,assign)BOOL isAD;
@property (nonatomic,strong)NSArray * listArray;
@property (assign, nonatomic) int pageCount;
@property (strong, nonatomic) NSMutableArray *cartArray;
@property (nonatomic,strong)EFSelectView  * m_view;
@property (nonatomic,strong)NSString* m_objectId;
@property (nonatomic,strong)UIView * m_coverView;
@property (assign, nonatomic) float selectH;
@property (nonatomic, strong) EFMallViewModel *viewModel;
@property (nonatomic,strong) EFShopCartViewModel *viewModel1;
@property (nonatomic, strong) NSMutableDictionary *requestParams;
@property (nonatomic, strong) NSMutableArray *goodList;
@property (nonatomic, assign) NSInteger page;
@end

@implementation EFMallVC
#pragma mark --- lazy load
- (EFMallViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[EFMallViewModel alloc] initWithViewController:self];
        _page = 0;
    }
    return _viewModel;
}

- (EFShopCartViewModel *)viewModel1{
    if (_viewModel1 == nil) {
        _viewModel1 = [[EFShopCartViewModel alloc] initWithViewController:self];
        _page = 0;
    }
    return _viewModel1;
}

- (NSMutableDictionary *)requestParams{
    if (_requestParams == nil) {
        _requestParams = [NSMutableDictionary dictionary];
        [_requestParams setObject:@(30) forKey:@"size"];
        [_requestParams setObject:@(self.page) forKey:@"page"];
    }
    return _requestParams;
}

- (NSMutableArray *)goodList{
    if (_goodList == nil) {
        _goodList = [NSMutableArray array];
    }
    return _goodList;
}
#pragma mark --- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    NSString * str = nil;
    NSLog(@"%@",str);
    [self setupNavi];
    [self setupView];
    [self registerNotification];
    //请求数据
    [self.viewModel getProductsList:self.requestParams];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.viewModel1 EFGetShopCartItems:0 Size:90];
}

- (void)registerNotification{
    [EFNotification addObserver:self selector:@selector(locationSuccess) name:EFLocationSuccessNotification object:nil];
}

- (void)setupNavi{
    self.navigationController.navigationBar.barTintColor = EF_MainColor;
    //设置title颜色
    UIColor * color = EF_TextColor_TextColorNavigation;
    self.navigationController.navigationBar.tintColor = color;
    if (CurrentSystemVersion > 8.2) {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17 weight:UIFontWeightMedium],NSForegroundColorAttributeName:color}];
    }else{
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:color}];
    }
    self.title = @"商城";
    self.view.backgroundColor = EF_BGColor_Primary;
}

- (void)setupView{
    _cartArray = [NSMutableArray array];
    NSString *plistPath = nil;
    plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame_" ofType:@"plist"];
    //如果没有创建EasyFrame_.plist文件，那么直接加载框架内部自带的
    if (plistPath == nil) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame" ofType:@"plist"];
    }
    _isLocation = [[[NSDictionary alloc] initWithContentsOfFile:plistPath][@"Mall"][@"isLocation"] boolValue];
    _isAD = [[[NSDictionary alloc] initWithContentsOfFile:plistPath][@"Mall"][@"isAD"] boolValue];
    _listArray = [[NSDictionary alloc] initWithContentsOfFile:plistPath][@"Mall"][@"ListArray"];
    if (_isLocation) {
        UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [locationBtn setImage:[UIImage imageNamed:@"ic_info_loc"] forState:UIControlStateNormal];
        locationBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        locationBtn.size = CGSizeMake(22, 22);
        //先读取上一次定位的地址
        NSDictionary *LastLocationDict =  [EFUserDefault objectForKey:EFLastLocationDictKey];
        NSDictionary *currentLocationDict = [EFUserDefault objectForKey:EFCurrentLocationDictKey];
        if (LastLocationDict != nil) {
            NSString *address = LastLocationDict[EFDictLocationAddressKey];
            NSNumber *regionID = LastLocationDict[EFDictRegionIDKey];
            [locationBtn setTitle:address forState:UIControlStateNormal];
            [locationBtn sizeToFit];
//            [self.requestParams setObject:regionID forKey:@"regionId"];
        }else{
            if (currentLocationDict != nil) {
                NSString *address = currentLocationDict[EFDictLocationAddressKey];
                NSNumber *regionID = currentLocationDict[EFDictRegionIDKey];
                if (address!= nil) {
                    [locationBtn setTitle:address forState:UIControlStateNormal];
                    [locationBtn sizeToFit];
                }
                NSDictionary *dict = @{EFDictLocationAddressKey : address,
                                       EFDictRegionIDKey : regionID};
                [EFUserDefault setObject:dict forKey:EFLastLocationDictKey];
                [EFUserDefault synchronize];
//                [self.requestParams setObject:regionID forKey:@"regionId"];
            }
        }
        [locationBtn addTarget:self action:@selector(locationBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:locationBtn];
        self.locationBtn = locationBtn;
    }
    
    WS(weakSelf)
    self.navigationItem.rightBarButtonItem = [UIUtil barButtonItem:self WithTitle:@"" withImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/rate_star_nav_searchbig"]] withBlock:^{
        EFSearchTwoVC *next = [[EFSearchTwoVC alloc] init];
        [weakSelf.navigationController pushViewController:next animated:YES];
    } isLeft:NO];
    
    _table = [[KYTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-50) andUpBlock:^{
        weakSelf.page = 0;
        [_requestParams setObject:@(self.page) forKey:@"page"];
        [weakSelf.viewModel getProductsList:weakSelf.requestParams];
    } andDownBlock:^{
        weakSelf.page += 1;
        [_requestParams setObject:@(self.page) forKey:@"page"];
        [weakSelf.viewModel getProductsList:weakSelf.requestParams];
    }];
    [self.view addSubview:_table];
    _table.dataSource = self;
    _table.delegate = self;
    _table.backgroundColor = EF_BGColor_Primary;
    _table.separatorStyle = UITableViewCellAccessoryNone;
    [_table registerClass:[EFMallCell class] forCellReuseIdentifier:SDEFMallCell];
    [_table reloadData];
    
    _shoppingCartBT = [KYMHButton new];
    _shoppingCartBT.titleLabel.font = [UIFont systemFontOfSize:13];
    [_shoppingCartBT setTitleColor:[UIColor whiteColor] forState:0];
    [_shoppingCartBT setTitle:@"购物车" forState:UIControlStateNormal];
    [_shoppingCartBT setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/btn_shoppingcart"]] forState:UIControlStateNormal];
    [_shoppingCartBT addTarget:self action:@selector(shoppingCartButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shoppingCartBT];
    
}

#pragma mark --- event response
- (void)locationBtnClick{
    WS(weakSelf)
    EFSelectCityVC *selectCity = [[EFSelectCityVC alloc] initWithSelectHandler:^(NSString *cityName, NSNumber *regionID) {
        [weakSelf.locationBtn setTitle:cityName forState:UIControlStateNormal];
        [weakSelf.locationBtn sizeToFit];
        [weakSelf.requestParams setObject:regionID forKey:@"regionId"];
        [weakSelf.viewModel getProductsList:weakSelf.requestParams];
        NSDictionary *dict = @{EFDictLocationAddressKey : cityName,
                               EFDictRegionIDKey:regionID};
        [EFUserDefault setObject:dict forKey:EFLastLocationDictKey];
        [EFUserDefault synchronize];
        [EFUserDefault setObject:nil forKey:kRegionCacheKey];
        [EFUserDefault synchronize];
        [weakSelf.table reloadData];
    }];
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:selectCity];
    
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)shoppingCartButtonClicked{
    
    EFShopCartVC *next = [[EFShopCartVC alloc] init];
    [self.navigationController pushViewController:next animated:YES];
    
}

#pragma mark --- notification
- (void)locationSuccess{
    NSDictionary *currentLocationDict = [EFUserDefault objectForKey:EFCurrentLocationDictKey];
    NSString *currentLocationAddress = currentLocationDict[EFDictLocationAddressKey];
    NSDictionary *lastLocationDict = [EFUserDefault objectForKey:EFLastLocationDictKey];
    if (!lastLocationDict) {
        NSString *lastLocationAddress = lastLocationDict[EFDictLocationAddressKey];
        if (![lastLocationAddress isEqualToString:currentLocationAddress]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"当前定位到%@",currentLocationAddress] message:@"是否切换为该城市?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即切换", nil];
            [alert show];
        }
    }else{
        [self.locationBtn setTitle:currentLocationAddress forState:UIControlStateNormal];
        [EFUserDefault setObject:nil forKey:kRegionCacheKey];
        [EFUserDefault synchronize];
        [self.locationBtn sizeToFit];
//        [self.requestParams setObject:currentLocationRegionID forKey:@"regionId"];
//        [self.viewModel getProductsList:self.requestParams];
    }
}

#pragma mark ---UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSDictionary *currentLocationDict = [EFUserDefault objectForKey:EFCurrentLocationDictKey];
        NSString *currentLocationAddress = currentLocationDict[EFDictLocationAddressKey];
        NSNumber *currentLocationRegionID = currentLocationDict[EFDictRegionIDKey];
        [self.locationBtn setTitle:currentLocationAddress forState:UIControlStateNormal];
        [self.locationBtn sizeToFit];
        [self.requestParams setObject:currentLocationRegionID forKey:@"regionId"];
        [EFUserDefault setObject:nil forKey:kRegionCacheKey];
        [EFUserDefault synchronize];
        [self.viewModel getGoodsList:self.requestParams];
    }
}

#pragma mark TableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isAD&&indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MineListCell"];
        EFCarouselObject *object1 = [[EFCarouselObject alloc] init];
        object1.imageURL = @"http://img10.3lian.com/c1/newpic/10/24/29.jpg";
        
        EFCarouselObject *object2 = [[EFCarouselObject alloc] init];
        object2.imageURL = @"http://d.hiphotos.baidu.com/zhidao/pic/item/eac4b74543a9822604312cf28882b9014b90eb77.jpg";
        
        EFCarouselObject *object3 = [[EFCarouselObject alloc] init];
        object3.imageURL = @"http://ww1.sinaimg.cn/large/7bb6feadgw1dv30xnokz5j.jpg";

        
        EFCarousel *carousel = [[EFCarousel alloc] init];
        carousel.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2];
        carousel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 160);
        carousel.iGCarouselSelectedBlock = ^(NSInteger index , EFCarouselObject *carouselObject){
            NSString * url = @"";
            if (carouselObject.pushURL) {
                url = carouselObject.pushURL;
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        };
        
        NSArray * arr = @[object1,object2,object3];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            carousel.carouselList = arr;
            [carousel reloadCarousel];
        });
        [cell addSubview:carousel];
        
        return cell;
    }
    EFMallGoodListModel *listModel = self.goodList[indexPath.row];
    EFMallCell *cell = [tableView dequeueReusableCellWithIdentifier:SDEFMallCell];
    cell.listModel = listModel;
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isAD) {
        if (section==0) {
            return 1;
        }
    }
    return self.goodList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isAD) {
        return 2;
    }
    return 1;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    headView.backgroundColor = EF_MainColor;
    for (int i = 0; i < _listArray.count; i++) {
        KYMHButton * button = [KYMHButton new];
        [button setTitle:_listArray[i] forState:0];
        if (i == 0 ) {
            NSDictionary *dict = [EFUserDefault objectForKey:kCategoryCacheKey];
            if(dict != nil){
                [button setTitle:dict[@"name"] forState:UIControlStateNormal];
                [self.requestParams setObject:dict[@"objectId"] forKey:@"categoryId"];
            }

        }else if (i == 1){
            NSDictionary *dict = [EFUserDefault objectForKey:kRegionCacheKey];
            if(dict != nil){
                [button setTitle:dict[EFDictLocationAddressKey] forState:UIControlStateNormal];
                [self.requestParams setObject:dict[EFDictRegionIDKey] forKey:@"regionId"];
            }
        }else if (i == 2){
            NSDictionary *dict = [EFUserDefault objectForKey:kSortCacheKey];
            if(dict != nil){
                [button setTitle:dict[@"name"] forState:UIControlStateNormal];
                [self.requestParams setObject:dict[@"objectId"] forKey:@"sort"];
            }
        }
        UIColor * color = EF_TextColor_TextColorNavigation;
        [button setTitleColor:color forState:0];
        [button setImage:Img(@"") forState:0];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [headView addSubview:button];
        [button addTarget:self action:@selector(showList:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100 + i;
        CGFloat w = SCREEN_WIDTH/_listArray.count;
        button.sd_layout
        .leftSpaceToView(0,i*w)
        .topEqualToView(headView)
        .heightIs(40)
        .widthIs(w);
    }
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_isAD &&section == 0) {
        return 0;
    }
    return 40;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isAD&&indexPath.section == 0) {
        return 160;
    }
    return 122;
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isAD&&indexPath.section == 1) {
        EFMallGoodListModel *listModel = self.goodList[indexPath.row];
        EFMallDetailsVC * vc = [[EFMallDetailsVC alloc] initWithProductId:[NSString stringWithFormat:@"%zd",listModel.objectId]];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (!_isAD){
        EFMallDetailsVC * vc = [[EFMallDetailsVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark 下拉列表
- (void)showList:(UIButton*)sender{
    [_m_coverView removeFromSuperview];
    _m_coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_m_coverView];
    _m_coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _m_coverView.hidden = YES;
    
    
    UIButton * bt = [self.view viewWithTag:sender.tag];
    
    UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(touch) forControlEvents:UIControlEventTouchUpInside];
    [_m_coverView addSubview:button];
    button.frame = _m_coverView.bounds;
    
    CGRect rect = [self.view convertRect:bt.frame fromView:bt.superview];
    
    _m_view = [[EFSelectView alloc]initWithFrame:CGRectMake(0, rect.origin.y + rect.size.height, self.view.width, 160) ObjectId:(int)sender.tag-100 Array:nil andCity:self.locationBtn.currentTitle andSelectBlock:^(CategoryModel *category) {
        _m_view.hidden = YES;
        _m_coverView.hidden = YES;
        _m_objectId = category.name;
        [bt setTitle:_m_objectId forState:UIControlStateNormal];
        self.page = 0;
        [self.requestParams setObject:@(self.page) forKey:@"page"];
        if (sender.tag == 100) {
            [self.requestParams setObject:@"" forKey:@"categoryId"];
            [self.viewModel getProductsList:self.requestParams];
            NSDictionary *dict = @{@"name":category.name,
                                   @"objectId":category.objectId};
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:kCategoryCacheKey];
        }else if (sender.tag == 101){
            
        }else if (sender.tag == 102){
            [self.requestParams setObject:category.objectId forKey:@"sort"];
            [self.viewModel getProductsList:self.requestParams];
            NSDictionary *dict = @{@"name":category.name,
                                   @"objectId":category.objectId};
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:kSortCacheKey];
        }
    }];
    [self.view addSubview:_m_view];
    _m_view.hidden = YES;
    
    _m_view.hidden = !_m_view.hidden;
    _m_coverView.hidden = !_m_coverView.hidden;
}

- (void)touch{
    _m_view.hidden = !_m_view.hidden;
    _m_coverView.hidden = !_m_coverView.hidden;
}


/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        CGFloat tabOffsetY = 160;
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY<=tabOffsetY) {
            _selectH = offsetY;
        }else{
            _selectH = 160;
        }
    }
    
}

#pragma mark --- 网络请求回调
- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
            [self.table endLoading];
    if (action & EFMailShopCart_Items) {
        if ([result.jsonDict[@"status"] intValue] == 200) {
            [_shoppingCartBT sd_resetLayout];
            [_shoppingCartBT showBadgeWithStyle:WBadgeStyleNumber value:_viewModel1.cartModelContentArray.count animationType:WBadgeAnimTypeNone];
            _shoppingCartBT.badgeCenterOffset = CGPointMake(38, 5);//微调小红点的位置
            _shoppingCartBT.sd_layout.rightSpaceToView(self.view,10).bottomSpaceToView(self.view,10).widthIs(44).heightIs(44);
        }
    }
    
    if (action == EFMallViewModelCallBackActionProductsList) {
        if (result.status == NetworkModelStatusTypeSuccess) {
            NSArray *goodList = [NSArray yy_modelArrayWithClass:[EFProductListModel class] json:result.content[@"content"]];
            if (self.page == 0) {
                [self.goodList removeAllObjects];
                [self.goodList addObjectsFromArray:goodList];
                [self.table reloadData];
            }else{
                if (goodList.count > 0) {
                    [self.goodList addObjectsFromArray:goodList];
                    [self.table reloadData];
                }else{
                    [UIUtil alert:@"没有更多商品啦!"];
                }
            }
        }else{
            [UIUtil alert:@"数据加载失败"];
            if (self.page != 0) {
                self.page -= 1;
            }
        }
    }
}


@end
