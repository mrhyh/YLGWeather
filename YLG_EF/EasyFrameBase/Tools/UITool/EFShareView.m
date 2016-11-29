//
//  EFShareView.m
//  QuickFlip
//
//  Created by KingYon on 15/5/9.
//  Copyright (c) 2015年 KingYon LLC. All rights reserved.
//

#import "EFShareView.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "TencentOpenAPI/QQApiInterface.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#define SHARE_TAG  100
@interface EFShareView ()<TencentSessionDelegate>{
    TencentOAuth *tencentOAuth;
    UIView       * qfShareView;
    NSString *shareURL;
     NSMutableArray  * arr ;
}
@property (nonatomic,strong)NSString *sys_id;
@property (nonatomic,strong)NSString *Type;
@property (nonatomic,strong)NSString *news_content;
@property (nonatomic,strong)NSString *imgURL;
@property (nonatomic,strong)UIImage *img;
@property (nonatomic, copy) NSString *serverAddressURL;
@end

static EFShareView * share = nil;

@implementation EFShareView

+ (EFShareView *)shareInstance
{
    if (share == nil) {
        share = [[self alloc] init];
    }
    return share;
}


- (void)openShareViewWithContent : (NSDictionary *)_content  CallBack:(shareViewCallBack)callBack{
    _callBack = callBack;
    share.news_content = [_content objectForKey:@"news_content"];
        if (share.news_content.length>10) {
            share.news_content = [share.news_content substringToIndex:10];
        }
    shareURL = [NSString stringWithFormat:@"%@%@",self.serverAddressURL,[_content objectForKey:@"shareURL"]];
    share.img = [_content objectForKey:@"img"];
    [share openPickerView];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor clearColor];
        NSLog(@"%f %f",self.frame.size.height,self.frame.size.width);
        tencentOAuth = [[TencentOAuth alloc] initWithAppId:TENCENT_APPID andDelegate:self];
        qfShareView = [[UIView alloc] initWithFrame:CGRectMake(20*SCREEN_W_RATE, SCREEN_HEIGHT, SCREEN_WIDTH, 300 * SCREEN_H_RATE)];
        qfShareView.backgroundColor = [UIColor whiteColor];
        [self addSubview:qfShareView];
        arr = [NSMutableArray array];
        NSMutableArray *btnImg = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"MallImage.bundle/ic_share_wx"],[NSString stringWithFormat:@"MallImage.bundle/ic_share_wxmoments"],[NSString stringWithFormat:@"MallImage.bundle/ic_share_weibo"],[NSString stringWithFormat:@"MallImage.bundle/ic_share_qq"],[NSString stringWithFormat:@"MallImage.bundle/ic_share_qzone"],[NSString stringWithFormat:@"MallImage.bundle/ic_share_more"], nil];
        NSMutableArray *btnName = [NSMutableArray arrayWithObjects:@"微信",@"朋友圈",@"微博",@"QQ",@"QQ空间",@"更多", nil];
        
        if (![WXApi isWXAppSupportApi] && ![WeiboSDK isCanShareInWeiboAPP]) {
            btnImg = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"MallImage.bundle/ic_share_qq"],[NSString stringWithFormat:@"MallImage.bundle/ic_share_qzone"],[NSString stringWithFormat:@"MallImage.bundle/ic_share_more"], nil];
            btnName = [NSMutableArray arrayWithObjects:@"QQ",@"QQ空间",@"更多", nil];
        }else if (![WXApi isWXAppSupportApi]){
            btnImg = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"MallImage.bundle/ic_share_weibo"],[NSString stringWithFormat:@"MallImage.bundle/ic_share_qq"],[NSString stringWithFormat:@"MallImage.bundle/ic_share_qzone"],[NSString stringWithFormat:@"MallImage.bundle/ic_share_more"], nil];
            btnName = [NSMutableArray arrayWithObjects:@"微博",@"QQ",@"QQ空间",@"更多", nil];
        }else if (![WeiboSDK isCanShareInWeiboAPP]) {
            btnImg = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"MallImage.bundle/ic_share_wx"],[NSString stringWithFormat:@"MallImage.bundle/ic_share_wxmoments"],[NSString stringWithFormat:@"MallImage.bundle/ic_share_qq"],[NSString stringWithFormat:@"MallImage.bundle/ic_share_qzone"],[NSString stringWithFormat:@"MallImage.bundle/ic_share_more"], nil];
            btnName = [NSMutableArray arrayWithObjects:@"微信",@"朋友圈",@"QQ",@"QQ空间",@"更多", nil];
        }
        
        arr = btnName;
        UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 10*SCREEN_H_RATE, qfShareView.frame.size.width, 20*SCREEN_H_RATE)];
        titleLB.text = @"分享到";
        titleLB.font = [UIFont systemFontOfSize:17];
        titleLB.textAlignment = NSTextAlignmentCenter;
        titleLB.backgroundColor = [UIColor clearColor];
        [qfShareView addSubview:titleLB];
        if (btnName.count < 4) {
            qfShareView.frame = CGRectMake(20*SCREEN_W_RATE, SCREEN_HEIGHT, SCREEN_WIDTH, 200 * SCREEN_H_RATE);
        }
        int btnWidth = 50*SCREEN_W_RATE;
        int marginX = (SCREEN_WIDTH - btnWidth*3)/4;
        int marginY = 20*SCREEN_H_RATE;
        
        int x = marginX;
        int y = CGRectGetMaxY(titleLB.frame) + marginY;
        
        for (int i = 0; i<btnImg.count; i++) {
            UIButton *shareBT = [UIButton buttonWithType:UIButtonTypeCustom];
            shareBT.frame = CGRectMake(x, y, btnWidth, btnWidth);
            [shareBT setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[btnImg objectAtIndex:i]]] forState:UIControlStateNormal];
            [shareBT setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_jh",[btnImg objectAtIndex:i]]] forState:UIControlStateHighlighted];
            [shareBT addTarget:self action:@selector(shareClickAction:) forControlEvents:UIControlEventTouchUpInside];
            shareBT.tag = SHARE_TAG + i;
            [qfShareView addSubview:shareBT];
            
            UILabel *shareLB = [[UILabel alloc] initWithFrame:CGRectMake(x-10*SCREEN_W_RATE, CGRectGetMaxY(shareBT.frame), btnWidth+20*SCREEN_W_RATE, 20*SCREEN_H_RATE)];
            shareLB.text = [btnName objectAtIndex:i];
            shareLB.font = [UIFont systemFontOfSize:12];
            shareLB.textAlignment = NSTextAlignmentCenter;
            shareLB.backgroundColor = [UIColor whiteColor];
            [qfShareView addSubview:shareLB];
            x += marginX+btnWidth;
            if (x+btnWidth >= SCREEN_WIDTH) {
                x = marginX;
                y += 30*SCREEN_H_RATE+btnWidth;
            }
            
        }

        UIButton *cancelBT = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBT.frame = CGRectMake(0, CGRectGetHeight(qfShareView.frame)-40*SCREEN_H_RATE, qfShareView.frame.size.width, 40*SCREEN_H_RATE);
        cancelBT.backgroundColor = EF_TextColor_TextColorDisable;
        [cancelBT setTitle:@"取消" forState:0];
        cancelBT.titleLabel.font = [UIFont systemFontOfSize:17];
        cancelBT.titleLabel.textAlignment = NSTextAlignmentCenter;
        [cancelBT setTitleColor:[UIColor blackColor] forState:0];
        [cancelBT addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [qfShareView addSubview:cancelBT];
        UITapGestureRecognizer* singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backView:)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [self addGestureRecognizer:singleRecognizer];
        
    }
    return self;
}

