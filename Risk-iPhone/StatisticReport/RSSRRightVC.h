//
//  RSSRRightVC.h
//  Risk
//
//  Created by ylgwhyh on 16/7/12.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "EFBaseViewController.h"

@interface RSSRRightVC : EFBaseViewController

/** * 分页 */
@property (assign, nonatomic) int pageCount;

@property (nonatomic, strong) UINavigationController *tabBarRootNC;

@end
