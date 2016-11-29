//
//  RSDataVC.m
//  Risk
//
//  Created by ylgwhyh on 16/7/3.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSDataVC.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "EFHpple.h"
#import "EFHppleElement.h"
#import "RSRiskViewModel.h"
#import "RSMethod.h"
#import "HTNewsImgModel.h"
#import "EF_AlbumView.h"
#import "HTMovePlayerViewController.h"
#import "HTConfig.h"

@interface RSDataVC ( ) <UIWebViewDelegate, NJKWebViewProgressDelegate,NSURLSessionDataDelegate>

@property ( nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSMutableData *cacheData;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) NSString *theRiskFilePath;

// 网页富文本部分
@property (nonatomic, weak) UIBarButtonItem *backItem;
@property (nonatomic, weak) UIBarButtonItem *forwardItem;
@property (nonatomic, weak) UIBarButtonItem *refreshItem;
@property (nonatomic, strong) NSMutableArray *imgsArray;


@property (nonatomic, strong) RSRiskViewModel * viewModel;

@property (nonatomic, strong) KYMHButton *middleButton;
@property (nonatomic, strong) KYMHButton *rightButton;
@property (nonatomic, strong) KYMHButton *shareButton;
@property (nonatomic, strong) UIView * rightNavView;

@property (nonatomic, strong) RSDataCenterDetailModel *model;

//二维码
@property (nonatomic, strong) UIView * codebackView;
@property (nonatomic, strong) UIImageView  * codeImageView;
@property (nonatomic, strong) UIView * codeImageViewBGView;
@property (nonatomic, strong) UIImageView *frameView;
@property (nonatomic, strong) UIImageView *codeMiddleImage;
@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) KYMHLabel *codeLabel;
@property (nonatomic, strong) KYMHLabel *priceLabel;
@property (nonatomic, strong) NSString * serverAddressURL;

@property (nonatomic,strong)SuccessActionCallBack  callBack;

@property (nonatomic, assign) BOOL isRefresh;

@end

@implementation RSDataVC {
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    CGFloat webViewHeight;
    BOOL isRequest;
}

#define RSHEDetailVC_CodeImageWidth 270
#define MFLoaclDocument @"loaclDocument"

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.rsDataVCRefreshBlock) {
        self.rsDataVCRefreshBlock(_isRefresh);
    }
    
    [SVProgressHUD dismiss];
}

- (instancetype)initWithCallBack:(SuccessActionCallBack)callBack{
    if (self = [super init]) {
        _callBack = callBack;
    }
    return self;
}

