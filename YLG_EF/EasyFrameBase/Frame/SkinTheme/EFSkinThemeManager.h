//
//  EFSkinThemeManager.h
//  Symiles
//
//  Created by Jack on 3/3/16.
//  Copyright © 2016 KingYon LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+UIColor_Hex.h"
//默认主题
#define EFSkinThemeDefaultKey @"Default"
//夜间主题
#define EFSkinThemeNightKey @"Night"
//存储当前皮肤主题的key
#define EFSkinThemeKey @"EFSkinThemeKey"
//皮肤更换的开关状态发生变化时的通知
#define EFSkinThemeChangeNotification @"EFSkinThemeChangeNotification"
//皮肤主题管理的开关状态
#define EFSkinThemeSwitchIsON @"EFSkinThemeSwitchIsON"
//皮肤主题更换时的通知
#define EFSkinThemeViewChange @"EFSkinThemeViewChange"

@interface EFSkinThemeManager : NSObject

+ (EFSkinThemeManager *)shareInstance;

@end

@interface EFSkinThemeManager (EFGetValueByKey)
+ (UIColor *)getTextColorWithKey : (NSString *)key;
+ (UIColor *)getBackgroundColorWithKey : (NSString *)key;
+ (NSNumber *)getFontSizeWithKey : (NSString *)key;
+ (NSNumber *)getSpaceSizeWithKey : (NSString *)key;
+ (UIColor *)getTextFileBackgroundColorWithKey : (NSString *)key;
+ (UIColor *)getTextColorWithKey:(NSString *)key andAlpha:(CGFloat)alpha;

@end

#define EF_TextColorByKey(key) [EFSkinThemeManager getTextColorWithKey:key];
#define EF_BackgroundColorByKey(key) [EFSkinThemeManager getBackgroundColorWithKey:key];
#define EF_OtherColorByKey(key) [EFSkinThemeManager getOtherColorWithKey:key];
#define EF_FontSizeByKey(key) [EFSkinThemeManager getFontSizeWithKey:key];
#define EF_SpaceSizeByKey(key) [EFSkinThemeManager getSpaceSizeWithKey:key];



#define SkinThemeKey_WhiteDivider @"WhiteDivider"   //白色分隔线
#define SkinThemeKey_WhiteHint @"WhiteHint"         //30% 提示/禁用
#define SkinThemeKey_WhiteSecondary @"WhiteSecondary"   //70% 减淡颜色
#define SkinThemeKey_WhiteNormal @"WhiteNormal"         //100% 正文颜色
#define SkinThemeKey_BlackDivider @"BlackDivider"
#define SkinThemeKey_BlackHint @"BlackHint"
#define SkinThemeKey_BlackSecondary @"BlackSecondary"
#define SkinThemeKey_BlackNormal @"BlackNormal"
#define SkinThemeKey_Black87 @"Black87"
//不同状态下，文字的颜色
#define SkinThemeKey_TextColorPrimary @"TextColorPrimary"           //主要文字颜色
#define SkinThemeKey_TextColorPrimaryDark @"TextColorPrimaryDark"   //文字颜色的深色
#define SkinThemeKey_TextColorAccent @"TextColorAccent"             //文字颜色强调
#define SkinThemeKey_TextColorSecondary @"TextColorSecondary"       //文字颜色减淡
#define SkinThemeKey_TextColorDisable @"TextColorDisable"           //文字颜色禁用（最浅）
#define SkinThemeKey_TextColorNavigation @"TextColorNavigation"     //导航文字颜色

//登录相关
#define SkinThemeKey_BGTextFiledColorLogin @"BGTextFiledColorLogin"

#define SkinThemeKey_TextColorLoginPrimary @"TextColorLoginPrimary"             //登录页文字颜色
#define SkinThemeKey_TextColorLoginSecondary @"TextColorLoginSecondary"   //登录页文字颜色减淡
#define SkinThemeKey_TextColorLoginDisable @"TextColorLoginDisable"       //登录页文字颜色禁用（最浅）
#define SkinThemeKey_LoginTextFieldPlaceHolderColor @"LoginTextFieldPlaceHolderColor"             //登录页输入框占位文字颜色

