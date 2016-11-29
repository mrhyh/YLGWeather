//
//  RSMedicineDetailVC.m
//  Risk
//
//  Created by ylgwhyh on 16/7/12.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSMedicineDetailVC.h"

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
#import "RSRKQuickViewMenuVC.h"
#import "SVProgressHUD.h"
#import "UIUtil.h"
#import "RSRiskViewModel.h"
#import "RSMethod.h"
#import "RSMedicineDetailMenuCell.h"

@interface RSMedicineDetailVC () <UIWebViewDelegate, RSRKQuickViewMenuVCDelegate,UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;

// 网页富文本部分
@property (nonatomic, weak) UIBarButtonItem *backItem;
@property (nonatomic, weak) UIBarButtonItem *forwardItem;
@property (nonatomic, weak) UIBarButtonItem *refreshItem;
@property (nonatomic, strong) NSMutableArray *imgsArray;
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *middleButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong)  RSRiskViewModel *viewModel;

@property (nonatomic, strong) DXPopover * popver; //弹出视图
@property (nonatomic, strong) UITableView * popTableView; //弹出视图
@property (nonatomic, strong) NSMutableArray *popArray; //弹出视图数据

//快速查看菜单
@property (nonatomic, strong) UIPopoverController *fastLookMenuPC;


@end

@implementation RSMedicineDetailVC {
    CGFloat webViewHeight;
    CGFloat spactToLeft;
    
    CGFloat tableViewW;
    CGFloat cellW;
    CGFloat cellH;
    CGFloat spaceToLeft;
    CGFloat tableViewH;
    
    UIColor *labelTextColor;
}

static NSString * const RSMedicineDetailVC_Menu = @"RSMedicineDetailVC_Menu";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
}

- (void ) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [SVProgressHUD dismiss];
}

- (void) initData {
    
    spactToLeft = DetailWebViewLeftToSpaceMF/2;
    _dataSource = [[NSMutableArray alloc] init];
    
    _viewModel = [[RSRiskViewModel alloc] initWithViewController:self];
    _popver = [[DXPopover alloc]init];
    
    tableViewW = 140;
    cellW = 100;
    cellH = 35;
    spaceToLeft = 10;
    tableViewH = SCREEN_HEIGHT-49;
    
    labelTextColor = EF_TextColor_TextColorPrimary;
}

- (void) initUI {
    self.title = _model.name;
    [self initNavigateRightView];
    [self initRightWebView];
    
    [_webView setOpaque:NO];
    _webView.backgroundColor = [UIColor clearColor];
    self.webView.hidden = YES;
    
    [self changeFavoriteStatus];
}

- (void ) initRightWebView {
    
    [self setupWebView];
}

- (void)initNavigateRightView{
    
    UIView * rightNavView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3*37, 40)];
    
    _leftButton = [self createButton:@"text_size" imageSelected:@"text_size" action:@selector(leftButtonAction:)];
    _middleButton = [self createButton:@"text_collection" imageSelected:@"text_isCollection" action:@selector(middleButtonAction:)];
    _rightButton = [self createButton:@"text_menu" imageSelected:@"text_menu" action:@selector(rightButtonAction:)];
    
    NSArray *views = @[_leftButton, _middleButton, _rightButton];
    [rightNavView sd_addSubviews:views];
    
    UIView *contentView = rightNavView;
    
    CGFloat btnH = 34;
    
    _rightButton.sd_layout
    .topSpaceToView(contentView,5)
    .rightSpaceToView(contentView, 5)
    .widthIs (btnH)
    .heightIs(btnH);
    
    _middleButton.sd_layout
    .topEqualToView(_rightButton)
    .rightSpaceToView(_rightButton, 0)
    .widthIs (btnH)
    .heightIs(btnH);
    
    
    _leftButton.sd_layout
    .topEqualToView(_rightButton)
    .rightSpaceToView(_middleButton, 0)
    .widthIs (btnH)
    .heightIs(btnH);

    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavView];
    self.navigationItem.rightBarButtonItem = barBtnItem;
}

#pragma mark  Lazy Load

- (void ) changeFavoriteStatus {
    
    if (_model.contentSocail.isFavorite) { //被收藏
        _middleButton.selected = YES;
    }else {
        _middleButton.selected = NO;
    }
}

#pragma mark createUI
- (UIButton * ) createButton:(NSString *)imageNormal imageSelected:(NSString *) imageSelected action:(SEL)action {
    
    UIButton * btn= [UIButton new];
    [btn setImage:Img(imageNormal) forState:UIControlStateNormal];
    [btn setImage:Img(imageSelected) forState:UIControlStateSelected];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    return btn;
}

#pragma mark 初始化webView

