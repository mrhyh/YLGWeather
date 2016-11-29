//
//  EFSkinThemeManager.m
//  Symiles
//
//  Created by Jack on 3/3/16.
//  Copyright © 2016 KingYon LTD. All rights reserved.
//

#import "EFSkinThemeManager.h"

@interface EFSkinThemeManager()
//配置名
@property (nonatomic, copy) NSString *configName;
//主题配置
@property (nonatomic, strong) NSDictionary *themeConfigDict;
//默认皮肤类型
@property (nonatomic, copy) NSString *defaultThemeType;
//当前皮肤的类型
@property (nonatomic, copy) NSString *currentThemeType;


- (void)reloadAppThemeType;
- (void)reloadConfigData;

- (UIColor *)getTextColorWithKey : (NSString *)key;
- (UIColor *)getBackgroundColorWithKey : (NSString *)key;
- (UIColor *)getOtherColorWithKey: (NSString *)key;
- (NSNumber *)getFontSizeWithKey : (NSString *)key;
- (NSNumber *)getSpaceSizeWithKey : (NSString *)key;

@end
@implementation EFSkinThemeManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        //皮肤主题采用默认方案
        if ([[NSUserDefaults standardUserDefaults] objectForKey:EFSkinThemeKey] == nil) {
            [[NSUserDefaults standardUserDefaults] setObject:EFSkinThemeDefaultKey forKey:EFSkinThemeKey];
        }
        [self reloadConfigData];
        [self reloadAppThemeType];
        //监听一键换肤按钮
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSkinTheme:) name:EFSkinThemeChangeNotification object:nil];
    }
    return self;
}

- (void)reloadConfigData{

    NSString *plistPath = nil;
    plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame_" ofType:@"plist"];
    //如果没有创建EasyFrame_.plist文件，那么直接加载框架内部自带的
    if (plistPath == nil) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame" ofType:@"plist"];
    }
    self.themeConfigDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath][@"SkinTheme"];
}

- (void)reloadAppThemeType{
    self.currentThemeType = [[NSUserDefaults standardUserDefaults] objectForKey:EFSkinThemeKey];
    //发出更改视图的皮肤通知
    [[NSNotificationCenter defaultCenter] postNotificationName:EFSkinThemeViewChange object:nil];
    
}

- (void)reloadSkinTheme:(NSNotification *)noti{
    NSString *key = noti.userInfo[EFSkinThemeKey];
    if ([key isEqualToString:EFSkinThemeNightKey]) {
        [[NSUserDefaults standardUserDefaults] setObject:EFSkinThemeNightKey forKey:EFSkinThemeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self reloadAppThemeType];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:EFSkinThemeDefaultKey forKey:EFSkinThemeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self reloadAppThemeType];
    }
    
    
}



static EFSkinThemeManager *skinThemeManager;

+ (EFSkinThemeManager *)shareInstance{
    if (!skinThemeManager) {
        skinThemeManager = [[EFSkinThemeManager alloc] init];
    }
    return skinThemeManager;
}

- (UIColor *)getTextColorWithKey : (NSString *)key FromTheme : (NSString *)theme{
    NSDictionary *dic = [self.themeConfigDict objectForKey:theme];
    NSDictionary *textColor = [dic objectForKey:@"TextColor"];
    NSString *str = [textColor objectForKey:key];
    if (str == nil) {
        return nil;
    }
    return HEX_COLOR(str);
}

- (UIColor *)getBackgroundColorWithKey : (NSString *)key FromTheme : (NSString *)theme{
    NSDictionary *dic = [self.themeConfigDict objectForKey:theme];
    NSDictionary *textColor = [dic objectForKey:@"BackgroundColor"];
    NSString *str = [textColor objectForKey:key];
    if (str == nil) {
        return nil;
    }
    return HEX_COLOR(str);
}


- (UIColor *)getTextFileBackGroundColorWith  : (NSString *)key{
    NSDictionary *dic = [self.themeConfigDict objectForKey:self.currentThemeType];
    NSDictionary *textColor = [dic objectForKey:@"BackgroundColor"];
    NSString *str = [textColor objectForKey:key];
    double alpha = 0.2;
    if (str == nil) {
        return nil;
    }
    return HEXA_COLOR(str, alpha);
}

- (UIColor *)getTextColorWithKey:(NSString *)key andAlpha:(CGFloat)alpha{
    NSDictionary *dic = [self.themeConfigDict objectForKey:self.currentThemeType];
    NSDictionary *textColor = [dic objectForKey:@"TextColor"];
    NSString *str = [textColor objectForKey:key];
    if (str == nil) {
        return nil;
    }
    return HEXA_COLOR(str, alpha);
}

