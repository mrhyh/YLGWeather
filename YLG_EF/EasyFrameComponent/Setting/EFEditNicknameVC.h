//
//  EFEditNicknameVC.h
//  EasyFrame_iOS2.0
//
//  Created by MH on 16/5/24.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFBaseViewController.h"

typedef void(^CompleteBlock)(NSString *nickName) ;

@interface EFEditNicknameVC : EFBaseViewController

- (instancetype)initWithCompleteBlock:(CompleteBlock)completeBlock;

@end