//按钮不同状态下文字颜色
#define SkinThemeKey_TextColorButtonNormal  @"TextColorButtonNormal"            //按钮文字正常颜色
#define SkinThemeKey_TextColorButtonHighlighted  @"TextColorButtonHighlighted"  //按钮文字高亮颜色
#define SkinThemeKey_TextColorButtonSelected  @"TextColorButtonSelected"  //按钮文字选中颜色
#define SkinThemeKey_TextColorButtonDisable @"TextColorButtonDisable"   //按钮文字禁用颜色
//皮肤背景色
#define SkinThemeKey_MainColor @"MainColor"                         //系统主色调
#define SkinThemeKey_BGColorPrimary @"BGColorPrimary"               //主要背景颜色
#define SkinThemeKey_BGColorSecondary @"BGColorSecondary"           //次要背景颜色
//按钮不同状态下的背景色
#define SkinThemeKey_BGButtonColorNormal @"BGButtonColorNormal"      //按钮正常背景颜色
#define SkinThemeKey_BGButtonColorHighlighted @"BGButtonColorHighlighted"  //按钮高亮背景颜色
#define SkinThemeKey_BGButtonColorSelected @"BGButtonColorSelected"  //按钮选中背景颜色
#define SkinThemeKey_BGButtonColorDisable @"BGButtonColorDisable"    //按钮禁用背景颜色
//Tabber不同状态下的背景色
#define SkinThemeKey_TextColorTabberNormal @"TextColorTabberNormal"      //按钮正常背景颜色
#define SkinThemeKey_TextColorTabberSelected @"TextColorTabberSelected"  //按钮选中背景颜色

//额外的key，供个别项目中的特殊需求进行颜色设置，暂时提供10个
#define SkinThemeKey_Color_One @"SkinThemeKey_Color_One"
#define SkinThemeKey_Color_Two @"SkinThemeKey_Color_Two"
#define SkinThemeKey_Color_Three @"SkinThemeKey_Color_Three"
#define SkinThemeKey_Color_Four @"SkinThemeKey_Color_Four"
#define SkinThemeKey_Color_Five @"SkinThemeKey_Color_Five"
#define SkinThemeKey_Color_Six @"SkinThemeKey_Color_Six"
#define SkinThemeKey_Color_Seven @"SkinThemeKey_Color_Seven"
#define SkinThemeKey_Color_Eight @"SkinThemeKey_Color_Eight"
#define SkinThemeKey_Color_Nine @"SkinThemeKey_Color_Nine"
#define SkinThemeKey_Color_Ten @"SkinThemeKey_Color_Ten"

//文字大小
#define SkinThemeKey_FontSizeNormal @"FontSizeNormal"       // 17  可在plist中更改 添加
#define SkinThemeKey_FontSizeMiddle @"FontSizeMiddle"       // 15
#define SkinThemeKey_FontSizeSmall @"FontSizeSmall"         // 13


/********************************方法中可以直接调用以下宏获取颜色值******************************************************/

//主要分割线颜色
#define EF_TextColor_WhiteDivider EF_TextColorByKey(SkinThemeKey_WhiteDivider)
//
#define EF_TextColor_WhiteHint EF_TextColorByKey(SkinThemeKey_WhiteHint)
//
#define EF_TextColor_WhiteSecondary EF_TextColorByKey(SkinThemeKey_WhiteSecondary)
//正文内容的颜色
#define EF_TextColor_WhiteNormal EF_TextColorByKey(SkinThemeKey_WhiteNormal)
//
#define EF_TextColor_BlackDivider EF_TextColorByKey(SkinThemeKey_BlackDivider)
//
#define EF_TextColor_BlackHint EF_TextColorByKey(SkinThemeKey_BlackHint)
//
#define EF_TextColor_BlackSecondary EF_TextColorByKey(SkinThemeKey_BlackSecondary)
//
#define EF_TextColor_BlackNormal EF_TextColorByKey(SkinThemeKey_BlackNormal)
//
#define EF_TextColor_Black87 EF_TextColorByKey(SkinThemeKey_Black87)
//主要的文字颜色
#define EF_TextColor_TextColorPrimary EF_TextColorByKey(SkinThemeKey_TextColorPrimary)
//文字颜色的深色
#define EF_TextColor_TextColorPrimaryDark EF_TextColorByKey(SkinThemeKey_TextColorPrimaryDark)
//文字强调的颜色
#define EF_TextColor_TextColorAccent EF_TextColorByKey(SkinThemeKey_TextColorAccent)
//文字减淡状态的颜色
#define EF_TextColor_TextColorSecondary EF_TextColorByKey(SkinThemeKey_TextColorSecondary)
//文字禁用（最浅）的颜色
#define EF_TextColor_TextColorDisable EF_TextColorByKey(SkinThemeKey_TextColorDisable)
//导航栏文字颜色
#define EF_TextColor_TextColorNavigation EF_TextColorByKey(SkinThemeKey_TextColorNavigation)
//登录界面文字正常的颜色
#define EF_TextColor_TextColorLoginPrimary EF_TextColorByKey(SkinThemeKey_TextColorLoginPrimary)
//登录界面文字减淡的颜色
#define EF_TextColor_TextColorLoginSecondary EF_TextColorByKey(SkinThemeKey_TextColorLoginSecondary)
//登录界面文字禁用（最浅）的颜色
#define EF_TextColor_TextColorLoginDisable EF_TextColorByKey(SkinThemeKey_TextColorLoginDisable)
//登录界面占位文字颜色
#define EF_TextColor_LoginTextFieldPlaceHolderColor EF_TextColorByKey(SkinThemeKey_LoginTextFieldPlaceHolderColor)

