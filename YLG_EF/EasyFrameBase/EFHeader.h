//
//  EFHeader.h
//  Mileby
//
//  Created by MH on 16/2/3.
//  Copyright © 2016年 MH. All rights reserved.
//

#ifndef EFHeader_h
#define EFHeader_h
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

//字体
#define Font(f) [UIFont systemFontOfSize:(f*SCREEN_HALFSCALE_RATE)]
#define BoldFont(f) [UIFont boldSystemFontOfSize:(f*SCREEN_HALFSCALE_RATE)]
#define DefRate  (1 + ((int)((int)(SCREEN_SCALE_RATE*100)%100)/200.0))
#define DefFont(f) [UIFont systemFontOfSize:f*DefRate]



//字体大小（CGFloat testFloat = normalFontSize）
#define normalFontSize    [[EFSkinThemeManager getFontSizeWithKey:SkinThemeKey_FontSizeNormal] floatValue] //17
#define middleFontSize    [[EFSkinThemeManager getFontSizeWithKey:SkinThemeKey_FontSizeMiddle] floatValue]  //15
#define smallFontSize    [[EFSkinThemeManager getFontSizeWithKey:SkinThemeKey_FontSizeSmall] floatValue]  //13


/*
 ********其他**********
 */
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//日志输出
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

//程序初次进入
#define APPFirstLoadIn @"APPFirstLoadIn"
#define APPFirstLoadInMain @"APPFirstLoadInMain"

//系统版本号
#define CurrentSystemVersion [[UIDevice currentDevice].systemVersion floatValue]
#define DeviceModel  [UIDevice currentDevice].model
#define SystemVersion [UIDevice currentDevice].systemVersion

#define APP_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

////各种SDK ID
////新浪微博
//#define WBSDK_Sina_AppKey @"3410191821"
//#define WBSDK_Sina_AppSecret @"4f718d28c38e1ff454a053bdaa76d267"
//#define WBSDK_Sina_RedirectURI @"http://www.ekuaifan.com"
//
////umeng统计
//#define UMENG_APPKEY @"55502a4467e58ed31c0007be"
//
////微信
//#define WEIXIN_APPID @"wx604a42760c9436ef"
//#define WEIXIN_AppSecret @"597333611cd97288f71a9b638dd601b2"
//
////QQ登录
//#define TENCENT_APPID @"1104473839"
//#define TENCENT_APPKEY @"n7Llfw0tfvsi2MrO"
//
////融云
//#define RONGYUE_APPKEY @"tdrvipksr8cn5"
//
////APP Store 账号
//#define APPStoreID 1088520991;
//#define APPURL @"https://itunes.apple.com/us/app/mileby/id1088520991?l=zh&ls=1&mt=8"
//
////极光推送相关
//#define NCAPPDeviceTokenKey @"776bdaa7ace1b0e1e3814faa"
////别名
//#define NCAlias @"NCAlias"
//
//#define APPAgreementURL @"http://101.201.220.99:8081/IFlight/public/content/clause"
//#define APPOursURL @"http://47.88.76.66:8081/Mileby/about.html"
//#define APPS @"http://47.88.76.66:8081/Mileby/points.html"
#endif /* Header_h */

//通知
/** 通知的宏 */
#define EFNotification [NSNotificationCenter defaultCenter]
/** 定位成功后发出的通知 */
#define EFLocationSuccessNotification @"EFLocationSuccessNotification"

//userDefaultKey
/** userDefault的红*/
#define EFUserDefault [NSUserDefaults standardUserDefaults]
/** 存放上一次定位的字典的key */
#define EFLastLocationDictKey @"EFLastLocationDictKey"

/** 存放当前定位的字典的key */
#define EFCurrentLocationDictKey @"EFCurrentLocationDictKey"

/** 字典中对应的地址字符串的key*/
#define EFDictLocationAddressKey @"EFDictLocationAddressKey"
/** 字典中对应的地址的区域ID的key*/
#define EFDictRegionIDKey @"EFDictRegionIDKey"
/** 存放是否设置了支付密码 */
#define EFIsSetPayPassWord @"EFIsSetPayPassWord"
/** 存放是否成为分享者 */
#define EFIsBecomeShare @"EFIsBecomeShare"