- (void) initWebView {
    
    if (nil == _webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.bouncesZoom = YES;
        
        _webView.scalesPageToFit = YES;  //WebView缩放相关
        _webView.multipleTouchEnabled = YES;
        _webView.userInteractionEnabled = YES;
        [_webView setOpaque:NO];
        _webView.backgroundColor = [UIColor clearColor];
        self.webView.hidden = YES;
        self.rightNavView.hidden = YES;
        [self.view addSubview:_webView];
        _progressProxy = [[NJKWebViewProgress alloc] init];
        _webView.delegate = _progressProxy;
        _progressProxy.webViewProxyDelegate = self;
        _progressProxy.progressDelegate = self;
        
        CGFloat progressBarHeight = 2.f;
        CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _progressView.progressBarView.tintColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackDivider];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [_progressView setProgress:0 animated:YES];
    }
    
    isRequest = YES;
    if (YES  == _viewModel.rsDataCenterDetailModel.isFile) {
        if ([UIUtil isNoEmptyStr:_viewModel.rsDataCenterDetailModel.smallRiskFilePath ]) {

            _theRiskFilePath = _viewModel.rsDataCenterDetailModel.smallRiskFilePath;
            
            if ( [UIUtil isEmptyStr:_viewModel.rsDataCenterDetailModel.smallMd5code]) {  //防止后台md5给空值导致崩溃
                isRequest = YES;
            }else {
                NSString *smallMd5code = [MFUserDefaults objectForKey:_viewModel.rsDataCenterDetailModel.smallMd5code];
                if ([smallMd5code isEqualToString:_viewModel.rsDataCenterDetailModel.smallMd5code] ) {
                    isRequest = NO;
                }else {
                    isRequest = YES;
                    [MFUserDefaults setObject:_viewModel.rsDataCenterDetailModel.smallMd5code forKey:_viewModel.rsDataCenterDetailModel.smallMd5code];
                    [MFUserDefaults synchronize];
                }
            }
        }else {
            _theRiskFilePath = _viewModel.rsDataCenterDetailModel.riskFilePath;
            
            if ( [UIUtil isEmptyStr:_viewModel.rsDataCenterDetailModel.md5code]) {  //防止后台md5给空值导致崩溃
                isRequest = YES;
            }else {
                NSString *md5code = [ MFUserDefaults objectForKey:_viewModel.rsDataCenterDetailModel.md5code];
                if ([md5code isEqualToString:_viewModel.rsDataCenterDetailModel.md5code] ) {
                    isRequest = NO;
                }else {
                    isRequest = YES;
                    [MFUserDefaults setObject:_viewModel.rsDataCenterDetailModel.md5code forKey:_viewModel.rsDataCenterDetailModel.md5code];
                    [MFUserDefaults synchronize];
                }
            }
        }
        
        
        //[_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:theRiskFilePath]]];
        
        //找到字符串中的“id=”，然后截取其后的字段
        NSRange range = [_theRiskFilePath rangeOfString:@"/riskfile/"];//匹配得到的下标
        NSString *objectIdStr = [_theRiskFilePath substringFromIndex:(range.location+range.length)];
        objectIdStr = [self cutOutString:objectIdStr];
        NSLog(@"截取的值为：%@",objectIdStr);
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@",MFLoaclDocument,objectIdStr]];
        
        if (YES == isRequest) {
            [self requestDocumentData];
        }else {
            if(![fileManager fileExistsAtPath:filePath]) {//如果不存在
                [self requestDocumentData];
            }else { //存在则直接打开
                NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask ,YES );
                NSString *documentsDirectory = [paths objectAtIndex:0];
                documentsDirectory = [documentsDirectory stringByAppendingString: [NSString stringWithFormat:@"/%@",MFLoaclDocument]];
                NSString *path = [documentsDirectory stringByAppendingPathComponent:objectIdStr];
                [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
            }
        }
    }else {
         [self loadWebContentView:_model];
    }
    
//    if (YES  == _viewModel.rsDataCenterDetailModel.isFile) {
//        NSString *theRiskFilePath;
//        if ([UIUtil isNoEmptyStr:_viewModel.rsDataCenterDetailModel.smallRiskFilePath ]) {
//            theRiskFilePath = _viewModel.rsDataCenterDetailModel.smallRiskFilePath;
//        }else {
//            theRiskFilePath = _viewModel.rsDataCenterDetailModel.riskFilePath;
//        }
//        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:theRiskFilePath]]];
//    }else {
//        [self loadWebContentView:_model];
//    }
}

- (NSString *)cutOutString:(NSString *)string {
    if ([string containsString:@"/"] ) {
        NSRange range = [string rangeOfString:@"/"];//匹配得到的下标
        string = [string substringFromIndex:(range.location+range.length)];
        NSLog(@"截取的值为：%@",string);
        [self cutOutString:string];
    }
    return string;
}


//获取Documents目录
-(NSString *)dirDoc{
    //[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"app_home_doc: %@",documentsDirectory);
    return documentsDirectory;
}

//创建文件夹
-(void )createDir{
    NSString *documentsPath =[self dirDoc];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:MFLoaclDocument];
    // 创建目录
    BOOL res=[fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    if (res) {
        NSLog(@"文件夹创建成功");
    }else
        NSLog(@"文件夹创建失败");
}

- (void)requestDocumentData {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    NSURLSessionDataTask *data = [session dataTaskWithURL:[NSURL URLWithString:_theRiskFilePath]];
    [data resume];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _progressView.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar addSubview:_progressView];
}

