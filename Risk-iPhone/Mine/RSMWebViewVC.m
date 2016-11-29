//
//  RSMWebViewVC.m
//  Risk
//
//  Created by ylgwhyh on 16/7/19.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSMWebViewVC.h"

//待删除
#import "RSVAArchivesModel.h"
#import "EFHpple.h"
#import "EFHppleElement.h"
#import "HTNewsImgModel.h"
#import "EF_AlbumView.h"
#import "HTMovePlayerViewController.h"
#import "SVWebViewController.h"
#import "HTConfig.h"
#import "SVProgressHUD.h"

#import "RSRiskViewModel.h"

@interface RSMWebViewVC () <UIWebViewDelegate>

// 网页富文本部分
@property (nonatomic, weak) UIBarButtonItem *backItem;
@property (nonatomic, weak) UIBarButtonItem *forwardItem;
@property (nonatomic, weak) UIBarButtonItem *refreshItem;
@property (nonatomic, strong) NSMutableArray *imgsArray;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) RSVAArchivesModel *htmlModel;

@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString * htmlString;

@property (nonatomic, copy) NSString * serverAddressURL;

@property (nonatomic, strong)RSRiskViewModel * viewModel;

@end

@implementation RSMWebViewVC {
    CGFloat webViewHeight;
}


- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        _titleString = [title copy];
        [self initData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initData {
    
    self.title = _titleString;
    _viewModel = [[RSRiskViewModel alloc] initWithViewController:self];
    
    
    if ([_titleString isEqualToString:@"专家点评"]) {
        [_viewModel getStaticViewUrlWithPath:@"findProfessorCommentStaticPage"];
    }else if ([_titleString isEqualToString:@"广告服务"]) {
        [_viewModel getStaticViewUrlWithPath:@"findADsStaticPage"];
    }else if ([_titleString isEqualToString:@"专家团队"]) {
        [_viewModel getStaticViewUrlWithPath:@"findDoctorStaticPage"];
    }else if ([_titleString isEqualToString:@"关于我们"]) {
        [_viewModel getStaticViewUrlWithPath:@"findfindAboutUsStaticPage"];
    }else if ([_titleString isEqualToString:@"大事记"]) {
        [_viewModel getStaticViewUrlWithPath:@"findTimeLineStaticPage"];
    }else if ([_titleString isEqualToString:@"更新记录"]) {
        [self setupWebView];
        [self loadHTMLFile];
    }
}

-(void)loadHTMLFile{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *basePath = [NSString stringWithFormat:@"%@/LocalHtml",path];
    
    NSURL *baseURL = [NSURL fileURLWithPath:basePath isDirectory:YES];
    NSString * htmlPath = [NSString stringWithFormat:@"%@/time-line.html",basePath];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [self.webView loadHTMLString:htmlCont baseURL:baseURL];
}

#pragma mark 订单

- (void)setupMainWebView {
    
    [self setupWebView];
    //    [self.webView loadHTMLString:_htmlString baseURL:nil];
    NSLog(@"htmlString=%@",_htmlString);
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_htmlString]]];
}

- (void)setupWebView {
    if(_webView == nil){
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        
        _webView.scrollView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.alwaysBounceHorizontal = YES;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.bouncesZoom = NO;
        _webView.scrollView.bounces = NO;
        _webView.dataDetectorTypes = UIDataDetectorTypeNone;
        
        [self.view addSubview:_webView];
    }
}


#pragma mark LoadWebContentView

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"加载成功");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD dismiss];
     NSLog(@"error-----%@",error);
}

#pragma mark 网络回调

- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result {
    if (action == RSRisk_NS_ENUM_getStaticViewPath) {
        if (result.status == 200) {
            _htmlString = _viewModel.path;
            if (![UIUtil isEmptyStr:_htmlString]) {
                [self setupMainWebView];
            }else {
                NSLog(@"没拿到地址");
            }
        }
    }
}

-(void)dealloc {
    if (_viewModel) {
        [_viewModel cancelAndClearAll];
        _viewModel = nil;
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end
