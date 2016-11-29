//
//  RSHERightVC.h
//  Risk
//
//  Created by ylgwhyh on 16/7/13.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "EFBaseViewController.h"

#import "AllHealthModel.h"


@interface RSHERightVC : EFBaseViewController <UISplitViewControllerDelegate>

@property (nonatomic, strong) Children *typeModel;
@property (nonatomic, strong) UISplitViewController  *splitViewController;

@property (nonatomic, assign) BOOL isHideNavigationTitleLabelBOOL;

@property (nonatomic, assign) NSInteger pushNumber;

//从上个界面传递的UINavigationController
@property (nonatomic, strong) UINavigationController *lastNC;

@end