- (void ) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initData];
    
    _viewModel = [[RSRiskViewModel alloc]initWithViewController:self];
    
    [SVProgressHUD show];
    [_viewModel findRiskFileById:_objectId];
    
}

- (void)initData {
    NSString *plistPath = nil;
    plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame_" ofType:@"plist"];
    //如果没有创建EasyFrame_.plist文件，那么直接加载框架内部自带的
    if (plistPath == nil) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame" ofType:@"plist"];
    }
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    _serverAddressURL = dictionary[@"ServerAddressURL"];
}

- (void ) initUIWhenRequestDataSuccess {
    [self initWebView];
    [self initNavigateRightView];
    [self changeFavoriteStatus];
    [self changePraisedStatus];
}

- (void ) initNavigateRightView {
    
    if ([_model.fileType isEqualToString:@"RiskFile"]) {
        
        _rightNavView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3*44, 44)];
        
        _middleButton = [self createButton:@"text_collection" imageSelected:@"text_isCollection" action:@selector(middleButtonAction:)];
        _rightButton = [self createButton:@"ic_action_like" imageSelected:@"ic_action_like_press" action:@selector(rightButtonAction:)];
        [_rightButton setTitle:[RSMethod ylg_returnPraisedCountString:_model.contentSocail.praisedCount] forState:UIControlStateNormal];
        [_rightButton horizontalCenterImageAndTitle];
        
        NSArray *views = @[ _middleButton, _rightButton];
        [_rightNavView sd_addSubviews:views];
        
        UIView *contentView = _rightNavView;
        
        CGFloat btnH = 34;
        
        _rightButton.sd_layout
        .topSpaceToView(contentView,5)
        .rightSpaceToView(contentView, 0)
        .widthIs (btnH)
        .heightIs(btnH);
        
        _middleButton.sd_layout
        .topEqualToView(_rightButton)
        .rightSpaceToView(_rightButton, 5)
        .widthIs (btnH)
        .heightIs(btnH);
        
        UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_rightNavView];
        
        self.navigationItem.rightBarButtonItem = barBtnItem;
        
    }else {
        UIView * rightNavView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3*44, 44)];
        
        _middleButton = [self createButton:@"text_collection" imageSelected:@"text_isCollection" action:@selector(middleButtonAction:)];
        _rightButton = [self createButton:@"ic_action_like" imageSelected:@"ic_action_like_press" action:@selector(rightButtonAction:)];
        _shareButton = [self createButton:@"text_share" imageSelected:@"text_share" action:@selector(shareButtonAction)];
        [_rightButton setTitle:[RSMethod ylg_returnPraisedCountString:_model.contentSocail.praisedCount] forState:UIControlStateNormal];
        [_rightButton horizontalCenterImageAndTitle];
        
        NSArray *views = @[ _middleButton, _rightButton,_shareButton];
        [rightNavView sd_addSubviews:views];
        
        UIView *contentView = rightNavView;
        
        CGFloat btnH = 34;
        
        _shareButton.sd_layout
        .topSpaceToView(contentView,5)
        .rightSpaceToView(contentView, 5)
        .widthIs (btnH)
        .heightIs(btnH);
        
        _rightButton.sd_layout
        .topEqualToView(_shareButton)
        .rightSpaceToView(_shareButton, 5)
        .widthIs (btnH)
        .heightIs(btnH);
        
        _middleButton.sd_layout
        .topEqualToView(_rightButton)
        .rightSpaceToView(_rightButton, 5)
        .widthIs (btnH)
        .heightIs(btnH);
        
        UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavView];
        
        self.navigationItem.rightBarButtonItem = barBtnItem;
    }
}

#pragma mark LoadWebContentView

- (void)loadWebContentView:(RSDataCenterDetailModel *)model{
    
    //点击可查看webView页面中的图片
    [self loadWebImaegs:model.riskFileContent];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    NSString *htmlcontent = model.riskFileContent;
    
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
    
    return YES;
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    // 允许处理服务器的响应，才会继续接收服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);
    self.cacheData = [NSMutableData data];
}

