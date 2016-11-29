//
//  EFMallDetailsVC.m
//  EF_MallDemo
//
//  Created by MH on 16/6/13.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFMallDetailsVC.h"
#import "EFMallDetailsTopCell.h"
#import "EFMallDetailsStoreCell.h"
#import "EFHpple.h"
#import "SVWebViewController.h"
#import "EFSelectView.h"
#import "EFGoodsCommentVC.h"
#import "EFAgencyInfoVC.h"
#import "EFMallViewModel.h"
#import "EFOrderConfirmVC.h"
#import "EFMallModel.h"
#import "EFPushCommentVC.h"
#import "EFGoodSpecificationCell.h"
#import "EFSelecteSpecificationView.h"
#import "UIColor+UIColor_Hex.h"

static NSString *const SDEFMallDetailsTopCell = @"EFMallDetailsTopCell";
static NSString *const SDEFMallDetailsStoreCell = @"EFMallDetailsStoreCell";
static NSString *const SDEFMallDetailSelectResultCell = @"EFGoodSpecificationCell";

@interface EFMallDetailsVC ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
@property (strong, nonatomic)KYTableView * table;
@property (nonatomic,assign)BOOL isStore;
@property (nonatomic,assign)int count;
@property (nonatomic,assign)float height;
@property (nonatomic,assign)BOOL isWeb;
@property (nonatomic,assign)BOOL isClass;
@property (strong, nonatomic)NSMutableArray      * imageArray;

@property (nonatomic,strong)EFSelectView  * m_view;
@property (nonatomic,strong)NSString* m_objectId;
@property (nonatomic,strong)UIView * m_coverView;

@property (nonatomic,strong)NSArray * listArray;

@property (nonatomic, strong) EFMallViewModel *viewModel;

@property (nonatomic, copy) NSString *productID;

@property (nonatomic, strong) NSMutableString *webContent;

@property (nonatomic, strong) ProductDetailModel *productDetail;

@end

@implementation EFMallDetailsVC
#pragma mark --- lazy load
- (EFMallViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[EFMallViewModel alloc] initWithViewController:self];
    }
    return _viewModel;
}


