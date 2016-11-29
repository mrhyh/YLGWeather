//
//  RSVideoVC.m
//  Risk-iPhone
//
//  Created by Cherie Jeong on 16/8/29.
//  Copyright © 2016年 Cherie Jeong. All rights reserved.
//

#import "RSVideoVC.h"
#import "WMPlayer.h"
#import "RSRiskViewModel.h"
#import "RSMethod.h"
#import "SVProgressHUD.h"
#import "RSDataCenterDetailModel.h"
#import "AppDelegate.h"
#import "LBXScanWrapper.h"
#import <ZYCornerRadius/UIImageView+CornerRadius.h>

@interface RSVideoVC ()<WMPlayerDelegate>{
    WMPlayer  *wmPlayer;
    CGRect     playerFrame; //全屏
//    CGRect     minFrame;
    CGFloat    minH;
}

@property (nonatomic, strong) KYMHButton *middleButton;
@property (nonatomic, strong) KYMHButton *rightButton;
@property (nonatomic, strong) KYMHButton *shareButton;

@property (nonatomic, strong) RSRiskViewModel *viewModel;

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

@implementation RSVideoVC{

}

#define RSHEDetailVC_CodeImageWidth 350

- (instancetype)initWithCallBack:(SuccessActionCallBack)callBack{
    if (self = [super init]) {
        _callBack = callBack;
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.rsVideoVCRefreshBlock) {
        self.rsVideoVCRefreshBlock(_isRefresh);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;

    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *plistPath = nil;
    plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame_" ofType:@"plist"];
    //如果没有创建EasyFrame_.plist文件，那么直接加载框架内部自带的
    if (plistPath == nil) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame" ofType:@"plist"];
    }
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    _serverAddressURL = dictionary[@"ServerAddressURL"];
    
    [self initData];
    [self requestData];
    
}

- (void ) initUIWhenRequestDataSuccess {
    [self initUI];
    [self changeFavoriteStatus];
    [self changePraisedStatus];
}

#pragma mark Request Data

- (void ) requestData {
    [RSMethod ylg_SVProgressHUD_showWithSVProgressHUDMaskTypeNone];
    [self.viewModel findRiskFileById:self.objectId];
}
- (void ) initData {
//    spaceToLeft = 50;
//    spaceToTop = 30;
//    minH = SCREEN_HEIGHT - 64 - 64 *3;
    _viewModel = [[RSRiskViewModel alloc] initWithViewController:self];
}

- (void ) initUI {
    [self initwmPlayer];
    [self initNavigateRightView];
}

- (void ) initwmPlayer {
    self.view.backgroundColor = RGBColor(45, 41, 38);
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    
    
    playerFrame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
//    minFrame = CGRectMake(3*spaceToLeft, (SCREEN_HEIGHT-minH-64)/2+64, (SCREEN_WIDTH-6*spaceToLeft), minH);
    wmPlayer = [[WMPlayer alloc]initWithFrame:playerFrame];
   
    wmPlayer.backgroundColor = RGBColor(45, 41, 38);
    wmPlayer.topView.hidden = NO;
    wmPlayer.isFullscreen = YES;
    wmPlayer.delegate = self;
    wmPlayer.fullScreenBtn.hidden = YES;
    
    NSString *videoString;
    if ([UIUtil isNoEmptyStr: self.model.smallRiskFilePath ]) {
        videoString = self.model.smallRiskFilePath;
    }else {
        videoString = self.model.riskFilePath;
    }
    wmPlayer.URLString = videoString;
    wmPlayer.closeBtn.hidden = NO;
    
    [self fullScreen];
    
    [self.view addSubview:wmPlayer];
    [wmPlayer play];
}

