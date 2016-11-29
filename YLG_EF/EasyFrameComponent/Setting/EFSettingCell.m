//
//  EFSettingCell.m
//  demo
//
//  Created by HqLee on 16/5/20.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "EFSettingCell.h"

@interface EFSettingCell()
@property (nonatomic, weak) UILabel *logoutLabel;
@property (nonatomic, weak) UIView *separateLine;
@property (nonatomic, strong) UISwitch *changeSkinSwitch;
@property (nonatomic, strong) UISwitch *pushSwitch;
@end
@implementation EFSettingCell
#pragma mark --- lazy load
- (UILabel *)logoutLabel{
    if (!_logoutLabel) {
        UILabel *logoutLabel = [[UILabel alloc] init];
        logoutLabel.text = @"退出登录";
        [logoutLabel sizeToFit];
        logoutLabel.textColor = EF_MainColor;
        logoutLabel.center = CGPointMake(SCREEN_WIDTH * 0.5, self.height * 0.5);
        [self.contentView addSubview:logoutLabel];
        _logoutLabel = logoutLabel;
    }
    return _logoutLabel;
}

- (UIView *)separateLine{
    if (!_separateLine) {
        UIView *separateLine = [[UIView alloc]initWithFrame:CGRectMake(10, 44.5, SCREEN_WIDTH-10, 0.5)];
        separateLine.backgroundColor = EF_TextColor_TextColorDisable;
        [self.contentView addSubview:separateLine];
        _separateLine = separateLine;
    }
    return _separateLine;
}

- (UISwitch *)changeSkinSwitch{
    if (!_changeSkinSwitch) {
        _changeSkinSwitch = [[UISwitch alloc] init];
        _changeSkinSwitch.on = [[[NSUserDefaults standardUserDefaults] objectForKey:EFSkinThemeSwitchIsON] boolValue];
        [_changeSkinSwitch addTarget:self action:@selector(changeSkinTheme:) forControlEvents:UIControlEventValueChanged];
    }
    return _changeSkinSwitch;
}

- (UISwitch *)pushSwitch{
    if (!_pushSwitch) {
        _pushSwitch = [[UISwitch alloc] init];
        [_pushSwitch addTarget:self action:@selector(changePushSwitch:) forControlEvents:UIControlEventValueChanged];

    }
    return _pushSwitch;
}

- (void)setSettingDict:(NSDictionary *)settingDict{
    _settingDict = settingDict;
    NSString *title = settingDict[@"title"];
    NSString *accessoryView = settingDict[@"accessoryView"];
    if ([accessoryView isEqualToString:@"switch"]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([title isEqualToString:@"一键换肤"]) {
            self.accessoryView = self.changeSkinSwitch;
        }else{
            self.accessoryView = self.pushSwitch;
        }
        
    }else if([accessoryView isEqualToString:@"arrow"]){
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.accessoryView = nil;
    }else{
        self.accessoryType = UITableViewCellAccessoryNone;
        self.accessoryView = nil;
    }
    if ([title isEqualToString:@"退出登录"]) {
        self.textLabel.text = @"";
        self.logoutLabel.hidden = NO;
        self.separateLine.hidden = YES;
    }else{
        self.textLabel.text = title;
        self.logoutLabel.hidden = YES;
        self.separateLine.hidden = NO;
    }
}

#pragma mark--- event response
- (void)changeSkinTheme:(UISwitch *)sender{
    [[NSUserDefaults standardUserDefaults] setObject:@(sender.isOn) forKey:EFSkinThemeSwitchIsON];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (sender.isOn) {
        [[NSNotificationCenter defaultCenter] postNotificationName:EFSkinThemeChangeNotification object:nil userInfo:@{EFSkinThemeKey:EFSkinThemeNightKey}];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:EFSkinThemeChangeNotification object:nil userInfo:@{EFSkinThemeKey:EFSkinThemeDefaultKey}];
    }
}

- (void)changePushSwitch:(UISwitch *)sender{
    if (sender.isOn) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsPushClose"];
    }else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IsPushClose"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
