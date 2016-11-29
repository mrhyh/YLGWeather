//
//  QFBaseViewController.m
//  QuickFix
//
//  Created by Jack on 4/8/15.
//  Copyright (c) 2015 KingYon LLC. All rights reserved.
//

#import "EFBaseViewController.h"

@implementation EFBaseViewController



- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = EF_BGColor_Primary;
    //设置title颜色
    UIColor * color = EF_TextColor_TextColorNavigation;
    UIColor * mainColor = EF_MainColor;
    [[UINavigationBar appearance] setBarTintColor:mainColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:color}];
    [[UINavigationBar appearance] setTintColor:color];
    [self skinChange];
    
    
    
    _plistPath = nil;
    _plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame_" ofType:@"plist"];
    //如果没有创建EasyFrame_.plist文件，那么直接加载框架内部自带的
    if (_plistPath == nil) {
        _plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame" ofType:@"plist"];
    }
    [self setPlistPath:_plistPath];
    
    //监听是否启用一键换肤的操作
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(skinChange) name:EFSkinThemeViewChange object:nil];
}


- (void)skinChange{
    self.view.backgroundColor = RGBColor(242, 246, 250);
    //设置title颜色
    UIColor * color = EF_TextColor_TextColorNavigation;
    UIColor * mainColor = EF_MainColor;
    [[UINavigationBar appearance] setBarTintColor:mainColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:color}];
    [[UINavigationBar appearance] setTintColor:color];

}

- (void)setPlistPath:(NSString *)plistPath{
    _plistPath = plistPath;
}
@end