#pragma mark --- 播放器设置代理
-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)fullScreen {
    wmPlayer.transform = CGAffineTransformIdentity;
    
    wmPlayer.transform = CGAffineTransformMakeRotation((90 * M_PI) / 180.0f);
    
    wmPlayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    wmPlayer.playerLayer.frame =  CGRectMake(0,0, kScreenHeight,kScreenWidth);
    
    [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(kScreenWidth-40);
        make.width.mas_equalTo(kScreenHeight);
    }];
    [wmPlayer.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.left.equalTo(wmPlayer).with.offset(0);
        make.width.mas_equalTo(kScreenHeight);
    }];
    [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wmPlayer.topView).with.offset(5);
        make.height.mas_equalTo(30);
        make.top.equalTo(wmPlayer.topView).with.offset(5);
        make.width.mas_equalTo(30);
    }];
    [wmPlayer.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wmPlayer.topView).with.offset(45);
        make.right.equalTo(wmPlayer.topView).with.offset(-45);
        make.center.equalTo(wmPlayer.topView);
        make.top.equalTo(wmPlayer.topView).with.offset(0);
        
    }];
    [wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenHeight);
        make.center.mas_equalTo(CGPointMake(kScreenWidth/2-36, -(kScreenWidth/2)+36));
        make.height.equalTo(@30);
    }];
    [wmPlayer.loadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointMake(kScreenWidth/2-37, -(kScreenWidth/2-37)));
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:wmPlayer];
    wmPlayer.fullScreenBtn.selected = YES;
    [wmPlayer bringSubviewToFront:wmPlayer.bottomView];
}

- (void ) initNavigateRightView {
    if ([_model.fileType isEqualToString:@"RiskFile"]) {
        
        UIView * rightNavView= [[UIView alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT-(3*44+20), 0, 3*44, 44)];
        _middleButton = [self createButton:@"text_collection" imageSelected:@"text_isCollection" action:@selector(middleButtonAction:)];
        _rightButton = [self createButton:@"ic_action_like" imageSelected:@"ic_action_like_press" action:@selector(rightButtonAction:)];
        [_rightButton setTitle:[RSMethod ylg_returnPraisedCountString:_model.contentSocail.praisedCount] forState:UIControlStateNormal];
        [_rightButton horizontalCenterImageAndTitle];
        
        [wmPlayer.topView addSubview:rightNavView];
        
        NSArray *views = @[ _middleButton, _rightButton];
        [rightNavView sd_addSubviews:views];
        
        UIView *contentView = rightNavView;
        
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
        
//        UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavView];
//        self.navigationItem.rightBarButtonItem = barBtnItem;
        
    }else {
        UIView * rightNavView= [[UIView alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT-(5*44+20), 0, 5*44, 44)];
        
        _middleButton = [self createButton:@"text_collection" imageSelected:@"text_isCollection" action:@selector(middleButtonAction:)];
        _rightButton = [self createButton:@"ic_action_like" imageSelected:@"ic_action_like_press" action:@selector(rightButtonAction:)];
        _shareButton = [self createButton:@"text_share" imageSelected:@"text_share" action:@selector(shareButtonAction)];
        [_rightButton setTitle:[RSMethod ylg_returnPraisedCountString:_model.contentSocail.praisedCount] forState:UIControlStateNormal];
        [_rightButton horizontalCenterImageAndTitle];
        
        
        [wmPlayer.topView addSubview:rightNavView];
        
        NSArray *views = @[ _middleButton, _rightButton,_shareButton];
        [rightNavView sd_addSubviews:views];
        
        UIView *contentView = rightNavView;
        
        CGFloat btnH = 34;
        
        _shareButton.sd_layout
        .topSpaceToView(contentView,5)
        .rightSpaceToView(contentView, 0)
        .widthIs (btnH)
        .heightIs(btnH);
        
        _rightButton.sd_layout
        .topEqualToView(_shareButton)
        .rightSpaceToView(_shareButton, 5)
        .widthIs (btnH+20)
        .heightIs(btnH);
        
        _middleButton.sd_layout
        .topEqualToView(_rightButton)
        .rightSpaceToView(_rightButton, 5)
        .widthIs (btnH)
        .heightIs(btnH);
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
        CGAffineTransform transform =CGAffineTransformMakeRotation(M_PI/2);
        [_codeImageViewBGView setTransform:transform];
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
        CGFloat codeSpaceToTop = 12;
        _codeImageView.sd_layout
        .topSpaceToView(_frameView,codeSpaceToTop)
        .leftSpaceToView(_frameView,codeSpaceToTop)
        .rightSpaceToView(_frameView,codeSpaceToTop)
        .bottomSpaceToView(_frameView,codeSpaceToTop);
        
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
//        _codeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 270, 270)];
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
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo:)];
//        [_codebackView addGestureRecognizer:tapGesture];
//        
//        [self setCodeImage];
//    }
//    _codebackView.hidden = NO;
//}

