//
//  LoginVC.h
//  Risk-iPhone
//
//  Created by Cherie Jeong on 16/8/25.
//  Copyright © 2016年 Cherie Jeong. All rights reserved.
//

#import "EFBaseViewController.h"

typedef void(^CompleteBlock)(BOOL isSussces);

@interface LoginVC : EFBaseViewController

- (instancetype)initWithCompleteBlock:(CompleteBlock)completeBlock;

@property (nonatomic,assign) BOOL isReferrsh;

@end
