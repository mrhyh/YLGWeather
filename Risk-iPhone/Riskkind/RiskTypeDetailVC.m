
//
//  RiskTypeDetailVC.m
//  Risk
//
//  Created by ylgwhyh on 16/7/2.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RiskTypeDetailVC.h"
#import "RiskTypeDetailLeftModel.h"
#import "RiskTypeDetailLeftCell.h"
#import "RSVAArchivesModel.h"
#import "EFHpple.h"
#import "EFHppleElement.h"
#import "HTNewsImgModel.h"
#import "EF_AlbumView.h"
#import "HTMovePlayerViewController.h"
#import "SVWebViewController.h"
#import "HTConfig.h"
#import "RSMedicineDetailVC.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "SVProgressHUD.h"
#import "RSMethod.h"
#import "RSRiskViewModel.h"

@interface RiskTypeDetailVC () <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>

@property (nonatomic, strong) KYTableView *leftTableView;

@property (nonatomic, strong ) RSRiskDetailModel *rsRiskDetailModel;

// 网页富文本部分
@property (nonatomic, weak) UIBarButtonItem *backItem;
@property (nonatomic, weak) UIBarButtonItem *forwardItem;
@property (nonatomic, weak) UIBarButtonItem *refreshItem;
@property (nonatomic, strong) NSMutableArray *imgsArray;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) RSVAArchivesModel *htmlModel;


@property (nonatomic, strong) UIButton * btn; //收藏按钮

@property (nonatomic, strong)  RSRiskViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray *sourceDataArray;

@property (nonatomic, assign) BOOL isShowFirstCell;

@property (nonatomic, strong) KYMHImageView * downImg;

@property (nonatomic, assign) BOOL isRefresh;

@end

@implementation RiskTypeDetailVC {
    CGFloat webViewHeight;
}

static NSString * const RiskTypeDetailLeftCell_One_ID = @"RiskTypeDetailLeftCell_One_IDFirst";

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_showNavigationView) {
        [EFAppManager shareInstance].sideAndTabHome.rootViewController.navigationBar.hidden = NO;
    }
}

- (void ) viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initData];
    [self initUI];
    [self requestData];
}

- (void )viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.riskTypeDetailVCRefreshBlock) {
        self.riskTypeDetailVCRefreshBlock(_isRefresh);
    }
    
    [SVProgressHUD dismiss];
}


#pragma mark Other Method

- (void ) loadNetData {
    self.title = _rsRiskDetailModel.name;
    [_leftTableView reloadData];
    [self loadWebContentView:_rsRiskDetailModel];
    
    [self changeFavoriteStatus];
}


- (void ) changeFavoriteStatus {
    if (_rsRiskDetailModel.contentSocail.isFavorite) { //被收藏
        _btn.selected = YES;
    }else {
        _btn.selected = NO;
    }
}

#pragma mark Request Data 

- (void ) requestData {
    [self.viewModel findRiskDetails:_objectId];
}

#pragma mark Init

- (void) initData {
    _viewModel = [[RSRiskViewModel alloc] initWithViewController:self];
    _sourceDataArray = [[NSMutableArray alloc ] init];
}

- (void ) initUI {
    [self initNavigateRightView];
    [self initLeftTableView];
    [self initRightWebView];
}

- (void)initNavigateRightView{
    UIColor *textColorButtonSelected = EF_TextColor_TextColorButtonSelected;
    _btn= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [_btn addTarget:self action:@selector(rightActionAction:) forControlEvents:UIControlEventTouchUpInside];
    [_btn setImage:Img(@"text_collection") forState:UIControlStateNormal];
    [_btn setImage:Img(@"text_isCollection") forState:UIControlStateSelected];
    [_btn setTitleColor:textColorButtonSelected forState:UIControlStateSelected];
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_btn];
    self.navigationItem.rightBarButtonItem = barBtnItem;
}

- (void ) initRightWebView {
   _webView = [self returnWebView];
}