#pragma mark --- life cycle
- (instancetype)initWithProductId:(NSString *)productID{
    if (self = [super init]) {
        _productID = productID;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated{
   [self.navigationController setToolbarHidden:YES animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.viewModel productDetailWithProductID:self.productID];
    self.title = @"商品详情";
    self.view.backgroundColor = EF_BGColor_Primary;
    
    self.navigationItem.rightBarButtonItem = [UIUtil barButtonItem:self WithTitle:@"" withImage:Img(@"More") withBlock:^{
        [self showList];
    } isLeft:NO];
    
    
    _listArray = [[NSDictionary alloc] initWithContentsOfFile:self.plistPath][@"Mall"][@"DetailsButtonArray"];
    _isStore = [[[NSDictionary alloc] initWithContentsOfFile:self.plistPath][@"Mall"][@"isStore"] boolValue];
    _isClass = [[[NSDictionary alloc] initWithContentsOfFile:self.plistPath][@"Mall"][@"isClass"] boolValue];
    if (_isStore) {
        _count = 4;
        if (!_isClass) {
            _count = 3;
        }
    }else{
        _count = 3;
        if (!_isClass) {
            _count = 2;
        }
    }
    _height = 0;
    _table = [[KYTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-40) andUpBlock:^{
        [_table endLoading];
    } andDownBlock:^{
        [_table endLoading];
    }];
    [self.view addSubview:_table];
    _table.mj_header.hidden = YES;
    _table.mj_footer.hidden = YES;
    _table.dataSource = self;
    _table.delegate = self;
    _table.backgroundColor = EF_BGColor_Primary;
    _table.separatorStyle = UITableViewCellAccessoryNone;
    [_table registerClass:[EFMallDetailsTopCell class] forCellReuseIdentifier:SDEFMallDetailsTopCell];
    [_table registerClass:[EFMallDetailsStoreCell class] forCellReuseIdentifier:SDEFMallDetailsStoreCell];
    [_table registerClass:[EFGoodSpecificationCell class] forCellReuseIdentifier:SDEFMallDetailSelectResultCell];
    
    UIView * bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.userInteractionEnabled = YES;
    [self.view addSubview:bottomView];
    
    KYMHButton * buyBT = [KYMHButton new];
    [buyBT setTitle:@"立即购买" forState:0];
    [buyBT setTitleColor:[UIColor whiteColor] forState:0];
    buyBT.backgroundColor = DefaultGreenColor;
    buyBT.titleLabel.font = [UIFont systemFontOfSize:13];
    [buyBT addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyBT];
    
    bottomView.sd_layout.bottomEqualToView(self.view).leftEqualToView(self.view).heightIs(40).widthIs(SCREEN_WIDTH/_listArray.count);
    
    
    buyBT.sd_layout.rightEqualToView(self.view).topEqualToView(bottomView).bottomEqualToView(bottomView).widthIs(SCREEN_WIDTH/_listArray.count);
    
    for (int i = 0; i < _listArray.count; i++) {
        KYMHButton * button = [KYMHButton new];
        [button setTitle:_listArray[i] forState:0];
        [button setTitleColor:[UIColor whiteColor] forState:0];
        button.backgroundColor = DefaultRedColor;
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(allbutton:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:button];
        CGFloat w = SCREEN_WIDTH/_listArray.count/2;
        button.sd_layout.leftSpaceToView(bottomView,0 + i * w).topEqualToView(bottomView).bottomEqualToView(bottomView).widthIs(w);
    }
}


- (void)allbutton:(UIButton*)sender{
    if (sender.tag == 100) {
        EFPushCommentVC *vc = [[EFPushCommentVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (sender.tag == 101) {
        [self.viewModel addShopCarWithProductId:[NSString stringWithFormat:@"%zd",self.productDetail.objectId] quantity:@"1"];
    }
}

- (void)buy{
    EFOrderConfirmVC *confirmVC = [[EFOrderConfirmVC alloc] init];
    confirmVC.productDetail = self.productDetail;
    [self.navigationController pushViewController:confirmVC animated:YES];
}

- (void)dealloc{
    [_viewModel cancelAndClearAll];
}

#pragma mark --- 网络回调
- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    if (action == EFMallViewModelCallBackActionAddShopCar) {
        if (result.status == NetworkModelStatusTypeSuccess) {
            [UIUtil alert:@"添加购物车成功!"];
        }else{
            [UIUtil alert:@"添加购物车失败!"];
        }
    }else if (action == EFMallViewModelCallBackActionProductDetail){
        if (result.status == NetworkModelStatusTypeSuccess) {
            self.productDetail = [ProductDetailModel yy_modelWithJSON:result.content];
            self.webContent = [NSMutableString stringWithFormat:@"%@",self.productDetail.introduce];
            
            [self.webContent replaceOccurrencesOfString:@"<img" withString:@"<img onclick =\"imgClicked(this)\" width=100%%" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [self.webContent length])];
            self.webContent = [NSMutableString stringWithFormat:@"<html><meta name=\"viewport\" content=\"width=device-width, initial-scale=1, user-scalable=no, minimum-scale=1.0, maximum-scale=2.0\"/><body style=\"padding:0px;\">%@<br><br></body></html>",self.webContent];
            [self loadWebImaegs:self.webContent];
            [self.table reloadData];
        }else{
            [UIUtil alert:@"商品数据加载失败!"];
        }
    }
}

#pragma mark TableViewDelegate


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WS(weakSelf)
    if (indexPath.section == 0) {
        EFMallDetailsTopCell *cell = [tableView dequeueReusableCellWithIdentifier:SDEFMallDetailsTopCell];
        cell.productDetail = self.productDetail;
        cell.indexPath = indexPath;
        
        if (!cell.commentButtonClickedBlock) {
            [cell setCommentButtonClickedBlock:^(NSIndexPath *indexPath) {
                EFGoodsCommentVC *next = [[EFGoodsCommentVC alloc] initWithProductId:[NSString stringWithFormat:@"%zd",self.productDetail.objectId]];
                [weakSelf.navigationController pushViewController:next animated:YES];
            }];
        }
        return cell;
        
    }else if (indexPath.section == _count-1){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WebCell"];
        
        UIWebView * webView = [UIWebView new];
        webView.backgroundColor = [UIColor whiteColor];
        webView.scrollView.backgroundColor = [UIColor clearColor];
        webView.delegate = self;
        [cell addSubview:webView];
        webView.scrollView.scrollEnabled = NO;
        UIView *contentView = cell;
        
        
        for (UIView *_aView in [webView subviews])
        {
            if ([_aView isKindOfClass:[UIScrollView class]])
            {
                [(UIScrollView *)_aView setShowsVerticalScrollIndicator:NO];
                //右侧的滚动条
                
                [(UIScrollView *)_aView setShowsHorizontalScrollIndicator:NO];
                //下侧的滚动条
                
                for (UIView *_inScrollview in _aView.subviews)
                {
                    if ([_inScrollview isKindOfClass:[UIImageView class]])
                    {
                        _inScrollview.hidden = YES;  //上下滚动出边界时的黑色的图片
                    }
                }
            }
        }
        
        webView.sd_layout
        .leftEqualToView(contentView)
        .topEqualToView(contentView)
        .rightEqualToView(contentView)
        .bottomEqualToView(contentView);

        if (self.webContent) {
            [webView loadHTMLString:self.webContent baseURL:nil];
        }
        

        
        return cell;
    }else if(indexPath.section == 1&&_isClass) {
        EFGoodSpecificationCell *cell = [tableView dequeueReusableCellWithIdentifier:SDEFMallDetailSelectResultCell];
        NSString *selectString = @"";
        for (ProductSpecification *productSpecification in self.productDetail.productSpecification) {
            selectString = [selectString stringByAppendingString:[NSString stringWithFormat:@" %@",productSpecification.value.text]];
        }
        cell.selectResult = selectString;
        return cell;
    }else{
        EFMallDetailsStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:SDEFMallDetailsStoreCell];
        cell.indexPath = indexPath;
        cell.productDetail = self.productDetail;
        if (!cell.phoneButtonClickedBlock) {
            [cell setPhoneButtonClickedBlock:^(NSIndexPath *indexPath) {
                
                EFAgencyInfoVC *infoVC = [[EFAgencyInfoVC alloc] initWithShopId:[NSString stringWithFormat:@"%zd",self.productDetail.shopItem.objectId]];
                [self.navigationController pushViewController:infoVC animated:YES];
            }];
        }
        return cell;
    }
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _count;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == _count-1 || section == _count-2) {
        UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        headView.backgroundColor = HEX_COLOR(@"#f6f6f6");
        UIView * lineView = [UIView new];
        lineView.backgroundColor = RGBColor(239, 244, 248);
        [headView addSubview:lineView];
        lineView.sd_layout
        .leftEqualToView(headView)
        .rightEqualToView(headView)
        .topEqualToView(headView)
        .heightIs(10);
        NSArray * arr;
        if (_isStore) {
            arr = @[@"机构信息",@"商品信息"];
        }else{
            arr = @[@"商品信息"];
        }
        
        int n = 2;
        if (!_isClass) {
            n = 1;
        }
        KYMHLabel * label = [KYMHLabel new];
        label.text = arr[section-n];
        label.textColor =  EF_TextColor_TextColorSecondary;
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:15];
        [headView addSubview:label];
        
        label.sd_layout.leftSpaceToView(headView,10).topSpaceToView(headView,10).widthIs(100).heightIs(30);
        return headView;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }else if(section == 1&&_isClass){
        return 10;
    }
    return 40;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 270;
    }else if (indexPath.section == _count-1) {
        return _height;
    }else if (indexPath.section == 1&&_isClass){
        return 44;
    }
    return 80;
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
    WS(weakSelf)
    if (indexPath.section == 1&&_isClass) {
        EFSelecteSpecificationView *selectView = [EFSelecteSpecificationView SelecteSepacificationView];
        selectView.productDetailModel = self.productDetail;
        [selectView setSelectHandler:^(NSString *result, NSInteger objectId){
            if (weakSelf.productDetail.objectId != objectId) {
                [weakSelf.viewModel productDetailWithProductID:[NSString stringWithFormat:@"%zd",objectId]];
            }
        }];
        [selectView push];
    }
    
}

