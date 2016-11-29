//
//  EFShopCartVC.m
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/15.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFShopCartVC.h"
#import "EFShopCartCell.h"
#import "EFGoodModel.h"
#import "EFShopCartHeadView.h"
#import "EFCartModel.h"
#import "EFShopCartViewModel.h"
#import "EFOrderConfirmVC.h"
#import "EFOrderConfirmTwoVC.h"


@interface EFShopCartVC () <UITableViewDataSource, UITableViewDelegate> {

    BOOL _isHasNavitationController;//是否含有导航
}

@property (nonatomic, strong) UIView *noDatabackgroundView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) KYTableView *tableView;
@property (nonatomic, strong) UIColor *mainBGColor;

@property (nonatomic, strong) KYMHButton *rightButton;


@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *selectedArray;
@property (strong, nonatomic) KYMHButton *allSellectedButton;
@property (strong, nonatomic) UILabel *totlePriceLabel;

@property (strong, nonatomic) UIView *bottomRightView; //底部右边View
@property (strong, nonatomic) UIView *backgroundView;  //底部View
@property (strong, nonatomic) KYMHButton *deleteButton;

@property (nonatomic,strong) EFShopCartViewModel *viewModel;

/** 是否有多个section分组---从配置文件读取*/
@property (nonatomic, assign) BOOL isMultipleSectionBool;

@end

@implementation EFShopCartVC {
    
    CGFloat segmentH;
    CGFloat spaceToLeft;
    CGFloat sectionViewH;
    CGFloat sectionImageH;
    CGFloat sectionFontSize;
    CGFloat tabBarH;
    
}

static NSString * const EFShopCartVC_EFShopCartCell = @"EFShopCartVC_EFShopCartCell";
#define  TAG_CartEmptyView 100

- (void)viewWillAppear:(BOOL)animated {
    
    //初始化显示状态
    _allSellectedButton.selected = NO;
    _totlePriceLabel.text = @"￥0.00";
    
    [self.viewModel EFGetShopCartItems:0 Size:90];
     [self countPrice];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDataSource];
    [self initNavigateView];
    
    if (self.dataArray.count > 0) {
        [self setupCartView];
    } else {
        [self setupCartEmptyView];
    }
    
    
    // Do any additional setup after loading the view.
}

//购物车为空时显示效果
- (void)setupCartEmptyView {
    //默认视图背景
    
    if(_noDatabackgroundView == nil) {
        _noDatabackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, tabBarH, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _noDatabackgroundView.tag = TAG_CartEmptyView;
        [self.view addSubview:_noDatabackgroundView];
        
        //默认图片
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/cart_default_bg"]]];
        img.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0 - 120);
        img.bounds = CGRectMake(0, 0, 247.0/187 * 100, 100);
        [_noDatabackgroundView addSubview:img];
        
        UILabel *warnLabel = [[UILabel alloc]init];
        warnLabel.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0 - 10);
        warnLabel.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 30);
        warnLabel.textAlignment = NSTextAlignmentCenter;
        warnLabel.text = @"购物车为空!";
        warnLabel.font = [UIFont systemFontOfSize:15];
        warnLabel.textColor = EF_TextColor_TextColorSecondary;
        [_noDatabackgroundView addSubview:warnLabel];
    }
}