//按钮正常状态下的文字颜色
#define EF_TextColor_TextColorButtonNormal EF_TextColorByKey(SkinThemeKey_TextColorButtonNormal)
//按钮高亮状态下的文字颜色
#define EF_TextColor_TextColorButtonHighlighted EF_TextColorByKey(SkinThemeKey_BGButtonColorHighlighted)
//按钮不可用状态下的文字颜色
#define EF_TextColor_TextColorButtonDisable EF_TextColorByKey(SkinThemeKey_TextColorButtonDisable)
//按钮选中状态下的文字颜色
#define EF_TextColor_TextColorButtonSelected EF_TextColorByKey(SkinThemeKey_TextColorButtonSelected)


//项目主色调
#define EF_MainColor EF_BackgroundColorByKey(SkinThemeKey_MainColor)
//主要的背景颜色
#define EF_BGColor_Primary EF_BackgroundColorByKey(SkinThemeKey_BGColorPrimary)
//次要的背景色
#define EF_BGColor_Secondary EF_BackgroundColorByKey(SkinThemeKey_BGColorSecondary)
//导航栏的背景色
#define EF_BGNavigationColor_Primary EF_BackgroundColorByKey(SkinThemeKey_BGNavigationColorPrimary)
//按钮正常状态下的背景色
#define EF_BGButtonColor_Normal EF_BackgroundColorByKey(SkinThemeKey_BGButtonColorNormal)
//按钮高亮状态下的背景色
#define EF_BGButtonColorHighlight EF_BackgroundColorByKey(SkinThemeKey_BGButtonColorHighlight)
//按钮不可用状态下的背景色
#define EF_BGButtonColorDisable EF_BackgroundColorByKey(SkinThemeKey_BGButtonColorDisable)
//按钮选中状态下的背景色
#define EF_BGButtonColorSelected EF_BackgroundColorByKey(SkinThemeKey_BGButtonColorSelected)
//登录界面、注册界面、忘记密码界面输入框背景颜色
#define EF_BGTextFiledColorLogin EF_BackgroundColorByKey(SkinThemeKey_BGTextFiledColorLogin)


//额外的key，供个别项目中的特殊需求进行颜色设置，暂时提供10个
#define EF_OtherColorOne EF_OtherColorByKey(SkinThemeKeyOtherColorOne)
#define EF_OtherColorTwo EF_OtherColorByKey(SkinThemeKey_Color_Two)
#define EF_OtherColorThree EF_OtherColorByKey(SkinThemeKey_Color_Three)
#define EF_OtherColorFour EF_OtherColorByKey(SkinThemeKey_Color_Four)
#define EF_OtherColorFive EF_OtherColorByKey(SkinThemeKey_Color_Five)
#define EF_OtherColorSix EF_OtherColorByKey(SkinThemeKey_Color_Six)
#define EF_OtherColorSeven EF_OtherColorByKey(SkinThemeKey_Color_Seven)
#define EF_OtherColorEight EF_OtherColorByKey(SkinThemeKey_Color_Eight)
#define EF_OtherColorNine EF_OtherColorByKey(SkinThemeKey_Color_Nine)
#define EF_OtherColorTen EF_OtherColorByKey(SkinThemeKey_Color_Ten)


//文字基本大小
#define EF_FontSizeNormal EF_FontSizeByKey(SkinThemeKey_FontSizeNormal)
//文字中等大小
#define EF_FontSizeMiddle EF_FontSizeByKey(SkinThemeKey_FontSizeMiddle)
//文字最小大小
#define EF_FontSizeSmall EF_FontSizeByKey(SkinThemeKey_FontSizeSmall)