#pragma mark WebView
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *url = [request URL];
    
    NSString *urlStr = [url absoluteString];
    NSLog(@"-----url------%@",urlStr);
    
    if ([urlStr isEqualToString:@"about:blank"]) {
        return YES;
    }
    
    
    if ([urlStr rangeOfString:@"jpg"].location != NSNotFound) {
        for (int i = 0; i < self.imageArray.count; i++) {
            NSString * imaUrl = self.imageArray[i];
            if ([imaUrl isEqualToString:urlStr]) {
                EF_AlbumView * img = [[EF_AlbumView alloc]initWithArr:self.imageArray andFrame:CGRectMake(0,(SCREEN_HEIGHT-SCREEN_WIDTH)/2, SCREEN_WIDTH, SCREEN_WIDTH) andIndex:i];
                [[UIApplication sharedApplication].keyWindow addSubview:img];
            }
        };
        return NO;
    }else{
        SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:url];
        [self.navigationController pushViewController:webViewController animated:YES];
        return NO;
    }
    
}



- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // finished loading, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //web内容加载完成后，让图片可以被点击
    [webView stringByEvaluatingJavaScriptFromString: @"function imgClicked(element) {\
     \
     document.location = element.src;\
     \
     }"];

    _height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    if (!_isWeb) {
        _isWeb = YES;
        [_table reloadData];
    }
}