-  (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    //下载过程中
    [self.cacheData appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    //    下载完成之后的处理
    
    if (error) {
        
    } else {
        
        //        UIImage *image = [UIImage imageWithData:self.cacheData];
        //        UIImageView *imav = [[UIImageView alloc] init];
        //        imav.frame = CGRectMake(10, 10, 100, 100);
        //        imav.image = image;
        //        [self.view addSubview:imav];
        //将数据的缓存归档存入到本地文件中
        
        NSURL *baseUrl = [NSURL URLWithString:_theRiskFilePath]; //仅仅为了让下面没警告
        if([_theRiskFilePath hasSuffix:@".pdf"]) {
            [self.webView loadData:self.cacheData MIMEType:@"application/pdf" textEncodingName:@"UTF-8" baseURL:baseUrl];
        }else if([_theRiskFilePath hasSuffix:@".ppt"]  ) {
            [self.webView loadData:self.cacheData MIMEType:@"application/ppt" textEncodingName:@"UTF-8" baseURL:baseUrl];
        }else if ([_theRiskFilePath hasSuffix:@".pptx"] ) {
            [self.webView loadData:self.cacheData MIMEType:@"application/pptx" textEncodingName:@"UTF-8" baseURL:baseUrl];
        }else if([_theRiskFilePath hasSuffix:@".doc"] || [_theRiskFilePath hasSuffix:@".docx"]){
            [self.webView loadData:self.cacheData MIMEType:@"application/vnd.openxmlformats-officedocument.wordprocessingml.document" textEncodingName:@"UTF-8" baseURL:baseUrl];
        }else {
            [self.webView loadData:self.cacheData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:baseUrl];
        }
        
        [self createDir]; //创建一个文件夹保存pdf、doc、ppt等文件
        
        //找到字符串中的“id=”，然后截取其后的字段
        NSRange range = [_theRiskFilePath rangeOfString:@"/riskfile/"];//匹配得到的下标
        NSString *objectIdStr = [_theRiskFilePath substringFromIndex:(range.location+range.length)];
        NSLog(@"截取的值为：%@",objectIdStr);
        //移除文件名之前所有的字段
        objectIdStr = [self cutOutString:objectIdStr];
        
        // 获取沙盒目录
        NSString *filePath = [[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",MFLoaclDocument]] stringByAppendingPathComponent:objectIdStr];
        [self.cacheData writeToFile:filePath atomically:YES];
    }
}

#pragma mark button Action

- (void ) middleButtonAction: (UIButton *)button {
    
    if ( (NO == button.selected) &&  (NO ==_model.contentSocail.isFavorite ) ) {
        
        [RSMethod ylg_SVProgressHUD_showWithSVProgressHUDMaskTypeNone];
        [self.viewModel favourate:_model.objectId];
        
    }else if  ( (YES == button.selected ) &&  (YES ==_model.contentSocail.isFavorite ) ) {
        
        [RSMethod ylg_SVProgressHUD_showWithSVProgressHUDMaskTypeNone];
        [self.viewModel cancelFavourite:_model.objectId];
    }
    
}

- (void ) changeFavoriteStatus {
    
    if (_model.contentSocail.isFavorite) { //被收藏
        _middleButton.selected = YES;
    }else {
        _middleButton.selected = NO;
    }
}

- (void ) changePraisedStatus {
    
    if (_model.contentSocail.isPraise) { //被点赞
        _rightButton.selected = YES;
    }else {
        _rightButton.selected = NO;
    }
    
    [_rightButton setTitle:[RSMethod ylg_returnPraisedCountString:_model.contentSocail.praisedCount] forState:UIControlStateNormal];
}

- (void ) rightButtonAction: (UIButton *)button {
    
    if ( (NO == button.selected) &&  (NO ==_model.contentSocail.isPraise ) ) {
        
        [RSMethod ylg_SVProgressHUD_showWithSVProgressHUDMaskTypeNone];
        [self.viewModel praise:_model.objectId];
        
    }else if  ( (YES == button.selected ) &&  (YES ==_model.contentSocail.isPraise ) ) {
        
        [RSMethod ylg_SVProgressHUD_showWithSVProgressHUDMaskTypeNone];
        [self.viewModel cancelPraise:_model.objectId];
    }
}

//生成二维码
- (void)shareButtonAction {
    if (_codebackView == nil) {
        _codebackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _codebackView.backgroundColor = RGBAColor(177 , 182, 187, 0.7);
        [self.view addSubview:_codebackView];
        
        _codeImageViewBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RSHEDetailVC_CodeImageWidth, RSHEDetailVC_CodeImageWidth)];
        _codeImageViewBGView.backgroundColor = [UIColor whiteColor];
        _codeImageViewBGView.center = _codebackView.center;
        _codeImageViewBGView.layer.shadowOffset=CGSizeMake(0, 0.5);//设置阴影的偏移量
        _codeImageViewBGView.layer.shadowRadius=1;//设置阴影的半径
        _codeImageViewBGView.layer.shadowColor=[UIColor blackColor].CGColor;//设置阴影的颜色为黑色
        _codeImageViewBGView.layer.shadowOpacity=0.3;
        [_codebackView addSubview:_codeImageViewBGView];
        
        _codeButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 300, 50, 50)];
        [_codeButton setImage:Img(@"close") forState:UIControlStateNormal];
        [_codeButton addTarget:self action:@selector(testButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_codeImageViewBGView addSubview:_codeButton];
        _codeButton.sd_layout
        .topSpaceToView(_codeImageViewBGView, 5)
        .rightSpaceToView(_codeImageViewBGView, 5)
        .widthIs(40)
        .heightIs(40);
        
        _frameView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, RSHEDetailVC_CodeImageWidth * 0.7 , RSHEDetailVC_CodeImageWidth * 0.7 )];
        _frameView.backgroundColor = [UIColor whiteColor];
        _frameView.layer.cornerRadius = 10;
        [_frameView.layer setMasksToBounds:YES];
        //如果还想加上阴影，就在ImageView的Layer上使用下面代码添加阴影
        CALayer * layer = [_frameView layer];
        UIColor *frameViewBorderColor = RGBColor(214, 214, 214);
        layer.borderColor = [frameViewBorderColor CGColor];
        layer.borderWidth = 1.0f;
        _frameView.layer.shadowOffset=CGSizeMake(0, 0.5);//设置阴影的偏移量
        _frameView.layer.shadowRadius=1;//设置阴影的半径
        _frameView.layer.shadowColor=[UIColor blackColor].CGColor;//设置阴影的颜色为黑色
        _frameView.layer.shadowOpacity=0.3;
        
        [_codeImageViewBGView addSubview:_frameView];
        _frameView.sd_layout
        .topSpaceToView (_codeImageViewBGView, 40)
        .leftSpaceToView (_codeImageViewBGView, 50)
        .rightSpaceToView (_codeImageViewBGView, 50)
        .bottomSpaceToView (_codeImageViewBGView, 65);
        
        UIColor *labelColor = [UIColor whiteColor];
        UIColor *labelTitleColor = RGBColor(100,99,97);
        
        NSString * priceStr = [NSString stringWithFormat:@"您需要支付：¥%.2f",_model.price];
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
        
        NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:11.0],NSFontAttributeName,nil];
        [attributedStr addAttributes:attributeDict range:NSMakeRange(0, 6)];
        
        _priceLabel = [[KYMHLabel alloc] init];
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.textColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackNormal];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.font = Font(15);
        if (_model.price <= 0) {
            _priceLabel.text = @"免费";
        }else {
            _priceLabel.attributedText = attributedStr;
        }
        [_codeImageViewBGView addSubview:_priceLabel];
        _priceLabel.sd_layout
        .centerXEqualToView(_frameView)
        .topSpaceToView(_frameView, 5)
        .heightIs(30)
        .widthIs(200);
        
        _codeLabel  = [[KYMHLabel alloc] initWithTitle:@"微信扫描二维码获取资料"BaseSize:CGRectMake(0, 0, 0, 0) LabelColor:labelColor LabelFont:15 LabelTitleColor:labelTitleColor TextAlignment:NSTextAlignmentCenter];
        [_codeImageViewBGView addSubview:_codeLabel];
        _codeLabel.sd_layout
        .centerXEqualToView(_frameView)
        .topSpaceToView(_priceLabel, 5)
        .heightIs(20)
        .widthIs(200);
        
        _codeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, RSHEDetailVC_CodeImageWidth*0.65, RSHEDetailVC_CodeImageWidth*0.65)];
        _codeImageView.center = _codeImageViewBGView.center;
        _codeImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_frameView addSubview:_codeImageView];
        CGFloat spaceToTop = 12;
        _codeImageView.sd_layout
        .topSpaceToView(_frameView,spaceToTop)
        .leftSpaceToView(_frameView,spaceToTop)
        .rightSpaceToView(_frameView,spaceToTop)
        .bottomSpaceToView(_frameView,spaceToTop);
        
        _codeMiddleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, RSHEDetailVC_CodeImageWidth, RSHEDetailVC_CodeImageWidth)];
        _codeMiddleImage.hidden = YES;
        [_codeMiddleImage setImage:Img(@"erWeiMa")];
        [_codeImageView addSubview:_codeMiddleImage];
        _codeMiddleImage.sd_layout
        .centerXEqualToView(_codeImageView)
        .centerYEqualToView(_codeImageView)
        .widthIs(35)
        .heightIs(35);
        _codeMiddleImage.layer.cornerRadius = 7;
        [_codeMiddleImage.layer setMasksToBounds:YES];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo:)];
        [_codebackView addGestureRecognizer:tapGesture];
        
        [self setCodeImage];
    }
    _codebackView.hidden = NO;
}