- (void ) initLeftTableView {
     WS(weakSelf)
    if (_leftTableView == nil) {
        _leftTableView = [[KYTableView alloc]initWithFrame:CGRectMake(0 , 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) andUpBlock:^{
            [weakSelf.leftTableView endLoading];
        } andDownBlock:^{
            [weakSelf.leftTableView endLoading];
        }];
        
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        [_leftTableView registerClass:[RiskTypeDetailLeftCell class] forCellReuseIdentifier:RiskTypeDetailLeftCell_One_ID];
        [self.view addSubview:_leftTableView];
    }
    
    if (_webView != nil) {
        _webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, webViewHeight);
    }
    [_leftTableView reloadData];
    
}

- (UIWebView *)returnWebView {
    if(_webView == nil){
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.alwaysBounceHorizontal = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.bouncesZoom = NO;
        _webView.scrollView.bounces = NO;
        _webView.dataDetectorTypes = UIDataDetectorTypeNone;
    }
    return _webView;
}


#pragma mark LoadWebContentView

- (void)loadWebContentView:(RSRiskDetailModel *)model{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    //点击可查看webView页面中的图片
    [self loadWebImaegs:model.content];
    
    NSString *htmlcontent = model.content;

    htmlcontent = [htmlcontent stringByReplacingOccurrencesOfString:@"|||r|||"withString:@""];
    htmlcontent = [htmlcontent stringByReplacingOccurrencesOfString:@"|||n|||"withString:@""];
    htmlcontent = [htmlcontent stringByReplacingOccurrencesOfString:@"|||t|||"withString:@""];
    htmlcontent = [htmlcontent stringByReplacingOccurrencesOfString:@"||||||"withString:@"\\"];
    
    //NSString *javaScriptString = @"<script> function stopEventBubble(event){ var e=event || window.event; if (e && e.stopPropagation){ e.stopPropagation();}else{e.cancelBubble=true;}}function to_detail(id,evt){stopEventBubble(evt);document.location.href='http://www.kingyon.com/ysyueeDetail?id='+id;}function maojie(id,evt){stopEventBubble(evt);document.location.href='ysyumaojie'+id;}</script>";
    
    htmlcontent = [NSString stringWithFormat:@"<!DOCTYPE html><html lang='en'><head><meta name='viewport' content='width=device-width, initial-scale=1, user-scalable=no'/><meta charset='UTF-8'><title>Document</title><link rel='stylesheet' href='css/style.css'></head> %@</html>", htmlcontent];


    [_webView loadHTMLString:htmlcontent baseURL:baseURL];
}


#pragma mark LoadWebImaegs 点击可查看webView页面中的图片

- (void)loadWebImaegs:(NSString *)_htmlContent{
    
    self.imgsArray = [NSMutableArray array];
    NSData *htmlData = [_htmlContent dataUsingEncoding:NSUTF8StringEncoding];
    EFHpple *xpathParser = [[EFHpple alloc] initWithHTMLData:htmlData];
    NSArray *elements  = [xpathParser searchWithXPathQuery:@"//img[@src]"];
    NSArray *elements2  = [xpathParser searchWithXPathQuery:@"//a/img[@src]"];
    for (int i =0 ; i < [elements count]; i++ ) {
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
        HTNewsImgModel *image = [[HTNewsImgModel alloc] init];
        image.imgId = url;
        image.imageUrl = url;
        image.description = @"";
        [self.imgsArray addObject:image];
    }
}


#pragma mark UIWebViewDelegate-将要加载Webview

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *url = [request URL];
    NSString *urlStr = [url absoluteString];
    
    NSLog(@"-----url------%@",[url absoluteString]);
    
    NSMutableArray * arr = [NSMutableArray array];
    
    for (int i = 0 ; i < [_imgsArray count]; i++) {
        HTNewsImgModel *img = [_imgsArray objectAtIndex:i];
        [arr addObject:img.imageUrl];
    }
    for (int i = 0 ; i < [_imgsArray count]; i++) {
        HTNewsImgModel *img = [_imgsArray objectAtIndex:i];
        
        if ([img.imageUrl isEqualToString:urlStr]) {
            EF_AlbumView * img = [[EF_AlbumView alloc]initWithArr:arr andFrame:CGRectMake(0,(SCREEN_HEIGHT-SCREEN_WIDTH)/2, SCREEN_WIDTH, SCREEN_WIDTH) andIndex:i];
            [[UIApplication sharedApplication].keyWindow addSubview:img];
            
            return NO;
        }
    }
    
    if ([urlStr rangeOfString:@"&type=playvideo"].location != NSNotFound) {
        HTMovePlayerViewController *moviePlayer = [[HTMovePlayerViewController alloc] initWithContentURL:url];
        moviePlayer.moviePlayer.fullscreen = YES;
        [self presentMoviePlayerViewControllerAnimated:moviePlayer];
        return NO;
    }
    if ([urlStr isEqualToString:@"about:blank"]) {
        return YES;
    }
    
