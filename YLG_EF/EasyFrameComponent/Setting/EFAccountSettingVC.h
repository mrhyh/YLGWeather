//
//  EFAccountSettingVC.h
//  demo
//
//  Created by MH on 16/5/24.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "EFBaseViewController.h"

@interface EFAccountSettingVC : EFBaseViewController<UITableViewDelegate,UITableViewDataSource>
/**列表内容,只读，初始化从plist文件中加载*/
@property (nonatomic, strong ,readonly) NSArray *settingArray;
/**列表*/
@property (nonatomic, strong) UITableView *tableview;
@end