- (void)Actiondo:(UIGestureRecognizer *)_sender {
    _codebackView.hidden = YES;
}

- (void)setCodeImage {
    // 1.创建过滤器
    CIFilter * filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
    
    // 3.给过滤器添加数据
    NSString * dataString = @"";
    
    if ([UIUtil isNoEmptyStr:_model.smallRiskFilePath])  {
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

//- (void)setCodeImage {
//    // 1.创建过滤器
//    CIFilter * filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
//    // 2.恢复默认
//    [filter setDefaults];
//    
//    // 3.给过滤器添加数据
//    NSString * dataString = [NSString stringWithFormat:@"%@",_model.riskFilePath];
//    NSData * data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
//    
//    [filter setValue:data forKey:@"inputMessage"];
//    
//    // 4.获取输出的二维码
//    CIImage * outPutImage = [filter outputImage];
//    
//    _codeImageView.image =  [self createNonInterpolatedUIImageFormCIImage:outPutImage withSize:200];
//    
//}

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

#pragma mark Other Method

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

- (void ) rightButtonAction: (UIButton *)button {
    
    if ( (NO == button.selected) &&  (NO ==_model.contentSocail.isPraise ) ) {
        
        [RSMethod ylg_SVProgressHUD_showWithSVProgressHUDMaskTypeNone];
        [self.viewModel praise:_model.objectId];
        
    }else if  ( (YES == button.selected ) &&  (YES ==_model.contentSocail.isPraise ) ) {
        
        [RSMethod ylg_SVProgressHUD_showWithSVProgressHUDMaskTypeNone];
        [self.viewModel cancelPraise:_model.objectId];
    }
}


#pragma mark createUI
- (KYMHButton * ) createButton:(NSString *)imageNormal imageSelected:(NSString *) imageSelected action:(SEL)action {
    
    KYMHButton * btn= [KYMHButton new];
    [btn setImage:Img(imageNormal) forState:UIControlStateNormal];
    [btn setImage:Img(imageSelected) forState:UIControlStateSelected];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [wmPlayer removeFromSuperview];
    wmPlayer.transform = CGAffineTransformIdentity;
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        wmPlayer.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        wmPlayer.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    wmPlayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    wmPlayer.playerLayer.frame =  CGRectMake(0,0, kScreenHeight,kScreenWidth);
    
    [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(kScreenWidth-40);
        make.width.mas_equalTo(kScreenHeight);
    }];
    [wmPlayer.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.equalTo(wmPlayer).with.offset(0);
        make.width.mas_equalTo(kScreenHeight);
    }];
    [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wmPlayer.topView).with.offset(5);
        make.height.mas_equalTo(30);
        make.top.equalTo(wmPlayer.topView).with.offset(5);
        make.width.mas_equalTo(30);
    }];
    [wmPlayer.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wmPlayer.topView).with.offset(45);
        make.right.equalTo(wmPlayer.topView).with.offset(-45);
        make.center.equalTo(wmPlayer.topView);
        make.top.equalTo(wmPlayer.topView).with.offset(0);
        
    }];
    [wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenHeight);
        make.center.mas_equalTo(CGPointMake(kScreenWidth/2-36, -(kScreenWidth/2)+36));
        make.height.equalTo(@30);
    }];
    [wmPlayer.loadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointMake(kScreenWidth/2-37, -(kScreenWidth/2-37)));
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:wmPlayer];
    wmPlayer.fullScreenBtn.selected = YES;
    [wmPlayer bringSubviewToFront:wmPlayer.bottomView];
    
}