- (void ) testButtonAction {
    _codebackView.hidden = YES;
}


- (void)Actiondo:(UIGestureRecognizer *)_sender {
    _codebackView.hidden = YES;
}

- (void)setCodeImage {
    // 1.创建过滤器
    CIFilter * filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
    
    // 3.给过滤器添加数据
    
    NSString *codeString;
    if ([UIUtil isNoEmptyStr:_model.smallRiskFilePath ]) {
        codeString = _model.smallRiskFilePath;
    }else {
        codeString = _model.riskFilePath;
    }
    
    
    NSString * dataString = [NSString stringWithFormat:@"%@",codeString];
    
    if ([UIUtil isNoEmptyStr:_model.smallRiskFilePath]) {
        if (_model.price <= 0) {
            dataString = [NSString stringWithFormat:@"%@",_model.smallRiskFilePath];
        }else {
            dataString = [NSString stringWithFormat:@"https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxe8a9badfdb018eec&redirect_uri=%@/riskshop/payIndex?id=%d&state=%d&response_type=code&scope=snsapi_userinfo#wechat_redirect",_serverAddressURL,(int)_model.objectId,(int)[UserModel ShareUserModel].objectId];
        }
    }else {
        if (_model.price <= 0) {
            dataString = [NSString stringWithFormat:@"%@",_model.riskFilePath];
        }else {
            dataString = [NSString stringWithFormat:@"https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxe8a9badfdb018eec&redirect_uri=%@/riskshop/payIndex?id=%d&state=%d&response_type=code&scope=snsapi_userinfo#wechat_redirect",_serverAddressURL,(int)_model.objectId,(int)[UserModel ShareUserModel].objectId];
        }
    }
    
    NSData * data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    
    [filter setValue:data forKey:@"inputMessage"];
    
    // 4.获取输出的二维码
    CIImage * outPutImage = [filter outputImage];
    
    _codeImageView.image =  [self createNonInterpolatedUIImageFormCIImage:outPutImage withSize:200];
    _codeMiddleImage.hidden = NO;
}