#warning TODO 原来的，1周后删除
//    if ( navigationType == UIWebViewNavigationTypeOther ) {
//        if (urlStr.length > 5) {
//            NSString *headStr = [urlStr substringToIndex:5];
//            if ( [headStr isEqualToString:@"http:"] || [headStr isEqualToString:@"https"] ) {
//                
//                //根据后台返回的富文本中的链接中的id跳转到对应详情
//                NSRange range = [urlStr rangeOfString:@"id="];//匹配得到的下标
//                NSLog(@"rang:%@",NSStringFromRange(range));
//                //截取字符index为2 到结尾之间的内容
//                NSString *objectIdStr = [urlStr substringFromIndex:(range.location+range.length)];
//                NSLog(@"截取的值为：%@",objectIdStr);
//                RiskTypeDetailVC *next = [[RiskTypeDetailVC alloc] init];
//                next.objectId = [objectIdStr integerValue];
//                [self.navigationController pushViewController:next animated:YES];
//            }else {
//                RSMedicineDetailVC *next = [[RSMedicineDetailVC alloc] init];
//                next.clickWebViewPushString = [urlStr substringFromIndex:urlStr.length - 3 ];
//                next.model = _rsRiskDetailModel;
//                [self.navigationController pushViewController:next animated:YES];
//            }
//        }
//        
//        return NO;
//    }
    
        if ([urlStr containsString:@"ysyueeDetail"]) {
            NSString *headStr = [urlStr substringToIndex:5];
            if ( [headStr isEqualToString:@"http:"] || [headStr isEqualToString:@"https"] ) {
                
                //根据后台返回的富文本中的链接中的id跳转到对应详情
                NSRange range = [urlStr rangeOfString:@"id="];//匹配得到的下标
                NSLog(@"rang:%@",NSStringFromRange(range));
                //截取字符index为2 到结尾之间的内容
                NSString *objectIdStr = [urlStr substringFromIndex:(range.location+range.length)];
                NSLog(@"截取的值为：%@",objectIdStr);
                
                RiskTypeDetailVC *next = [[RiskTypeDetailVC alloc] init];
                next.objectId = [objectIdStr intValue];
                [self.navigationController pushViewController:next animated:YES];
                
                return NO;
            }
        }else  if ([urlStr containsString:@"ysyumaojie"]){
            RSMedicineDetailVC *next = [[RSMedicineDetailVC alloc] init];
            next.clickWebViewPushString = [urlStr substringFromIndex:urlStr.length - 3];
            next.model = _rsRiskDetailModel;
            
            [self.navigationController pushViewController:next animated:YES];
            
            return NO;
        }

    return YES;

}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [SVProgressHUD dismiss];
    self.backItem.enabled = webView.canGoBack;
    self.forwardItem.enabled = webView.canGoForward;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *str = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",(int)([HTConfig getFontPercentage] * 100)];
    [webView stringByEvaluatingJavaScriptFromString:str];
    
    [webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "for(i=0;i < document.images.length;i++){"
     "var myimg = document.images[i];var touchopen = 1;"
     "myimg.style.width = '100%';"
     "myimg.style.height = '';"
     "var imagelink = document.createElement('a');"
     "imagelink.href=myimg.src;"
     "var imageparent = myimg.parentNode;"
     "if(imageparent.tagName!='A'){"
     "imageparent.insertBefore(imagelink,myimg);"
     "imagelink.appendChild(myimg);}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none'; document.body.style.KhtmlUserSelect='none'"]; //去掉长按打开连接功能
    
    //更改至---》[self setupAuthorView];创建控件出获取高度
    CGFloat WebViewHeight = 0.0f;
    
