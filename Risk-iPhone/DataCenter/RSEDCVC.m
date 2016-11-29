//
//  RSEDCVC.m
//  Risk
//
//  Created by Cherie Jeong on 16/8/5.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSEDCVC.h"


@interface RSEDCVC () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView * webView;
@property (nonatomic, strong) NSString * serverAddressURL;

@end

@implementation RSEDCVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _titleStr;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (_serverAddressURL == nil) {
        NSString *plistPath = nil;
        plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame_" ofType:@"plist"];
        //如果没有创建EasyFrame_.plist文件，那么直接加载框架内部自带的
        if (plistPath == nil) {
            plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame" ofType:@"plist"];
        }
        NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        _serverAddressURL = dictionary[@"ServerAddressURL"];
    }
    
    [self setupWebView];
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
    
    //    [self.webView loadHTMLString:_htmlString baseURL:nil];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",_serverAddressURL,_webURL]]]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD dismiss];
}

-(void)dealloc {
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}


@end