- (void)setupWebView {
    
    if(_webView == nil){
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(spactToLeft ,0, SCREEN_WIDTH-2*spactToLeft,  SCREEN_HEIGHT)];
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        [SVProgressHUD show];
        _webView.scrollView.backgroundColor = [UIColor clearColor];
        _webView.scrollView.alwaysBounceHorizontal = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.bouncesZoom = NO;
        _webView.scrollView.bounces = NO;
        
        [self.view addSubview:_webView];
    }
    
    [self loadWebContentView:_model];
}

#pragma mark LoadWebContentView

- (void)loadWebContentView:(RSRiskDetailModel *)model{
    
    //点击可查看webView页面中的图片
    [self loadWebImaegs:model.contentAll];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    //NSString *javaScriptString = @"<script> function stopEventBubble(event){ var e=event || window.event; if (e && e.stopPropagation){ e.stopPropagation();}else{e.cancelBubble=true;}}function to_detail(id,evt){stopEventBubble(evt);document.location.href='http://www.kingyon.com/ysyueeDetail?id='+id;}function maojie(id,evt){stopEventBubble(evt);document.location.href='ysyumaojie'+id;}</script>";
    
    NSString *htmlcontent = model.contentAll;
    
    htmlcontent = [htmlcontent stringByReplacingOccurrencesOfString:@"|||r|||"withString:@""];
    htmlcontent = [htmlcontent stringByReplacingOccurrencesOfString:@"|||n|||"withString:@""];
    htmlcontent = [htmlcontent stringByReplacingOccurrencesOfString:@"|||t|||"withString:@""];
    htmlcontent = [htmlcontent stringByReplacingOccurrencesOfString:@"||||||"withString:@"\\"];
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
    
#warning TODO 暂时注释
//    if ( navigationType == UIWebViewNavigationTypeLinkClicked ) {
//        if (urlStr.length > 5) {
//            NSString *headStr = [urlStr substringToIndex:5];
//            if ( [headStr isEqualToString:@"http:"] || [headStr isEqualToString:@"https"] ) {
//                
//                NSString *objectIdStr;
//                NSRange range = [urlStr rangeOfString:@"id="];//匹配得到的下标
//                NSLog(@"rang:%@",NSStringFromRange(range));
//                //截取字符index为2 到结尾之间的内容
//                objectIdStr = [urlStr substringFromIndex:(range.location+range.length)];
//                NSLog(@"截取的值为：%@",objectIdStr);
//
//                RiskTypeDetailVC *next = [[RiskTypeDetailVC alloc] init];
//                next.objectId = [objectIdStr integerValue];
//                [self.navigationController pushViewController:next animated:YES];
//            }
//        }
//        return NO;
//    }
    
//    if ([urlStr containsString:@"ysyueeDetail"]) {
//        NSString *headStr = [urlStr substringToIndex:5];
//        if ( [headStr isEqualToString:@"http:"] || [headStr isEqualToString:@"https"] ) {
//            
//            //根据后台返回的富文本中的链接中的id跳转到对应详情
//            NSRange range = [urlStr rangeOfString:@"id="];//匹配得到的下标
//            NSLog(@"rang:%@",NSStringFromRange(range));
//            //截取字符index为2 到结尾之间的内容
//            NSString *objectIdStr = [urlStr substringFromIndex:(range.location+range.length)];
//            NSLog(@"截取的值为：%@",objectIdStr);
//            
//            RiskTypeDetailVC *next = [[RiskTypeDetailVC alloc] init];
//            next.objectId = [objectIdStr integerValue];
//            [self.navigationController pushViewController:next animated:YES];
//            
//            return NO;
//        }
//    }
    
    if ( [urlStr containsString:@"ysyueeDetail"] ) {
        NSString *headStr = [urlStr substringToIndex:5];
        if ( [headStr isEqualToString:@"http:"] || [headStr isEqualToString:@"https"] ) {
            
            NSString *objectIdStr;
            NSRange range = [urlStr rangeOfString:@"id="];//匹配得到的下标
            NSLog(@"rang:%@",NSStringFromRange(range));
            //截取字符index为2 到结尾之间的内容
            objectIdStr = [urlStr substringFromIndex:(range.location+range.length)];
            NSLog(@"截取的值为：%@",objectIdStr);
            
            RiskTypeDetailVC *next = [[RiskTypeDetailVC alloc] init];
            next.objectId = (int)[objectIdStr integerValue];
            [self.navigationController pushViewController:next animated:YES];
            
            return NO;
        }
    }


    return YES;
}


