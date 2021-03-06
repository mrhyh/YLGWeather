//
//  RiskHeader.h
//  Risk
//
//  Created by ylgwhyh on 16/6/29.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#ifndef RiskHeader_h
#define RiskHeader_h


#endif /* RiskHeader_h */


/*
 ********UI**********
 */
//图片
#define Img(a) [UIImage imageNamed:a]
//尺寸
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define IS_IPHONE4 SCREEN_HEIGHT==480
#define IS_IPHONE5 SCREEN_HEIGHT==568
#define IS_IPHONE6 SCREEN_HEIGHT==667
#define IS_IPHONE6PS SCREEN_HEIGHT==736

#define SCREEN_SCALE_RATE SCREEN_WIDTH/320
#define SCREEN_W_RATE SCREEN_WIDTH/320
#define SCREEN_H_RATE ((IS_IPHONE4)?(1.0):(SCREEN_HEIGHT/568))
#define SCREEN_HALFSCALE_RATE (1.0 + ((int)((int)(SCREEN_SCALE_RATE*100)%100)/200.0))

//颜色
#define DefaultMainColor [UIColor colorWithRed:89.f/255.f green:156.f/255.f blue:233.f/255.f alpha:1.0]
#define DefaultBodyColor [UIColor colorWithRed:3.f/255.f green:3.f/255.f blue:3.f/255.f alpha:1.0]
#define DefaultAbstractColor [UIColor colorWithRed:143.f/255.f green:142.f/255.f blue:148.f/255.f alpha:1.0]
#define DefaultDisableColor [UIColor colorWithRed:199.f/255.f green:199.f/255.f blue:205.f/255.f alpha:1.0]
#define DefaultGreenColor [UIColor colorWithRed:88.f/255.f green:232.f/255.f blue:165.f/255.f alpha:1.0]
#define DefaultRedColor [UIColor colorWithRed:209.f/255.f green:46.f/255.f blue:53.f/255.f alpha:1.0]
#define UIColor_Hex(string) [UIColor colorWithHexString:string]
#define RGBColor(R,G,B) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1]
#define RGBAColor(R,G,B,A) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]
#define BCWhiteColor(W,A) [UIColor colorWithWhite:W/255.0f alpha:A]


//
#define topTitleViewTinColor 

//字体
#define Font(f) [UIFont systemFontOfSize:(f*SCREEN_HALFSCALE_RATE)]
#define BoldFont(f) [UIFont boldSystemFontOfSize:(f*SCREEN_HALFSCALE_RATE)]
#define DefRate  (1 + ((int)((int)(SCREEN_SCALE_RATE*100)%100)/200.0))
#define DefFont(f) [UIFont systemFontOfSize:f*DefRate]

//字体大小
#define normalFontSize    [[EFSkinThemeManager getFontSizeWithKey:SkinThemeKey_FontSizeNormal] floatValue]  //17
#define middleFontSize    [[EFSkinThemeManager getFontSizeWithKey:SkinThemeKey_FontSizeMiddle] floatValue]  //15
#define smallFontSize    [[EFSkinThemeManager getFontSizeWithKey:SkinThemeKey_FontSizeSmall] floatValue]   //13

#define MFNavigationRightSaveButtonFont  16 //导航栏右边字体统一大小

#define IndexZero [NSIndexPath indexPathForRow:0 inSection:0]

/*
 ********其他**********
 */
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

/**
 ********* APP_Plist 网络地址 *****
 */

#define APP_PlistURL @"https://raw.githubusercontent.com/tryZx/My/master/Risk_iPhone.plist"
//<a href="itms-services://?action=download-manifest&url=https://raw.githubusercontent.com/tryZx/My/master/Risk_iPhone.plist">Install App</a>

//日志输出
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)

//系统版本号
//#define CurrentSystemVersion [[UIDevice currentDevice].systemVersion floatValue]
#endif

#define UUID [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]

//网络配置
#define ServerAddressURL @"http://192.168.0.122:8799/ubirth"

//程序初次进入
#define APPFirstLoadIn @"APPFirstLoadIn"
#define APPFirstLoadInMain @"APPFirstLoadInMain"

//各种SDK ID
//新浪微博
#define WBSDK_Sina_AppKey @"3410191821"
#define WBSDK_Sina_AppSecret @"4f718d28c38e1ff454a053bdaa76d267"
#define WBSDK_Sina_RedirectURI @"http://www.ekuaifan.com"

//umeng统计
#define UMENG_APPKEY @"57fcba3967e58e69bd000d6f"

//微信
#define WEIXIN_APPID @"wxf20564d58b4d757c"
#define WEIXIN_AppSecret @"e4c8b62584761ab965ccfbdf8b411da6"
#define WEIXIN_Info @"WEIXIN_Info"
//QQ登录
#define TENCENT_APPID @"1104473839"
#define TENCENT_APPKEY @"n7Llfw0tfvsi2MrO"