/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


#pragma mark createUI
- (KYMHButton * ) createButton:(NSString *)imageNormal imageSelected:(NSString *) imageSelected action:(SEL)action {
    
    KYMHButton * btn= [KYMHButton new];
    [btn setImage:Img(imageNormal) forState:UIControlStateNormal];
    [btn setImage:Img(imageSelected) forState:UIControlStateSelected];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

#pragma mark webViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
    //...........................省略其他无关代码
    self.webView.hidden = NO;
    self.rightNavView.hidden = NO;
    
    self.backItem.enabled = webView.canGoBack;
    self.forwardItem.enabled = webView.canGoForward;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    NSString *str = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",(int)([HTConfig getFontPercentage] * 100)];
//    [webView stringByEvaluatingJavaScriptFromString:str];
//    
//    [webView stringByEvaluatingJavaScriptFromString:
//     @"var script = document.createElement('script');"
//     "script.type = 'text/javascript';"
//     "script.text = \"function ResizeImages() { "
//     "for(i=0;i < document.images.length;i++){"
//     "var myimg = document.images[i];var touchopen = 1;"
//     "myimg.style.width = '100%';"
//     "myimg.style.height = '';"
//     "var imagelink = document.createElement('a');"
//     "imagelink.href=myimg.src;"
//     "var imageparent = myimg.parentNode;"
//     "if(imageparent.tagName!='A'){"
//     "imageparent.insertBefore(imagelink,myimg);"
//     "imagelink.appendChild(myimg);}"
//     "}"
//     "}\";"
//     "document.getElementsByTagName('head')[0].appendChild(script);"];
//    
//    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
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
    
    self.webView.hidden = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD showProgress:1.0 status:@""];
    [UIUtil alert:@"加载内容失败"];
    isRequest = YES;
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    NSLog(@"加载进度------%f",progress);
    NSString *str = [NSString stringWithFormat:@"%.0f%%",progress * 100.00];
    [SVProgressHUD showProgress:progress status:str];
}