#pragma mark UIWebViewDelegate-已经加载Webview完毕

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
    
    //更改至---》[self setupAuthorView];创建控件出获取高度
    CGFloat WebViewHeight = 0.0f;
    
    if ([_webView.subviews count] > 0) {
        UIView *scrollerView = _webView.subviews[0];
        if ([scrollerView.subviews count] >0) {
            UIView *webDocView = scrollerView.subviews[0];
            if  ([webDocView isKindOfClass:[NSClassFromString(@"UIWebBrowserView") class]]){
                WebViewHeight = webDocView.frame.size.height;//获取文档的高度
                //更新UIWebView 的高度
                webViewHeight = WebViewHeight;
            }
        }
    }

    if ( ![UIUtil isEmptyStr:_clickWebViewPushString] ) {
        NSString *js = [NSString stringWithFormat:@"window.location.href = '#%@'",_clickWebViewPushString];
        [self.webView stringByEvaluatingJavaScriptFromString:js];
    }
    
    self.webView.hidden = NO;
}


#pragma mark UIWebViewDelegate-加载Webview失败

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD dismiss];
}

#pragma mark set

- (void ) setModel:(RSRiskDetailModel *)model {
    _model = model;
}

#pragma mark button Action 

- (void ) leftButtonAction: (UIButton *)button {
    
    button.selected = !button.selected;
    NSLog(@"leftButtonAction");
    
    if (button.selected ) {
              [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '90%'"];
    }else {
              [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'"];
    }
}

- (void ) middleButtonAction: (UIButton *)button {
    if ( (NO == button.selected) &&  (NO ==_model.contentSocail.isFavorite ) ) {
        
        [RSMethod ylg_SVProgressHUD_showWithSVProgressHUDMaskTypeNone];
        [self.viewModel favourateRISK:_model.objectId];
        
    }else if  ( (YES == button.selected ) &&  (YES ==_model.contentSocail.isFavorite ) ) {
        
        [RSMethod ylg_SVProgressHUD_showWithSVProgressHUDMaskTypeNone];
        [self.viewModel cancelFavouriteRISK:_model.objectId];
    }
}

- (void ) rightButtonAction: (UIButton *)button {
    button.selected = !button.selected;

    _dataSource = [_model.menuLs mutableCopy];
    
    if (_popTableView == nil) {
        _popTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 150, SCREEN_HEIGHT-64-20) style:UITableViewStyleGrouped];
        _popTableView.delegate = self;
        _popTableView.dataSource = self;
        _popTableView.backgroundColor = [UIColor whiteColor];
        _popTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    
    CGPoint starPoint = CGPointMake(SCREEN_WIDTH-33, 64);//弹出的点
    [_popver showAtPoint:starPoint popoverPostion:DXPopoverPositionDown withContentView:_popTableView inView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark UITableView Delegate 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSString *CellIdentifier =[NSString stringWithFormat:@"Ceddddddll%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    RSMedicineDetailMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:RSMedicineDetailVC_Menu];
    if (cell == nil) {
        cell = [[RSMedicineDetailMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RSMedicineDetailVC_Menu];
    }
    menuLsModel *model = _dataSource[indexPath.row];
    cell.selectedBackgroundView.backgroundColor = [UIColor grayColor];
    cell.textString = model.meunName;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    menuLsModel *model = _dataSource[indexPath.row];
    
    NSString *string = [NSString stringWithFormat:@"%@",model.id];
    NSLog(@"选择的id%@",string);
    NSString *js = [NSString stringWithFormat:@"window.location.href = '#%@'",string];
    [self.webView stringByEvaluatingJavaScriptFromString:js];
    
    if (_popver != nil ) {
        [_popver dismiss];
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellW, cellH)];
    
    KYMHLabel *label = [[KYMHLabel alloc] initWithTitle:@" 快速查看菜单" BaseSize:CGRectMake(spaceToLeft, 0, cellW, cellH) LabelColor:nil LabelFont:middleFontSize LabelTitleColor:RiskTypeTitleColor TextAlignment:NSTextAlignmentLeft];
    [headView addSubview:label];
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return cellH;
}


#pragma mark RSRKQuickViewMenuVCDelegate

- (void)menuSelected:(NSString *)string {
    
    NSLog(@"menuSelected");
    NSLog(@"%@",string);
    
    NSString *js = [NSString stringWithFormat:@"window.location.href = '#%@'",string];
    [self.webView stringByEvaluatingJavaScriptFromString:js];
    
    if (_popver != nil ) {
        [_popver dismiss];
    }
}


#pragma mark ViewModel回调

- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result {
    
    
    if ( RSRisk_NS_ENUM_favourate_RISK  == action) {
        if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeSuccess) {
            
            [RSMethod ylg_showSuccessWithStatus:@"收藏成功"];
            _middleButton.selected = YES;
            _model.contentSocail.isFavorite = YES;
            [self changeFavoriteStatus];
        }else {
            [RSMethod ylg_showSuccessWithStatus:result.message];
        }
    }
    
    if ( RSRisk_NS_ENUM_cancelFavourate_RISK == action) {
        if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeSuccess) {
            
            [RSMethod ylg_showSuccessWithStatus:@"已经取消收藏"];
            _model.contentSocail.isFavorite = NO;
            _middleButton.selected = NO;
            [self changeFavoriteStatus];
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