- (NSNumber *)getFontSizeWithKey : (NSString *)key FromTheme : (NSString *)theme{
    NSDictionary *dic = [self.themeConfigDict objectForKey:theme];
    NSDictionary *fonts = [dic objectForKey:@"FontSize"];
    NSNumber *size = [fonts objectForKey:key];
    return size;
}


- (NSNumber *)getSpaceSizeWithKey : (NSString *)key FromTheme : (NSString *)theme{
    NSDictionary *dic = [self.themeConfigDict objectForKey:theme];
    NSDictionary *spaces = [dic objectForKey:@"SpaceSize"];
    NSNumber *size = [spaces objectForKey:key];
    return size;
}


- (UIColor *)getTextColorWithKey : (NSString *)key{
    UIColor *color = [self getTextColorWithKey:key FromTheme:self.currentThemeType];
    if (color == nil && self.currentThemeType != self.defaultThemeType) {
        color = [self getTextColorWithKey:key FromTheme:self.defaultThemeType];
    }
    if (color==nil) {
        NSLog(@"---------未找到字体颜色 ： %@",key);
        color = [UIColor clearColor];
    }
    return color;
}

- (UIColor *)getOtherColorWithKey: (NSString *)key{
    UIColor *color = [self getBackgroundColorWithKey:key FromTheme:self.currentThemeType];
    if (color == nil && self.currentThemeType != self.defaultThemeType) {
        color = [self getBackgroundColorWithKey:key FromTheme:self.defaultThemeType];
    }
    if (color==nil) {
        NSLog(@"---------未找到其他颜色 ： %@",key);
        color = [UIColor clearColor];
    }
    return color;
}


- (UIColor *)getBackgroundColorWithKey : (NSString *)key{
    UIColor *color = [self getBackgroundColorWithKey:key FromTheme:self.currentThemeType];
    if (color == nil && self.currentThemeType != self.defaultThemeType) {
        color = [self getBackgroundColorWithKey:key FromTheme:self.defaultThemeType];
    }
    if (color==nil) {
        NSLog(@"---------未找到背景颜色 ： %@",key);
        color = [UIColor clearColor];
    }
    return color;
}


- (NSNumber *)getFontSizeWithKey : (NSString *)key{
    NSNumber *number = [self getFontSizeWithKey:key FromTheme:self.currentThemeType];
    if (number == nil && self.currentThemeType != self.defaultThemeType) {
        number = [self getFontSizeWithKey:key FromTheme:self.defaultThemeType];
    }
    if (number==nil) {
        NSLog(@"---------未找到字体大小 ： %@",key);
        number = [NSNumber numberWithInt:0];
    }
    return number;
}


- (NSNumber *)getSpaceSizeWithKey : (NSString *)key{
    NSNumber *number = [self getSpaceSizeWithKey:key FromTheme:self.currentThemeType];
    if (number == nil && self.currentThemeType != self.defaultThemeType) {
        number = [self getSpaceSizeWithKey:key FromTheme:self.defaultThemeType];
    }
    if (number==nil) {
        NSLog(@"---------未找到间隔大小 ： %@",key);
        number = [NSNumber numberWithInt:0];
    }
    return number;
}


@end



@implementation EFSkinThemeManager (EFGetValueByKey)

+ (UIColor *)getTextColorWithKey : (NSString *)key{
    return [[EFSkinThemeManager shareInstance] getTextColorWithKey:key];
}

+ (UIColor *)getBackgroundColorWithKey : (NSString *)key{
    return [[EFSkinThemeManager shareInstance] getBackgroundColorWithKey:key];
}

+ (UIColor *)getTextFileBackgroundColorWithKey : (NSString *)key{
    return [[EFSkinThemeManager shareInstance] getTextFileBackGroundColorWith:key];
}

+ (NSNumber *)getFontSizeWithKey : (NSString *)key{
    return [[EFSkinThemeManager shareInstance] getFontSizeWithKey:key];
}

+ (NSNumber *)getSpaceSizeWithKey : (NSString *)key{
    return [[EFSkinThemeManager shareInstance] getSpaceSizeWithKey:key];
}

+ (UIColor *)getTextColorWithKey:(NSString *)key andAlpha:(CGFloat)alpha{
    return [[EFSkinThemeManager shareInstance] getTextColorWithKey:key andAlpha:alpha];
}
@end