#pragma mark 网络回调
- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result {
    if (action == RSRisk_NS_ENUM_findRiskFileById) {
        if (result.status == 200) {
            if (_viewModel.rsDataCenterDetailModel) {
                _model = [[RSDataCenterDetailModel alloc]init];
                _model = _viewModel.rsDataCenterDetailModel;
                [self initUIWhenRequestDataSuccess];
                
            }else {
                NSLog(@"没有数据");
            }
        }else {
            NSLog(@"请求失败");
        }
    }
    
    if ( RSRisk_NS_ENUM_favourate  == action) {
        if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeSuccess) {
            
            [RSMethod ylg_showSuccessWithStatus:@"收藏成功"];
            _middleButton.selected = YES;
            _model.contentSocail.isFavorite = YES;
            [self changeFavoriteStatus];
            _isRefresh = YES;
        }else {
            [SVProgressHUD dismiss];
        }
    }
    
    if ( RSRisk_NS_ENUM_cancelFavourite == action) {
        if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeSuccess) {
            
            [RSMethod ylg_showSuccessWithStatus:@"已经取消收藏"];
            _model.contentSocail.isFavorite = NO;
            _middleButton.selected = NO;
            [self changeFavoriteStatus];
            _isRefresh = YES;
        }else {
            [SVProgressHUD dismiss];
        }
    }
    
    if ( RSRisk_NS_ENUM_praise  == action) {
        if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeSuccess) {
            
            [RSMethod ylg_showSuccessWithStatus:@"点赞成功"];
            _rightButton.selected = YES;
            _model.contentSocail.isPraise = YES;
            _model.contentSocail.praisedCount += 1;
            [self changePraisedStatus];
        }else {
            [SVProgressHUD dismiss];
        }
    }
    
    if ( RSRisk_NS_ENUM_cancelPraise == action) {
        if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeSuccess) {
            
            [RSMethod ylg_showSuccessWithStatus:@"已经取消点赞"];
            _model.contentSocail.isPraise = NO;
            _rightButton.selected = NO;
            _model.contentSocail.praisedCount -= 1;
            [self changePraisedStatus];
        }else {
            [SVProgressHUD dismiss];
        }
    }
}

- (void)dealloc {
    
    [SVProgressHUD dismiss];
    if (_viewModel) {
        [_viewModel cancelAndClearAll];
        _viewModel = nil;
    }
    
    if (_callBack) {
        _callBack(YES);
        _callBack = nil;
    }
    
}

@end