//    if ([_webView.subviews count] > 0) {
//        UIView *scrollerView = _webView.subviews[0];
//        if ([scrollerView.subviews count] >0) {
//            UIView *webDocView = scrollerView.subviews[0];
//            if  ([webDocView isKindOfClass:[NSClassFromString(@"UIWebBrowserView") class]]){
//                WebViewHeight = webDocView.frame.size.height;//获取文档的高度
//                //更新UIWebView 的高度
//                webViewHeight = WebViewHeight;
//                
//                
//            }
//        }
    WebViewHeight = webView.scrollView.contentSize.height;
    webViewHeight = WebViewHeight;
//    }
    
    [self initLeftTableView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD dismiss];
}

#pragma mark buttonAction 

- (void ) rightActionAction: (UIButton *)button {
    if ( (NO == button.selected) &&  (NO ==_rsRiskDetailModel.contentSocail.isFavorite ) ) {
        
        [RSMethod ylg_SVProgressHUD_showWithSVProgressHUDMaskTypeNone];
        [self.viewModel favourateRISK:_rsRiskDetailModel.objectId];
        
    }else if  ( (YES == button.selected ) &&  (YES ==_rsRiskDetailModel.contentSocail.isFavorite ) ) {
        
        [RSMethod ylg_SVProgressHUD_showWithSVProgressHUDMaskTypeNone];
        [self.viewModel cancelFavouriteRISK:_rsRiskDetailModel.objectId];
    }
}

#pragma mark - TableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        RiskTypeDetailLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:RiskTypeDetailLeftCell_One_ID];
        if (!cell) {
            cell = [[RiskTypeDetailLeftCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:RiskTypeDetailLeftCell_One_ID];
        }
        cell.model = _rsRiskDetailModel;
        
        if (_downImg == nil) {
            _downImg = [[KYMHImageView alloc]initWithImage:Img(@"ic_arrow_down") BaseSize:CGRectMake(SCREEN_WIDTH/2-8, 70, 16, 8) ImageViewColor:[UIColor clearColor]];
            [cell addSubview:_downImg];
        }
        
        if (!_isShowFirstCell) {
            _downImg.hidden = NO;
        }else {
            _downImg.hidden = YES;
        }
        
        return cell;
    }else {
        UITableViewCell * cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, webViewHeight)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _webView = [self returnWebView];
        [cell.contentView addSubview:_webView];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        _isShowFirstCell = YES;
        [self initLeftTableView];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (nil == _rsRiskDetailModel ) {
        return  0;
    } else {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 0.5;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * headView = [UIView new];
    headView.backgroundColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary];
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        if (!_isShowFirstCell) {
            return 80;
        }
        
        id model = _rsRiskDetailModel;
        
        CGFloat cellHeight =  [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[RiskTypeDetailLeftCell class] contentViewWidth:[self cellContentViewWith]];
        return cellHeight;
    }else {
        return webViewHeight;
    }
    
    
}

- (CGFloat)cellContentViewWith {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

#pragma mark ViewModel回调

- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result {
    
    if (  RSRisk_NS_ENUM_findRiskDetails == action) {
        [SVProgressHUD dismiss];
        if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeSuccess) {
            _rsRiskDetailModel = self.viewModel.rsRiskDetailModel;
            [self loadNetData];
        }else {
            [UIUtil alert:result.message];
        }
    }
    
    if ( RSRisk_NS_ENUM_favourate_RISK  == action) {
        if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeSuccess) {
            
            [RSMethod ylg_showSuccessWithStatus:@"收藏成功"];
            _btn.selected = YES;
            _rsRiskDetailModel.contentSocail.isFavorite = YES;
            [self changeFavoriteStatus];
            _isRefresh = YES;
        }else {
            [RSMethod ylg_showSuccessWithStatus:result.message];
        }
    }
    
    if ( RSRisk_NS_ENUM_cancelFavourate_RISK == action) {
        if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeSuccess) {
            
            [RSMethod ylg_showSuccessWithStatus:@"已经取消收藏"];
            _rsRiskDetailModel.contentSocail.isFavorite = NO;
            _btn.selected = NO;
            [self changeFavoriteStatus];
            _isRefresh = YES;
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
    [SVProgressHUD dismiss];
}

@end