-(void)cancelAction{
    [self closePickerView];
}

-(void)moreAction{
    if (self.callBack) {
        self.callBack(YES);
        self.callBack = nil;
    }
}

- (void)backView:(UITapGestureRecognizer*)recognizer
{
    CGPoint point = [recognizer locationInView:qfShareView];
    if (point.y<0) {
        [self closePickerView];
    }
}

//分享点击事件

- (void)shareClickAction:(id)_sender{
    UIButton *btn = (UIButton*)_sender;
    int buttonIndex = (int)btn.tag - SHARE_TAG;
    NSData *  imageData = UIImageJPEGRepresentation(_img, 0.3);
    NSString *shareTitle = _news_content;
    NSString *shareDescription = _news_content;
    NSString * typeStr = [arr objectAtIndex:buttonIndex];
    //分享到qq
    if ([typeStr isEqualToString:@"QQ"] || [typeStr isEqualToString:@"QQ空间"]){
        
        
        
        
        QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:shareURL]
                                                            title:shareTitle
                                                      description:shareDescription
                                    //                                                 previewImageData:[NSData dataWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:shareLogoImg]]];
                                                 previewImageData:imageData];
        
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        QQApiSendResultCode sent = 0;
        if ([typeStr isEqualToString:@"QQ"]) {
            sent = [QQApiInterface sendReq:req];
        }else{
            sent = [QQApiInterface SendReqToQZone:req];
        }
        [self handleSendResult:sent];
        
        [self performSelector:@selector(cancelAction) withObject:nil afterDelay:1];
    }
    
    //微信
    else if ([typeStr isEqualToString:@"微信"] || [typeStr isEqualToString:@"朋友圈"]) {
        if (![WXApi isWXAppInstalled]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"亲，您还没有安装微信客户端" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }else{
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = shareTitle;
            message.description = shareDescription;
            //            [message setThumbImage:shareLogoImg];
            message.thumbData = imageData;
            WXWebpageObject *ext = [WXWebpageObject object];
            ext.webpageUrl = shareURL;
            
            message.mediaObject = ext;
            
            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
            req.bText = NO;
            req.message = message;
            if ([typeStr isEqualToString:@"微信"]) {
                req.scene = WXSceneSession;
            }else{
                req.scene = WXSceneTimeline;
            }
            [WXApi sendReq:req];
            
            [self performSelector:@selector(cancelAction) withObject:nil afterDelay:1];
            
        }
        
    }
    
    //微博
    
    else if ([typeStr isEqualToString:@"微博"])
    {
        WBMessageObject *message = [WBMessageObject message];
        WBWebpageObject *webpage = [WBWebpageObject object];
        webpage.objectID = @"identifier1";
        webpage.title = shareTitle;
        webpage.description = shareDescription;
        webpage.thumbnailData = imageData;
        webpage.webpageUrl = shareURL;
        message.mediaObject = webpage;
        
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
        request.userInfo = @{@"ShareMessageFrom": @"ViewController",
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
        
        [WeiboSDK sendRequest:request];
        
        [self performSelector:@selector(cancelAction) withObject:nil afterDelay:1];
    }
    //更多
    else if ([typeStr isEqualToString:@"更多"])
    {
        [self performSelector:@selector(cancelAction) withObject:nil afterDelay:0.5];
       [self performSelector:@selector(moreAction) withObject:nil afterDelay:1];
    }
    else{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [NSString stringWithFormat:@"%@  %@",shareTitle,shareURL];
         [UIUtil alert:@"复制成功"];
        [self performSelector:@selector(cancelAction) withObject:nil afterDelay:1];
    }
}


- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQZONENOTSUPPORTTEXT:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"空间分享不支持纯文本分享，请使用图文分享" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQZONENOTSUPPORTIMAGE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"空间分享不支持纯图片分享，请使用图文分享" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        default:
        {
            break;
        }
    }
}

- (void)closePickerView{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = BCWhiteColor(60, 0.0);
        qfShareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, qfShareView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)openPickerView{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = BCWhiteColor(60, 0.3);
        qfShareView.frame = CGRectMake(0, SCREEN_HEIGHT-qfShareView.frame.size.height, SCREEN_WIDTH, qfShareView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark --- setter && getter
- (NSString *)serverAddressURL{
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
    return _serverAddressURL;
}


@end
