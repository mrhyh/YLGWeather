//
//  MineVC.h
//  Risk-iPhone
//
//  Created by Cherie Jeong on 16/8/24.
//  Copyright © 2016年 Cherie Jeong. All rights reserved.
//

#import "EFBaseViewController.h"

@interface MineVC : EFBaseViewController

+ (MineVC*)shareInstance;

- (void)changeMsgNum:(int)number;

@end