//支付宝
#define ALiPay_Info @"ALiPay_Info"

//融云
#define RONGYUE_APPKEY @"tdrvipksr8cn5"

//APP Store 账号
#define APPStoreID 1088520991;
#define APPURL @"https://itunes.apple.com/us/app/mileby/id1088520991?l=zh&ls=1&mt=8"

//极光推送相关
#define MKJPushAppKey @"0012d4ccacdb42fc6d66e63a"  //极光推送AppKey
#define MFJPushNotAppStory @"NotAppStory" //App发布渠道(企业版)

/*****************************Risk项目用到的颜色***************************/

#define RiskTypeTitleColor RGBColor(46, 83, 111)   //风险分类页面浅蓝色
#define MFRiskTypeNoFDAFontSize (middleFontSize) //风险分类非FDA字体大小

//随访档案
#define RSVisitArchiveButtonColor RGBColor(28 , 183, 92)   //随访档案 绿色
#define RSVisitArchiveTextFieldBGColor [UIColor whiteColor]  //随访档案TextField背景色

#define RSVisitArchiveCommonFontSize (smallFontSize+1) //随访档案最通用的字体大小
#define RSVisitArchiveTableViewHeadSectionBGColor  RGBColor(248, 249, 248) //随访档案tableView头部背景色（用这个）

#define DetailWebViewLeftToSpaceMF 10
#define MFRSMineW (320)  //个人中心宽度
#define MFRSMineH (600)

#define MFRSEPLeftVCWidth SCREEN_WIDTH*0.25 //交流平台左边页面宽度
#define MFNoDataPromptString @"暂无数据"
#define RSVisitArchiveButtonH ([[UIScreen mainScreen] bounds].size.height > 568 ? 30 :30) //随访档案button、TextField等等高度

#define MFDefaultPageSize 150  //请求的默认分页大小
#define MFDefaultMaximumPageSize 150  //请求的默认分页大小

//#define MFRiskLoginToken @"TOKEN 1/d4707f8d-740c-4b1d-b916-645f635b10a8" //世杰
#define MFRiskLoginToken @"TOKEN 36/5eb9abd0-46a2-4eba-b3c5-4b4a52b49024" //122


//UserdefaultsKey

#define MFIsLogoutUserdefaultKey @"MFIsLogoutUserdefaultKey"
#define MFHuanXin_IsNotLoginSuccessUserdefaultKey @"MFHuanXin_IsNotLoginSuccessUserdefaultKey" //记录环信是否登录成功的情况

//环信AppKey
#define HuanXin_AppKey @"chengdumaixun#ubirth"
#define HuanXin_ClientId @"YXA6_o_AwGgTEeakFxURLNJrGg"
#define HuanXin_ClientSecret @"YXA6Jn18AqmaIEW9K1xcYzZBqhX3YjY"
#define HuanXin_Risk_aps @"dentist1_aps"
#define HuanXin_Group_Id @"246791891310346668"

//避免环信出问题
//#define HuanXin_AppKey @"chengdumaixun#ubirth11"
//#define HuanXin_ClientId @"YXA6_o_AwGgTEeakFxU111RLNJrGg"
//#define HuanXin_ClientSecret @"YXA6Jn18AqmaIEW9111K1xcYzZBqhX3YjY"
//#define HuanXin_Risk_aps @"dentist111_aps"
//#define HuanXin_Group_Id @"246791891111310346668"

//通知
#define MFRequestGetUserProfileByEasemobNotificationKey @"MFRequestGetUserProfileByEasemobNotificationKey" //获取群里全新id，并通过id获取用户资料
#define MF_RefreshHeadImage_Notification @"MF_RefreshHeadImage_Notification" //刷新交流平台头像的通知
#define MF_Refresh_EaseMessageViewController_TableView_Notification @"MF_Refresh_EaseMessageViewController_TableView_Notification"  //更换头像后刷新聊天界面
#define MF_UpdateApp   @"MF_UpdateApp" //检查更新通知
#define MF_Notification_DrugInformationUpdate @"MF_Notification_DrugInformationUpdate" //药品信息更新


//控件尺寸
#define MFCommonCellH (([[UIScreen mainScreen] bounds].size.height > 568) ? 90.0 :90.0) //首页、资料中心、收藏的页面的Cell高度
#define MFCommonspaceToTop 10 //cell图片距离顶部、底部的距离
#define MFCommonImageH (MFCommonCellH-2*MFCommonspaceToTop)  //cell图片高度
#define MFCommonImageW ((MFCommonImageH/70.0)*86.0)  //cell图片宽度
#define MFCommonTopTitleViewH 40 //资料中心、资料中心更多、我的收藏界面
#define MFCommonSwitchZoomProportion 0.75 //switch控件缩放比例


#define RiskUserName @"RiskUserName"

//
#import "UIScrollView+EmptyDataSet.h"

//#endif /* RiskHeader_h */
