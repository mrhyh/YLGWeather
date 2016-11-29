//
//  EFMineCenterVC.h
//  EasyFrame
//
//  Created by Cherie Jeong on 16/4/21.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFBaseViewController.h"
#import "KYMHImageView.h"
#import "KYMHLabel.h"
#import "KYMHButton.h"

@interface EFMineCenterVC : EFBaseViewController <UITableViewDataSource,UITableViewDelegate>

/**列表内容,只读，初始化从plist文件中加载*/
@property (nonatomic, strong ,readonly) NSArray * mineCenterArray;
/**列表*/
@property (nonatomic, strong) UITableView *tableview;
/**右边的设置按钮*/
@property (nonatomic, strong) UIBarButtonItem *settingBarBtnItem;

@property (nonatomic, strong) KYMHImageView * headImageView;
@property (nonatomic, strong) KYMHImageView * AvatarView;
@property (nonatomic, strong) KYMHLabel * nicknameLB;

/**右边的设置按钮*/
@property (nonatomic, strong) KYMHButton * settingBtn;

- (void)settingBtnClick;
@end