//-(void)toNormal{
//    [wmPlayer removeFromSuperview];
//    [UIView animateWithDuration:0.5f animations:^{
//        wmPlayer.transform = CGAffineTransformIdentity;
//        wmPlayer.frame =CGRectMake(playerFrame.origin.x, playerFrame.origin.y, playerFrame.size.width, playerFrame.size.height);
//        wmPlayer.playerLayer.frame =  wmPlayer.bounds;
//        [self.view addSubview:wmPlayer];
//        [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(wmPlayer).with.offset(0);
//            make.right.equalTo(wmPlayer).with.offset(0);
//            make.height.mas_equalTo(40);
//            make.bottom.equalTo(wmPlayer).with.offset(0);
//        }];
//        
//        
//        [wmPlayer.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(wmPlayer).with.offset(0);
//            make.right.equalTo(wmPlayer).with.offset(0);
//            make.height.mas_equalTo(40);
//            make.top.equalTo(wmPlayer).with.offset(0);
//        }];
//        
//        
//        [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(wmPlayer.topView).with.offset(5);
//            make.height.mas_equalTo(30);
//            make.top.equalTo(wmPlayer.topView).with.offset(5);
//            make.width.mas_equalTo(30);
//        }];
//        
//        
//        [wmPlayer.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(wmPlayer.topView).with.offset(45);
//            make.right.equalTo(wmPlayer.topView).with.offset(-45);
//            make.center.equalTo(wmPlayer.topView);
//            make.top.equalTo(wmPlayer.topView).with.offset(0);
//        }];
//        
//        [wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(wmPlayer);
//            make.width.equalTo(wmPlayer);
//            make.height.equalTo(@30);
//        }];
//        
//    }completion:^(BOOL finished) {
//        wmPlayer.isFullscreen = NO;
//        [self setNeedsStatusBarAppearanceUpdate];
//        wmPlayer.fullScreenBtn.selected = NO;
//        
//    }];
//}

///播放器事件
-(void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)closeBtn{
    NSLog(@"clickedCloseButton");
    [self releaseWMPlayer];
    [self.navigationController popViewControllerAnimated:YES];
    
}
///播放暂停
-(void)wmplayer:(WMPlayer *)wmplayer clickedPlayOrPauseButton:(UIButton *)playOrPauseBtn{
    NSLog(@"clickedPlayOrPauseButton");
}


///全屏按钮
//-(void)wmplayer:(WMPlayer *)wmplayer clickedFullScreenButton:(UIButton *)fullScreenBtn{
//    if (fullScreenBtn.isSelected) {//全屏显示
//        wmPlayer.isFullscreen = YES;
//        [UIView animateWithDuration:1 animations:^{
//            // 存放需要执行动画的代码
//            
//            wmPlayer.frame = playerFrame;
//            
//        } completion:^(BOOL finished) {
//        }];
//        
//    }else{
//        //[self toNormal];
//        
//        wmPlayer.isFullscreen = NO;
//        [UIView animateWithDuration:1 animations:^{
//            // 存放需要执行动画的代码
//            
//            wmplayer.frame = minFrame;
//            
//        } completion:^(BOOL finished) {
//        }];
//    }
//}

