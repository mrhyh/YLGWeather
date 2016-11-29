//
//  EFSettingViewController.h
//  demo
//
//  Created by HqLee on 16/5/19.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "EFBaseViewController.h"
typedef void(^CompleteBlock)(BOOL isSussces) ;
@interface EFSettingViewController : EFBaseViewController<UITableViewDelegate,UITableViewDataSource>
/**列表内容,只读，初始化从plist文件中加载*/
@property (nonatomic, strong ,readonly) NSArray *settingArray;
/**列表*/
@property (nonatomic, strong) UITableView *tableview;

- (instancetype)initWithCompleteBlock:(CompleteBlock)completeBlock;

@end
