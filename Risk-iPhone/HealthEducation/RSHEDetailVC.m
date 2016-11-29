//
//  RSHEDetailVC.m
//  Risk
//
//  Created by ylgwhyh on 16/7/14.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSHEDetailVC.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "RSMethod.h"
#import "UIImageView+CornerRadius.h"
#import "RSRiskViewModel.h"
#import "LBXScanWrapper.h"
#import <ZYCornerRadius/UIImageView+CornerRadius.h>

@interface RSHEDetailVC () <UIWebViewDelegate, NJKWebViewProgressDelegate>

@property ( nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) RSRiskViewModel * viewModel;
@property (nonatomic, strong) KYMHButton *middleButton;
@property (nonatomic, strong) KYMHButton *rightButton;
@property (nonatomic, strong) KYMHButton *shareButton;

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

@end

@implementation RSHEDetailVC {
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}

#define RSHEDetailVC_CodeImageWidth 270

- (instancetype)initWithCallBack:(SuccessActionCallBack)callBack{
    if (self = [super init]) {
        _callBack = callBack;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    NSString *plistPath = nil;
    plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame_" ofType:@"plist"];
    //如果没有创建EasyFrame_.plist文件，那么直接加载框架内部自带的
    if (plistPath == nil) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame" ofType:@"plist"];
    }
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    _serverAddressURL = dictionary[@"ServerAddressURL"];
    
    
    _viewModel = [[RSRiskViewModel alloc]initWithViewController:self];
    [_viewModel findRiskFileById:_objectId];
    
}

- (void)initData {
    
}


- (void) initUI {
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.scrollView.bouncesZoom = YES;
    
    _webView.scalesPageToFit = YES;  //WebView缩放相关
    _webView.multipleTouchEnabled = YES;
    _webView.userInteractionEnabled = YES;
    
    [self.view addSubview:_webView];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.progressBarView.backgroundColor = [UIColor clearColor];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    NSString *theRiskFilePath;
    if ([UIUtil isNoEmptyStr:_model.smallRiskFilePath ]) {
        theRiskFilePath = _model.smallRiskFilePath;
    }else {
        theRiskFilePath = _model.riskFilePath;
    }
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:theRiskFilePath]]];
}

- (void ) initUIWhenRequestDataSuccess {
    [self initUI];
    [self initNavigateRightView];
    [self changeFavoriteStatus];
    [self changePraisedStatus];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}

- (void ) initNavigateRightView {
    
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


//- (void)shareButtonAction {
//    if (_codebackView == nil) {
//        _codebackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        _codebackView.backgroundColor = RGBAColor(0, 0, 0, 0.7);
//        [self.view addSubview:_codebackView];
//        
//        _codeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, RSHEDetailVC_CodeImageWidth, RSHEDetailVC_CodeImageWidth)];
//        _codeImageView.center = _codebackView.center;
//        _codeImageView.contentMode = UIViewContentModeScaleAspectFit;
//        [_codebackView addSubview:_codeImageView];
//        
//        //如果还想加上阴影，就在ImageView的Layer上使用下面代码添加阴影
//        _codeImageView.layer.shadowOffset=CGSizeMake(0, 0.5);//设置阴影的偏移量
//        _codeImageView.layer.shadowRadius=1;//设置阴影的半径
//        _codeImageView.layer.shadowColor=[UIColor blackColor].CGColor;//设置阴影的颜色为黑色
//        _codeImageView.layer.shadowOpacity=0.3;
//        
//        
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo:)];
//        [_codebackView addGestureRecognizer:tapGesture];
//        
//        [self setCodeImage];
//    }
//    _codebackView.hidden = NO;
//}

- (void)setCodeImage {
    // 1.创建过滤器
    CIFilter * filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
    
    // 3.给过滤器添加数据
    NSString * dataString = @"";
    
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

    _codebackView.hidden = NO;
    _codeImageView.image = [LBXScanWrapper createQRWithString:dataString size:_codeImageView.bounds.size];
    
    NSData * data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    
    [filter setValue:data forKey:@"inputMessage"];
    
    // 4.获取输出的二维码
    CIImage * outPutImage = [filter outputImage];
    _codeImageView.image =  [self createNonInterpolatedUIImageFormCIImage:outPutImage withSize:RSHEDetailVC_CodeImageWidth];
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

- (void)Actiondo:(UIGestureRecognizer *)_sender {
    _codebackView.hidden = YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"开始");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"完成");
    [SVProgressHUD dismiss];
    //...........................省略其他无关代码
    self.webView.hidden = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD showProgress:1.0 status:@""];
    [UIUtil alert:@"加载内容失败"];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    [_progressView setProgress:progress animated:YES];
    NSString *str = [NSString stringWithFormat:@"%.0f%%",progress * 100.00];
    [SVProgressHUD showProgress:progress status:str];
    //self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"]; //暂时不需要
}


- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result {
    if (action == RSRisk_NS_ENUM_findRiskFileById) {
        if (result.status == 200) {
            if (_viewModel.rsDataCenterDetailModel) {
                _model = self.viewModel.rsDataCenterDetailModel;
                [self initUIWhenRequestDataSuccess];
            }else {
                NSLog(@"没有数据");
            }
        }else {
            NSLog(@"请求失败");
        }
        [SVProgressHUD dismiss];
    }
    
    if ( RSRisk_NS_ENUM_favourate  == action) {
        if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeSuccess) {
            
            
            [RSMethod ylg_showSuccessWithStatus:@"收藏成功"];
            _middleButton.selected = YES;
            _model.contentSocail.isFavorite = YES;
            [self changeFavoriteStatus];
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