///单击播放器
-(void)wmplayer:(WMPlayer *)wmplayer singleTaped:(UITapGestureRecognizer *)singleTap{
    NSLog(@"didSingleTaped");
}
///双击播放器
-(void)wmplayer:(WMPlayer *)wmplayer doubleTaped:(UITapGestureRecognizer *)doubleTap{
    NSLog(@"didDoubleTaped");
}
///播放状态
-(void)wmplayerFailedPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state{
    NSLog(@"wmplayerDidFailedPlay");
}
-(void)wmplayerReadyToPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state{
    NSLog(@"wmplayerDidReadyToPlay");
}
-(void)wmplayerFinishedPlay:(WMPlayer *)wmplayer{
    NSLog(@"wmplayerDidFinishedPlay");
}
/**
 *  旋转屏幕通知
 */
- (void)onDeviceOrientationChange{
    if (wmPlayer==nil||wmPlayer.superview==nil){
        return;
    }
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            NSLog(@"第3个旋转方向---电池栏在下");
        }
            break;
        case UIInterfaceOrientationPortrait:{
            NSLog(@"第0个旋转方向---电池栏在上");
//            if (wmPlayer.isFullscreen) {
//                [self toNormal];
//            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"第2个旋转方向---电池栏在左");
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"第1个旋转方向---电池栏在右");
            
        }
            break;
        default:
            break;
    }
}

- (void)releaseWMPlayer
{
    if ( nil != wmPlayer ) {
        [wmPlayer pause];
#warning  TODO 暂时注释，对于某些打不开的连接会导致整个App假死（任何操作都无法进行），还不知道原因
        //    [self.wmPlayer.player.currentItem cancelPendingSeeks];
        //    [self.wmPlayer.player.currentItem.asset cancelLoading];
        
        [wmPlayer removeFromSuperview];
        [wmPlayer.playerLayer removeFromSuperlayer];
        [wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
        wmPlayer.player = nil;
        wmPlayer.currentItem = nil;
        //释放定时器，否侧不会调用WMPlayer中的dealloc方法
        [wmPlayer.autoDismissTimer invalidate];
        wmPlayer.autoDismissTimer = nil;
        
        wmPlayer.playOrPauseBtn = nil;
        wmPlayer.playerLayer = nil;
        wmPlayer = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark ViewModel回调

- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result {
    
    if ( RSRisk_NS_ENUM_findRiskFileById == action) {
        if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeSuccess) {
            
            _model = self.viewModel.rsDataCenterDetailModel;
            [self initUIWhenRequestDataSuccess];
        }
        [SVProgressHUD dismiss];
    }
    
    if ( RSRisk_NS_ENUM_favourate  == action) {
        if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeSuccess) {
            
            [RSMethod ylg_showSuccessWithStatus:@"收藏成功"];
            _middleButton.selected = YES;
            _model.contentSocail.isFavorite = YES;
            [self changeFavoriteStatus];
            _isRefresh = YES;
        }else {
            [RSMethod ylg_showSuccessWithStatus:result.message];
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
            [RSMethod ylg_showSuccessWithStatus:result.message];
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
            [RSMethod ylg_showSuccessWithStatus:result.message];
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
            [RSMethod ylg_showSuccessWithStatus:result.message];
        }
    }
    
    if ( RSRisk_NS_ENUM_cancelPraise == action ||
        RSRisk_NS_ENUM_praise == action ||
        RSRisk_NS_ENUM_cancelFavourite == action ||
        RSRisk_NS_ENUM_favourate == action ||
        RSRisk_NS_ENUM_findRiskFileById == action)  {
        
        if ([result.jsonDict[@"status"] intValue] != NetworkModelStatusTypeSuccess ) {
            [SVProgressHUD dismiss];
            [UIUtil alert:result.message];
        }
    }
}


#pragma mark dealloc

- (void)dealloc{
    
    [self releaseWMPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"DetailViewController deallco");
    
    if (self.viewModel) {
        [self.viewModel cancelAndClearAll];
        self.viewModel = nil;
    }
    
    if (_callBack) {
        _callBack(YES);
        _callBack = nil;
    }
    
    [SVProgressHUD dismiss];
}

@end