- (void)loadWebImaegs:(NSString *)_htmlContent{
    self.imageArray = [NSMutableArray array];
    NSData *htmlData = [_htmlContent dataUsingEncoding:NSUTF8StringEncoding];
    EFHpple *xpathParser = [[EFHpple alloc] initWithHTMLData:htmlData];
    NSArray *elements  = [xpathParser searchWithXPathQuery:@"//img[@src]"];
    NSArray *elements2  = [xpathParser searchWithXPathQuery:@"//a/img[@src]"];
    for (int i =0 ; i < [elements count]; i++) {
        EFHppleElement *element = [elements objectAtIndex:i];
        NSString *url = [element objectForKey:@"src"];
        for (int i =0 ; i < [elements2 count]; i++) {
            if([url isEqualToString:[[elements objectAtIndex:i] objectForKey:@"src"]]) {
                element = nil;
                break;
            }
        }
        if (!element) {
            continue;
        }
        [self.imageArray addObject:url];
    }
}




#pragma mark 下拉列表
- (void)showList{
    if (_m_view== nil) {
        _m_coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:_m_coverView];
        _m_coverView.backgroundColor = [UIColor clearColor];
        _m_coverView.hidden = YES;
        
        
        UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(touch) forControlEvents:UIControlEventTouchUpInside];
        [_m_coverView addSubview:button];
        button.frame = _m_coverView.bounds;
        
        
        _m_view = [[EFSelectView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 160) ObjectId:3 Array:nil andCity:nil andSelectBlock:^(CategoryModel *category) {
            _m_view.hidden = YES;
            _m_coverView.hidden = YES;
            _m_objectId = category.name;
            
            if ([category.name isEqualToString:@"分享"]) {
                NSDictionary *dic = @{@"shareURL":@"www.baidu.com",@"img":[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/rate_star_big"]],@"news_content":@"EF商城"};
                [[EFShareView shareInstance] openShareViewWithContent:dic CallBack:^(BOOL isMore) {
                    if (isMore) {
                        NSString *string = @"EF商城";
                        NSURL *URL = [NSURL URLWithString:@"www.baidu.com"];
                        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[string,[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/rate_star_big"]],URL] applicationActivities:nil];
                        [self presentViewController:activityController animated:YES completion:nil];
                    }
                }];
            }
        }];
        [self.view addSubview:_m_view];
        _m_view.hidden = YES;
    }
    
    _m_view.hidden = !_m_view.hidden;
    _m_coverView.hidden = !_m_coverView.hidden;
}
- (void)touch{
    _m_view.hidden = !_m_view.hidden;
    _m_coverView.hidden = !_m_coverView.hidden;
}
@end