- (void)initNavigateView{

    _rightButton= [[KYMHButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [_rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    [_rightButton setTitle:@"完成" forState:UIControlStateSelected];
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace  target:nil action:nil];
    
    negativeSpacer.width = -10;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, barBtnItem, nil];
}


#pragma mark -- 购物车为空时的默认视图
- (void)changeView {
    
    if (self.dataArray.count > 0) {
        UIView *view = [self.view viewWithTag:TAG_CartEmptyView];
        if (view != nil) {
            [view removeFromSuperview];
        }
        
        [self setupCartView];
        
    } else {
        
        if(_backgroundView) {
             [_backgroundView removeFromSuperview];
            _backgroundView = nil;
        }
        if(_tableView) {
            [self.tableView removeFromSuperview];
            self.tableView = nil;
        }
        
        [self setupCartEmptyView];
    }
}

- (void)rightButtonAction {
    _rightButton.selected = !_rightButton.selected;
    _bottomRightView.hidden = !_bottomRightView.hidden;
    _deleteButton.hidden = !_deleteButton.hidden;
}

#pragma mark --- 底部视图
- (void)setupCustomBottomView {
    
    CGFloat backgroundViewH = 49;
    
    if(_backgroundView == nil) {
        _backgroundView = [[UIView alloc]init];
        _backgroundView.frame = CGRectMake(0, SCREEN_HEIGHT - tabBarH, SCREEN_WIDTH, tabBarH);
        _backgroundView.backgroundColor = [UIColor whiteColor];
        _backgroundView.tag = TAG_CartEmptyView + 1;
        [self.view addSubview:_backgroundView];
        
        
        UIView *lineView = [[UIView alloc]init];
        lineView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
        lineView.backgroundColor = [UIColor lightGrayColor];
        [_backgroundView addSubview:lineView];
        
        //全选按钮
        CGFloat selectAllButtonH = 39;
        UIColor *selectAllButtonSelectTitleColor = EF_TextColor_TextColorPrimary;
        _allSellectedButton = [KYMHButton new];
        _allSellectedButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_allSellectedButton setTitle:@" 全选" forState:UIControlStateNormal];
        [_allSellectedButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/ic_pass"]] forState:UIControlStateNormal];
        [_allSellectedButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/ic_select"]] forState:UIControlStateSelected];
        [_allSellectedButton setTitleColor:selectAllButtonSelectTitleColor forState:UIControlStateNormal];
        [_allSellectedButton addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundView addSubview:_allSellectedButton];
        
        
        _bottomRightView = [UIView new];
        _bottomRightView.hidden = NO; //默认显示
        [_backgroundView addSubview:_bottomRightView];
        
        //结算确认
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = RGBColor(207, 153, 54);
        btn.titleLabel.font = Font(17);
        [btn setTitle:@"确认" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(goToPayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomRightView addSubview:btn];
        
        KYMHLabel *staticLabel = [KYMHLabel new];
        staticLabel.textColor = EF_TextColor_TextColorSecondary;
        staticLabel.font = Font(12);
        staticLabel.textAlignment = NSTextAlignmentRight;
        staticLabel.text = @"合计 (不含运费)";
        [_bottomRightView addSubview:staticLabel];
        
        //合计
        _totlePriceLabel = [[UILabel alloc]init];
        _totlePriceLabel.font = Font(13);
        _totlePriceLabel.textAlignment = NSTextAlignmentRight;
        _totlePriceLabel.textColor = EF_TextColor_TextColorPrimary;
        _totlePriceLabel.text = @"¥0.00";
        [_bottomRightView addSubview:_totlePriceLabel];
        
        //删除
        _deleteButton = [KYMHButton new];
        _deleteButton.backgroundColor = [UIColor redColor];
        _deleteButton.titleLabel.font = Font(17);
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        _deleteButton.hidden = YES; //默认隐藏
        [_deleteButton addTarget:self action:@selector(deleteButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundView addSubview:_deleteButton];
        
        //布局
        _allSellectedButton.sd_layout
        .leftSpaceToView(_backgroundView, 0)
        .topSpaceToView (_backgroundView, (backgroundViewH-selectAllButtonH)/2)
        .widthIs(80)
        .heightIs(selectAllButtonH);
        
        _bottomRightView.sd_layout
        .topSpaceToView(_backgroundView, 0)
        .leftSpaceToView (_allSellectedButton, 20)
        .rightSpaceToView(_backgroundView, 0)
        .heightIs(tabBarH);
        
        btn.sd_layout
        .topSpaceToView (_bottomRightView, 0)
        .rightSpaceToView (_bottomRightView, 0)
        .widthIs(123)
        .heightIs(tabBarH);
        
        staticLabel.sd_layout
        .topSpaceToView (_bottomRightView, 8)
        .rightSpaceToView (btn, 22)
        .heightIs(12)
        .widthIs(140);
        
        _totlePriceLabel.sd_layout
        .topSpaceToView (staticLabel, 7)
        .rightSpaceToView (btn, 22)
        .widthIs (140)
        .heightIs(12);
        
        _deleteButton.sd_layout
        .topSpaceToView (_backgroundView, 0)
        .rightSpaceToView (_backgroundView, 0)
        .widthIs (123)
        .heightIs(tabBarH);
    }
}

#pragma mark --- 确认选择,提交订单按钮点击事件
- (void)goToPayButtonClick:(UIButton*)button {
    if (self.selectedArray.count > 0) {
        for (ShopCartContentModel *model in self.selectedArray) {
            NSLog(@"选择的商品>>%@>>>%@",model.productItem.shopItem.name,model.productItem.name);
        }
        EFOrderConfirmTwoVC *next = [[EFOrderConfirmTwoVC alloc] init];
        next.shopCartGoodArray = self.selectedArray;
        [self.navigationController pushViewController:next animated:YES];
        
    } else {
        NSLog(@"你还没有选择任何商品");
        [UIUtil alert:@"你还没有选择任何商品"];
    }
    
}

- (void) initDataSource {
    
    self.viewModel = [[EFShopCartViewModel alloc] initWithViewController:self];
    
    segmentH = 40;
    spaceToLeft = 10;
    sectionViewH = 30;
    sectionImageH = 17;
    sectionFontSize = 13;
    tabBarH = 49;
    
    self.title = @"购物车";
    _mainBGColor = EF_MainColor;
    
    _isMultipleSectionBool = [[[NSDictionary alloc] initWithContentsOfFile:self.plistPath][@"Mall"][@"isMultipleSection"] boolValue];

    [self changeView];
}

- (void)setupCartView {
    [self createUITableView];
}

- (KYTableView *)createUITableView{
    
    //创建底部视图
    [self setupCustomBottomView];

    WS(weakSelf)
    if (!_tableView) {
        _tableView = [[KYTableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) andUpBlock:^{
            [weakSelf.tableView endLoading];
        } andDownBlock:^{
            [weakSelf.tableView endLoading];
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = RGBColor(237, 243, 248);
        [_tableView registerClass:[EFShopCartCell class] forCellReuseIdentifier:EFShopCartVC_EFShopCartCell];
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}

#pragma mark --- Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WS(weakSelf)
    EFShopCartCell *cell = [tableView dequeueReusableCellWithIdentifier:EFShopCartVC_EFShopCartCell];
    ShopCartContentModel *model = self.dataArray[indexPath.section][indexPath.row];
    __block typeof(cell)wsCell = cell;
    
    [cell EFNumberAddWithBlock:^(NSInteger number) {
        
        //修改商品数量
        [self.viewModel UpdateItemQuantityWithProductId:model.productItem.objectId Quantity:number callBackBlock:^(CallBackStatus callBackStatus, NetworkModel *result) {
            
            if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeSuccess) {
                
                wsCell.efNumber = number;
                model.quantity = number;

                //替换数据源中修改了数量的商品模型
                [weakSelf.dataArray[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:model];
                if ([weakSelf.selectedArray containsObject:model]) {
                    [weakSelf.selectedArray removeObject:model];
                    [weakSelf.selectedArray addObject:model];
                    [weakSelf countPrice];
                }
            }else if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeInputError ) {
                [UIUtil alert:result.message];
            }
        }];
        
    }];
    
    //修改商品数量
    [cell EFNumberCutWithBlock:^(NSInteger number) {

        [self.viewModel UpdateItemQuantityWithProductId:model.productItem.objectId Quantity:number callBackBlock:^(CallBackStatus callBackStatus, NetworkModel *result) {
              
              if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeSuccess) {
                  
                  wsCell.efNumber = number;
                  model.quantity = number;
                  
                  //替换数据源中修改了数量的商品模型
                  [self.dataArray[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:model];
                  
                  //判断已选择数组里有无该对象,有就删除  重新添加
                  if ([self.selectedArray containsObject:model]) {
                      [self.selectedArray removeObject:model];
                      [self.selectedArray addObject:model];
                      [self countPrice];
                  }
              }else if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeInputError ) {
                  [UIUtil alert:result.message];
              }

          }];
    }];
    
    //选中商品
    [cell EFCellSelectedWithBlock:^(BOOL select) {
        
        model.select = select;
        
        //替换数据源中修改了数量的商品模型
        [self.dataArray[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:model];
        
        //判断这个店铺的商品是否已经全部被选中
        NSArray *array = self.dataArray[indexPath.section];
        BOOL isAllSelected = YES;
        for (int i=0; i < array.count; i++) {
            ShopCartContentModel *model = array[i];
            if(model.select == NO) {
                isAllSelected = NO;
                break;
            }
        }
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
        if (select) {
            [self.selectedArray addObject:model];
        } else {
            [self.selectedArray removeObject:model];
        }
        
        //计算商品总数
        NSInteger goodCountInteger = 0;
        for (int i=0; i<weakSelf.dataArray.count ; i++) {
            NSMutableArray *array = [NSMutableArray array];
            array =  weakSelf.dataArray[i];
            goodCountInteger += array.count;
        }
        
        if (self.selectedArray.count == goodCountInteger) {
            _allSellectedButton.selected = YES;
        } else {
            _allSellectedButton.selected = NO;
        }
        [self countPrice];
    }];
    
    [cell EFReloadDataWithModel:model];
    return cell;
}


-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf)
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        ShopCartContentModel *model = self.dataArray[indexPath.section][indexPath.row];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该商品?删除后无法恢复!" preferredStyle:1];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf.viewModel EFRemoveItemsWithProductIds:[NSString stringWithFormat:@"%ld",(long)model.productItem.objectId] callBackBlock:^(CallBackStatus callBackStatus, NetworkModel *result) {
                
                if ([result.jsonDict[@"status"] intValue] == 200)  {


                    NSArray *array = weakSelf.dataArray[indexPath.section];
                    if(array.count == 1) {
                        [weakSelf.dataArray removeObjectAtIndex:indexPath.section];
                        [weakSelf.tableView reloadData];
                    }else {
                        
                        //删除
                        [weakSelf.dataArray[indexPath.section] removeObjectAtIndex:indexPath.row];
                        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    }
                    
                    //判断删除的商品是否已选择
                    if ([weakSelf.selectedArray containsObject:model]) {
                        //从已选中删除,重新计算价格
                        [weakSelf.selectedArray removeObject:model];
                        [weakSelf countPrice];
                    }
                    
                    if (weakSelf.selectedArray.count == weakSelf.dataArray.count) {
                        _allSellectedButton.selected = YES;
                    } else {
                        _allSellectedButton.selected = NO;
                    }
                    
                    if (weakSelf.dataArray.count == 0) {
                        [weakSelf changeView];
                        [_tableView reloadData];
                    }
                    
                    
                }
            }];
            
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:okAction];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array;
    if(_dataArray.count > 0) {
          array = _dataArray[section];
    }
    return array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if( _isMultipleSectionBool == NO) {
        return 1;
    } else {
        return self.dataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 96;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(_isMultipleSectionBool == NO ) {
        return nil;
    } else {
        WS(weakSelf)
        
        NSMutableArray *tempArray = [NSMutableArray array];
        tempArray = self.dataArray[section];
        
        if(tempArray.count > 0) {
           
            ShopCartContentModel *model = tempArray[0];
            
            EFShopCartHeadView *headView = [[EFShopCartHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, sectionViewH) Name:model.productItem.shopItem.name SelectBlock:^(BOOL isSelected) {
                
                if(isSelected) {
                    for (int i=0; i<tempArray.count; i++) {
                        ShopCartContentModel *shopCartModel = tempArray[i];
                        shopCartModel.select = YES;
#warning TODO 这里最好以商品ID来判断
                        if(![self.selectedArray containsObject:shopCartModel]) {
                            [self.selectedArray addObject:shopCartModel];
                        }
                        headView.button.selected = isSelected;
                    }
                }else {
                    
                    for (int i=0; i<tempArray.count; i++) {
                        ShopCartContentModel *shopCartModel = tempArray[i];
                        shopCartModel.select = NO;
#warning TODO 这里最好以商品ID来判断
                        if([self.selectedArray containsObject:shopCartModel]) {
                            [self.selectedArray removeObject:shopCartModel];
                        }
                    }
                    
                    headView.button.selected = isSelected;
                }
                
                for(int i=0; i<tempArray.count; i++) {
                    NSIndexPath *path = [NSIndexPath indexPathForItem:i inSection:section];
                    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic] ; //后面的参数代码更新时的动画
                }
                
                
                NSInteger goodCountInteger = 0;
                for (int i=0; i<weakSelf.dataArray.count ; i++) {
                    NSMutableArray *array = [NSMutableArray array];
                    array =  weakSelf.dataArray[i];
                    goodCountInteger += array.count;
                }
                
                if (self.selectedArray.count == goodCountInteger) {
                    _allSellectedButton.selected = YES;
                } else {
                    _allSellectedButton.selected = NO;
                }
                [self countPrice];
            }];
            
            //判断这个店铺的商品是否已经全部被选中
            NSArray *array = self.dataArray[section];
            BOOL isAllSelected = YES;
            for (int i=0; i < array.count; i++) {
                ShopCartContentModel *model = array[i];
                if(model.select == NO) {
                    isAllSelected = NO;
                    break;
                }
            }
            headView.button.selected = isAllSelected;
            
            return headView;
        }else {
            return nil;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if(_isMultipleSectionBool == NO){
        return nil;
        
    } else {
        
        if(section+1 == self.dataArray.count) { //最后一个section
            return nil;
        }else {
            UIView *sectionFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
            sectionFootView.backgroundColor = RGBColor(238, 244, 249);
            return sectionFootView;
        }
    }
}

-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if(_isMultipleSectionBool == NO ) {
        return 0.0001;
    } else {
         return sectionViewH;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if(_isMultipleSectionBool == NO ) {
        return 0.0001;
        
    } else {
        
        if(section+1 == self.dataArray.count) { //最后一个section
            return 0.0001;
        }else {
            return 8;
        }
    }

}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)reloadTable {
    [self.tableView reloadData];
}



#pragma mark --- 页面按钮点击事件
#pragma mark --- 返回按钮点击事件
- (void)backButtonClick:(UIButton*)button {
    if (_isHasNavitationController == NO) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark --- 全选按钮点击事件
- (void)selectAllBtnClick:(UIButton*)button {
    
    button.selected = !button.selected;
    
    //点击全选时,把之前已选择的全部删除
    for ( ShopCartContentModel *model in self.selectedArray) {
        model.select = NO;
    }
 
    [self.selectedArray removeAllObjects];
    
    if (button.selected) {
        
        for (int i=0; i<self.dataArray.count; i++) {
            for (ShopCartContentModel *model in self.dataArray[i]) {
                model.select = YES;
                [self.selectedArray addObject:model];
            }
        }
    }
    
    [self.tableView reloadData];
    [self countPrice];
}


#pragma mark --- 删除按钮事件
- (void) deleteButtonAction {
   
    /*
    [self.dataArray removeObjectsInArray:self.selectedArray];
    [self.selectedArray removeAllObjects];
    [self changeView];
    [_tableView reloadData];
    [self countPrice];
    
    [self.viewModel EFClearItems]; //清空购物车
    */
    
    NSString *goodIdString;
    for (int i=0; i<self.selectedArray.count ; i++) {
        ShopCartContentModel *model = self.selectedArray[i];
        if(i != 0) {
            goodIdString = [goodIdString stringByAppendingFormat:@",%ld",(long)model.productItem.objectId];
        }else {
            goodIdString = [NSString stringWithFormat:@"%ld",model.productItem.objectId];
        }
    }
    
    [self.viewModel EFRemoveItemsWithProductIds:goodIdString callBackBlock:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        if ([result.jsonDict[@"status"] intValue] == 200)  {

            NSLog(@"删除成功");
    
            //移除被删除的商品
            NSMutableArray *dataCopyArray = [NSMutableArray array];
            [dataCopyArray addObjectsFromArray:self.dataArray];
            
            //NSMutableArray *dataCopyArray = [self.dataArray addObjectsFromArray:self.dataArray];
            for (int i=0; i<dataCopyArray.count ; i++) {
                NSArray *array = [dataCopyArray[i] mutableCopy];
                for (int j=0; j<array.count; j++) {
                    ShopCartContentModel *model = array[j];
                    if([_selectedArray containsObject:model]) {
                        [self.dataArray[i] removeObject:model];
                    }
                }
            }
            
            //移除二维数组中的空数组
            NSMutableArray *tempDeleteModelArray = [NSMutableArray arrayWithArray:self.dataArray];
            for (int i=0; i<tempDeleteModelArray.count; i++) {
                NSArray *array = tempDeleteModelArray[i];
                if(array.count == 0) {
                    [self.dataArray removeObject:array];
                }
            }
            
            [self.selectedArray removeAllObjects];
            
            [self changeView];
            [_tableView reloadData];
            [self countPrice];
        }
    }];

}

#pragma mark --- 计算已选中商品金额
-(void)countPrice {
    NSInteger totlePrice = 0.0;

    for (ShopCartContentModel *model in self.selectedArray) {
        NSInteger price = model.productItem.price;
        totlePrice += price*model.quantity;
    }
    NSString *string = [NSString stringWithFormat:@"￥%.2ld",(long)totlePrice];
    self.totlePriceLabel.text = string;
}



#pragma mark --- 初始化数组
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)selectedArray {
    if (_selectedArray == nil) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

#pragma mark ViewModel 回调
- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    if (action & EFMailShopCart_Items) {
        if ([result.jsonDict[@"status"] intValue] == 200) {
            if(_viewModel.cartModel.content.count == 0 ) {
                
            }else {
                //[_dataArray addObjectsFromArray:_viewModel.cartModelContentArray];
                [_dataArray addObjectsFromArray:_viewModel.cartClassifyModelArray];
            }
            
            if (self.dataArray.count > 0) {
                [self setupCartView];
            } else {
                [self setupCartEmptyView];
            }
        }
    }
    
    if (action & EFMailShopCart_ClearItems) {
        if ([result.jsonDict[@"status"] intValue] == 200) {
            [UIUtil alert:result.message];
        }
    }
    
    if (action & EFMailShopCart_UpdateItemQuantity) {
        if ([result.jsonDict[@"status"] intValue] == 200) {
            
        }
    }
    
    if (action & EFMailShopCart_RemoveItems) {
        if ([result.jsonDict[@"status"] intValue] == 200) {
            NSLog(@"删除商品成功");
        }
    }
    
}

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
